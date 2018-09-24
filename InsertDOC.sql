USE CIPS_TEST_AG;

begin tran;

declare @NEXT_ID int;

set @NEXT_ID = ( select idd.nextid from idd where idd.TABLENAME = 'DOC' and idd.FIELDNAME = 'ID' );

with d as 
(
	select distinct [dea number] as dea_number, [npi number] as npi_number, [doc last name] as doc_last_name, [doc first name] as doc_first_name, [doc middle name] as doc_middle_name
		from cips_raw_philly.dbo.rx	
)
INSERT INTO [dbo].[DOC]
           ([ID]
           ,[LNAME]
           ,[FNAME]
           ,[MNAME]
           ,[DEA]
           ,[ST]
           ,[DORMANT_FLAG]
           ,[STOCK_LIABILITY_FLAG]
           ,[CNTRL_LIABILITY_FLAG]
           ,[NPI]
		   ,[CONVERSION])
     SELECT
           @NEXT_ID + ROW_NUMBER() OVER (ORDER BY d.npi_number),--<ID, int,>
           d.doc_last_name,										--<LNAME, varchar(20),>
           d.doc_first_name,									--<FNAME, varchar(20),>
           d.doc_middle_name,									--<MNAME, varchar(10),>
           d.dea_number,										--<DEA, varchar(9),>
           '  ',												--<ST, varchar(2),>
           'F',													--<DORMANT_FLAG, char(1),>
           'F',													--<STOCK_LIABILITY_FLAG, char(1),>
           'F',													--<CNTRL_LIABILITY_FLAG, char(1),>
           d.npi_number,										--<NPI, varchar(20),>           
		   r.data												--CONVERSION
	
	from d
	left outer join doc on ( doc.npi = d.npi_number )
	left outer join cips_raw_philly.dbo.tmp_reg r on ( r.id = 'conversion' )	
	where doc.id is null;

GO

update idd set nextid = ( select max(id) + 1 from doc ) where idd.tablename = 'DOC' and idd.FIELDNAME = 'ID';

commit;

--select max(id) from doc;
--select * from doc where id = 74179















