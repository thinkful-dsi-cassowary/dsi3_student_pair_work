--------------------------------------
-- sql_06_02_solution.sql
-- Solve each of the following usimg SQL

-------------------------------------
-- Retrieving All Rows and Columns from emp
SELECT *
FROM emp;
-------------------------------------
/*
Retrieve all employees from the emp table who work in dept number 20 or 30, with
a salary > 2000, and a hiredate between 1980 and 1982 (inclusive).

More on dates and time:
https://popsql.com/learn-sql/postgresql/how-to-query-date-and-time-in-postgresql/

The columns in your result set should be as follows:
Employee No., Name, Job, Salary, Manager, Hire Date, Department Number
Hint consider the now() function for current date-time.
*/

SELECT *
FROM emp
WHERE (deptno BETWEEN 20 AND 30) 
AND (hiredate BETWEEN '1980-1-1' AND '1982-12-31')
AND (sal > 2000);

SELECT empno AS employee_no, ename AS name, job, sal AS salary, mgr AS manager, hiredate AS hire_date, deptno AS department_number
FROM emp
WHERE (deptno BETWEEN 20 AND 30) 
AND (hiredate BETWEEN '1980-1-1' AND '1982-12-31')
AND (sal > 2000);

-------------------------------------
/*
Retrieve all emp records with a commission that is non-null and a salary less than or equal to $2000, 
and department number is 10 */

SELECT *
FROM emp
WHERE comm IS NOT Null;
-------------------------------------
/*
Provide a query that retrieves a single column for for the first 5 records as follows:

'ALLEN was hired on 1981-02-20, current salary is $1600'
*/

SELECT CONCAT(ename, ' was hired on ', hiredate, ', current salary is $', sal)
FROM emp
LIMIT 5;

-------------------------------------
/*
Using Conditional Logic in a SELECT Statement
to add an additional column that returns:
'UNDERPAID' if salary <= 1000
'OVERPAID' if salary >=3000
'OK' in all other cases
*/

SELECT *,
CASE WHEN sal <= 1000 THEN 'UNDERPAID'
	WHEN sal >= 3000 THEN 'OVERPAID'
	ELSE 'OK'
	END AS status
FROM emp;
-------------------------------------
-- Returning n Random Records from a Table
-- Use any built-in function supported by your DBMS for returning random values. 
-- Use that function in an ORDER BY clause to sort rows randomly. 
-- Then, use LIMIT to limit the number of randomly sorted rows to return.
-- Run each query multiple times.

SELECT *
FROM emp
ORDER BY random()
LIMIT 5;

-------------------------------------
/*
Retrieve all employees who have not been assigned a manager
*/

SELECT *
FROM emp
WHERE mgr IS NULL;

-------------------------------------
/*
Retrieve all employee name and manager who have not been assigned a manager, but
replace [null] with 0

*/

SELECT ename, COALESCE(mgr, 0) AS manager
FROM emp;

-------------------------------------
/*
Retieve all employee records matching the substring 'MAN' in job
*/

SELECT *
FROM emp
WHERE job LIKE '%MAN%';
