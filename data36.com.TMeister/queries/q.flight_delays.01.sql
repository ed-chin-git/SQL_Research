-- Advanced SQL subqueries
--  https://data36.com/sql-data-analysis-advanced-tutorial-ep6/
(SELECT 
  tailnum,
  avg_dd
FROM
 (SELECT
    tailnum,
    AVG(depdelay) AS avg_dd
  FROM
    flights
  GROUP BY tailnum
  ORDER BY avg_dd )
  AS tailnum_avgdd
LIMIT 1)

UNION ALL

(SELECT 
  tailnum,
  avg_dd
FROM
  (SELECT
    tailnum,
    AVG(depdelay) AS avg_dd
  FROM
    flights
  GROUP BY tailnum
  ORDER BY avg_dd DESC ) 
  AS tailnum_avgdd
LIMIT 1)
;
