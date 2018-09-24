USE CIPS_TEST_AG;

select
( select count(distinct r.[Pat Acct #] ) from cips_raw_philly.dbo.rx r ) 'Exported Patients',
( select count(*) from pat where pat.fac_id in ( select fac_id from rgn_fac where rgn_id = ( select data from cips_raw_philly.dbo.tmp_reg where id = 'RGN_ID' ) ) ) 'Imported Patients'

--select * from pat where fac_id in ( select fac_id from rgn_fac where rgn_id = 65 ) order by id;

select
( select count(distinct r.[NPI Number]) from cips_raw_philly.dbo.rx r ) 'Exported Doctors',
( select count(*) from doc where conversion = ( select data from cips_raw_philly.dbo.tmp_reg where id = 'conversion' ) ) 'Imported Doctors'

-- Keep in mind that we only add drugs where the name, strength, and dosage don't already exist in the CIPS drug table
select
( select count(distinct r.[Drug Name] + r.Strength + r.Dosage ) from cips_raw_philly.dbo.rx r ) 'Exported Drugs',
( select count(*) from drg where conversion = ( select data from cips_raw_philly.dbo.tmp_reg where id = 'conversion' ) ) 'Imported Drugs'

select
( select count(*) from cips_raw_philly.dbo.rx r ) 'Exported Rx''s',
( select count(*) from rxf where phr_id = ( select data from cips_raw_philly.dbo.tmp_reg r where r.id = 'PHR_ID' ) and rxf.conversion = ( select data from cips_raw_philly.dbo.tmp_reg tmp_conversion where tmp_conversion.id = 'conversion' ) ) 'CIPS OLD Rx''s',
( select count(*) from rxf where phr_id = ( select data from cips_raw_philly.dbo.tmp_reg r where r.id = 'NEW_PHR_ID' ) and rxf.conversion = ( select data from cips_raw_philly.dbo.tmp_reg tmp_conversion where tmp_conversion.id = 'conversion' ) ) 'CIPS NEW Rx''s',
( select count(*) from rxf where rxf.conversion = ( select data from cips_raw_philly.dbo.tmp_reg tmp_conversion where tmp_conversion.id = 'conversion' ) and fil_id is null ) 'Converted rx''s with missing fills'

select
( 
	select count(*) from cips_raw_philly.dbo.rx r 
	left outer join rxf on ( rxf.phr_id = ( select data from cips_raw_philly.dbo.tmp_reg r where r.id = 'PHR_ID' ) and rxf.rx_number = r.[Rx Number] ) 
	left outer join pat on ( pat.id = rxf.pat_id )
	where ( r.[Pat Last Name] <> pat.lname or [Pat First Name] <> pat.fname )
) 'Scripts with mismatched patients',
( 
	select count(*) from cips_raw_philly.dbo.rx r 
	left outer join rxf on ( rxf.phr_id = ( select data from cips_raw_philly.dbo.tmp_reg r where r.id = 'PHR_ID' ) and rxf.rx_number = r.[Rx Number] ) 
	left outer join doc on ( doc.id = rxf.doc_id )
	where ( r.[Doc Last Name] <> doc.lname )-- or r.[Doc First Name] <> doc.fname )
) 'Scripts with mismatched doctors',
( 
	select count(*) from cips_raw_philly.dbo.rx r 
	left outer join rxf on ( rxf.phr_id = ( select data from cips_raw_philly.dbo.tmp_reg r where r.id = 'PHR_ID' ) and rxf.rx_number = r.[Rx Number] ) 
	left outer join drg on ( drg.id = rxf.drg_id )
	where ( r.[Drug Name] <> drg.dname or r.Strength <> drg.strength or r.Dosage <> drg.dos_id )
) 'Scripts with mismatched drugs';

/*
-- Get list of mismatched docs

select r.[Doc Last Name], r.[Doc First Name], r.[NPI Number], doc.lname, doc.fname, doc.npi
	from cips_raw_philly.dbo.rx r 
	left outer join rxf on ( rxf.phr_id = ( select data from cips_raw_philly.dbo.tmp_reg r where r.id = 'PHR_ID' ) and rxf.rx_number = r.[Rx Number] ) 
	left outer join doc on ( doc.id = rxf.doc_id )
	where ( r.[Doc Last Name] <> doc.lname or r.[Doc First Name] <> doc.fname )
*/

-- Verify that we have updated Rx # range IDD appropriately
select idd.fieldname, idd.nextid, rxf.rx_number as 'Rx Number - If NULL we are good'
from idd
left outer join rxf on ( rxf.phr_id = ( select data from cips_raw_philly.dbo.tmp_reg r where r.id = 'NEW_PHR_ID' ) and rxf.rx_number = idd.nextid )
where idd.TABLENAME = 'RXF'
and idd.fieldname like '%NUMBER%'
and idd.nextid > 0;










