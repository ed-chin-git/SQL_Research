SELECT *
FROM flight_delays f
WHERE f.uniquecarrier='UA'
AND   f.arrdelay > 0
ORDER by f.arrdelay DESC
;
