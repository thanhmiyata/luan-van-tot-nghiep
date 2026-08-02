SELECT T1.name FROM instructor AS T1 LEFT JOIN teaches AS T2 ON T1.ID = T2.ID WHERE T2.ID IS NULL	college_2
SELECT T1.title FROM course AS T1 JOIN prereq AS T2 ON T1.course_id = T2.course_id JOIN course AS T3 ON T2.prereq_id = T3.course_id WHERE T3.title = 'Differential Geometry'	college_2
SELECT name FROM instructor WHERE ID NOT IN (SELECT ID FROM teaches WHERE semester = 'Spring')	college_2
SELECT T2.title FROM prereq AS T1 JOIN course AS T2 ON T1.prereq_id = T2.course_id JOIN course AS T3 ON T1.course_id = T3.course_id WHERE T3.title = 'TÃ i chÃ­nh Quá»c táº¿'	college_2
SELECT T1.title FROM course AS T1 JOIN prereq AS T2 ON T1.course_id = T2.prereq_id JOIN course AS T3 ON T2.course_id = T3.course_id WHERE T3.title = 'Äiá»n toÃ¡n di Äá»ng'	college_2
SELECT ID, name, dept_name, salary FROM instructor ORDER BY salary ASC	college_2
SELECT T1.name FROM instructor AS T1 JOIN teaches AS T2 ON T1.ID = T2.ID JOIN course AS T3 ON T2.course_id = T3.course_id WHERE T3.title = 'Láº­p trÃ¬nh C'	college_2
SELECT dept_name, building FROM department WHERE budget > (SELECT avg(budget) FROM department)	college_2
SELECT T1.course_id FROM course AS T1 JOIN section AS T2 ON T1.course_id = T2.course_id WHERE T2.semester = 'Fall' AND T2.year = 2009 UNION SELECT T1.course_id FROM course AS T1 JOIN section AS T2 ON T1.course_id = T2.course_id WHERE T2.semester = 'Spring' AND T2.year = 2010	college_2
SELECT DISTINCT salary FROM instructor WHERE salary < (SELECT MAX(salary) FROM instructor)	college_2
SELECT T1.title, T1.credits FROM course AS T1 JOIN section AS T2 ON T1.course_id = T2.course_id JOIN classroom AS T3 ON T2.building = T3.building AND T2.room_number = T3.room_number ORDER BY T3.capacity DESC LIMIT 1	college_2
SELECT T1.name FROM instructor AS T1 JOIN advisor AS T2 ON T1.ID = T2.i_ID GROUP BY T2.i_ID HAVING COUNT(T2.s_ID) > 1	college_2
SELECT title FROM course WHERE dept_name = (SELECT dept_name FROM department WHERE dept_name = 'Statistics') AND title NOT IN (SELECT title FROM course WHERE dept_name = (SELECT dept_name FROM department WHERE dept_name = 'Psychology'))	college_2
SELECT T1.dept_name FROM department AS T1 JOIN instructor AS T2 ON T1.dept_name = T2.dept_name WHERE T2.name LIKE '%Soisalon%'	college_2
SELECT T1.dept_name FROM department AS T1 JOIN course AS T2 ON T1.dept_name = T2.dept_name GROUP BY T1.dept_name ORDER BY count(*) DESC LIMIT 3	college_2
SELECT T1.dept_name FROM department AS T1 INNER JOIN instructor AS T2 ON T1.dept_name = T2.dept_name GROUP BY T1.dept_name ORDER BY avg(T2.salary) DESC LIMIT 1	college_2
SELECT T1.name FROM student AS T1 JOIN department AS T2 ON T1.dept_name = T2.dept_name WHERE T2.dept_name = 'History' ORDER BY T1.tot_cred DESC LIMIT 1	college_2
SELECT dept_name, building FROM department WHERE budget > (SELECT avg(budget) FROM department)	college_2
SELECT count(DISTINCT T1.course_id) FROM course AS T1 JOIN department AS T2 ON T1.dept_name = T2.dept_name WHERE T2.dept_name = 'Physics'	college_2
SELECT DISTINCT T1.name FROM student AS T1 JOIN takes AS T2 ON T1.ID = T2.ID JOIN section AS T3 ON T2.course_id = T3.course_id AND T2.sec_id = T3.sec_id AND T2.semester = T3.semester AND T2.year = T3.year WHERE T3.year = 2009 OR T3.year = 2010	college_2
SELECT name FROM instructor ORDER BY salary DESC LIMIT 1	college_2
SELECT T1.name, T2.course_id FROM instructor AS T1 JOIN teaches AS T2 ON T1.ID = T2.ID	college_2
SELECT T1.title, T2.name FROM course AS T1 JOIN teaches AS T3 ON T1.course_id = T3.course_id JOIN instructor AS T2 ON T3.ID = T2.ID JOIN section AS T4 ON T3.course_id = T4.course_id AND T3.sec_id = T4.sec_id AND T3.semester = T4.semester AND T3.year = T4.year WHERE T4.year = 2008 ORDER BY T1.title ASC	college_2
SELECT min(salary) FROM instructor WHERE dept_name IN (SELECT dept_name FROM instructor GROUP BY dept_name HAVING avg(salary) > (SELECT avg(salary) FROM instructor))	college_2
SELECT sum(T1.credits) FROM course AS T1 JOIN department AS T2 ON T1.dept_name = T2.dept_name GROUP BY T1.dept_name	college_2
SELECT T1.dept_name FROM department AS T1 JOIN course AS T2 ON T1.dept_name = T2.dept_name GROUP BY T1.dept_name ORDER BY sum(T2.credits) DESC LIMIT 1	college_2
SELECT T1.dept_name, count(*) FROM department AS T1 JOIN student AS T2 ON T1.dept_name = T2.dept_name GROUP BY T1.dept_name	college_2
SELECT count(DISTINCT T1.ID) FROM instructor AS T1 JOIN teaches AS T2 ON T1.ID = T2.ID JOIN section AS T3 ON T2.course_id = T3.course_id AND T2.sec_id = T3.sec_id AND T2.semester = T3.semester AND T2.year = T3.year WHERE T3.semester = 'Spring' AND T3.year = 2010	college_2
SELECT T1.name FROM student AS T1 JOIN takes AS T2 ON T1.ID = T2.ID JOIN section AS T3 ON T2.course_id = T3.course_id AND T2.sec_id = T3.sec_id AND T2.semester = T3.semester AND T2.year = T3.year WHERE T3.year = 2009 OR T3.year = 2010	college_2
SELECT building, COUNT(*) FROM classroom WHERE capacity > 50 GROUP BY building	college_2
SELECT T1.name FROM instructor AS T1 JOIN department AS T2 ON T1.dept_name = T2.dept_name WHERE T1.salary > (SELECT MIN(salary) FROM instructor WHERE dept_name = 'Biology')	college_2
SELECT T1.name, T2.dept_name FROM student AS T1 JOIN department AS T2 ON T1.dept_name = T2.dept_name ORDER BY T1.tot_cred ASC	college_2
SELECT dept_name, building FROM department ORDER BY budget DESC	college_2
SELECT T2.name FROM student AS T1 INNER JOIN advisor AS T3 ON T1.ID = T3.s_ID INNER JOIN instructor AS T2 ON T3.i_ID = T2.ID ORDER BY T1.tot_cred DESC LIMIT 1	college_2
SELECT dept_name, budget FROM department WHERE budget > (SELECT avg(budget) FROM department)	college_2
SELECT T1.name FROM student AS T1 JOIN takes AS T2 ON T1.ID = T2.ID JOIN course AS T3 ON T2.course_id = T3.course_id JOIN prereq AS T4 ON T3.course_id = T4.course_id WHERE T4.prereq_id IN (SELECT course_id FROM course WHERE title = 'International Finance')	college_2
SELECT T1.title, T2.name FROM course AS T1 JOIN teaches AS T3 ON T1.course_id = T3.course_id JOIN instructor AS T2 ON T3.ID = T2.ID JOIN section AS T4 ON T3.course_id = T4.course_id AND T3.sec_id = T4.sec_id AND T3.semester = T4.semester AND T3.year = T4.year WHERE T4.year = 2008 ORDER BY T1.title	college_2
SELECT T1.building, T1.room_number, T1.semester, T1.year FROM SECTION AS T1 JOIN COURSE AS T2 ON T1.course_id = T2.course_id JOIN DEPARTMENT AS T3 ON T2.dept_name = T3.dept_name WHERE T3.dept_name = 'Psychology' ORDER BY T2.title ASC	college_2
SELECT name FROM instructor WHERE dept_name = 'Comp. Sci.' AND salary > 80000	college_2
SELECT COUNT(*), AVG(T1.salary) FROM instructor AS T1 JOIN department AS T2 ON T1.dept_name = T2.dept_name WHERE T1.dept_name = (SELECT dept_name FROM department ORDER BY budget DESC LIMIT 1)	college_2
