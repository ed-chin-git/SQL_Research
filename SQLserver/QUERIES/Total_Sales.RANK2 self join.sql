/** SELF JOIN : Compute Rank by Highest Sales Amount  ***/

use tutorials
SELECT t1.[name]
      ,t1.[Sales] t1_Sales
      ,COUNT(t2.Sales) as Sales_Rank
FROM [dbo].[Total_Sales] as t2,
     [dbo].[Total_Sales] as t1 

WHERE t1.Sales  < t2.Sales
   OR (t1.Sales = t2.Sales and t1.name = t2.name)
GROUP BY t1.name,
         t1.Sales
ORDER BY t1.Sales DESC, 
         t1.name  DESC
;

SELECT t1.[name]
      ,t1.[Sales] t1_Sales
	  ,t2.name  t2_name
	  ,t2.Sales t2_Sales
FROM [dbo].[Total_Sales] as t2,
     [dbo].[Total_Sales] as t1
ORDER BY t1.Sales DESC, 
         t1.name  DESC
;