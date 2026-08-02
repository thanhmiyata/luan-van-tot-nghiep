SELECT COUNT(Employee_ID) FROM employee
SELECT COUNT(*) AS count FROM employee
SELECT Name FROM employee ORDER BY Age ASC
SELECT Name, Age FROM employee ORDER BY Age ASC
SELECT City, COUNT(Employee_ID) AS employee_count FROM employee GROUP BY City
SELECT City, COUNT(Employee_ID) FROM employee GROUP BY City
SELECT City FROM employee WHERE Age < 30 GROUP BY City HAVING COUNT(*) > 1
SELECT City FROM employee WHERE Age < 30 GROUP BY City HAVING COUNT(*) > 1
SELECT Location, COUNT(Shop_ID) AS number_of_shops FROM shop GROUP BY Location
SELECT COUNT(Shop_ID) AS "Number of shops", Location FROM shop GROUP BY Location
SELECT Manager_name, District FROM shop ORDER BY Number_products DESC LIMIT 1
SELECT Manager_name, District FROM shop ORDER BY Number_products DESC LIMIT 1
SELECT MIN(Number_products) AS min_number_products, MAX(Number_products) AS max_number_products FROM shop
SELECT MIN(Number_products), MAX(Number_products) FROM shop
SELECT Name, Location, District FROM shop ORDER BY Number_products DESC
SELECT Name, Location, District FROM shop ORDER BY Number_products DESC
SELECT Name FROM shop WHERE Number_products > (SELECT AVG(Number_products) FROM shop)
SELECT Name FROM shop WHERE Number_products > (SELECT AVG(Number_products) FROM shop)
SELECT employee.Name FROM employee JOIN evaluation ON employee.Employee_ID = evaluation.Employee_ID GROUP BY employee.Employee_ID ORDER BY COUNT(evaluation.Employee_ID) DESC LIMIT 1
SELECT e.Name FROM employee AS e JOIN evaluation AS ev ON e.Employee_ID = ev.Employee_ID GROUP BY e.Employee_ID ORDER BY COUNT(*) DESC LIMIT 1
SELECT employee.Name FROM employee JOIN evaluation ON employee.Employee_ID = evaluation.Employee_ID ORDER BY evaluation.Bonus DESC LIMIT 1
SELECT Name FROM employee JOIN evaluation ON employee.Employee_ID = evaluation.Employee_ID ORDER BY Bonus DESC LIMIT 1
SELECT Name FROM employee WHERE NOT Employee_ID IN (SELECT Employee_ID FROM evaluation)
SELECT Name FROM employee WHERE NOT Employee_ID IN (SELECT Employee_ID FROM evaluation)
SELECT shop.Name FROM shop JOIN hiring ON shop.Shop_ID = hiring.Shop_ID GROUP BY shop.Shop_ID ORDER BY COUNT(hiring.Employee_ID) DESC LIMIT 1
SELECT shop.Name FROM shop JOIN hiring ON shop.Shop_ID = hiring.Shop_ID GROUP BY shop.Shop_ID ORDER BY COUNT(*) DESC LIMIT 1
SELECT Name FROM shop WHERE NOT Shop_ID IN (SELECT Shop_ID FROM hiring)
SELECT Name FROM shop WHERE NOT Shop_ID IN (SELECT Shop_ID FROM hiring)
SELECT shop.Name, COUNT(*) AS number_of_employees FROM shop JOIN hiring ON shop.Shop_ID = hiring.Shop_ID GROUP BY shop.Name
SELECT shop.Name, COUNT(hiring.Employee_ID) FROM shop JOIN hiring ON shop.Shop_ID = hiring.Shop_ID GROUP BY shop.Name
SELECT SUM(Bonus) AS total_bonus FROM evaluation
SELECT SUM(Bonus) FROM evaluation
SELECT Shop_ID, Employee_ID, Start_from, Is_full_time FROM hiring
SELECT Shop_ID, Employee_ID, Start_from, Is_full_time FROM hiring
SELECT District FROM shop WHERE Number_products < 3000 INTERSECT SELECT District FROM shop WHERE Number_products > 10000
SELECT District FROM shop WHERE Number_products < 3000 INTERSECT SELECT District FROM shop WHERE Number_products > 10000
SELECT COUNT(DISTINCT Location) FROM shop
SELECT COUNT(DISTINCT Location) AS count FROM shop
