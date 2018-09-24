USE CIPS_TEST_AG;

begin tran;

declare @NEXT_ID int;

set @NEXT_ID = ( select idd.nextid from idd where idd.TABLENAME = 'PAT_ALC' and idd.FIELDNAME = 'ID' );

--select * from alc

INSERT INTO [dbo].[PAT_ALC]
           ([ID]
           ,[PAT_ID]
           ,[ALC_ID]
           ,[RASH_FLAG]
           ,[SHOCK_FLAG]
           ,[ASTHMA_FLAG]
           ,[NAUSEA_FLAG]
           ,[ANEMIA_FLAG]
           ,[OTHER_FLAG])
     SELECT
           @NEXT_ID + ROW_NUMBER() OVER (ORDER BY a.[pat account number]),
           pat.id,													--<PAT_ID, int,>
           alc.id,													--<ALC_ID, int,>
           'F',														--<RASH_FLAG, char(1),>
           'F',														--<SHOCK_FLAG, char(1),>
           'F',														--<ASTHMA_FLAG, char(1),>
           'F',														--<NAUSEA_FLAG, char(1),>
           'F',														--<ANEMIA_FLAG, char(1),>
           'F'														--<OTHER_FLAG, char(1),>

	from cips_raw_philly.dbo.alc a
	left outer join pat on ( pat.acct_number = a.[pat account number] and pat.fac_id in ( select fac_id from rgn_fac where rgn_id = ( select data from cips_raw_philly.dbo.tmp_reg where id = 'RGN_ID' ) ) )
	left outer join alc on ( alc.DTEXT = a.Allergy )
	where pat.id is not null
	and pat.id not in ( select pat_id from pat_alc where pat_alc.pat_id = pat.id and pat_alc.alc_id = alc.id );

GO

update idd set nextid = ( select max(id) + 1 from pat_alc ) where idd.tablename = 'PAT_ALC' and idd.FIELDNAME = 'ID';

commit;














