  use L10
go

set transaction isolation level read uncommitted
--set transaction isolation level read committed
--set transaction isolation level repeatable read
--set transaction isolation level serializable
begin transaction

-----------����������--------------------------------------------

update Owners set Age=Age+10 where Name = '�������'
waitfor delay '00:00:07'
select * from Owners where Name = '�������'

-----------������� ������---------------------------------------------
--update Owners
--	set Message = '������� ������' where Name = '�������'
--	waitfor delay '00:00:07'
--	rollback work
--	select * from Owners 

----------�� �������������------------------------------------------------
	
	--update Owners
	--set Message = '� �����' where Name = '�������'
	--waitfor delay '00:00:07'
	--select * from Owners where Name = '�������'

----�������-----------------------------------------------------
	--select * from Owners
	--waitfor delay '00:00:07'
	--select * from Owners

commit transaction;
go

