-- This SQL inserts original rx # fills, the scripts will be rolled into customer rx # range...

USE CIPS_TEST_AG;

begin tran;

declare @NEXT_ID int;

set @NEXT_ID = ( select idd.nextid from idd where idd.TABLENAME = 'DCM' and idd.FIELDNAME = 'ID' );

INSERT INTO [dbo].DCM
           ([ID]
           ,[RXF_ID]
		   ,[REA_ID]
		   ,[USR_ID]
		   ,[DC_DATE]
		   ,[SYS_DATE]
		   ,[SYS_TIME])
     SELECT
           @NEXT_ID + ROW_NUMBER() OVER (ORDER BY rxf.id),					--<ID, int,>
           rxf.id,															--<RXF_ID, int,>
           tmp_rea.data,													--REA_ID
		   tmp_usr.data,													--USR_ID
		   rxf.dc_date,														--DC_DATE
		   convert(date, getdate()),										--<SYS_DATE, [dbo].[DATE],>
           convert(time, getdate())											--<SYS_TIME, [dbo].[DATE],>
           
	from rxf
	left outer join cips_raw_philly.dbo.tmp_reg tmp_phr on ( tmp_phr.id = 'PHR_ID' )	
	left outer join cips_raw_philly.dbo.tmp_reg tmp_usr on ( tmp_usr.id = 'SYS_USR_ID' )
	left outer join cips_raw_philly.dbo.tmp_reg tmp_rea on ( tmp_rea.id = 'DC_REA_ID' )
	left outer join usr on ( usr.id = tmp_usr.data )
	left outer join dcm on ( dcm.rxf_id = rxf.id )
	where rxf.phr_id = tmp_phr.data
	and rxf.dc_flag = 'T'
	and dcm.id is null;

GO

update idd set nextid = ( select max(id) + 1 from DCM ) where idd.tablename = 'DCM' and idd.FIELDNAME = 'ID';

commit;

--select max(id) from dcm;
--select * from dcm where id >= 598














