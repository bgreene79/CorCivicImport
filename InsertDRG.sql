USE CIPS_TEST_AG;

begin tran;

declare @NEXT_ID int;

set @NEXT_ID = ( select idd.nextid from idd where idd.TABLENAME = 'DRG' and idd.FIELDNAME = 'ID' );

with d as 
(
	select distinct [drug name] drug_name, [strength] strength, [dosage] dosage
		from cips_raw_philly.dbo.rx	
)
INSERT INTO [dbo].[DRG]
           ([ID]
           ,[DNAME]
           ,[STRENGTH]
           ,[DOS_ID]
           ,[NDC]
           ,[FORMATTED_NDC]
           ,[DEA]
           ,[DEFAULT_DAYS_FAC]
           ,[DEFAULT_REF_DAYS_FAC]
           ,[NF_DAYS_FAC]
           ,[NF_REF_DAYS_FAC]
           ,[NOFORM_DAYS_FAC]
           ,[NOFORM_REF_DAYS_FAC]
           ,[DISPENSE_QTY_FLAG]
           ,[DIS_UNIT]
           ,[PUR_UNIT]
           ,[INV_UNIT]
           ,[ORD_UNIT]
           ,[DISPLAY_FLAG]
           ,[ACQ_UPDATE_FLAG]
           ,[AWP_UPDATE_FLAG]
           ,[GENERIC_FLAG]
           ,[DORMANT_FLAG]
           ,[MAINTENANCE_FLAG]
           ,[OTC_FLAG]
           ,[MULTI_ING_FLAG]
           ,[FRIDGE_FLAG]
           ,[FORMULARY_FLAG]
           ,[SELF_CARRY_FLAG]
           ,[BILL_FLAG]
           ,[NON_MED_FLAG]
           ,[CREDITABLE_FLAG]
           ,[REFILL_DUE_FLAG]
           ,[PEDIGREE_FLAG]
           ,[FORCE_REVIEW_FLAG]
           ,[MACHINE]
           ,[ROA]
           ,[DEFAULT_KOP]
           ,[FORCE_KOP_FLAG]
           ,[DST_DISPENSE]
           ,[CONSENT_REQUIRED]
           ,[WAC_UPDATE_FLAG]
           ,[PHARMACY_FLAG]
           ,[HCPC_CODE]
           ,[CMP_FORM_CODE]
           ,[CMP_UNIT_CODE]
           ,[CMP_ROUTE_CODE]
           ,[THREE_FLAG]
           ,[CMP_TYPE]
           ,[LOT_NUM_FLAG]
           ,[THP_OPTION]
           ,[FORMULARY_TWO_FLAG]
           ,[ALLOW_STOCK_FLAG]
           ,[PROFILE_ONLY_FLAG]
           ,[LIFE_SUSTAINING_FLAG]
           ,[OPIOID_FLAG]
		   ,[CONVERSION])
     SELECT           
		   @NEXT_ID + ROW_NUMBER() OVER (ORDER BY d.drug_name),																		--<ID, int,><ID, int,>
           d.drug_name,																												--<DNAME, varchar(30),>
           d.strength,																												--<STRENGTH, varchar(12),>
           d.dosage,																												--<DOS_ID, varchar(8),>
           'CONVERSION',																											--<NDC, varchar(13),>
           'CONVERSION',																											--<FORMATTED_NDC, varchar(11),>
           0,																														--<DEA, char(1),>
           'D',																														--<DEFAULT_DAYS_FAC, char(1),>
           'D',																														--<DEFAULT_REF_DAYS_FAC, char(1),>
           'D',																														--<NF_DAYS_FAC, char(1),>
           'D',																														--<NF_REF_DAYS_FAC, char(1),>
           'D',																														--<NOFORM_DAYS_FAC, char(1),>
           'D',																														--<NOFORM_REF_DAYS_FAC, char(1),>
           'F',																														--<DISPENSE_QTY_FLAG, char(1),>
           'E',																														--<DIS_UNIT, char(1),>
           'E',																														--<PUR_UNIT, char(1),>
           'E',																														--<INV_UNIT, char(1),>
           'E',																														--<ORD_UNIT, char(1),>
           'F',																														--<DISPLAY_FLAG, char(1),>
           'T',																														--<ACQ_UPDATE_FLAG, char(1),>
           'T',																														--<AWP_UPDATE_FLAG, char(1),>
           'T',																														--<GENERIC_FLAG, char(1),>
           'T',																														--<DORMANT_FLAG, char(1),>
           'F',																														--<MAINTENANCE_FLAG, char(1),>
           'F',																														--<OTC_FLAG, char(1),>
           'F',																														--<MULTI_ING_FLAG, char(1),>
           'F',																														--<FRIDGE_FLAG, char(1),>
           'F',																														--<FORMULARY_FLAG, char(1),>
           'T',																														--<SELF_CARRY_FLAG, char(1),>
           'T',																														--<BILL_FLAG, char(1),>
           'F',																														--<NON_MED_FLAG, char(1),>
           'T',																														--<CREDITABLE_FLAG, char(1),>
           'T',																														--<REFILL_DUE_FLAG, char(1),>
           'T',																														--<PEDIGREE_FLAG, char(1),>
           'F',																														--<FORCE_REVIEW_FLAG, char(1),>
           'N',																														--<MACHINE, char(1),>
           '  ',																													--<ROA, varchar(2),>
           'D',																														--<DEFAULT_KOP, char(1),>
           'F',																														--<FORCE_KOP_FLAG, char(1),>
           'C',																														--<DST_DISPENSE, char(1),>
           'F',																														--<CONSENT_REQUIRED, char(1),>
           'T',																														--<WAC_UPDATE_FLAG, char(1),>
           'T',																														--<PHARMACY_FLAG, char(1),>
           '0',																														--<HCPC_CODE, char(1),>
           '0',																														--<CMP_FORM_CODE, char(1),>
           '0',																														--<CMP_UNIT_CODE, char(1),>
           '0',																														--<CMP_ROUTE_CODE, char(1),>
           'F',																														--<THREE_FLAG, char(1),>
           '0',																														--<CMP_TYPE, char(1),>
           'F',																														--<LOT_NUM_FLAG, char(1),>
           'N',																														--<THP_OPTION, char(1),>
           'F',																														--<FORMULARY_TWO_FLAG, char(1),>
           'T',																														--<ALLOW_STOCK_FLAG, char(1),>
           'F',																														--<PROFILE_ONLY_FLAG, char(1),>
           'F',																														--<LIFE_SUSTAINING_FLAG, char(1),>
           'F',																														--<OPIOID_FLAG, char(1),>           
		   r.data																													--CONVERSION
	from d
	left outer join cips_raw_philly.dbo.tmp_reg r on ( r.id = 'conversion' )	
	left outer join drg on ( drg.dname = d.drug_name and drg.strength = d.strength and drg.DOS_ID = d.dosage )
	where drg.id is null;
GO

update idd set nextid = ( select max(id) + 1 from DRG ) where idd.tablename = 'DRG' and idd.FIELDNAME = 'ID';

commit;

--select * from drg where conversion = 'philly'
--select distinct [drug id] drug_id, [formatted ndc] formatted_ndc, [drug name] drug_name, [strength] strength, [dosage] dosage from cips_raw_philly.dbo.rx	














