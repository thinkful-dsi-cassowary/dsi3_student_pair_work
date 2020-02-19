----------------------------------------------
-- sql_07_01_solution.sql
-- Sorting Query Results
-- Database: employees, table: emp
-- Solve each of the following usimg SQL

--------------------------------------
/*
Provide a query that returns ename, job, sal
for department 20 in sorted order. 
*/

SELECT ename, job, sal, deptno
FROM emp
WHERE deptno = 20
ORDER BY ename; 

--------------------------------------
/*
Provide a query that returns employee name, job, and salary 
sorted in descending order of salary.
*/

SELECT ename, job, sal
FROM emp
ORDER BY sal DESC;

--------------------------------------
/*
Provide a query that returns employee name, job, and salary 
sorted in descending order of salary using column number.
*/

SELECT ename, job, sal
FROM emp
ORDER BY 3 DESC;

--------------------------------------
/* Provide a query that returns empno, deptno, sal, ename, job
sorted by department number ascending, and salary descending
*/

SELECT empno, deptno, sal, ename, job
FROM emp
ORDER BY deptno, sal DESC;

--------------------------------------
/*
Provide a query that returns employee name and job
sorted by the first 3 characters of the employee's name
*/

SELECT ename, job
FROM emp
ORDER BY substr(ename, 1, 3);

--------------------------------------
/*
Provide a query that returns ename, sal, comm
such that NULL values of comm are returned last
*/

SELECT ename, sal, comm
FROM emp
ORDER BY comm NULLS LAST;

--------------------------------------
/* CHALLENGE QUERY
Provide a query that uses a CASE expression
such that if job is “SALESMAN” and comm is NOT NULL
sort on COMM; otherwise, you want to sort by SAL. 
*/

SELECT *,
CASE WHEN (job ILIKE 'sales') AND (comm IS NOT NULL) THEN comm
ELSE sal
END AS ordered
FROM emp
ORDER BY ordered;
