/** https://techtfq.com/video/real-sql-interview-query-complex-sql-interview-query-and-solution 
    https://youtu.be/i3xK7Nc414Q
	SQL -WITH clause	https://youtu.be/QNfnuK-1YYY?si=Oxv1SBTUCjmk5xhY 
	       : referred to as Common Table Expressions(CTE) or Sub-Query Factoring
**/
-- __  To create tables run SQL_Create_family_members.sql script first _

-- ___ check data  ____
select * from family_members;

-- ____________ Solution in PostgreSQL __ Recursive _____________________________
with recursive related_fam_members as
		(select * from base_query
		 union
		 select fam.person_id, r.family_group
		 from related_fam_members r
		 join family_members fam on fam.relative_id1 = r.relatives or relative_id2 = r.relatives
		),
	base_query as
		(select relative_id1 as relatives, substring(person_id,1,3) as family_group
		 from family_members where relative_id1 is not null
		union
		 select relative_id2 as relatives, substring(person_id,1,3) as family_group
		 from family_members where relative_id2 is not null
		order by 1),
	no_relatives as
		(select person_id
		from family_members fam
		where relative_id1 is null and relative_id2 is null
		and person_id not in (select relatives from base_query))

select concat('F_', row_number() over(order by relatives)) as Family_id, relatives
from
	(select distinct string_agg(relatives, ', ' order by relatives) as relatives
	from related_fam_members
	group by family_group
	union
	select * from no_relatives
	) x;
