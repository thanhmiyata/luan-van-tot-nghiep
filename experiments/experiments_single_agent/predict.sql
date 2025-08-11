SELECT COUNT(*) as head_count FROM head WHERE age > 56	department_management
SELECT h.name, h.born_state, h.age FROM head h JOIN management m ON h.head_ID = m.head_ID ORDER BY h.age	department_management
SELECT Creation, Name, Budget_in_Billions FROM department	department_management
SELECT MIN(Budget_in_Billions) as min_budget, MAX(Budget_in_Billions) as max_budget FROM department	department_management
SELECT AVG(Num_Employees) as avg_employees FROM department WHERE Ranking BETWEEN 10 AND 15	department_management
SELECT name FROM head WHERE born_state != 'California'	department_management
SELECT DISTINCT department.Creation FROM department JOIN head ON department.Department_ID = head.head_ID WHERE head.born_state = 'Alabama'	department_management
SELECT DISTINCT born_state FROM head GROUP BY born_state HAVING COUNT(*) >= 3	department_management
SELECT Creation AS Most_Common_Creation_Year, COUNT(*) AS Frequency FROM department GROUP BY Creation ORDER BY Frequency DESC LIMIT 1	department_management
SELECT d.Name, d.Num_Employees FROM department d JOIN management m ON d.Department_ID = m.department_ID JOIN head h ON m.head_ID = h.head_ID WHERE m.temporary_acting = 'Có'	department_management
SELECT COUNT(DISTINCT temporary_acting) AS temporary_status_count FROM management	department_management
SELECT COUNT(DISTINCT d.Department_ID) AS departments_without_head_in_management FROM department d LEFT JOIN head h ON d.Name = h.name LEFT JOIN management m ON h.head_ID = m.head_ID WHERE m.head_ID IS NULL	department_management
SELECT DISTINCT age FROM head h JOIN management m ON h.head_ID = m.head_ID WHERE m.temporary_acting = 'Yes'	department_management
SELECT DISTINCT h1.born_state FROM department d1 JOIN head h1 ON d1.head_ID = h1.head_ID JOIN department d2 JOIN head h2 ON d2.head_ID = h2.head_ID WHERE d1.Name = 'Treasury' AND d2.Name = 'Homeland Security' AND h1.born_state = h2.born_state	department_management
SELECT d.Department_ID, d.Name, COUNT(DISTINCT m.head_ID) as head_count FROM department d JOIN management m ON d.Department_ID = m.department_ID GROUP BY d.Department_ID, d.Name HAVING head_count > 1	department_management
SELECT head_ID, name FROM head WHERE name LIKE '%Ha%'	department_management
SELECT COUNT(*) AS total_farms FROM farm	farm
SELECT COUNT(*) AS total_farms FROM farm	farm
SELECT Total_Horses FROM farm ORDER BY Total_Horses ASC	farm
SELECT Farm_ID, Total_Horses FROM farm ORDER BY Total_Horses ASC	farm
SELECT DISTINCT farm_competition.Hosts FROM farm_competition WHERE farm_competition.Theme != 'Người ngoài hành tinh'	farm
SELECT DISTINCT Hosts FROM farm_competition WHERE Theme != 'Người ngoài hành tinh'	farm
SELECT DISTINCT Theme FROM farm_competition ORDER BY Year ASC	farm
SELECT DISTINCT Theme, Year FROM farm_competition ORDER BY Year ASC	farm
SELECT AVG(Working_Horses) as avg_working_horses FROM farm WHERE Total_Horses > 5000	farm
SELECT AVG(Working_Horses) as avg_working_horses FROM farm WHERE Total_Horses > 5000	farm
SELECT MAX(Total_Cattle) as max_cattle, MIN(Total_Cattle) as min_cattle FROM farm	farm
SELECT MAX(Total_Cattle) as max_cattle, MIN(Total_Cattle) as min_cattle FROM farm	farm
SELECT COUNT(DISTINCT Status) AS UniqueStatusCount FROM city	farm
SELECT COUNT(DISTINCT Status) AS unique_status_count FROM city	farm
SELECT Official_Name FROM city ORDER BY Population DESC	farm
SELECT Official_Name FROM city ORDER BY Population DESC	farm
SELECT Official_Name, Status FROM city ORDER BY Population DESC LIMIT 1	farm
SELECT Official_Name, Status FROM city ORDER BY Population DESC LIMIT 1	farm
SELECT DISTINCT competition_record.Year, city.Official_Name FROM competition_record JOIN city ON competition_record.Host_city_ID = city.City_ID	farm
SELECT DISTINCT fc.Year, c.Official_Name FROM farm_competition fc JOIN city c ON fc.Host_city_ID = c.City_ID	farm
SELECT DISTINCT c.Official_Name FROM city c JOIN farm_competition fc ON c.City_ID = fc.Host_city_ID GROUP BY c.City_ID, c.Official_Name HAVING COUNT(DISTINCT fc.Competition_ID) > 1	farm
SELECT DISTINCT c.Official_Name FROM city c JOIN farm_competition fc ON c.City_ID = fc.Host_city_ID GROUP BY c.Official_Name HAVING COUNT(fc.Competition_ID) > 1	farm
SELECT c.Official_Name, c.Status, COUNT(fc.Competition_ID) as Competition_Count FROM city c JOIN farm_competition fc ON c.City_ID = fc.Host_city_ID GROUP BY c.City_ID, c.Official_Name, c.Status ORDER BY Competition_Count DESC LIMIT 1	farm
SELECT c.Status, COUNT(fc.Competition_ID) as CompetitionCount FROM city c JOIN farm_competition fc ON c.City_ID = fc.Host_city_ID GROUP BY c.City_ID, c.Status ORDER BY CompetitionCount DESC LIMIT 1	farm
SELECT DISTINCT fc.Theme FROM farm_competition fc JOIN city c ON fc.Host_city_ID = c.City_ID WHERE c.Population > 1000	farm
SELECT DISTINCT fc.Theme FROM farm_competition fc JOIN city c ON fc.Host_city_ID = c.City_ID WHERE c.Population > 1000	farm
SELECT Status, AVG(Population) AS Average_Population FROM city WHERE Population > 0 GROUP BY Status	farm
SELECT Status, AVG(Population) AS Average_Population FROM city GROUP BY Status	farm
SELECT Status, COUNT(Official_Name) as city_count FROM city GROUP BY Status ORDER BY city_count DESC	farm
SELECT Status, COUNT(Status) as status_frequency FROM city GROUP BY Status ORDER BY status_frequency ASC	farm
SELECT Status, COUNT(*) as Status_Count FROM city GROUP BY Status ORDER BY Status_Count DESC LIMIT 1	farm
SELECT Status, COUNT(*) as status_count FROM city GROUP BY Status ORDER BY status_count DESC LIMIT 1	farm
SELECT DISTINCT c.Official_Name FROM city c WHERE NOT EXISTS (SELECT 1 FROM farm_competition fc WHERE fc.Host_city_ID = c.City_ID)	farm
SELECT DISTINCT c.Official_Name FROM city c WHERE c.City_ID NOT IN (SELECT DISTINCT Host_city_ID FROM farm_competition WHERE Host_city_ID IS NOT NULL)	farm
