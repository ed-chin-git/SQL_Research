-- Advanced SQL subqueries
--  https://data36.com/sql-data-analysis-advanced-tutorial-ep6/
  SELECT
   tailnum,
   SUM(distance) AS dist
  FROM
     (SELECT * 
     FROM  flights
     WHERE tailnum != '0' AND tailnum !='000000') as flt_d
  GROUP BY tailnum
  HAVING SUM(distance) > 800000
  ;
