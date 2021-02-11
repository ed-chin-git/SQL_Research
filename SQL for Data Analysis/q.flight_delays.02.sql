  SELECT
   tailnum,
   SUM(distance) AS dist
  FROM
     (SELECT * 
     FROM  flight_delays
     WHERE tailnum != '0' AND tailnum !='000000') as flt_d
  GROUP BY tailnum
  HAVING SUM(distance) > 800000
  ;
