use master;
go
 
drop database if exists l14_1;
go
 
create database l14_1;
go
 
use l14_1;
go
 
create table Pokemon (
	ID  int primary key, 
	Name varchar(30) not null
)
go