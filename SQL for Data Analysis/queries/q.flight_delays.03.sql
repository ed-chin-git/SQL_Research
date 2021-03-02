-- Advanced SQL subqueries
--  https://data36.com/sql-data-analysis-advanced-tutorial-ep6/
SELECT AVG(dist)
FROM
  (SELECT
   tailnum,
   SUM(distance) AS dist
  FROM
     (SELECT * 
     FROM  flight_delays
     WHERE tailnum != '0' AND tailnum !='000000') as flt_d
  GROUP BY tailnum
  HAVING SUM(distance) > 800000) 
  AS tailnum_dist
;
