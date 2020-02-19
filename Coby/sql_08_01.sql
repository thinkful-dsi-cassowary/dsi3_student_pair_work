----------------------------------------------
/*
If may not have permission to create a new database, ask
your instructor what database you can add tables to
or just create this database locally.

To create a database usinig pgAmin:
-- Open up query tool
-- Right mouse click on Databases and create a new database: students
-- Right click on the new database and open up a query window.

-- Select the new database and open up a query tool for the student database.
-- Verify that there are no tables yet in the database.
*/
-- No tables :)
/*
---------------------------------------------------
-- Open a query tool in the proper database
-- Create table 'student' with the following fields: sno integer, sname varchar(10), age integer.
Define sno as the primary key. */

-- CREATE TABLE student(
-- 	sno int PRIMARY KEY,
-- 	sname varchar(10),
-- 	age int,);

/*
Create table 'courses' with the following fields: cno varchar(5), title varchar(10),	credits integer.
Define cno as the primary key.
*/
	
-- CREATE TABLE courses(
-- 	cno varchar(5),
-- 	title varchar(10),
-- 	credits int,
-- 	PRIMARY KEY(cno));

/*
-- Create table 'professor' with the following fields: lname varchar(10), dept varchar(10), salary integer, age integer.
Define lname as the primary key.
*/

-- CREATE TABLE professor(
-- 	lname varchar(10) PRIMARY KEY,
-- 	dept varchar(10),
-- 	salary int,
-- 	age int);

/*
-- Create table 'take' for students and the courses they take with the following fields: 
sno integer, cno varchar(5).
Define (sno, cno) as a composite primary key.
Define sno as a foreign key reference on student(sno).
Define cno as a foreign key reference on courses(cno).
*/

-- CREATE TABLE take(
-- 	sno int,
-- 	cno varchar(5),
-- 	PRIMARY KEY(sno, cno),
-- 	FOREIGN KEY(sno) REFERENCES students(sno),
-- 	FOREIGN KEY(cno) REFERENCES courses(cno));

/*
-- Create table 'teach' for professors and the courses they teach with the following fields: 
lname varchar(10), cno varchar(5).
Define (lname, cno) as a composite primary key.
Define lname as a foreign key reference on professor(lname).
Define cno as a foreign key reference on courses(cno).
*/

-- CREATE TABLE teach(
-- 	lname varchar(10),
-- 	cno varchar(5),
-- 	PRIMARY KEY(lname, cno),
-- 	FOREIGN KEY(lname) REFERENCES professor(lname),
-- 	FOREIGN KEY(cno) REFERENCES courses(cno));

/*
--------------------------------------------
-- Execute the following insert commands to populate the database
-- Watch for errors. 
-- If you have error, revisit your table create statements.
-- You can delete a table as follows: drop table <table name>
*/
-- insert into students values (1,'AARON',20);
-- insert into students values (2,'CHUCK',21);
-- insert into students values (3,'DOUG',20);
-- insert into students values (4,'MAGGIE',19);
-- insert into students values (5,'STEVE',22);
-- insert into students values (6,'JING',18);
-- insert into students values (7,'BRIAN',21);
-- insert into students values (8,'KAY',20);	
-- insert into students values (9,'GILLIAN',20);	
-- insert into students values (10,'CHAD',21);		
-- insert into courses values ('CS112','PHYSICS',4);	
-- insert into courses values ('CS113','CALCULUS',4);	
-- insert into courses values ('CS114','HISTORY',4);		
-- insert into professor values ('CHOI','SCIENCE',400,45);	
-- insert into professor values ('GUNN','HISTORY',300,60);	
-- insert into professor values ('MAYER','MATH',400,55);	
-- insert into professor values ('POMEL','SCIENCE',500,65);	
-- insert into professor values ('FEUER','MATH',400,40);		
-- insert into take values (1,'CS112');	
-- insert into take values (1,'CS113');	
-- insert into take values (1,'CS114');	
-- insert into take values (2,'CS112');	
-- insert into take values (3,'CS112');	
-- insert into take values (3,'CS114');	
-- insert into take values (4,'CS112');	
-- insert into take values (4,'CS113');	
-- insert into take values (5,'CS113');	
-- insert into take values (6,'CS113');	
-- insert into take values (6,'CS114');	
-- insert into teach values ('CHOI','CS112');	
-- insert into teach values ('CHOI','CS113');	
-- insert into teach values ('CHOI','CS114');	
-- insert into teach values ('POMEL','CS113');	
-- insert into teach values ('MAYER','CS112');
-- insert into teach values ('MAYER','CS114');

-------------------------------------------------
-- Execute the following queries to validate your database



-- select count(*) from students;
-- 10

-- select count(*) from courses;
-- 3

-- select count(*) from professor;
-- 5

-- select count(*) from take;
-- 11

-- select count(*) from teach;
-- 6

-------------------------------------------------
-- Write the following queries:

-- How many students take CS112?

SELECT COUNT(sno)
FROM take
WHERE cno = 'CS112';
--ANS: 4

-- What are the names of students who take CS112?

SELECT students.sname
FROM take LEFT JOIN students
ON take.sno = students.sno
WHERE cno = 'CS112';

-- Challenge: What are the names of students who do not take CS112?

SELECT DISTINCT students.sname
FROM take LEFT JOIN students
ON take.sno = students.sno
WHERE cno != 'CS112';

-- AARON decides to drop CS112, remove AARON from the take table, repeat 
-- the query above to verify results

-- DELETE 
-- FROM take
-- WHERE sno = 1 AND cno = 'CS112';                                                                                                                                                    

-- JING decides to change renrollment from CS114 to CS112, update the take table

-- UPDATE take 
-- SET cno = 'CS112' 
-- WHERE sno = 6 AND cno = 'CS114';

-- AARON decides to re-enroll in CS112, insert AARON back into the take table, repeat 
-- the query above to verify results
	
-- INSERT INTO take (sno, cno)
-- VALUES (1, 'CS112');
	
	
SELECT * FROM take;
/* If you would like, you can drop tables as follows:
drop table <tablename>
*/
	