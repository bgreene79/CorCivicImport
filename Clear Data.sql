update rxf set fil_id = null where conversion = 'philly';

delete from fil where conversion = 'philly';
delete top(100) from rxf where conversion = 'philly';
delete from doc where conversion = 'philly';
delete from drg where conversion = 'philly';

select * from rxf where conversion = 'philly'

