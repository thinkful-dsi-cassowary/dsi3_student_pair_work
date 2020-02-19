------------------------------
-- Quiz Grouping
-- sql_07_02.sql
-------------------------------

-------------------------------------
/*
Retrieve the department along with max, min, and avg salary for each department.
Round the avg salary by 2 decimal places.
Order by avg salary descending.
Use legible column aliases.
*/

SELECT deptno AS department_number, 
	MAX(sal) AS max_salary,
	MIN(sal) AS min_salary,
	ROUND(AVG(sal), 2) AS avg_salary
FROM emp
GROUP BY deptno
ORDER BY AVG(sal) DESC;

-- Retrieve the department and job along with max, min, and avg salary for each department and job.
-- Round the avg salary by 2 decimal places.
-- Order by avg salary descending.
-- Use legible column aliases.

SELECT deptno AS department_no,
	job,
	MAX(sal) AS max_salary,
	MIN(sal) AS min_salary,
	ROUND(AVG(sal), 2) AS avg_salary
FROM emp
GROUP BY deptno, job
ORDER BY avg_salary DESC;

-- Retrieve job along with the salary, the salary average, and the salary variance.
-- Use legible column aliases.
-- Sort by range

SELECT ROUND(VARIANCE(sal), 2) AS salary_variance,
ROUND(AVG(sal), 2) AS avg_salary,
MAX(sal) - MIN(sal) AS salary_range
FROM emp
GROUP BY job
ORDER BY salary_range;

-- Which department has the highest salary range for a specific job?
-- List department, job, and salary range in descending order
-- Use legible column aliases.

SELECT deptno, job,
	MAX(sal) - MIN(sal) AS salary_range
FROM emp
GROUP BY deptno, job
ORDER BY salary_range DESC;
-- Dept number 30 has the highest salary range in the salesman job (350)

-- How many unique commissions are there? Retrieve the commision value and quantity of that value.

SELECT DISTINCT comm AS commission_value,
COUNT(DISTINCT comm) AS commission_count
FROM emp
GROUP BY comm
ORDER BY commission_value;

/*
What are the unique unique counts for departments and jobs?
Use legible column aliases.
*/

SELECT deptno, job
FROM emp
GROUP BY deptno, job
ORDER BY deptno, job;
-- 10 distinct deptno job combinations

/* Retrieve all departments with an average salary < $1500*/

SELECT deptno
FROM emp
GROUP BY deptno
HAVING AVG(sal) < 1500;
-- None of so thanks for that.
