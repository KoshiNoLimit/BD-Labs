  use master;
go
 
drop database if exists l13_2;
go
 
create database l13_2;
go
 
use l13_2;
go
 
create table Pokemon (
	Name varchar(30) primary key, 
	Power int check (Power > 0), 
	Owner varchar(30)
)
go

create trigger PokIns on Pokemon instead of insert as
begin
	if exists (select * from inserted where Owner not in (select Name from l13_1.dbo.Owner ))
		raiserror('owner is not exists', 16, 1)
	else insert into Pokemon select * from inserted
end
go

create trigger PokUp on Pokemon instead of update as
begin
	if(update(Owner))
	begin
		if exists(select Owner 
					from inserted
					where Owner is not null 
						and Owner not in(select Name from l13_1.dbo.Owner))
			raiserror('owner is not exists', 16, 1)
		else update Pokemon set Power = inserted.Power, Owner = inserted.Owner from inserted where Pokemon.Name = inserted.Name 
	end
	else update Pokemon set 
							Power = inserted.Power,
							Owner = inserted.Owner
								from inserted where Pokemon.Name = inserted.Name
end
go


insert Pokemon values
					('Pikachuix', 234, 'A'),
					('Metapodx', 100, 'Cxx'),
					('BeeDrillx', 400, 'A')

update Pokemon set Power = 20 where Power = 234
go
select * from Pokemon