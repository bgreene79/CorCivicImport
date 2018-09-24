-- This SQL inserts rolled scripts based upon original script numbers...

USE CIPS_TEST_AG;

begin tran;

exec dbo.RollRxs 0;
exec dbo.RollRxs 1;
exec dbo.RollRxs 2;
exec dbo.RollRxs 3;
exec dbo.RollRxs 4;
exec dbo.RollRxs 5;
exec dbo.RollRxs 6;

update rxf set new_rxf_id = ( select r.id from rxf r where old_rxf_id = rxf.id )
	from rxf
	left outer join cips_raw_philly.dbo.tmp_reg tmp_conversion on ( tmp_conversion.id = 'conversion' )
	left outer join cips_raw_philly.dbo.tmp_reg tmp_phr_old on ( tmp_phr_old.id = 'PHR_ID' )
	where rxf.phr_id = tmp_phr_old.data
	and rxf.conversion = tmp_conversion.data
	and rxf.new_rxf_id is null;

commit;

--select max(id) from rxf;
--select * from rxf where id = 54403;





