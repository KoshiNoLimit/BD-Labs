use master
if db_id (N'L10') is not null
drop database L10;
create database L10
	on  
		(name = PrimaryData, 
		filename = 'C:\data\L10.mdf', size = 10 mb, maxsize = unlimited, filegrowth = 10% )
	log on
		(name = LogData, 
		filename = 'C:\data\L101.ldf', size = 10 mb, maxsize = unlimited, filegrowth = 10% )
go

use L10
go

IF OBJECT_ID (N'dbo.Owners', N'U') IS NOT NULL  
DROP TABLE dbo.Owners; 
go

create table dbo.Owners ( 
	Name varchar(30) primary key not null,
	Message varchar(100) default 'Hi, man',
	Age int null,
	Wins tinyint default 0 
)
go

insert dbo.Owners values
	('Владимир', 'Я пришел за победой!', 34, 0)
insert dbo.Owners values
	('Антонио', default, 19, 14)
go
