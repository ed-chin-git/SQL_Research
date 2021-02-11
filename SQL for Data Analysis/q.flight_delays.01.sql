(SELECT 
  tailnum,
  avg_dd
FROM
 (SELECT
    tailnum,
    AVG(depdelay) AS avg_dd
  FROM
    flight_delays
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
    flight_delays
  GROUP BY tailnum
  ORDER BY avg_dd DESC ) 
  AS tailnum_avgdd
LIMIT 1)
;
