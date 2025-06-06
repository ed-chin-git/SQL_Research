/** Query 5:
From the login_details table, fetch the users who logged in consecutively 3 or more times.

Approach:   We need to fetch users who have appeared 3 or more times consecutively in login details table. 
            There is a window function which can be used to fetch data from the following record. 
            Use that window function to compare the user name in current row with user name in 
            the next row and in the row following the next row. If it matches then fetch those records.
**/

-- __________ create table  _________________
drop table login_details;
create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

-- current_date works only in postGRES
delete from login_details;
insert into login_details values
(101, 'Michael', current_date),
(102, 'James', current_date),
(103, 'Stewart', current_date+1),
(104, 'Stewart', current_date+1),
(105, 'Stewart', current_date+1),
(106, 'Michael', current_date+2),
(107, 'Michael', current_date+2),
(108, 'Stewart', current_date+3),
(109, 'Stewart', current_date+3),
(110, 'James', current_date+4),
(111, 'James', current_date+4),
(112, 'James', current_date+5),
(113, 'James', current_date+6);

select * from login_details;

-- ______________ S O L U T I O N _______________________
select distinct repeated_names
from (
select *,
case when user_name = lead(user_name) over(order by login_id)
and  user_name = lead(user_name,2) over(order by login_id)
then user_name else null end as repeated_names
from login_details) x
where x.repeated_names is not null;
