use master
if db_id (N'L11') is not null
drop database L11;
create database L11
	on  
		(name = PrimaryData, 
		filename = 'C:\data\L11.mdf', size = 10 mb, maxsize = unlimited, filegrowth = 10% )
	log on
		(name = LogData, 
		filename = 'C:\data\L111.ldf', size = 10 mb, maxsize = unlimited, filegrowth = 10% )
go
use L11
go

IF OBJECT_ID (N'Hospital', N'U') IS NOT NULL  
DROP TABLE Hospital; 
IF OBJECT_ID (N'Patient', N'U') IS NOT NULL  
DROP TABLE Patient;  
IF OBJECT_ID (N'Doctor', N'U') IS NOT NULL  
DROP TABLE Doctor;  
IF OBJECT_ID (N'Work_Shedule', N'U') IS NOT NULL  
DROP TABLE Work_Shedule;  
IF OBJECT_ID (N'Manufacturer', N'U') IS NOT NULL  
DROP TABLE Manufacturer;
IF OBJECT_ID (N'Medicament', N'U') IS NOT NULL  
DROP TABLE Medicament;
IF OBJECT_ID (N'Hosp_med', N'U') IS NOT NULL  
DROP TABLE Hosp_med;
IF OBJECT_ID (N'MedicamentList', N'U') IS NOT NULL  
DROP VIEW MedicamentList;
go 
----------------------------------------------------------------

create table Hospital (
	number int primary key not null check(number > 0),
	phone char(10) unique,
	address varchar(50) unique
)
go

create table Patient (
	polic char(10) primary key not null,
	name varchar(50) not null,
	address varchar(50) not null,

	number_of_hospital int not null references Hospital (number) 
		on update no action
		on delete cascade 
		

)
go

create table Doctor (
	name varchar(50) primary key not null,
	address varchar(50) null,
	education text not null,
	phone char(10) unique not null,
	cabinet int check(cabinet > 0),

	number_of_hospital int references Hospital (number)
		on update no action
		on delete set null,

		check (number_of_hospital is not null or cabinet is null)
)
go

create table Work_Shedule (
	date date primary key,
	after time not null,
	until time not null,
	check(after < until),

	doc_name varchar(50) references Doctor (name)
		on update cascade
		on delete cascade
)
go

create table Manufacturer (
	code varchar(30) primary key,
	phone char(10) not null,
	address varchar(50) null, 
	name varchar(30) not null,
	licence text not null
)
go

create table Medicament (
	code varchar(20) primary key,
	name varchar(30) not null,
	category varchar(30) not null,

	code_man varchar(30) references Manufacturer (code)
		on delete cascade
		on update no action
)
go

create table Hosp_med (
	number_of_hospital int references Hospital (number)
		on delete cascade
		on update no action,
	code_med varchar(20) references  Medicament (code)
		on delete cascade
		on update no action,

	primary key(number_of_hospital, code_med)
)
go
------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------
create view MedicamentList as
	select
		med.name, med.code_man, man.name as man_name
	from Medicament med left join Manufacturer man
		on med.code_man = man.code
go

create trigger newHosp
on Hospital instead of insert as
begin
	declare @count as int
	select @count = count(*) from inserted
	if ((select count(*) from Doctor where number_of_hospital is null)>=@count)
	begin 
		insert into Hospital select inserted.number, inserted.phone, inserted.address from inserted
		update Doctor set number_of_hospital = inserted.number 
					from inserted where name in(
												select top(@count) name from Doctor where number_of_hospital is null)
	end
	else raiserror('Can not add hospital couse have not jobless doctor', 16, 1);
end
go

create trigger delHosp
on hospital instead of delete as
begin
	if not exists(select * from deleted inner join Patient on deleted.number = Patient.number_of_hospital)
	begin
		delete Hospital where number in(select number from deleted) 
	end
	else raiserror('Can not delete hospital that have patients', 16, 1);
end
go

create trigger delDoc
on Doctor instead of delete as
begin
	if not exists(
		select  del, here from 
			(select number_of_hospital, count(*) as del 
			from deleted 
			where number_of_hospital is not null 
			group by number_of_hospital) s1
			left join
			(select number_of_hospital, count(*) as here from Doctor where number_of_hospital is not null group by number_of_hospital) s2
			on s1.number_of_hospital = s2.number_of_hospital
			where del > here - 1)
			
	delete Doctor where name in(select name from deleted) 
	else raiserror('Can not delete doctor because hospital became free', 16, 1);
end
go

create trigger onInsert 
on Work_Shedule
instead of insert as
begin 
	if exists(select * from(
										Doctor join inserted
										on Doctor.name = inserted.doc_name
										) where Doctor.number_of_hospital is null)
		raiserror('Can not add shedule for jobless doctor', 16, 1);
	else insert into Work_Shedule 
		select i.date, i.after, i.until, i.doc_name 
		from inserted as i;
end	
go

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
insert Doctor values('Малахов', null, 'Доктор мед. наук 083849', '9190017976', null, null)
insert Doctor values('Кто', 'Марс, коллония 4, хижина 6', 'Университет галактической медицины', '9056382423', null, null)
insert Hospital values (23, '8005353535', 'ул. Разбитых фонарей, д 2'), (11, '8944944570', 'ул. Красных фонарей, д 8')

insert Work_Shedule values('2020-05-05', '09:00:00', '10:00:00', 'Малахов')
insert Work_Shedule values('2020-05-06', '14:00:00', '17:00:00', 'Малахов')

insert Patient values('1234567890', 'Сергей', 'Невский проспект 111', 23)
insert Patient values('7134567690', 'Чубака', 'Звезда смерти, отсек 0', 23)
insert Patient values('7234567690', 'Ворон', 'Гнездо', 11)


insert Manufacturer values('q;lkj123', '9998023945', null, 'Лечилкин', 'одобрено галактическим советом')
insert Manufacturer values('3287dhgf', '9935523526', null, 'Менделеевка', 'рекомендовано минздравом')

insert Medicament values('werwefdsg4563e', 'Сироп рожкового дерева +', 'витамины профилактика', 'q;lkj123')
insert Medicament values('5463465аg4563e', 'Зелёнка', 'средства нар. применения', '3287dhgf')

insert Hosp_med values(23, 'werwefdsg4563e')




go
select distinct number_of_hospital from Patient
select Name as doctor, number_of_hospital as host from Doctor;
select * from Doctor right join Hospital on number_of_hospital = number 
select * from Doctor full outer join Hospital on number_of_hospital = number 
select * from Work_Shedule where date between '2020-05-04' and '2020-06-05' 
select * from Hospital where number like '2%'
select min(number) from Hospital
select max(number) from Hospital
select sum(number) from Hospital

select * from Patient where number_of_hospital > 9 
union all 
select * from Patient where number_of_hospital > 9

select * from Patient where number_of_hospital > 9 
union
select * from Patient where number_of_hospital > 9

select * from Hospital where number > 9 
intersect 
select * from Hospital where number > 9

select * from Hospital where number > 9 
except 
select * from Hospital where number > 9

select * from Hosp_med

select number_of_hospital  from Patient group by number_of_hospital having count(*) > 1
go