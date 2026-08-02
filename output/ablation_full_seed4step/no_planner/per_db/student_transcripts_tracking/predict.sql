SELECT line_1, line_2 FROM Addresses
SELECT line_1, line_2 FROM Addresses
SELECT COUNT(*) FROM Courses
SELECT COUNT(course_id) FROM Courses
SELECT course_description FROM Courses WHERE course_name = 'math'
SELECT course_description FROM Courses WHERE course_name LIKE '%math%'
SELECT zip_postcode FROM Addresses WHERE city = 'Port Chelsea'
SELECT zip_postcode FROM Addresses WHERE city = 'Port Chelsea'
SELECT D.department_name, D.department_id FROM Departments AS D JOIN Degree_Programs AS DP ON D.department_id = DP.department_id GROUP BY D.department_id ORDER BY COUNT(*) DESC LIMIT 1
SELECT d.department_name, d.department_id FROM Departments AS d JOIN Degree_Programs AS dp ON d.department_id = dp.department_id GROUP BY d.department_id ORDER BY COUNT(*) DESC LIMIT 1
SELECT COUNT(DISTINCT Departments.department_id) AS COUNT FROM Departments JOIN Degree_Programs ON Departments.department_id = Degree_Programs.department_id
SELECT COUNT(DISTINCT department_id) FROM Degree_Programs
SELECT COUNT(DISTINCT degree_summary_name) FROM Degree_Programs
SELECT COUNT(DISTINCT degree_summary_name) FROM Degree_Programs
SELECT COUNT(degree_program_id) FROM Degree_Programs JOIN Departments ON Degree_Programs.department_id = Departments.department_id WHERE Departments.department_name = 'engineering'
SELECT COUNT(*) FROM Degree_Programs JOIN Departments ON Degree_Programs.department_id = Departments.department_id WHERE Departments.department_name = 'engineering'
SELECT section_name, section_description FROM Sections
SELECT section_name, section_description FROM Sections
SELECT course_name, course_id FROM Courses WHERE course_id IN (SELECT course_id FROM Sections WHERE NOT section_id IS NULL GROUP BY course_id HAVING COUNT(*) <= 2)
SELECT course_name, course_id FROM Courses WHERE NOT course_id IN (SELECT course_id FROM Sections GROUP BY course_id HAVING COUNT(section_id) >= 2)
SELECT section_name FROM Sections ORDER BY section_name DESC
SELECT section_name FROM Sections ORDER BY section_name DESC
SELECT Semesters.semester_name, Semesters.semester_id FROM Student_Enrolment JOIN Semesters ON Student_Enrolment.semester_id = Semesters.semester_id GROUP BY Semesters.semester_name, Semesters.semester_id ORDER BY COUNT(Student_Enrolment.student_id) DESC LIMIT 1
SELECT s.semester_name, s.semester_id FROM Semesters AS s JOIN Student_Enrolment AS se ON s.semester_id = se.semester_id GROUP BY s.semester_id, s.semester_name ORDER BY COUNT(se.student_id) DESC LIMIT 1
SELECT department_description FROM Departments WHERE department_name LIKE '%the computer%'
SELECT department_description FROM Departments WHERE department_name LIKE '%computer%'
SELECT s.first_name, s.middle_name, s.last_name, s.student_id FROM Students AS s JOIN Student_Enrolment AS se ON s.student_id = se.student_id GROUP BY s.first_name, s.middle_name, s.last_name, s.student_id HAVING COUNT(DISTINCT se.degree_program_id) = 2
SELECT Students.first_name, Students.middle_name, Students.last_name, Students.student_id FROM Students JOIN Student_Enrolment ON Students.student_id = Student_Enrolment.student_id JOIN (SELECT student_id, semester_id FROM Student_Enrolment GROUP BY student_id, semester_id HAVING COUNT(DISTINCT degree_program_id) = 2) AS EnrolledTwice ON Students.student_id = EnrolledTwice.student_id AND Student_Enrolment.semester_id = EnrolledTwice.semester_id
SELECT Students.first_name, Students.middle_name, Students.last_name FROM Students JOIN Student_Enrolment ON Students.student_id = Student_Enrolment.student_id JOIN Degree_Programs ON Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id WHERE Degree_Programs.degree_summary_name = 'Bachelor'
SELECT Students.first_name, Students.middle_name, Students.last_name FROM Students JOIN Student_Enrolment ON Students.student_id = Student_Enrolment.student_id JOIN Degree_Programs ON Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id WHERE Degree_Programs.degree_summary_name = 'Bachelor'
SELECT degree_summary_name FROM Degree_Programs JOIN Student_Enrolment ON Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id GROUP BY degree_summary_name ORDER BY COUNT(student_id) DESC LIMIT 1
SELECT degree_summary_name FROM Degree_Programs JOIN Student_Enrolment ON Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id GROUP BY degree_summary_name ORDER BY COUNT(*) DESC LIMIT 1
SELECT Degree_Programs.degree_program_id, Degree_Programs.degree_summary_description FROM Degree_Programs JOIN Student_Enrolment ON Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id GROUP BY Degree_Programs.degree_program_id, Degree_Programs.degree_summary_description ORDER BY COUNT(*) DESC LIMIT 1
SELECT Degree_Programs.degree_program_id, Degree_Programs.degree_summary_name FROM Degree_Programs JOIN Student_Enrolment ON Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id GROUP BY Degree_Programs.degree_program_id, Degree_Programs.degree_summary_name ORDER BY COUNT(*) DESC LIMIT 1
SELECT s.student_id, s.first_name, s.middle_name, s.last_name, COUNT(se.student_id) AS number_of_enrollments, s.student_id AS student_id_duplicate FROM Students AS s JOIN Student_Enrolment AS se ON s.student_id = se.student_id GROUP BY s.student_id, s.first_name, s.middle_name, s.last_name ORDER BY number_of_enrollments DESC LIMIT 1
SELECT S.first_name, S.middle_name, S.last_name, S.student_id, COUNT(SE.student_enrolment_id) AS number_of_enrollments FROM Students AS S JOIN Student_Enrolment AS SE ON S.student_id = SE.student_id GROUP BY S.student_id, S.first_name, S.middle_name, S.last_name ORDER BY COUNT(SE.student_enrolment_id) DESC LIMIT 1
SELECT semester_name FROM Semesters WHERE NOT EXISTS(SELECT 1 FROM Student_Enrolment WHERE Student_Enrolment.semester_id = Semesters.semester_id)
SELECT semester_name FROM Semesters WHERE NOT semester_id IN (SELECT semester_id FROM Student_Enrolment)
SELECT course_name FROM Courses WHERE course_id IN (SELECT DISTINCT course_id FROM Student_Enrolment_Courses)
SELECT course_name FROM Courses WHERE course_id IN (SELECT DISTINCT course_id FROM Student_Enrolment_Courses)
SELECT course_name FROM Courses JOIN Student_Enrolment_Courses ON Courses.course_id = Student_Enrolment_Courses.course_id GROUP BY Courses.course_id ORDER BY COUNT(*) DESC LIMIT 1
SELECT course_name FROM Courses JOIN Student_Enrolment_Courses ON Courses.course_id = Student_Enrolment_Courses.course_id GROUP BY Courses.course_id ORDER BY COUNT(*) DESC LIMIT 1
SELECT Students.last_name FROM Students WHERE Students.current_address_id IN (SELECT address_id FROM Addresses WHERE state_province_county = 'North Carolina') AND NOT Students.student_id IN (SELECT student_id FROM Student_Enrolment)
SELECT S.last_name FROM Students AS S JOIN Addresses AS A ON S.current_address_id = A.address_id WHERE A.state_province_county = 'North Carolina' AND NOT S.student_id IN (SELECT student_id FROM Student_Enrolment)
SELECT Transcripts.transcript_date, Transcripts.transcript_id FROM Transcripts JOIN Transcript_Contents ON Transcripts.transcript_id = Transcript_Contents.transcript_id GROUP BY Transcripts.transcript_id, Transcripts.transcript_date HAVING COUNT(*) >= 2
SELECT T.transcript_date, T.transcript_id FROM Transcripts AS T JOIN Transcript_Contents AS TC ON T.transcript_id = TC.transcript_id GROUP BY T.transcript_id, T.transcript_date HAVING COUNT(*) >= 2
SELECT cell_mobile_number FROM Students WHERE first_name = 'Timmothy' AND last_name = 'Ward'
SELECT cell_mobile_number FROM Students WHERE first_name = 'Timmothy' AND last_name = 'Ward'
SELECT first_name, middle_name, last_name FROM Students ORDER BY date_first_registered ASC LIMIT 1
SELECT first_name, middle_name, last_name FROM Students ORDER BY date_first_registered ASC LIMIT 1
SELECT first_name, middle_name, last_name FROM Students ORDER BY date_first_registered ASC LIMIT 1
SELECT s.first_name, s.middle_name, s.last_name FROM Students AS s JOIN Transcripts AS t ON s.student_id = t.transcript_id ORDER BY t.transcript_date ASC LIMIT 1
SELECT first_name FROM Students WHERE current_address_id <> permanent_address_id
SELECT first_name FROM Students WHERE current_address_id <> permanent_address_id
SELECT Addresses.address_id, Addresses.line_1, Addresses.line_2, Addresses.line_3 FROM Addresses JOIN Students ON Students.current_address_id = Addresses.address_id GROUP BY Addresses.address_id, Addresses.line_1, Addresses.line_2, Addresses.line_3 ORDER BY COUNT(*) DESC LIMIT 1
SELECT A.address_id, A.line_1, A.line_2 FROM Addresses AS A JOIN Students AS S ON A.address_id = S.current_address_id GROUP BY A.address_id, A.line_1, A.line_2 ORDER BY COUNT(*) DESC LIMIT 1
SELECT AVG(transcript_date) FROM Transcripts
SELECT AVG(transcript_date) AS average_transcript_date FROM Transcripts
SELECT transcript_date, other_details FROM Transcripts ORDER BY transcript_date ASC LIMIT 1
SELECT transcript_date, other_details FROM Transcripts ORDER BY transcript_date ASC LIMIT 1
SELECT COUNT(transcript_id) FROM Transcripts
SELECT COUNT(*) AS count FROM Transcripts
SELECT MAX(transcript_date) FROM Transcripts ORDER BY transcript_date DESC
SELECT MAX(transcript_date) FROM Transcripts
SELECT COUNT(t2.transcript_id) AS max_count, t1.student_course_id FROM Student_Enrolment_Courses AS t1 JOIN Transcript_Contents AS t2 ON t1.student_course_id = t2.student_course_id GROUP BY t1.student_course_id ORDER BY max_count DESC LIMIT 1
SELECT COUNT(*), student_enrolment_id FROM Student_Enrolment_Courses GROUP BY student_enrolment_id ORDER BY COUNT(*) DESC LIMIT 1
SELECT T.transcript_date, T.transcript_id FROM Transcripts AS T JOIN Transcript_Contents AS TC ON T.transcript_id = TC.transcript_id GROUP BY T.transcript_id ORDER BY COUNT(*) ASC LIMIT 1
SELECT T.transcript_date, T.transcript_id FROM Transcripts AS T JOIN Transcript_Contents AS TC ON T.transcript_id = TC.transcript_id GROUP BY T.transcript_date, T.transcript_id ORDER BY COUNT(TC.student_course_id) ASC LIMIT 1
SELECT semester_name FROM Semesters WHERE semester_id IN (SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN (SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_name = 'Master') INTERSECT SELECT semester_id FROM Student_Enrolment WHERE degree_program_id IN (SELECT degree_program_id FROM Degree_Programs WHERE degree_summary_name = 'Bachelor'))
SELECT Student_Enrolment.semester_id FROM Student_Enrolment JOIN Degree_Programs ON Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id JOIN Semesters ON Student_Enrolment.semester_id = Semesters.semester_id WHERE degree_summary_name = 'Master' INTERSECT SELECT Student_Enrolment.semester_id FROM Student_Enrolment JOIN Degree_Programs ON Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id JOIN Semesters ON Student_Enrolment.semester_id = Semesters.semester_id WHERE degree_summary_name = 'Bachelor'
SELECT COUNT(DISTINCT address_id) AS count FROM Addresses JOIN Students ON Addresses.address_id = Students.current_address_id
SELECT DISTINCT A.line_1, A.line_2, A.line_3, A.city, A.zip_postcode, A.state_province_county, A.country, A.other_address_details FROM Addresses AS A JOIN Students AS S ON A.address_id = S.current_address_id OR A.address_id = S.permanent_address_id
SELECT student_id, current_address_id, permanent_address_id, first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details FROM Students ORDER BY first_name DESC
SELECT student_id, current_address_id, permanent_address_id, first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details FROM Students ORDER BY last_name DESC
SELECT section_name, section_description, other_details FROM Sections WHERE section_name = 'h'
SELECT section_description FROM Sections WHERE section_name = 'h'
SELECT s.first_name FROM Students AS s JOIN Addresses AS a ON s.permanent_address_id = a.address_id WHERE a.country = 'Haiti' OR s.cell_mobile_number = '09700166582'
SELECT first_name FROM Students WHERE permanent_address_id IN (SELECT address_id FROM Addresses WHERE country = 'Haiti') OR cell_mobile_number = '09700166582'
