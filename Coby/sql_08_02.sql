------------------------------
-- SQL JOINS
-- sql_08_02_solution.sql
-- Using the dvdrentals database
-------------------------------

-- For reference only:
select * from actor;
select * from address;
select * from category;
select * from film;
select * from film_category;
select * from film_actor;
select * from language;
select * from payment;
select count(*) from payment;
select count(*) from payment_p2007_01;
select * from payment_p2007_01;

-------------------------------
/*
Generate a result set report displaying film id, film title, and the
name of the language of the film (not the language_id).
Order the results by language.
You will need to explore the film and language tables.
1:m relationship. Each film uses one language, but any language can be in many films.
*/

SELECT f.film_id, f.title, l.name AS language
FROM film AS f
INNER JOIN
language AS l
ON f.language_id = l.language_id;

-------------------------------
/*
Generate a result set report displaying actor id, actor first name, actor last name, and title and year 
for each film the actor has appeared in.
Order the results by actor last name, then year in ascending order.
You will need to explore the actor, actor_film and film tables.
m:m relationship. An actor can be in many films, and each film can have many actors.
*/

SELECT a.actor_id, a.first_name, a.last_name, f.title, f.release_year
FROM actor AS a 
INNER JOIN film_actor AS fa
ON a.actor_id = fa.actor_id
INNER JOIN film AS f
ON fa.film_id = f.film_id
ORDER BY a.last_name, f.release_year;

-------------------------------
/*
Generate a result set displayig customer_id, customer first name, and the total amount the customer spent
using table payment_p2007_01 only.
Order by aggregate amount descending.
Identify the top spending customer. Minnie Romero $33.94
Send the top customer a check for $1,000 ;-).
*/

SELECT p.customer_id, c.first_name, SUM(p.amount) AS total_spent
FROM payment_p2007_01 AS p
INNER JOIN
customer AS c
ON p.customer_id = c.customer_id
GROUP BY p.customer_id, c.first_name
ORDER BY total_spent DESC;


-- INSERT INTO payment_p2007_01 (customer_id, amount)
-- VALUES (239, -1000);
-------------------------------
/*
Generate the same report in the previous question, however integrate all records
from table payment_p2007_01, table payment_p2007_02, and table payment_p2007_03.
HINT: UNION ALL
Identify the top spending customer. Elenaor Hunt $87.82.
Send the top customer a check for $10,000 ;-).
*/

SELECT p1.customer_id, c.first_name, SUM(p1.amount) AS total_spent
FROM payment_p2007_01 AS p1
INNER JOIN
customer AS c
ON p1.customer_id = c.customer_id
GROUP BY p1.customer_id, c.first_name

UNION ALL

SELECT p2.customer_id, c.first_name, SUM(p2.amount) AS total_spent
FROM payment_p2007_02 AS p2
INNER JOIN
customer AS c
ON p2.customer_id = c.customer_id
GROUP BY p2.customer_id, c.first_name

UNION ALL

SELECT p3.customer_id, c.first_name, SUM(p3.amount) AS total_spent
FROM payment_p2007_03 as p3
INNER JOIN
customer AS c
ON p3.customer_id = c.customer_id
GROUP BY p3.customer_id, c.first_name

ORDER BY total_spent DESC;

--DONEZO GARBUNZO!