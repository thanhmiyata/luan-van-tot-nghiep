SELECT COUNT(*) FROM conductor
SELECT COUNT(*) AS count FROM conductor
SELECT Name FROM conductor ORDER BY Age ASC
SELECT Name FROM conductor ORDER BY Age ASC
SELECT Name FROM conductor WHERE Nationality <> 'USA'
SELECT Name FROM conductor WHERE Nationality <> 'USA'
SELECT Record_Company, Year_of_Founded FROM orchestra ORDER BY Year_of_Founded DESC
SELECT Record_Company FROM orchestra ORDER BY Year_of_Founded DESC
SELECT AVG(Attendance) AS average_attendance FROM show
SELECT AVG(Attendance) FROM show
SELECT MAX(Share), MIN(Share) FROM performance WHERE Type <> 'Live final'
SELECT MAX(Share), MIN(Share) FROM performance WHERE Type <> 'Live final'
SELECT COUNT(DISTINCT Nationality) FROM conductor
SELECT COUNT(DISTINCT Nationality) FROM conductor
SELECT Name, Year_of_Work FROM conductor ORDER BY Year_of_Work DESC
SELECT Name FROM conductor ORDER BY Year_of_Work DESC
SELECT Name FROM conductor ORDER BY Year_of_Work DESC LIMIT 1
SELECT Name FROM conductor ORDER BY Year_of_Work DESC LIMIT 1
SELECT conductor.Name, orchestra.Orchestra FROM conductor JOIN orchestra ON conductor.Conductor_ID = orchestra.Conductor_ID
SELECT conductor.Name, orchestra.Orchestra FROM conductor JOIN orchestra ON conductor.Conductor_ID = orchestra.Conductor_ID
SELECT Name FROM conductor WHERE Conductor_ID IN (SELECT Conductor_ID FROM orchestra GROUP BY Conductor_ID HAVING COUNT(DISTINCT Orchestra_ID) > 1)
SELECT Name FROM conductor WHERE Conductor_ID IN (SELECT Conductor_ID FROM orchestra GROUP BY Conductor_ID HAVING COUNT(DISTINCT Orchestra_ID) > 1)
SELECT Name FROM conductor JOIN orchestra ON conductor.Conductor_ID = orchestra.Conductor_ID GROUP BY conductor.Conductor_ID, Name ORDER BY COUNT(orchestra.Orchestra_ID) DESC LIMIT 1
SELECT T1.Name FROM conductor AS T1 JOIN orchestra AS T2 ON T1.Conductor_ID = T2.Conductor_ID GROUP BY T1.Conductor_ID ORDER BY COUNT(*) DESC LIMIT 1
SELECT conductor.Name FROM conductor JOIN orchestra ON conductor.Conductor_ID = orchestra.Conductor_ID WHERE orchestra.Year_of_Founded > 2008
SELECT Name FROM conductor JOIN orchestra ON conductor.Conductor_ID = orchestra.Conductor_ID WHERE Year_of_Founded > 2008
SELECT Record_Company, COUNT(Orchestra) AS number_of_orchestras FROM orchestra GROUP BY Record_Company
SELECT Record_Company, COUNT(Orchestra_ID) AS number_of_orchestras FROM orchestra GROUP BY Record_Company
SELECT Major_Record_Format, COUNT(*) FROM orchestra GROUP BY Major_Record_Format ORDER BY COUNT(*) ASC
SELECT Major_Record_Format, COUNT(*) AS frequency FROM orchestra GROUP BY Major_Record_Format ORDER BY frequency DESC
SELECT Record_Company FROM orchestra GROUP BY Record_Company ORDER BY COUNT(*) DESC LIMIT 1
SELECT Record_Company FROM orchestra GROUP BY Record_Company ORDER BY COUNT(*) DESC LIMIT 1
SELECT Orchestra FROM orchestra WHERE NOT Orchestra_ID IN (SELECT Orchestra_ID FROM performance)
SELECT Orchestra FROM orchestra WHERE NOT Orchestra_ID IN (SELECT Orchestra_ID FROM performance)
SELECT Record_Company FROM orchestra WHERE Year_of_Founded < 2003 INTERSECT SELECT Record_Company FROM orchestra WHERE Year_of_Founded > 2003
SELECT Record_Company FROM orchestra WHERE Year_of_Founded < 2003 INTERSECT SELECT Record_Company FROM orchestra WHERE Year_of_Founded > 2003
SELECT COUNT(*) FROM orchestra WHERE Major_Record_Format = 'CD' OR Major_Record_Format = 'DVD'
SELECT COUNT(*) FROM orchestra WHERE Major_Record_Format = 'CD' OR Major_Record_Format = 'DVD'
SELECT Year_of_Founded FROM orchestra WHERE Orchestra_ID IN (SELECT Orchestra_ID FROM performance GROUP BY Orchestra_ID HAVING COUNT(*) > 1)
SELECT Year_of_Founded FROM orchestra WHERE Orchestra_ID IN (SELECT Orchestra_ID FROM performance GROUP BY Orchestra_ID HAVING COUNT(*) > 1)
