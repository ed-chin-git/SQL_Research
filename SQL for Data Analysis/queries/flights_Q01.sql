SELECT
    MIN(delays_by_tailnum.avg_dd),
    MAX(delays_by_tailnum.avg_dd)
FROM
    (SELECT 
     tailnum,
     AVG(depdelay) AS avg_dd
    FROM 
    flights
    GROUP BY tailnum
    ORDER BY avg_dd) AS delays_by_tailnum;