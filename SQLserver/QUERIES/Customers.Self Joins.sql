/****** https://www.tutorialspoint.com/sql/sql-self-joins.htm 
        Self Joins   ******/
USE tutorials
SELECT a.[id] as a_id
	  ,a.name as a_name
	  ,a.salary as a_salary

/*     ,b.[name] as b_name
      ,b.[salary] as b_salary
*/

FROM [tutorials].[dbo].[Customers] as a,
     [tutorials].[dbo].[Customers] as b

WHERE a.salary <= b.salary

ORDER BY
	 a.salary DESC,
     b.SALARY      
;