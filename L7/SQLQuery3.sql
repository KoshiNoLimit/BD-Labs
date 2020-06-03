use master
if db_id (N'L7') is not null
drop database L7;
create database L7
	on  
		(name = PrimaryData, 
		filename = 'C:\data\L7.mdf', size = 10 mb, maxsize = unlimited, filegrowth = 10% )
	log on
		(name = LogData, 
		filename = 'C:\data\L71.ldf', size = 10 mb, maxsize = unlimited, filegrowth = 10% )
use L7
go
----------ÑÎÇÄÀÍÈÅ ÏÐÅÄÑÒÀÂËÅÍÈß----------------------------------------------
create table dbo.Pokemons2 (
	PokemonID int primary key, 
	Name varchar(30) not null,
	Owner varchar(30) default 'free',
	Power int check (Power > 0)
)
create sequence dbo.IDs
start with 0
increment by 1;
insert dbo.Pokemons2 values
	(next value for dbo.IDs, 'Pikachui', 'Àíäðåé' , 400)
insert dbo.Pokemons2 values 
	(next value for dbo.IDs, 'Metapod', 'Ë¸õà', 1301)
insert dbo.Pokemons2 values
	(next value for dbo.IDs, 'Charmeleon', default, 22)
insert dbo.Pokemons2 values
	(next value for dbo.IDs, 'Beedrill', 'Ñòàíèñëàâ', 711)
go

create view Strong_Pokemons as
	select Name, Power
	from Pokemons2
	where Power > 300
go

select * from Strong_Pokemons

drop view Strong_Pokemons
drop table Pokemons2
go
------------------------------------------------------------------------------------


-----------------ÑÎÇÄÀÍÈÅ ÏÐÅÄÑÒÀÂËÅÍÈß ÍÀ ÎÑÍÎÂÅ ÏÎËÅÉ ÎÁÎÈÕ-----------------------
create table dbo.Owners ( 
	Name varchar(30) primary key not null,
	Message varchar(100) default 'Hi, man',
	Age tinyint not null,
	Wins tinyint default 0 
)
go

create table dbo.Pokemons3 (
	PokemonID int primary key identity(0, 1), 
	Name varchar(30),
	Owner varchar(30) foreign key references dbo.Owners (Name)
		on update cascade
		on delete set null,
	Power int check (Power > 0)
)
go

insert dbo.Owners values
	('Âëàäèìèð', 'ß ïðèøåë çà ïîáåäîé!', 34, 0)
insert dbo.Owners values
	('Àíòîíèî', default, 19, 14)
go
insert dbo.Pokemons3 values
	('Pikachui', 'Âëàäèìèð' , 500)
insert dbo.Pokemons3 values
	('Metapod', 'Àíòîíèî', 211)
insert dbo.Pokemons3 values
	('Charmeleon', null, 342)
go

create view RESUME_FOR_TOURNIR as
	select
		o.Name as Login, o.Wins, p.Name as Pokemon_name
	from Owners o INNER JOIN Pokemons3 p
		on o.Name = p.Owner
go

select * from RESUME_FOR_TOURNIR

drop view RESUME_FOR_TOURNIR
drop table Pokemons3
drop table Owners
go
----------------------------------------------------------------------------


--------------ÑÎÇÄÀÍÈÅ ÈÄÅÊÑÀ ----------------------------------------------
create table dbo.Pokemons1 (
	PokemonID  int primary key, 
	Name varchar(30) not null,
	Owner varchar(30) default 'free',
	Power int check (Power > 0)
)
insert dbo.Pokemons1 values
	(1, 'Pikachui', 'Àíäðåé' , 600)
insert dbo.Pokemons1 values 
	(2, 'Metapod', 'Ë¸õà', 101)
insert dbo.Pokemons1 values
	(3, 'Charmeleon', default, 322)
go

create index Sort_pokemons
	on Pokemons1 (Power)
	include (Owner)
go

select Owner from dbo.Pokemons1 where Power > 300  


select Owner, Power, Name from dbo.Pokemons1 where Power > 300  



drop index Sort_pokemons on Pokemons1
go
-----------------------------------------------------------------------------------


-----------------ÈÍÄÅÊÑÈÐÎÂÀÍÍÎÅ ÏÐÄÑÒÀÂËÅÍÈÅ--------------------------------------
create view Strong_Pokemons with schemabinding as
	select Name, Power
	from dbo.Pokemons1
	where Power > 300
go

create unique clustered index Sort_pokemons
	on Strong_pokemons (Power)
go

select * from Strong_Pokemons

drop view Strong_Pokemons
drop table Pokemons1
go
-----------------------------------------------------------------------------------
