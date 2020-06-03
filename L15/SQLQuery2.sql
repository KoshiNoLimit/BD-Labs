 use master;
go
 
drop database if exists l13_1;
go
 
create database l13_1;
go
 
use l13_1;
go
 
create table Owner (
	ID int primary key identity,
	Name varchar(30) unique,
	Wins int check(Wins >= 0)
)
go

create trigger OwDel on Owner after delete as
begin
	update l13_2.dbo.Pokemon 
	set Owner = null 
	where Owner in(select Name from deleted)
end
go

create trigger OwUp on Owner instead of update as 
begin
	if(update(Name))
	begin
		raiserror('Name can not be changed', 16, 1)
		return
	end	
	else update Owner set Wins = inserted.Wins from inserted where Owner.ID = inserted.ID
end
go


insert Owner values 
				('A', 21),
				('B', 9),
				('C', 6)
go

update Owner set Wins = 30 where Wins = 21
update Owner set Name = 'X' where Name = 'A'
select * from Owner
go