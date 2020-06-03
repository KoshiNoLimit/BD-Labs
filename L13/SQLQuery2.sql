use master;
go
 
drop database if exists l13_2;
go
 
create database l13_2;
go
 
use l13_2;
go
 
create table Pokemon (
	ID  int primary key
	check (ID > 5), 
	Name varchar(30) not null,
	Owner varchar(30),
	Power int check (Power > 0)
)
go