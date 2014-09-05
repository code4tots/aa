/*
 * Some SQL queries for learning SQL while reading
 * "Learning SQL" 2nd edition by Beaulieu
 */

/* do setup to have table to test on */
CREATE TABLE employees (
	emp_id   INT,
	fname    TEXT,
	lname    TEXT,
	dept_id  INT,
	bday     DATE,
	PRIMARY KEY (emp_id)
) ;

CREATE TABLE departments (
	dept_id   INT,
	name      TEXT,
	PRIMARY KEY (dept_id)
) ;

CREATE TABLE simple (
	a         INT
);

/* data from 3.4.1.1 */

/* INSERT results in pairs of numbers 0 8 
 * I wonder what the first number means ....
 * ???
 */
INSERT INTO employees VALUES
	( 1, 'Michael' , 'Smith',     1, '1990-01-25'),
	( 2, 'Susan'   , 'Barker',    1, '1985-11-01'),
	( 3, 'Robert'  , 'Tyler',     2, null),
	( 4, 'Susan'   , 'Hawthorne', 1, null),
	( 5, 'John'    , 'Gooding',   4, null),
	( 6, 'Helen'   , 'Fleming',   4, null),
	
	( 7, 'John'    , 'Smith',     3, null),
	
	( 8, 'Lara'     , 'Croft',    0, '1999-07-15')
	;

/* some made up data */
INSERT INTO departments VALUES
	( 1, 'Software'),
	( 2, 'Hardware'),
	( 3, 'IT'),
	( 4, 'HR')
	;

INSERT INTO simple VALUES
	( 1 ),
	( 2 ),
	( null )
	;

/* --------------------------------------------------------------------  */
/* --------------------------------------------------------------------  */
/* --------------------------------------------------------------------  */
/* --------------------------------------------------------------------  */
/* --------------------------------------------------------------------  */
/* --------------------------------------------------------------------  */
/* --------------------------------------------------------------------  */
/* --------------------------------------------------------------------  */


/* let's just see the data was input correctly */
-- SELECT * FROM employees ;

/* 3.3 SELECT */

/* 3.3.1 Column Aliases */
/*
Even though double quoting for identifiers is part of the ANSI standard,
MySQL and Microsoft SQL do not respect this by default. Something to watch
out for in the future.
*/
-- SELECT
-- 	employees.fname           "first name",
-- 	UPPER(employees.lname)    "last name",
-- 	'ACTIVE'                   status
-- FROM
-- 	employees ;


/* 3.3.2 removing duplicates */
-- SELECT DISTINCT
-- 	fname
-- FROM
-- 	employees ;

/* 3.4.1 Tables

3 kinds of tables

	-- permanent (CREATE TABLE)
	-- temporary (subquery)
	-- virtual   (CREATE VIEW)

*/

/* 3.4.1.1 subquery generated tables */
-- SELECT
-- 	e.emp_id
-- FROM (
-- 	SELECT
-- 		employees.*
-- 	FROM
-- 		employees
-- ) e ;

/* 3.4.1.2 views */
CREATE VIEW employees_view AS
SELECT
	emp_id,
	fname
FROM
	employees ;

-- SELECT * FROM employees_view ;

/* 3.4.2 Table Links */

/* inner join */
-- SELECT
-- 	employees.emp_id,
-- 	employees.fname "first name",
-- 	employees.lname "last name",
-- 	departments.name
-- FROM
-- 	employees
-- INNER JOIN
-- 	departments
-- ON
-- 	employees.dept_id = departments.dept_id
-- 	;


/* outer join */
-- SELECT
-- 	employees.emp_id,
-- 	employees.fname "first name",
-- 	employees.lname "last name",
-- 	departments.name
-- FROM
-- 	employees
-- LEFT OUTER JOIN
-- 	departments
-- ON
-- 	employees.dept_id = departments.dept_id
-- 	;

