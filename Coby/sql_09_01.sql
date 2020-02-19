----------------------------------
-- Assignment Advanced JOINs
-- sql_09_01_solution.sql
-- Using the nycflights13 database.
----------------------------------

-- Only for reference:
select * from flights;
select * from airports;
select * from airlines;
select * from weather;
/*
Generate a report showing the faa abreviation and _name_ for all destination airports 
where 'LGA' is the origin.

"IAH"	"George Bush Intercontinental"
"ATL"	"Hartsfield Jackson Atlanta Intl"
"IAD"	"Washington Dulles Intl"
*/

SELECT origin, dest, name
FROM flights AS f
INNER JOIN
airports AS a
ON f.dest = a.faa
WHERE f.origin = 'LGA';
/*
Generate a report showing a distinct list of carrier text and name for all airlines in the airlines table
with the destination 'LGA'

"US"	"US Airways Inc."	"US"	"LGA"
"MQ"	"Envoy Air"		null	null
"HA"	"Hawaiian Airlines Inc."	null	null		
*/

SELECT a.carrier, name
FROM airlines AS a
INNER JOIN
flights AS f
ON a.carrier = f.carrier
WHERE f.dest = 'LGA';
/*
How many records were returned?
*/
-- 1??????? RUDE

/*
Repeat the query above showing all airlines even if they do not have a record 
to join with in the flights table.
HINT: LEFT OUTER or RIGHT OUTER JOIN

"US"	"US Airways Inc."	"US"	"LGA"
"MQ"	"Envoy Air"		null	null
"HA"	"Hawaiian Airlines Inc."	null	null		
*/
SELECT a.carrier, name
FROM airlines AS a
LEFT OUTER JOIN
flights AS f
ON a.carrier = f.carrier;
-- WHERE f.dest = 'LGA';
/*
How many records were returned?
*/
-- 1 again :\ c'mon man

/*
Generate a report for Delta Airlines showing a distinct list of airport dest codes and 
airport names 'DL' does not fly to.

HINT: Sometimes its easier to consider a sub-query to rule out what you do not
want versus a complex JOIN. 

"ABQ"	"Albuquerque International Sunport"
"ACK"	"Nantucket Mem"
"ALB"	"Albany Intl"
*/

SELECT dest, name
FROM (SELECT * FROM flights WHERE carrier <> 'DL') AS f
INNER JOIN
airports AS a
ON a.faa = f.dest
GROUP BY dest, name;



