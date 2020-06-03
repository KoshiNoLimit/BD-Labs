use master
go
if db_id (N'L6') is not null
drop database L6;
go
create database L6
	on  
		(name = PrimaryData, 
		filename = 'C:\data\L6.mdf', size = 10 mb, maxsize = unlimited, filegrowth = 10% )
	log on
		(name = LogData, 
		filename = 'C:\data\L61.ldf', size = 10 mb, maxsize = unlimited, filegrowth = 10% )
go
use L6
go





create table dbo.Pokemons (
	PokemonID int not null primary key identity(0, 1), 
	Name varchar(30) not null
)
go

alter table dbo.Pokemons ADD
	Owner varchar(30) default 'free',
	Power int check (Power > 0);
go

insert dbo.Pokemons values
	('Pikachui', 'Андрей' , 500)
insert dbo.Pokemons values
	('Metapod', 'Лёха', 211)
insert dbo.Pokemons values
	('Charmeleon', default, 342)
go

select * from Pokemons
select SCOPE_IDENTITY() as scope_identity;--оба ограничения
select @@IDENTITY as indentity@@;--ограничение на сеанс
select IDENT_CURRENT('Pokemons') as identity_current;--без ограничений
go

drop table Pokemons
go





create table dbo.Pokemons1 (
	PokemonID uniqueidentifier not null default newid(), 
	Name varchar(30) not null,
	Owner varchar(30) default 'free',
	Power int check (Power > 0)
)

insert dbo.Pokemons1 values
	(newid(), 'Pikachui', 'Андрей' , 600)
insert dbo.Pokemons1 values 
	(newid(), 'Metapod', 'Лёха', 101)
insert dbo.Pokemons1 values
	(newid(), 'Charmeleon', default, 322)
go

select * from Pokemons1
go
drop table Pokemons1
go





create table dbo.Pokemons2 (
	PokemonID int primary key, 
	Name varchar(30) not null,
	Owner varchar(30) default 'free',
	Power int check (Power > 0)
)
go

create sequence dbo.IDs
start with 0
increment by 1;
go

insert dbo.Pokemons2 values
	(next value for dbo.IDs, 'Pikachui', 'Андрей' , 400)
insert dbo.Pokemons2 values 
	(next value for dbo.IDs, 'Metapod', 'Лёха', 1301)
insert dbo.Pokemons2 values
	(next value for dbo.IDs, 'Charmeleon', default, 22)
go

select * from Pokemons2
go
drop table Pokemons2
go





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
	('Владимир', 'Я пришел за победой!', 34, 0)
insert dbo.Owners values
	('Антонио', default, 19, 14)
go

insert dbo.Pokemons3 values
	('Pikachui', 'Владимир' , 500)
insert dbo.Pokemons3 values
	('Metapod', 'Антонио', 211)
insert dbo.Pokemons3 values
	('Charmeleon', null, 342)
go

select * from Owners
go
select * from Pokemons3
go

delete from Owners where Name = 'Владимир'
update Owners set Name = 'Коля' where Name = 'Антонио'
go

select * from Owners
go
select * from Pokemons3
go



drop table Pokemons3
go
drop table Owners
go

  	