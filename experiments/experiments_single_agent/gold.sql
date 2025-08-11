SELECT count(*) FROM head WHERE age  >  56	department_management
SELECT name ,  born_state ,  age FROM head ORDER BY age	department_management
SELECT creation ,  name ,  budget_in_billions FROM department	department_management
SELECT max(budget_in_billions) ,  min(budget_in_billions) FROM department	department_management
SELECT avg(num_employees) FROM department WHERE ranking BETWEEN 10 AND 15	department_management
SELECT name FROM head WHERE born_state != 'California'	department_management
SELECT DISTINCT T1.creation FROM department AS T1 JOIN management AS T2 ON T1.department_id  =  T2.department_id JOIN head AS T3 ON T2.head_id  =  T3.head_id WHERE T3.born_state  =  'Alabama'	department_management
SELECT born_state FROM head GROUP BY born_state HAVING count(*)  >=  3	department_management
SELECT creation FROM department GROUP BY creation ORDER BY count(*) DESC LIMIT 1	department_management
SELECT T1.name ,  T1.num_employees FROM department AS T1 JOIN management AS T2 ON T1.department_id  =  T2.department_id WHERE T2.temporary_acting  =  'Yes'	department_management
SELECT count(DISTINCT temporary_acting) FROM management	department_management
SELECT count(*) FROM department WHERE department_id NOT IN (SELECT department_id FROM management);	department_management
SELECT DISTINCT T1.age FROM management AS T2 JOIN head AS T1 ON T1.head_id  =  T2.head_id WHERE T2.temporary_acting  =  'Yes'	department_management
SELECT T3.born_state FROM department AS T1 JOIN management AS T2 ON T1.department_id  =  T2.department_id JOIN head AS T3 ON T2.head_id  =  T3.head_id WHERE T1.name  =  'Treasury' INTERSECT SELECT T3.born_state FROM department AS T1 JOIN management AS T2 ON T1.department_id  =  T2.department_id JOIN head AS T3 ON T2.head_id  =  T3.head_id WHERE T1.name  =  'Homeland Security'	department_management
SELECT T1.department_id ,  T1.name ,  count(*) FROM management AS T2 JOIN department AS T1 ON T1.department_id  =  T2.department_id GROUP BY T1.department_id HAVING count(*)  >  1	department_management
SELECT head_id ,  name FROM head WHERE name LIKE '%Ha%'	department_management
SELECT count(*) FROM farm	farm
SELECT count(*) FROM farm	farm
SELECT Total_Horses FROM farm ORDER BY Total_Horses ASC	farm
SELECT Total_Horses FROM farm ORDER BY Total_Horses ASC	farm
SELECT Hosts FROM farm_competition WHERE Theme !=  'Aliens'	farm
SELECT Hosts FROM farm_competition WHERE Theme !=  'Aliens'	farm
SELECT Theme FROM farm_competition ORDER BY YEAR ASC	farm
SELECT Theme FROM farm_competition ORDER BY YEAR ASC	farm
SELECT avg(Working_Horses) FROM farm WHERE Total_Horses  >  5000	farm
SELECT avg(Working_Horses) FROM farm WHERE Total_Horses  >  5000	farm
SELECT max(Cows) ,  min(Cows) FROM farm	farm
SELECT max(Cows) ,  min(Cows) FROM farm	farm
SELECT count(DISTINCT Status) FROM city	farm
SELECT count(DISTINCT Status) FROM city	farm
SELECT Official_Name FROM city ORDER BY Population DESC	farm
SELECT Official_Name FROM city ORDER BY Population DESC	farm
SELECT Official_Name ,  Status FROM city ORDER BY Population DESC LIMIT 1	farm
SELECT Official_Name ,  Status FROM city ORDER BY Population DESC LIMIT 1	farm
SELECT T2.Year ,  T1.Official_Name FROM city AS T1 JOIN farm_competition AS T2 ON T1.City_ID  =  T2.Host_city_ID	farm
SELECT T2.Year ,  T1.Official_Name FROM city AS T1 JOIN farm_competition AS T2 ON T1.City_ID  =  T2.Host_city_ID	farm
SELECT T1.Official_Name FROM city AS T1 JOIN farm_competition AS T2 ON T1.City_ID  =  T2.Host_city_ID GROUP BY T2.Host_city_ID HAVING COUNT(*)  >  1	farm
SELECT T1.Official_Name FROM city AS T1 JOIN farm_competition AS T2 ON T1.City_ID  =  T2.Host_city_ID GROUP BY T2.Host_city_ID HAVING COUNT(*)  >  1	farm
SELECT T1.Status FROM city AS T1 JOIN farm_competition AS T2 ON T1.City_ID  =  T2.Host_city_ID GROUP BY T2.Host_city_ID ORDER BY COUNT(*) DESC LIMIT 1	farm
SELECT T1.Status FROM city AS T1 JOIN farm_competition AS T2 ON T1.City_ID  =  T2.Host_city_ID GROUP BY T2.Host_city_ID ORDER BY COUNT(*) DESC LIMIT 1	farm
SELECT T2.Theme FROM city AS T1 JOIN farm_competition AS T2 ON T1.City_ID  =  T2.Host_city_ID WHERE T1.Population  >  1000	farm
SELECT T2.Theme FROM city AS T1 JOIN farm_competition AS T2 ON T1.City_ID  =  T2.Host_city_ID WHERE T1.Population  >  1000	farm
SELECT Status ,  avg(Population) FROM city GROUP BY Status	farm
SELECT Status ,  avg(Population) FROM city GROUP BY Status	farm
SELECT Status FROM city GROUP BY Status ORDER BY COUNT(*) ASC	farm
SELECT Status FROM city GROUP BY Status ORDER BY COUNT(*) ASC	farm
SELECT Status FROM city GROUP BY Status ORDER BY COUNT(*) DESC LIMIT 1	farm
SELECT Status FROM city GROUP BY Status ORDER BY COUNT(*) DESC LIMIT 1	farm
SELECT Official_Name FROM city WHERE City_ID NOT IN (SELECT Host_city_ID FROM farm_competition)	farm
SELECT Official_Name FROM city WHERE City_ID NOT IN (SELECT Host_city_ID FROM farm_competition)	farm
