use master
go
if db_id (N'FirstDB') is not null
drop database FirstDB;
go

create database FirstDB
	on  
		(name = PrimaryData, 
		filename = 'C:\dataFirstDB.mdf', size = 10 mb, maxsize = unlimited, filegrowth = 10% )
	log on
		(name = LogData, 
		filename = 'C:\data.ldf', size = 10 mb, maxsize = unlimited, filegrowth = 10% )
go

use FirstDB
go

create table Music
	(Brand varchar(25), NameG varchar(30), Price int)
go

insert Music(Brand, NameG, Price)
	values 
		('YAMAHA', 'F-310', 9900),
		('FENDER', 'SQUIER BULLET STRAT HT HSS', 13600)
go


alter database FirstDB
	add filegroup NewGroup
go

alter database FirstDB
	add file (
	name = Nameless,
	filename = 'C:\data\FirstDB2.ndf',
	size = 10 mb,
	maxsize= 30 mb
	)
	to filegroup NewGroup;
go

alter database FirstDB
	modify filegroup NewGroup default;
go

create table People
	(Name varchar(25), Soname varchar(30), Age int)
go

insert People(Name, Soname, Age)
	values 
		('Вася', 'Петров', 9),
		('Петя', 'Васечкин', 10)
go

drop table People
go

alter database FirstDB
	modify filegroup [Primary] default;
go

alter database FirstDB
	remove file Nameless;

alter database FirstDB
	remove filegroup NewGroup;
go


create schema FirstS;
go

alter schema FirstS
	transfer dbo.Music;
go

drop table FirstS.Music;
go
drop schema FirstS;
go

