use master;
go
 
drop database if exists l13_union;
go
 
create database l13_union;
go
 
use l13_union;
go

create view All_Pokemons as
select * from l13_1.dbo.Pokemon
union all
select * from l13_2.dbo.Pokemon
go

insert All_Pokemons values
	(2, 'Pikachui', 'Андрей' , 600)
insert All_Pokemons values 
	(6, 'Metapod', 'Лёха', 101)
insert All_Pokemons values
	(7, 'Charmeleon', 'Николай', 322)
go

select * from All_Pokemons
select * from l13_1.dbo.Pokemon
select * from l13_2.dbo.Pokemon

update All_Pokemons set Name = 'Beedrill' where ID = 7
delete from All_Pokemons where ID = 6

select * from All_Pokemons
select * from l13_1.dbo.Pokemon
select * from l13_2.dbo.Pokemon
go