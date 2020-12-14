/*** Correlated subquery /  SELF JOIN
  https://1keydata.com/sql/sql-rank.html ***/

SELECT  t1.[name]  as t1_name
       ,t1.[Sales] as t1_sales

/* DO NOT include with WHERE clause
  (columns are not in GROUP BY)  
       ,t2.[Sales] as t2_sales
	,t2.[name]  as t2_name
*/

       ,COUNT(t2.name) as Sales_Rank

  FROM [tutorials].[dbo].[Total_Sales] as t1 , 
       [tutorials].[dbo].[Total_Sales] as t2

/***  Include this with COUNT() **/
  WHERE (t1.Sales < t2.Sales) 
     OR (t1.Sales = t2.Sales AND t1.name = t2.name)  
  GROUP BY t1.Sales,
           t1.name
/*****************************************/


  ORDER BY t1.Sales  DESC, 
           t1.name   DESC