/** Query 9:
Find the top 2 accounts with the maximum number of unique patients on a monthly basis.

Note: Prefer the account if with the least value in case of same number of unique patients

Approach: 
	First convert the date to month format since we need the output specific to each month.
	Then group together all data based on each month and account id so you get the total no of 
	patients belonging to each account per month basis. 
	Then rank this data as per no of patients in descending order and account id in ascending order 
	so in case there are same no of patients present under multiple account 
	if then the ranking will prefer the account if with lower value.
	Finally, choose up to 2 records only per month to arrive at the final output.
**/

-- __________ create table  _________________
drop table patient_logs;
create table patient_logs
(
  account_id int,
  date date,
  patient_id int
);

insert into patient_logs values (1, to_date('02-01-2020','dd-mm-yyyy'), 100);
insert into patient_logs values (1, to_date('27-01-2020','dd-mm-yyyy'), 200);
insert into patient_logs values (2, to_date('01-01-2020','dd-mm-yyyy'), 300);
insert into patient_logs values (2, to_date('21-01-2020','dd-mm-yyyy'), 400);
insert into patient_logs values (2, to_date('21-01-2020','dd-mm-yyyy'), 300);
insert into patient_logs values (2, to_date('01-01-2020','dd-mm-yyyy'), 500);
insert into patient_logs values (3, to_date('20-01-2020','dd-mm-yyyy'), 400);
insert into patient_logs values (1, to_date('04-03-2020','dd-mm-yyyy'), 500);
insert into patient_logs values (3, to_date('20-01-2020','dd-mm-yyyy'), 450);

select * from patient_logs;

-- ______________ S O L U T I O N _______________________
select a.month, a.account_id, a.no_of_unique_patients
from (
		select x.month, x.account_id, no_of_unique_patients,
			row_number() over (partition by x.month order by x.no_of_unique_patients desc) as rn
		from (
				select pl.month, pl.account_id, count(1) as no_of_unique_patients
				from (select distinct to_char(date,'month') as month, account_id, patient_id
						from patient_logs) pl
				group by pl.month, pl.account_id) x
     ) a
where a.rn < 3;
