----------------------------------------------
-- sql_practice_10_02.sql
----------------------------------------------
/*
/*
If you have not created a "student" database:

To create a database usinig pgAmin:
-- Open up query tool
-- Right mouse click on Databases and create a new database: students
-- Right click on the new database and open up a query window.

-- Select the new database and open up a query tool for the student database.
-- Verify that there are no tables yet in the database.

Note: you may not have permission to create a new database, ask
your instructor what database you can add tables to
or just create this database locally.
*/

/*
---------------------------------------------------
-- Open a query tool in the proper database
-- Create table 'student' with the following fields: sno integer, sname varchar(10), age integer.
Define sno as the primary key.
*/

create table student ( 
	sno integer primary key,	  
	sname varchar(10),	  
	age integer	);	

/*
-- Create table 'courses' with the following fields: cno varchar(5), title varchar(10),	credits integer.
Define cno as the primary key.
*/
	
create table courses ( 
	cno varchar(5) primary key,	  
	title varchar(10),	  
	credits integer	);

/*
-- Create table 'professor' with the following fields: lname varchar(10), dept varchar(10), salary integer, age integer.
Define lname as the primary key.
*/

create table professor	( 
	lname varchar(10) primary key,	  
	dept varchar(10),	  
	salary integer,	  
	age integer	);

/*
-- Create table 'take' for students and the courses they take with the following fields: 
sno integer, cno varchar(5).
Define (sno, cno) as a composite primary key.
Define sno as a foreign key reference on student(sno).
Define cno as a foreign key reference on courses(cno).
*/

create table take	( 
	sno integer,	  
	cno varchar(5),
	primary key(sno, cno),
	foreign key (sno) references student(sno),
	foreign key (cno) references courses(cno));

/*
-- Create table 'teach' for professors and the courses they teach with the following fields: 
lname varchar(10), cno varchar(5).
Define (lname, cno) as a composite primary key.
Define lname as a foreign key reference on professor(lname).
Define cno as a foreign key reference on courses(cno).
*/

create table teach	( 
	lname varchar(10),	  
	cno varchar(5),
	primary key (lname, cno),
	foreign key (lname) references professor(lname),
	foreign key (cno) references courses(cno));

/*
--------------------------------------------
-- Execute the following insert commands to populate the database
-- Watch for errors. 
-- If you have error, revisit your table create statements.
-- You can delete a table as follows: drop table <table name>
*/
insert into student values (1,'AARON',20);
insert into student values (2,'CHUCK',21);
insert into student values (3,'DOUG',20);
insert into student values (4,'MAGGIE',19);
insert into student values (5,'STEVE',22);
insert into student values (6,'JING',18);
insert into student values (7,'BRIAN',21);
insert into student values (8,'KAY',20);	
insert into student values (9,'GILLIAN',20);	
insert into student values (10,'CHAD',21);		
insert into courses values ('CS112','PHYSICS',4);	
insert into courses values ('CS113','CALCULUS',4);	
insert into courses values ('CS114','HISTORY',4);		
insert into professor values ('CHOI','SCIENCE',400,45);	
insert into professor values ('GUNN','HISTORY',300,60);	
insert into professor values ('MAYER','MATH',400,55);	
insert into professor values ('POMEL','SCIENCE',500,65);	
insert into professor values ('FEUER','MATH',400,40);		
insert into take values (1,'CS112');	
insert into take values (1,'CS113');	
insert into take values (1,'CS114');	
insert into take values (2,'CS112');	
insert into take values (3,'CS112');	
insert into take values (3,'CS114');	
insert into take values (4,'CS112');	
insert into take values (4,'CS113');	
insert into take values (5,'CS113');	
insert into take values (6,'CS113');	
insert into take values (6,'CS114');	
insert into teach values ('CHOI','CS112');	
insert into teach values ('CHOI','CS113');	
insert into teach values ('CHOI','CS114');	
insert into teach values ('POMEL','CS113');	
insert into teach values ('MAYER','CS112');
insert into teach values ('MAYER','CS114');

