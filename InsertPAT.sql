USE CIPS_TEST_AG;

begin tran;

declare @NEXT_ID int;

set @NEXT_ID = ( select idd.nextid from idd where idd.TABLENAME = 'PAT' and idd.FIELDNAME = 'ID' );

with p as 
(
	select distinct [pat acct #] as pat_acct_#, [pat last name] as pat_last_name, [pat first name] as pat_first_name, [pat m name] as pat_m_name, 
						[date of birth] as date_of_Birth, [facility code] as facility_code, [pat location] as pat_location
						from cips_raw_philly.dbo.rx	
)
INSERT INTO [dbo].[PAT]
           ([ID]
           ,[ACCT_NUMBER]
           ,[BOOK_NUMBER]
           ,[LNAME]
           ,[FNAME]
           ,[MNAME]
           ,[DOB]
           ,[GENDER]
           ,[RACE]
           ,[LANG]
           ,[STATUS]
           ,[FAC_ID]
		   ,[CHG_ID]
           ,[LOCATION]
           ,[DISPENSE_TYPE]
           ,[DEFAULT_KOP]
           ,[SAFETYCAP_FLAG]
           ,[CLASS2_FLAG]
           ,[DISPLAY_FLAG]
           ,[COMPLIANT_FLAG]
           ,[BILL_FLAG]
           ,[SLF_CRY_FLAG]
           ,[CHECK_MEDISPAN_FLAG]
           ,[STOCK_FLAG]
           ,[ORIGIN]
           ,[AWAY]
           ,[SYS_DATE]
           ,[RESIDENCE]
		   ,[CONTROLLED_ALLOWED]
		   ,[ST] )
     SELECT
           @NEXT_ID + ROW_NUMBER() OVER (ORDER BY p.pat_acct_#), 
           p.pat_acct_#,
           NULL,
           p.pat_last_name,
           p.pat_first_name,
           p.pat_m_name,
           case when p.date_of_birth <> '<None>' then p.date_of_Birth else NULL end,
           'U',															--<GENDER, char(1),> - We get the full text from report writer exports, so use the first char
           'U',															--<RACE, char(1),>
           'E',															--<LANG, char(1),>
           'N',															--<STATUS, char(1),>
           case when fac.id is not null then fac.id else deffac.id end,	--<FAC_ID, int,>
		   chg.id,														--CHG_ID
           p.pat_location,												--<LOCATION, varchar(40),>
           'N',															--<DISPENSE_TYPE, char(1),>
           'S',															--<DEFAULT_KOP, char(1),>
           'F',															--<SAFETYCAP_FLAG, char(1),>
           'T',															--<CLASS2_FLAG, char(1),>
           'T',															--<DISPLAY_FLAG, char(1),>
           'T',															--<COMPLIANT_FLAG, char(1),>
           'T',															-- BILL_FLAG
           'T',															--<SLF_CRY_FLAG, char(1),>
           'T',															--<CHECK_MEDISPAN_FLAG, char(1),>
           'F',															--<STOCK_FLAG, char(1),>
           'NONE',														--<ORIGIN, varchar(10),>
           'F',															--<AWAY, char(1),>
           convert(date, getdate()),									--<SYS_DATE, [dbo].[DATE],>
           'Z',															--<RESIDENCE, char(1),>
		   'T',															--CONTROLLED_ALLOWED
		   '  '															--ST		

		from p
		left outer join cips_raw_philly.dbo.FacilityTranslation ft on ( ft.OldFacCode = p.facility_code )
		left outer join cips_raw_philly.dbo.FacilityTranslation fd on ( fd.Defaults = 'T' )
		left outer join fac on ( fac.dcode = ft.NewFacCode )
		left outer join fac deffac on ( deffac.dcode = fd.NewFacCode )
		left outer join chg on ( chg.dcode = 'COU' )
		where p.pat_acct_# not in ( select pat.ACCT_NUMBER from pat where pat.fac_id in ( select fac_id from rgn_fac where rgn_id = ( select data from cips_raw_philly.dbo.tmp_reg where id = 'RGN_ID' ) ) )
		and len(p.pat_acct_#) > 0
GO

update idd set nextid = ( select max(id) + 1 from pat ) where idd.tablename = 'PAT' and idd.FIELDNAME = 'ID';

commit;

--select max(id) from pat;
--select * from idd where tablename = 'pat';











