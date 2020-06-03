use master
if db_id (N'L9') is not null
drop database L9;
create database L9
	on  
		(name = PrimaryData, 
		filename = 'C:\data\L9.mdf', size = 10 mb, maxsize = unlimited, filegrowth = 10% )
	log on
		(name = LogData, 
		filename = 'C:\data\L91.ldf', size = 10 mb, maxsize = unlimited, filegrowth = 10% )
go
use L9
go

IF OBJECT_ID (N'dbo.Pokemons', N'U') IS NOT NULL  
DROP TABLE dbo.Pokemons; 
IF OBJECT_ID (N'dbo.Owners', N'U') IS NOT NULL  
DROP TABLE dbo.Owners; 
go
IF OBJECT_ID ('RESUME_FOR_TOURNIR', 'V') IS NOT NULL  
DROP VIEW RESUME_FOR_TOURNIR;  
GO  
---------------------------------------------------------------------------------------
create table dbo.Owners ( 
	Name varchar(30) primary key not null,
	Message varchar(100) default 'Hi, man',
	Age tinyint null,
	Wins tinyint default 0 
)
go

create table dbo.Pokemons (
	PokemonID int primary key identity(0, 1), 
	Name varchar(30),
	Owner varchar(30) foreign key references dbo.Owners (Name)
		on update cascade
		on delete set null,
	Power int check (Power > 0) null
)
go

insert dbo.Owners values
	('Владимир', 'Я пришел за победой!', 34, 0)
insert dbo.Owners values
	('Антонио', default, 19, 14)
go
insert dbo.Pokemons values
	('Pikachui', 'Владимир' , 500)
insert dbo.Pokemons values
	('Metapod', 'Антонио', 211)
insert dbo.Pokemons values
	('Charmeleon', null, 342)
go

create view RESUME_FOR_TOURNIR as
	select
		o.Name as Login, o.Wins, p.Name as Pokemon_name
	from Owners o INNER JOIN Pokemons p
		on o.Name = p.Owner
go
-----------------------------------------------------------------------------------------


--------------------------------------1--------------------------------------------------
create trigger onInsert 
on Pokemons 
for insert as
begin
	print 'new Pokemon'
end
go

create trigger onDelete 
on Pokemons 
for delete as
begin
	if exists(select * 
				from deleted 
				where Power > 500)
		raiserror('Error', 16, 1)
end
go

create trigger onUpdate 
on Pokemons  
for update as
begin
	print 'Updated'
end
go
----------------------------------------------------------------------------------------


-----------------------------------2----------------------------------------------------
create trigger onViewInsert 
on RESUME_FOR_TOURNIR 
instead of insert as
begin
	insert into Owners(Name, Wins)
	select 
		i.Login, 
		i.Wins
	from inserted as i

	Insert into Pokemons(Name, Owner)
	select 
		Pokemon_name, 
		Login
	from inserted
end
go

create trigger onViewDelete 
on RESUME_FOR_TOURNIR 
instead of delete as
begin 
	delete from Pokemons 
	where Name in(
					select Pokemon_name 
					from deleted
				)
end	
go

create trigger onViewUpdate 
on RESUME_FOR_TOURNIR  
instead of update as
begin
	if(update(Login))
	begin
		raiserror('Login cannot be changed', 16, 1)
		return
	end

	if(update(Wins))
	begin
		if exists( 
					select * 
					from (
							inserted 
							join Owners 
								on inserted.Login = Owners.Name
					) 
					where inserted.Wins > Owners.Wins
		)
		begin
			update Owners 
				set Wins = inserted.Wins 
				from inserted  
				where 
					inserted.Login = Owners.Name 
					and inserted.Wins > Owners.Wins
		end
		else raiserror('Wins cannot be lower', 16, 1) 
	end

	if(update(Pokemon_name)) 
	begin
		raiserror('Pokemon cannot be changed', 16, 1)
		return
	end
end
go


insert RESUME_FOR_TOURNIR 
values
	('Алехандро', 41, 'Pidgey'), 
	('Паша Техник', 34, 'Charmel')

update RESUME_FOR_TOURNIR 
set Wins = 50 
where Login = 'Владимир'

update RESUME_FOR_TOURNIR 
set Wins = 47 
where Login = 'Владимир'

delete RESUME_FOR_TOURNIR 
where Login = 'Алехандро'

select * 
from Owners

select * 
from Pokemons

select * 
from RESUME_FOR_TOURNIR
go


