use L10
go

set transaction isolation level read uncommitted
--set transaction isolation level read committed
--set transaction isolation level repeatable read
--set transaction isolation level serializable
begin transaction

-----------����������--------------------------------------------

update Owners set Age=Age+4 where Name = '�������'
select * from Owners where Name = '�������'

--------------������� ������----------------------------------------

	--select * from Owners where Name = '�������'

-------�� �������������---------------------------------------------

--update Owners set Message = '� �������' where Name = '�������'

-----------�������-----------------------------------------------

	--insert dbo.Owners values('�������', '��� ��� ��������?', 21, 34)

--------------------------------------------------------------------

commit transaction
go