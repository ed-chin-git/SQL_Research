/** Query 4:
From the doctors table, fetch the details of doctors who work in the same hospital but in different speciality.
Approach:   Use self join to solve this problem. 
            Self join is when you join a table to itself.

Additional Query: 
        Write SQL query to fetch the doctors who work in same 
        hospital irrespective of their specialty.
**/

-- __________ create table  _________________
drop table doctors;
create table doctors
(
id int primary key,
name varchar(50) not null,
speciality varchar(100),
hospital varchar(50),
city varchar(50),
consultation_fee int
);

insert into doctors values
(1, 'Dr. Shashank', 'Ayurveda', 'Apollo Hospital', 'Bangalore', 2500),
(2, 'Dr. Abdul', 'Homeopathy', 'Fortis Hospital', 'Bangalore', 2000),
(3, 'Dr. Shwetha', 'Homeopathy', 'KMC Hospital', 'Manipal', 1000),
(4, 'Dr. Murphy', 'Dermatology', 'KMC Hospital', 'Manipal', 1500),
(5, 'Dr. Farhana', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1700),
(6, 'Dr. Maryam', 'Physician', 'Gleneagles Hospital', 'Bangalore', 1500);

select * from doctors;

-- ______________ S O L U T I O N _______________________
select d1.name, d1.speciality,d1.hospital
from doctors d1
join doctors d2
on d1.hospital = d2.hospital and d1.speciality <> d2.speciality
and d1.id <> d2.id;

-- _________________  Sub Question  ______________________
-- Now find the doctors who work in same hospital irrespective of their speciality.

-- ______________ S O L U T I O N __________________________
select d1.name, d1.speciality,d1.hospital
from doctors d1
join doctors d2
on d1.hospital = d2.hospital
and d1.id <> d2.id;
