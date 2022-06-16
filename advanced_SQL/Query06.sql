/** Query 6:
From the students table, write a SQL query to interchange the adjacent student names.

Note: If there are no adjacent student then the student name should stay the same.

Approach: Assuming id will be a sequential number always. If id is an odd number then fetch the student name 
        from the following record. If id is an even number then fetch the student name from the preceding record. 
        Try to figure out the window function which can be used to fetch the preceding the following record data. 
        If the last record is an odd number then it wont have any adjacent even number hence figure out a way to not
        interchange the last record data.
**/

--Table Structure:
drop table students;
create table students
(
id int primary key,
student_name varchar(50) not null
);
insert into students values
(1, 'James'),
(2, 'Michael'),
(3, 'George'),
(4, 'Stewart'),
(5, 'Robin');

select * from students;

-- Solution:

select id,student_name,
case when id%2 <> 0 then lead(student_name,1,student_name) over(order by id)
when id%2 = 0 then lag(student_name) over(order by id) end as new_student_name
from students;
