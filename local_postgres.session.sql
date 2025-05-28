SELECT
  SURVIVORS.passenger_class,
  SURVIVORS.Num_Of_Survivors,
  DEATHS.Num_Of_Deaths
FROM
(
    SELECT pclass AS passenger_class, COUNT(*) AS Num_Of_Survivors
    FROM titanic
    WHERE survived = 1
    GROUP BY pclass
    ORDER BY pclass
) AS SURVIVORS
inner join
(
     SELECT pclass, COUNT(*) AS Num_Of_Deaths
    FROM titanic
    WHERE survived = 0
    GROUP BY pclass
    ORDER BY pclass
) AS DEATHS
on SURVIVORS.passenger_class = DEATHS.pclass
ORDER BY SURVIVORS.passenger_class;
-- This query retrieves the number of survivors and deaths from the Titanic dataset, grouped by passenger class.
-- It uses subqueries to count survivors and deaths separately, then joins the results on passenger class.