/* self joins */
/*

------------------------------------------------------------------------------

Using venn diagrams to explain joins seems pretty stupid to me.

If you say that INNER JOIN is the intersection point in the venn diagram,
you expect the resulting set to be smaller than either of the original sets.

However, that just isn't the way joins work.

------------------------------------------------------------------------------

My conjecture from what I see here is that all JOINS (INNER and OUTER) of two
tables A and B result in a subset of (A union null) x (B union null).

In particular,
    CROSS JOIN          will result in exactly    A           x  B,
	INNER JOIN          will result in subset of  A           x  B,
	LEFT OUTER JOIN     will result in subset of (A U {null}) x  B,
	RIGHT OUTER JOIN    will result in subset of  A           x (B U {null}),
	FULL OUTER JOIN     will result in subset of (A U {null}) x (B U {null})

CURRENT MODEL OF EXECUTION 
CURRENT MODEL OF EXECUTION 
CURRENT MODEL OF EXECUTION 
CURRENT MODEL OF EXECUTION 
CURRENT MODEL OF EXECUTION 
CURRENT MODEL OF EXECUTION 
CURRENT MODEL OF EXECUTION 
CURRENT MODEL OF EXECUTION 

	--	With INNER JOINs, we select all elements of A x B that make ON condition
		true.
		
			The query compares each row of A with each row of B to find all 
			pairs of rows which satisfy the join-predicate.
				(Wikipedia Join_(SQL))
			
			Some syntactic sugar variants
			
				-- Equi-Join
				-- Natural Join (auto-compare columns with same names)

	-- 	With LEFT OUTER JOINS, we include all elements of of INNER JOINs but
		also all pairs (a,null) for all "a" that did not appear in the INNER JOIN.
		Of course, the predicate for "a" must be true to be included.

	--	RIGHT OUTER JOIN is symmetric to LEFT OUTER JOIN.

	-- 	FULL OUTER JOIN is the union of LEFT OUTER JOIN and RIGHT OUTER JOIN.


*******************************************************************************
**** This is all assuming all the predicates turn up true for all matches. ****
*******************************************************************************

*******************************************************************************
ABOVE STARRED BLOCK IS WRONG!!!!
	it looks like OUTER JOINs include all rows from the table regardless of
	whether the predicate is true.
	
	As such, a FULL OUTER JOIN will give you a discriminated union when
	JOIN-ing ON false.
	
	(Originally I used the term disjoint union for discriminated union.
	However, the term "disjoint union" is often used for other things too,
	so from here on out, I'll try to use "discriminated union" when I mean
	discriminated union).
*******************************************************************************


http://en.wikipedia.org/wiki/Nested_loop_join

Algorithm to verify that I'm right about at least (INNER) JOIN.

  For each tuple r in R do
     For each tuple s in S do
        If r and s satisfy the join condition
           Then output the tuple <r,s>


*/

-- SELECT
-- 	*
-- FROM
-- 	employees a
-- INNER JOIN
-- 	employees b
-- ON
-- 	a.fname = b.fname
-- AND
-- 	a.emp_id = b.emp_id
-- 	;

/* You get A x B by INNER JOIN-ing ON a tautology */
-- SELECT
-- 	*
-- FROM
-- 	simple a
-- INNER JOIN
-- 	simple b
-- ON
-- 	1 = 1
-- 	;

/* You get discriminated union by FULL OUTER JOIN-ing ON false */
-- SELECT
-- 	*
-- FROM
-- 	simple a
-- FULL OUTER JOIN
-- 	simple b
-- ON
-- 	1 = 0
-- 	;


/* 3.5 the WHERE clause */

-- SELECT
-- 	fname "name",
-- 	bday  "birthday"
-- FROM
-- 	employees
-- WHERE
-- 	(bday < '1990-01-01') OR (bday > '1995-01-01');

/* 3.6 Group By and Having */

/* seem to be waiting on "GROUP BY" and "HAVING" */

-- SELECT
-- 	d.name,
-- 	count(e.emp_id) num_employees
-- FROM
-- 	departments d,
-- 	employees e
-- GROUP BY
-- 	d.name
-- HAVING
-- 	count(e.emp_id) > 2 ;


/* 3.7 ORDER BY */

-- SELECT
-- 	fname,
-- 	lname
-- FROM
-- 	employees
-- ORDER BY
-- 	fname,
-- 	lname ;

-- SELECT
-- 	fname,
-- 	lname
-- FROM
-- 	employees
-- ORDER BY
-- 	lname,
-- 	fname ;

-- SELECT
-- 	fname,
-- 	lname
-- FROM
-- 	employees
-- ORDER BY
-- 	lname,
-- 	fname DESC;

-- SELECT
-- 	fname,
-- 	lname
-- FROM
-- 	employees
-- ORDER BY
-- 	RIGHT(lname, 1),
-- 	- emp_id ;

/* Ch 4 and nulls */

SELECT
	emp_id,
	fname, 
	lname
FROM
	employees
WHERE
	bday IS NOT NULL ;


/* --------------------------------------------------------------------  */
/* --------------------------------------------------------------------  */
/* --------------------------------------------------------------------  */
/* --------------------------------------------------------------------  */
/* --------------------------------------------------------------------  */
/* --------------------------------------------------------------------  */
/* --------------------------------------------------------------------  */
/* --------------------------------------------------------------------  */
/* drop the table, so I can run this script again with clean environment */
DROP VIEW employees_view ;
DROP TABLE employees ; /* must be dropped last since employees_view depends on this */
DROP TABLE departments ;
DROP TABLE simple ;

