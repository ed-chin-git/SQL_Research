/** Query 1:
Write a SQL query to fetch all the duplicate records from a table.
Note: Record is considered duplicate if a user name is present more than once.

Approach:   Partition the data based on user name and then give a row number to each of the partitioned user name. 
            If a user name exists more than once then it would have multiple row numbers. 
            Using the row number which is other than 1, we can identify the duplicate records.
**/

-- Create Table Structure:
drop table users;
create table users
(
user_id int primary key,
user_name varchar(30) not null,
email varchar(50));

insert into users values
(1, 'Sumit', 'sumit@gmail.com'),
(2, 'Reshma', 'reshma@gmail.com'),
(3, 'Farhana', 'farhana@gmail.com'),
(4, 'Robin', 'robin@gmail.com'),
(5, 'Robin', 'robin@gmail.com');

select * from users;

-- Solution 1:

-- Replace ctid with rowid for Oracle, MySQL and Microsoft SQLServer
select *
from users u
where u.ctid not in (
select min(ctid) as ctid
from users
group by user_name
order by ctid);


-- Solution 2: Using window function.

select user_id, user_name, email
from (
select *,
row_number() over (partition by user_name order by user_id) as rn
from users u
order by user_id) x
where x.rn <> 1;
