use master;
go
 
drop database if exists l14_union;
go
 
create database l14_union;
go
 
use l14_union;
go

IF OBJECT_ID ('All_Pokemons', 'V') IS NOT NULL  
DROP VIEW All_Pokemons;  
GO  

create view All_Pokemons as
select one.ID, one.Name, two.Owner, two.Power
	from l14_1.dbo.Pokemon one, l14_2.dbo.Pokemon two
	where one.ID = two.ID
go

create trigger onViewInsert 
on All_Pokemons 
instead of insert as
begin
	insert into l14_1.dbo.Pokemon(ID, Name)
	select 
		ID, 
		Name
	from inserted

	Insert into l14_2.dbo.Pokemon(ID, Owner, Power)
	select 
		ID, 
		Owner,
		Power
	from inserted
end
go

create trigger onViewDelete 
on All_Pokemons 
instead of delete as
begin 
	delete from l14_1.dbo.Pokemon
	where ID in(
					select ID 
					from deleted
				)

	delete from l14_2.dbo.Pokemon
	where ID in(
					select ID 
					from deleted
				)
end	
go

create trigger onViewUpdate 
on All_Pokemons  
instead of update as
begin
	if(update(ID))
	begin
		raiserror('Cant update ID', 16, 1)
	end

	if(update(Name))
	begin
		update l14_1.dbo.Pokemon
			set Name = inserted.Name from inserted
			where inserted.ID = l14_1.dbo.Pokemon.ID
	end

	if(update(Owner)) 
	begin
		update l14_2.dbo.Pokemon
			set Owner = inserted.Owner from inserted
			where inserted.ID = l14_2.dbo.Pokemon.ID
	end

	if(update(Power))
	begin
		update l14_2.dbo.Pokemon
			set POwer = inserted.Power from inserted
			where inserted.ID = l14_2.dbo.Pokemon.ID
	end
end
go

insert All_Pokemons values
	(2, 'Pikachui', 'Андрей' , 600)
insert All_Pokemons values 
	(6, 'Metapod', 'Лёха', 101)
insert All_Pokemons values
	(7, 'Charmeleon', 'Николай', 322)
go

select * from All_Pokemons
select * from l14_1.dbo.Pokemon
select * from l14_2.dbo.Pokemon

update All_Pokemons set Name = 'Beedrill' where ID = 7
delete from All_Pokemons where ID = 6

select * from All_Pokemons
select * from l14_1.dbo.Pokemon
select * from l14_2.dbo.Pokemon
go