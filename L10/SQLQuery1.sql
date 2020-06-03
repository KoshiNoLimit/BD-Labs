  use L10
go

set transaction isolation level read uncommitted
--set transaction isolation level read committed
--set transaction isolation level repeatable read
--set transaction isolation level serializable
begin transaction

-----------потерянные--------------------------------------------

update Owners set Age=Age+10 where Name = 'Антонио'
waitfor delay '00:00:07'
select * from Owners where Name = 'Антонио'

-----------грязное чтение---------------------------------------------
--update Owners
--	set Message = 'грязное чтение' where Name = 'Антонио'
--	waitfor delay '00:00:07'
--	rollback work
--	select * from Owners 

----------не повторяющееся------------------------------------------------
	
	--update Owners
	--set Message = 'Я уехал' where Name = 'Антонио'
	--waitfor delay '00:00:07'
	--select * from Owners where Name = 'Антонио'

----ФАнтомы-----------------------------------------------------
	--select * from Owners
	--waitfor delay '00:00:07'
	--select * from Owners

commit transaction;
go

