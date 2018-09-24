-- This SQL inserts original rx # scripts, they will be rolled into customer rx # range...

USE CIPS_TEST_AG;

begin tran;

declare @NEXT_ID int;

set @NEXT_ID = ( select idd.nextid from idd where idd.TABLENAME = 'RXF' and idd.FIELDNAME = 'ID' );

--select patindex( '%AS NEEDED%', 'take as needed' )

INSERT INTO [dbo].[RXF]
           ([ID]
           ,[RX_NUMBER]
           ,[REF_USED]
           ,[REF_LEFT]
           ,[SIG]
           ,[EXPANDED_SIG]
           ,[EXPAND_SIG_FLAG]
           ,[ROA]
           ,[REF_DAYS_SUPPLY]
           ,[DAYS_SUPPLY]
           ,[NEXT_FIL_TYPE]
           ,[PRN_FLAG]
           ,[FILLS_ALLOWED]
           ,[SIG_PRN_FLAG]
           ,[DAW]
           ,[ORIGIN]
           ,[SCRIPTTYPE]
           ,[DC_REA_ID]
           ,[FIL_ID]
           ,[PAT_ID]
           ,[DRG_ID]
           ,[DOC_ID]
           ,[PHR_ID]
           ,[NEW_RXF_ID]
           ,[OLD_RXF_ID]
           ,[SYS_USR_ID]
           ,[RXF_ORD_ID]
           ,[RXF_ORD_ORDER_NUM]
           ,[RXF_ORD_TYPE]
           ,[TOT_QTY_DUE]
           ,[QTY_DUE]
           ,[QTY_USED]
           ,[QTY_DOSE]
           ,[DLY_QTY]
           ,[REF_QTY]
           ,[ORG_DATE]
           ,[FIRST_ORG_DATE]
           ,[EXP_DATE]
           ,[DC_DATE]
           ,[ORD_DATE]
           ,[LAST_FIL]
           ,[SYS_DATE]
           ,[SYS_TIME]
           ,[DC_FLAG]
           ,[UNEVEN_DOSE_FLAG]
           ,[STOCK_FLAG]
           ,[DISTRIBUTION_FLAG]
           ,[MAR_PRINT_FLAG]
           ,[ACT_REF_USED]           
           ,[RELEASE_FLAG]
           ,[RXF_ORD_CODE]
           ,[SHORT_TERM_FLAG]
           ,[NEW_RXF_ORD_ID]
           ,[EPCS_FLAG]
           ,[FILLS_USED]
		   ,[CONVERSION])
     SELECT
           @NEXT_ID + ROW_NUMBER() OVER (ORDER BY r.[rx number]),					--<ID, int,>
           r.[rx number],															--<RX_NUMBER, int,>									
           0,																		--<REF_USED, int,>
           0,																		--<REF_LEFT, int,>
           r.[expanded sig],														--<SIG, varchar(255),>
           r.[expanded sig],														--<EXPANDED_SIG, varchar(255),>
           'F',																		--<EXPAND_SIG_FLAG, char(1),>
           '  ',																	--<ROA, varchar(2),>
           fac.default_ref_days,													--<REF_DAYS_SUPPLY, int,>
           r.[days supply],															--<DAYS_SUPPLY, int,>
           'M',																		--<NEXT_FIL_TYPE, char(1),>
           'F',																		--<PRN_FLAG, char(1),>
           0,																		--<FILLS_ALLOWED, int,>
           case when patindex( '%AS NEEDED%', r.[Expanded SIG] ) > 0 then 'T' else 'F' end,	--<SIG_PRN_FLAG, char(1),>
           '0',																		--<DAW, char(1),>
           'N',																		--<ORIGIN, char(1),>			
           'C',																		--<SCRIPTTYPE, char(1),>
           tmp_rea.data,															--<DC_REA_ID, varchar(8),>
           NULL,																	--<FIL_ID, int,>
           pat.id,																	--<PAT_ID, int,>
           drg.id,																	--<DRG_ID, int,>
           doc.id,																	--<DOC_ID, int,>
           tmp_phr.data,															--<PHR_ID, int,>
           NULL,																	--<NEW_RXF_ID, int,>
           NULL,																	--<OLD_RXF_ID, int,>
           tmp_usr.data,															--<SYS_USR_ID, int,>
           NULL,																	--<RXF_ORD_ID, int,>
           NULL,																	--<RXF_ORD_ORDER_NUM, varchar(60),>
           'CORMRSRV2',																--<RXF_ORD_TYPE, varchar(10),>  - Clinical uses the CorEMR2 service for everything
           convert( decimal(12,4), r.[daily qty] ) * convert( int, r.[days supply] ),--<TOT_QTY_DUE, decimal(12,4),>
           convert( decimal(12,4), r.[daily qty] ) * convert( int, r.[days supply] ),--<QTY_DUE, decimal(12,4),>
           0,																		--<QTY_USED, decimal(12,4),>
           r.[qty per dose],														--<QTY_DOSE, decimal(12,4),>
           r.[daily qty],															--<DLY_QTY, decimal(12,4),>
           0,																		--<REF_QTY, decimal(12,4),>
           r.[original date],														--<ORG_DATE, [dbo].[DATE],>
           r.[original date],														--<FIRST_ORG_DATE, [dbo].[DATE],>
           r.[expiration date],														--<EXP_DATE, [dbo].[DATE],>
           convert(date, getdate()),												--<DC_DATE, [dbo].[DATE],>
           case when r.[date ordered] = '<None>' then NULL else r.[date ordered] end,--<ORD_DATE, [dbo].[DATE],>
           NULL,																	--<LAST_FIL, [dbo].[DATE],>
           convert(date, getdate()),												--<SYS_DATE, [dbo].[DATE],>
           convert(time, getdate()),												--<SYS_TIME, [dbo].[DATE],>
           'T',																		--<DC_FLAG, char(1),>
           'F',																		--<UNEVEN_DOSE_FLAG, char(1),>
           pat.stock_flag,															--<STOCK_FLAG, char(1),>
           'F',																		--<DISTRIBUTION_FLAG, char(1),>
           'F',																		--<MAR_PRINT_FLAG, char(1),>
           0,																		--<ACT_REF_USED, int,>
           'F',																		--<RELEASE_FLAG, char(1),>
           NULL,																	--<RXF_ORD_CODE, varchar(10),>
           'F',																		--<SHORT_TERM_FLAG, char(1),>
           NULL,																	--<NEW_RXF_ORD_ID, int,>
           'F',																		--<EPCS_FLAG, char(1),>
           0,																		--<FILLS_USED, int,>
		   tmp_conversion.data														--CONVERSION


	from cips_raw_philly.dbo.rx r
	left outer join cips_raw_philly.dbo.tmp_reg tmp_phr on ( tmp_phr.id = 'PHR_ID' )
	left outer join cips_raw_philly.dbo.tmp_reg tmp_usr on ( tmp_usr.id = 'SYS_USR_ID' )
	left outer join cips_raw_philly.dbo.tmp_reg tmp_rea on ( tmp_rea.id = 'DC_REA_ID' )
	left outer join pat on ( pat.acct_number = r.[pat acct #] and pat.fac_id in ( select fac_id from rgn_fac where rgn_id = ( select data from cips_raw_philly.dbo.tmp_reg where id = 'RGN_ID' ) ) )
	left outer join fac on ( fac.id = pat.fac_id )
	left outer join drg on ( drg.id = ( select min(d.id) from drg d where d.dname = r.[Drug Name] and d.strength = r.[Strength] and d.DOS_ID = r.Dosage ) )
	left outer join doc on ( doc.npi = r.[npi number] )
	left outer join cips_raw_philly.dbo.tmp_reg tmp_conversion on ( tmp_conversion.id = 'conversion' )
	left outer join rxf on ( rxf.phr_id = tmp_phr.data and rxf.rx_Number = r.[Rx Number] )
	where rxf.id is null;
GO

update idd set nextid = ( select max(id) + 1 from RXF ) where idd.tablename = 'RXF' and idd.FIELDNAME = 'ID';

commit;

--select * from cips_raw_philly.dbo.rx r














