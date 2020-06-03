use master;
go
 
drop database if exists l14_2;
go
 
create database l14_2;
go
 
use l14_2;
go
 
create table Pokemon (
	ID  int primary key,
	Owner varchar(30),
	Power int check (Power > 0)
)
go