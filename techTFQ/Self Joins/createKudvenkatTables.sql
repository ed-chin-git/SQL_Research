/*-- In MS SQL Server
USE techTFQ
GO
*/

-- postgres : Set the search path to the department schema
-- This assumes that the department schema already exists in the techTFQ database.
set search_path = department;


-- Create tables and insert data for Self Joins demo
-- Tables: tbldepartment, tblEmployee
Create table tbldepartment
(
     ID int primary key,
     DepartmentName varchar(50),
     Location varchar(50),
     DepartmentHead varchar(50)
)
-- Go

Insert into tbldepartment values (1, 'IT', 'London', 'Rick')
Insert into tbldepartment values (2, 'Payroll', 'Delhi', 'Ron')
Insert into tbldepartment values (3, 'HR', 'New York', 'Christie')
Insert into tbldepartment values (4, 'Other Department', 'Sydney', 'Cindrella')

-- Go



set search_path = department;
drop table if exists tblemployee cascade;
Create table tblemployee
(
     ID int primary key,
     Name varchar(50),
     Gender varchar(50),
     Salary int,
     ManagerId int NULL,

     DepartmentId int,
     CONSTRAINT fk_Department
     FOREIGN KEY(DepartmentId) 
     REFERENCES tbldepartment(Id)
)
--Go

set search_path = department;
Insert into tblEmployee values (1, 'Tom', 'Male', 4000, 4, 1)
Insert into tblEmployee values (2, 'Pam', 'Female', 3000, 4, 3)
Insert into tblEmployee values (3, 'John', 'Male', 3500, 4, 1)
Insert into tblEmployee values (4, 'Sam', 'Male', 4500, 6, 2)
Insert into tblEmployee values (5, 'Todd', 'Male', 2800, 9, 2)
Insert into tblEmployee values (6, 'Ben', 'Male', 7000, NULL, 1)
Insert into tblEmployee values (7, 'Sara', 'Female', 4800, 8, 3)
Insert into tblEmployee values (8, 'Valarie', 'Female', 5500, 6, 1)
Insert into tblEmployee values (9, 'James', 'Male', 6500, 10, 3)
Insert into tblEmployee values (10, 'Russell', 'Male', 8800, NULL, 2)
-- Go