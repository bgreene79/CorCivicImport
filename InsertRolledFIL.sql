-- This SQL inserts the rolled rx # fills...

USE CIPS_TEST_AG;

begin tran;

declare @NEXT_ID int;

set @NEXT_ID = ( select idd.nextid from idd where idd.TABLENAME = 'FIL' and idd.FIELDNAME = 'ID' );

INSERT INTO [dbo].[FIL]
           ([ID]
           ,[RXF_ID]
           ,[PHR_ID]
           ,[RXF_NUMBER]
           ,[SEQ_NUM]
           ,[NDC]
           ,[DEA]
           ,[STATUS]
           ,[KOP]
           ,[QTY_DSP]
           ,[QTY_SENT]
           ,[QTY_PER_CARD]
           ,[QTY_PER_BUBBLE]
           ,[DISPENSE_QTY]
           ,[DAYS_SUPPLY]
           ,[UNIT]
           ,[LOT_NUMBER]
           ,[LOT_DATE]
           ,[FAC_TYPE]
           ,[ORIGIN]
           ,[PAT_LOCATION]
           ,[LABEL_COUNT]
           ,[LABEL_SPLITS]
           ,[SCRIPTTYPE]
           ,[PAT_ID]
           ,[DRG_ID]
           ,[FAC_ID]
           ,[ORD_DRG_ID]
           ,[PRI_ID]
           ,[PHARMACIST]
           ,[PHARM_USR_ID]
           ,[TECH]
           ,[TECH_USR_ID]
           ,[PND_USR_ID]
           ,[SYS_USR_ID]
           ,[PV_USR_ID]
           ,[VOID_SYS_USR_ID]
           ,[VOID_REA_ID]
           ,[CHG_ID]
           ,[PRC_ID]
           ,[DSP_ID]
           ,[OVR_ID]
           ,[DISPENSE_TEXT]
           ,[AUTHORIZE]
           ,[RXF_ORD_ID]
           ,[RXF_ORD_ORDER_NUM]
           ,[MACHINE]
           ,[THP]
           ,[FIL_DATE]
           ,[BIL_DATE]
           ,[TIME_DISPENSED]
           ,[SYS_DATE]
           ,[SYS_TIME]
           ,[SYS_TIME_HOUR]
           ,[ADM_DATE]
           ,[ADM_PASS]
           ,[END_DATE]
           ,[END_PASS]
           ,[VOID_SYS_DATE]
           ,[VOID_SYS_TIME]
           ,[PRC_FACTOR]
           ,[PRC_FEE]
           ,[COST_BASIS]
           ,[COST]
           ,[HIGH_ACQ_COST]
           ,[ACQ_COST]
           ,[PRICE]
           ,[AWP]
           ,[GENERIC_FLAG]
           ,[PREGNANT_FLAG]
           ,[PREFERRED_FLAG]
           ,[RTN_FLAG]
           ,[FORMULARY_FLAG]
           ,[BILL_FLAG]
           ,[SAFETY_CAP_FLAG]
           ,[MAINTENANCE_FLAG]
           ,[OTC_FLAG]
           ,[CREDITABLE_FLAG]
           ,[LAB_REQ_FLAG]
           ,[PACKS_FLAG]
           ,[DSP_FILL_FLAG]
           ,[SHOW_IN_REVIEW_FLAG]
           ,[SCREENED]
           ,[PR_FLAG]
           ,[DI_SEVERITY]
           ,[RXF_CON_ID]
           ,[SAVED_VERSION]
           ,[VERSION]
           ,[PHARMACY_FLAG]
           ,[U_COST_BASIS]
           ,[THREE]
		   ,[EMAR]
           ,[NET_QTY_DSP]
           ,[CARD_QUANT]
           ,[MANUAL_PRC_FLAG]
           ,[WAC_COST]
           ,[QTY_UNCOSTED]
		   ,[CONVERSION])
     SELECT
           @NEXT_ID + ROW_NUMBER() OVER (ORDER BY rxf.id),					--<ID, int,>
           rxf.id,															--<RXF_ID, int,>
           rxf.phr_id,														--<PHR_ID, int,>
           rxf.rx_number,													--<RXF_NUMBER, int,>
           0,																--<SEQ_NUM, int,>
           drg.ndc,															--<NDC, varchar(14),>
           drg.dea,															--<DEA, char(1),>
           'F',																--<STATUS, char(1),>
           rxf.next_fil_type,												--<KOP, char(1),>
           0,																--<QTY_DSP, decimal(12,4),>
           0,																--<QTY_SENT, decimal(12,4),>
           0,																--<QTY_PER_CARD, decimal(12,4),>
           0,																--<QTY_PER_BUBBLE, decimal(12,4),>
           0,																--<DISPENSE_QTY, decimal(12,4),>
           0,																--<DAYS_SUPPLY, int,>
           drg.dis_unit,													--<UNIT, char(1),>
           NULL,															--<LOT_NUMBER, varchar(13),>
           NULL,															--<LOT_DATE, [dbo].[DATE],>
           NULL,															--<FAC_TYPE, char(1),>
           'N',																--<ORIGIN, char(1),>
           NULL,															--<PAT_LOCATION, varchar(40),>
           0,																--<LABEL_COUNT, int,>
           NULL,															--<LABEL_SPLITS, varchar(255),>
           'C',																--<SCRIPTTYPE, char(1),>
           rxf.pat_id,														--<PAT_ID, int,>
           rxf.drg_id,														--<DRG_ID, int,>
           pat.fac_id,														--<FAC_ID, int,>
           rxf.drg_id,														--<ORD_DRG_ID, int,>
           NULL,															--<PRI_ID, int,>
           rph_usr.initials,												--<PHARMACIST, varchar(3),>
           rph_usr.id,														--<PHARM_USR_ID, int,>
           rph_usr.initials,												--<TECH, varchar(3),>
           rph_usr.id,														--<TECH_USR_ID, int,>
           NULL,															--<PND_USR_ID, int,>
           rxf.sys_usr_id,													--<SYS_USR_ID, int,>
           NULL,															--<PV_USR_ID, int,>
           NULL,															--<VOID_SYS_USR_ID, int,>
           NULL,															--<VOID_REA_ID, varchar(8),>
           pat.chg_id,														--<CHG_ID, int,>
           NULL,															--<PRC_ID, int,>
           NULL,															--<DSP_ID, int,>
           NULL,															--<OVR_ID, int,>
           NULL,															--<DISPENSE_TEXT, varchar(40),>
           NULL,															--<AUTHORIZE, varchar(30),>
           NULL,															--<RXF_ORD_ID, int,>
           rxf.RXF_ORD_ORDER_NUM,											--<RXF_ORD_ORDER_NUM, varchar(60),>
           'N',																--<MACHINE, char(1),>
           'F',																--<THP, char(1),>
           rxf.sys_date,													--<FIL_DATE, [dbo].[DATE],>
           rxf.sys_Date,													--<BIL_DATE, [dbo].[DATE],>
           NULL,															--<TIME_DISPENSED, [dbo].[DATE],>
           convert(date, getdate()),										--<SYS_DATE, [dbo].[DATE],>
           convert(time, getdate()),										--<SYS_TIME, [dbo].[DATE],>
           NULL,															--<SYS_TIME_HOUR, int,>
           rxf.sys_date,													--<ADM_DATE, [dbo].[DATE],>
           NULL,															--<ADM_PASS, varchar(10),>
           NULL,															--<END_DATE, [dbo].[DATE],>
           NULL,															--<END_PASS, varchar(10),>
           NULL,															--<VOID_SYS_DATE, [dbo].[DATE],>
           NULL,															--<VOID_SYS_TIME, [dbo].[DATE],>
           NULL,															--<PRC_FACTOR, decimal(10,4),>
           NULL,															--<PRC_FEE, decimal(10,4),>
           'N',																--<COST_BASIS, char(1),>
           0,																--<COST, decimal(10,4),>
           0,																--<HIGH_ACQ_COST, decimal(10,4),>
           0,																--<ACQ_COST, decimal(10,4),>
           0,																--<PRICE, decimal(10,4),>
           0,																--<AWP, decimal(10,4),>
           drg.generic_flag,												--<GENERIC_FLAG, char(1),>
           'F',																--<PREGNANT_FLAG, char(1),>
           'F',																--<PREFERRED_FLAG, char(1),>
           'F',																--<RTN_FLAG, char(1),>
           'F',																--<FORMULARY_FLAG, char(1),>
           'T',																--<BILL_FLAG, char(1),>
           'F',																--<SAFETY_CAP_FLAG, char(1),>
           'F',																--<MAINTENANCE_FLAG, char(1),>
           drg.otc_flag,													--<OTC_FLAG, char(1),>
           'F',																--<CREDITABLE_FLAG, char(1),>
           'F',																--<LAB_REQ_FLAG, char(1),>
           'F',																--<PACKS_FLAG, char(1),>
           'F',																--<DSP_FILL_FLAG, char(1),>
           'T',																--<SHOW_IN_REVIEW_FLAG, char(1),>
           'N',																--<SCREENED, char(1),>
           'F',																--<PR_FLAG, char(1),>
           NULL,															--<DI_SEVERITY, int,>
           NULL,															--<RXF_CON_ID, int,>
           NULL,															--<SAVED_VERSION, varchar(12),>
           '?',																--<VERSION, varchar(12),>
           'T',																--<PHARMACY_FLAG, char(1),>
           'N',																--<U_COST_BASIS, char(1),>
           'F',																--<THREE, char(1),>
           'F',																--<EMAR, char(1),>
           0,																--<NET_QTY_DSP, decimal(12,4),>
           0,																--<CARD_QUANT, decimal(12,4),>
           'F',																--<MANUAL_PRC_FLAG, char(1),>
           0,																--<WAC_COST, decimal(10,4),>
           0,																--<QTY_UNCOSTED, decimal(12,4),>
		   rxf.conversion													--CONVERSION

	from rxf
	left outer join pat on ( pat.id = rxf.pat_id )
	left outer join drg on ( drg.id = rxf.drg_id )
	left outer join cips_raw_philly.dbo.tmp_reg tmp_rph on ( tmp_rph.id = 'RPH_USR_ID' )
	left outer join usr rph_usr on ( rph_usr.id = tmp_rph.data )
	left outer join cips_raw_philly.dbo.tmp_reg cnv on ( cnv.id = 'conversion' )	
	where rxf.conversion = cnv.data
	and rxf.fil_id is null;

GO

update idd set nextid = ( select max(id) + 1 from FIL ) where idd.tablename = 'FIL' and idd.FIELDNAME = 'ID';

commit;

/***************************************************************/
/* Now tie the profiled fill back to the RXF                   */
/***************************************************************/

update rxf set fil_id = fil.id, last_fil = fil.fil_date
from rxf
left outer join fil on ( fil.rxf_id = rxf.id )
where rxf.fil_id is null;

/***************************************************************/














