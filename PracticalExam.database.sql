use master

if exists (select * from sys.databases  where name='PracticalExam')
drop database PracticalExam

create database PracticalExam

use PracticalExam

--1: Insert into above tables at least 3 records per table [3 marks].

-- create tables

create table Department (
   DepartId int primary key,
   DepartName varchar(50) not null,
   Description varchar(100) not null
)

create table Employee (
   EmpCode char(6) primary key,
   FirstName varchar(30) not null,
   LastName varchar(30) not null,
   Birthday date not null,
   Gender bit default (1),
   Address varchar(100),
   DepartId int foreign key references Department(DepartId),
   Salary money
)

-- insert records

insert into Department values 
(1, 'Sales Department', 'Sales products' ), 
(2, 'Customer Service Department', 'Customer Service Department'),
(3, 'Information Technology Department', 'Organization systems, networks, data and applications all connect and function properly')

insert into Employee values
('EMP01', 'An', 'Nguyen', '1998-10-12', 1 , 'Ha Noi', 1, 4000)

insert into Employee values
('EMP03', 'Hoa', 'Vu', '1998-10-12', 1 , 'Ha Noi', 2, 5000)

insert into Employee values
('EMP05', 'Thanh', 'Nguyen', '2000-10-12', 1 , 'Ha Noi', 1, 8000)

select * from Department

select * from Employee

--2: Increase the salary for all employees by 10% [1 mark].

update Employee
set Salary = Salary + Salary*0.1

--3: Using ALTER TABLE statement to add constraint on Employee table 
--to ensure that salary always greater than 0 [2 marks]

alter table Employee
add constraint CheckSalary check (Salary > 0)

--test
insert into Employee values
('EMP06', 'Thanh', 'Hoa', '2000-10-12', 1 , 'Ha Noi', 2, -8000)

--4: Create a trigger named tg_chkBirthday 
--to ensure value of birthday column on Employee table always greater than 23 [3 marks].


create trigger TG_CheckBirthday
on Employee
after update, insert
as
begin
    declare @dayOfBirthDay date;
	select @dayOfBirthDay  = inserted.Birthday from inserted;

	if(Day(@dayOfBirthDay) <= 23 ) 
	begin
	    print 'Day of birthday must be greater than 23!';
		rollback transaction;
	end
end

--test
insert into Employee values ('EMP06', 'Thanh', 'Hoa', '2000-10-12', 1 , 'Ha Noi', 2, 8000)

--5: Create an unique, none-clustered index named IX_DepartmentName
-- on DepartName column on Department table [2 marks].

 create unique nonclustered index IX_DepartmentName
 on Department(DepartName)

 --6 : Create a view to display employee’s code, full name and department name of all employees [3 marks].

 create view View_Employee
 as
 select e.EmpCode,
        e.LastName + ' ' + e.FirstName as FullName,
		d.DepartName
 from Employee as e
 inner join Department as d on d.DepartId = e.DepartId
 

 select * from View_Employee

 --7: Create a stored procedure named sp_getAllEmp that accepts Department ID 
 --as given input parameter and displays all employees in that Department [3 marks]


 create procedure sp_getAllEmp (@id int)
 as
 begin
    if(@id  in (select DepartId from Department))
	begin
	   select e.EmpCode,
	          e.LastName + ' ' + e.LastName as FullName,
			  e.Address,
			  e.Birthday,
			  e.Gender,
			  e.Salary
	   from Employee as e
	   inner join Department as d on e.DepartId = d.DepartId
	   where d.DepartId = @id

	end
	else
	begin
	 
	  print 'Dont find depart Id!';
	   rollback transaction;
	end

 end

 exec sp_getAllEmp @id=1

 --8: Create a stored procedure named sp_delDept
 --that accepts employee Id as given input parameter to delete an employee [3 marks].

 create procedure sp_delDept(@empCode char(6))
 as 
 begin
   if (select count (*) from Employee where Employee.EmpCode = @empCode) > 0
   begin
      delete from Employee
     where EmpCode = @empCode
      print 'Delete employee complete!'
   end
   else
   begin
      print 'Dont find employee!';
      rollback transaction;
   end


 end

 exec sp_delDept @empCode = 'EMP01'




 
