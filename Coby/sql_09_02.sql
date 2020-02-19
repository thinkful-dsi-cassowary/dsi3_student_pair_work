-------------------------------------
-- - Quiz - Subqueries and CTEs
-- - sql_09_02.sql
-- - fueleconoy database vehicle table.
-------------------------------------

/*
Calculate the standard deviation in highway mileage for all vehicles in the vehicle table
using a subquery.
*/
-- sqrt(sum((x-mean)^2 / n))
SELECT SQRT(SUM(POWER((hwy - x.avg_hwy), 2))/ COUNT(hwy)) AS std_hwy
FROM vehicles
CROSS JOIN (
	SELECT AVG(hwy) AS avg_hwy
	FROM vehicles
	) AS x;
/*
Calculate the standard deviation in highway mileage for all vehicles in the vehicle table
using a subquery using CTEs
*/
WITH mean_table AS
(
SELECT AVG(hwy) AS hwy_mean
FROM vehicles
)
SELECT SQRT(SUM(POWER((hwy - mean_table.hwy_mean), 2))/ COUNT(hwy)) AS hwy_std
FROM vehicles CROSS JOIN mean_table;
/*
Challenge:
Retrieve a list of all makes and models who have highway mileage outside of 2 standard deviations
from the mean
*/
WITH std_table AS
(

WITH mean_table AS
(
SELECT AVG(hwy) AS hwy_mean
FROM vehicles
)
SELECT SQRT(SUM(POWER((hwy - mean_table.hwy_mean), 2))/ COUNT(hwy)) AS hwy_std,
	MAX(mean_table.hwy_mean) AS hwy_mean
FROM vehicles CROSS JOIN mean_table
	
)
SELECT make, model, ROUND(AVG(hwy)) AS hwy_mileage, 
	ROUND(MAX(std_table.hwy_mean), 2) AS hwy_mean,
	ROUND(MAX(std_table.hwy_std), 2) AS hwy_std
FROM vehicles CROSS JOIN std_table
WHERE ABS(hwy - std_table.hwy_mean) > 2*(std_table.hwy_std)
GROUP BY make, model
ORDER BY make, model;
/* Using the vehicle table, write a non-trivial query using sub-queries of your choosing.
*/

SELECT make, model, year, hwy, cty, hwy - cty
FROM vehicles;