-------------------------------------------------
-- Execute the following queries to validate your database

select s.sname, t.cno
from student s, take t, courses c
where s.sno=t.sno
and t.cno=c.cno
order by s.sname;

select count(*) from student;
-- 10

select count(*) from courses;
-- 3

select count(*) from professor;
-- 5

select count(*) from take;
-- 11

select count(*) from teach;
-- 6
*/

-------------------------------------------------
-- Write the following queries.
-------------------------------------------------

-------------------------------------------------
-- 1) What are the names of students who take CS112?
SELECT sname
FROM take AS t
INNER JOIN
student AS s
ON t.sno = s.sno
WHERE cno = 'CS112';

SELECT sname
FROM student
WHERE sno IN (SELECT sno FROM take WHERE cno = 'CS112');

-------------------------------------------------
-- 2) What are the names of students who do not take CS112?
-- Hint: set negation
-- Discussion: Find the set of students who take CS112, and then return all students who are not them.
SELECT sname
FROM student
WHERE sno NOT IN (SELECT sno FROM take WHERE cno = 'CS112');


SELECT sname
FROM student AS s
LEFT OUTER JOIN
(SELECT * FROM take WHERE cno = 'CS112') AS t
ON t.sno = s.sno
WHERE cno IS NULL;
-------------------------------------------------
-- 3) Repeat query (2) using CTEs

WITH takecte AS
(
	SELECT * FROM take WHERE cno = 'CS112'
)
SELECT sname, t.cno, s.sno
FROM student AS s
LEFT OUTER JOIN
takecte AS t
ON t.sno = s.sno
WHERE cno IS NULL;

SELECT * FROM take WHERE cno = 'CS112';

-------------------------------------------------
-- 4) Find students who take CS112 or CS114 but not both. 

WITH snos AS
(
	SELECT CASE
		WHEN cs114.sno IS NULL THEN cs112.sno
		ELSE cs114.sno
		END
	FROM (SELECT sno, cno FROM take WHERE cno = 'CS114') AS cs114
	FULL OUTER JOIN
	(SELECT sno, cno FROM take WHERE cno = 'CS112') AS cs112
	ON cs114.sno = cs112.sno
	WHERE cs112.cno IS NULL OR cs114.cno IS NULL
)
SELECT sname, sno
FROM student
WHERE sno IN (SELECT sno FROM snos);

--compare
SELECT * FROM take;

-------------------------------------------------
-- 5) Find students who take CS112 and no other courses.
-- Discussion: Use the aggregate function COUNT to ensure that students returned by the query take only one course.

WITH counts AS
(
	SELECT sno, COUNT(cno), MAX(cno) AS cno
	FROM take
	GROUP BY sno
	HAVING COUNT(cno) = 1
)
SELECT sname, student.sno
FROM student
WHERE sno IN (SELECT sno FROM counts WHERE cno = 'CS112');

-------------------------------------------------
-- 6) Calculate the number of classes taken by each student, order by number descending

WITH counts AS
(
	SELECT sno, COUNT(cno) AS course_count
	FROM take
	GROUP BY sno
)
SELECT sname, COALESCE(course_count, 0)
FROM student
LEFT OUTER JOIN
counts
ON student.sno = counts.sno
ORDER BY course_count DESC NULLS LAST;

-------------------------------------------------
-- 7) Find  students who take at most two courses. 
-- Discussion: Use the aggregate function COUNT to determine which students take no more than two courses:

WITH counts AS
(
	SELECT sno, COUNT(cno) AS course_count
	FROM take
	GROUP BY sno
)
SELECT s.sno, sname, course_count
FROM student AS s
LEFT OUTER JOIN
counts AS c
ON s.sno = c.sno
WHERE c.course_count >= 2;

/* If you would like, you can drop tables as follows:
drop table <tablename>
*/