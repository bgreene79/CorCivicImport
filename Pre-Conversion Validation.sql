
USE CIPS_TEST_AG;

-- Verify that we don't have fac translation codes not in CIPS...
IF  (select count(*) from cips_raw_philly.dbo.FacilityTranslation as FT
where NOT EXISTS ( select f.DCODE from FAC as F
					  where ft.NewFacCode = f.DCODE ) ) > 0
	
RAISERROR('NewFacCode not found in fac.dcodes', 16, 1 );

-- Get a count of records in the intermediate tables
select
( select count(*) from cips_raw_philly.dbo.alc ) as 'Patient ALC',
( select count(*) from cips_raw_philly.dbo.rx ) as 'Rx'

--Validate patient facility codes matching translation table...
select count(*) 'Unmapped Patient Facilities'
from cips_raw_philly.dbo.rx p
left outer join cips_raw_philly.dbo.FacilityTranslation ft on ( ft.OldFacCode = p.[facility code] )
where ft.NewFacCode is null;

--Look for missing and duplicate patient account #'s
select
( select count(distinct r.[Pat Acct #]) from cips_raw_philly.dbo.rx r ) as 'Patients',
( select count(*) from cips_raw_philly.dbo.rx r where len(r.[Pat Acct #]) = 0 ) as 'Patients with missing account #',
( select count(distinct r.[Pat Acct #]) from cips_raw_philly.dbo.rx r where len(r.[Pat Acct #]) > 0 ) as 'Unique Patients'

--Validate ALC_IDs - Any records returned are not in the 'TO' database...
select count(*) as 'Missing ALC Records'
from cips_raw_philly.dbo.alc a
left outer join alc on ( alc.DTEXT = a.[Allergy] )
where alc.id is null;

-- Check for allergies for patients not in table
select count(*) as 'Allergies for Missing Patients'
from cips_raw_philly.dbo.alc a
left outer join cips_raw_philly.dbo.rx r on ( r.[Pat Acct #] = a.[PAT ACCOUNT NUMBER] )
where r.[Rx Number] is null;

--Validate that intermediate table has doctor NPIs
select count(*) as 'Rx''s with missing provider NPI'
from cips_raw_philly.dbo.rx r
where ( r.[NPI Number] is null or len( r.[NPI Number] ) = 0 );

--Validate that intermediate table has drug names
select count(*) as 'Rx''s with missing drug names'
from cips_raw_philly.dbo.rx r
where ( r.[Drug Name] is null or len( r.[Drug Name] ) = 0 );




