use L10
go

set transaction isolation level read uncommitted
--set transaction isolation level read committed
--set transaction isolation level repeatable read
--set transaction isolation level serializable
begin transaction

-----------потерянные--------------------------------------------

update Owners set Age=Age+4 where Name = 'Антонио'
select * from Owners where Name = 'Антонио'

--------------грязное чтение----------------------------------------

	--select * from Owners where Name = 'Антонио'

-------не повторяющееся---------------------------------------------

--update Owners set Message = 'Я приехал' where Name = 'Антонио'

-----------Фантомы-----------------------------------------------

	--insert dbo.Owners values('Николай', 'Где мои покемоны?', 21, 34)

--------------------------------------------------------------------

commit transaction
go