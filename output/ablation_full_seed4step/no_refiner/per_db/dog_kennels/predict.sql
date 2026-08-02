SELECT state FROM Owners INTERSECT SELECT state FROM Professionals
SELECT state FROM Owners INTERSECT SELECT state FROM Professionals
SELECT AVG(Dogs.age) FROM Dogs JOIN Treatments ON Dogs.dog_id = Treatments.dog_id
SELECT AVG(Dogs.age) AS average_age FROM Dogs JOIN Treatments ON Dogs.dog_id = Treatments.dog_id
SELECT P.professional_id, P.last_name, P.cell_number FROM Professionals AS P INNER JOIN Treatments AS T ON P.professional_id = T.professional_id WHERE P.state = 'Indiana' OR (SELECT COUNT(*) FROM Treatments WHERE professional_id = P.professional_id) > 2
SELECT professional_id, last_name, cell_number FROM Professionals WHERE state = 'Indiana' OR professional_id IN (SELECT professional_id FROM Treatments GROUP BY professional_id HAVING COUNT(*) > 2)
SELECT name FROM Dogs WHERE NOT dog_id IN (SELECT dog_id FROM Treatments WHERE cost_of_treatment > 1000)
SELECT Dogs.name FROM Dogs WHERE NOT Dogs.dog_id IN (SELECT dog_id FROM Treatments GROUP BY dog_id HAVING SUM(cost_of_treatment) > 1000)
SELECT first_name FROM (SELECT DISTINCT first_name FROM Owners UNION SELECT DISTINCT first_name FROM Professionals) AS combined WHERE NOT first_name IN (SELECT DISTINCT name FROM Dogs)
SELECT 1
SELECT professional_id, role_code, email_address FROM Professionals WHERE NOT professional_id IN (SELECT professional_id FROM Treatments WHERE NOT professional_id IS NULL)
SELECT professional_id, role_code, email_address FROM Professionals WHERE NOT professional_id IN (SELECT professional_id FROM Treatments)
SELECT o.owner_id, o.first_name, o.last_name FROM Owners AS o JOIN Dogs AS d ON o.owner_id = d.owner_id GROUP BY o.owner_id ORDER BY COUNT(*) DESC LIMIT 1
SELECT Owners.owner_id, Owners.first_name, Owners.last_name FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id GROUP BY Owners.owner_id, Owners.first_name, Owners.last_name ORDER BY COUNT(Dogs.dog_id) DESC LIMIT 1
SELECT Professionals.professional_id, Professionals.role_code, Professionals.first_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id GROUP BY Professionals.professional_id, Professionals.role_code, Professionals.first_name HAVING COUNT(*) >= 2
SELECT P.professional_id, P.role_code, P.first_name FROM Professionals AS P JOIN Treatments AS T ON P.professional_id = T.professional_id GROUP BY P.professional_id, P.role_code, P.first_name HAVING COUNT(*) >= 2
SELECT b.breed_name FROM Breeds AS b JOIN Dogs AS d ON b.breed_code = d.breed_code GROUP BY d.breed_code ORDER BY COUNT(*) DESC LIMIT 1
SELECT b.breed_name FROM Breeds AS b JOIN Dogs AS d ON b.breed_code = d.breed_code GROUP BY b.breed_name ORDER BY COUNT(*) DESC LIMIT 1
SELECT o.owner_id, o.last_name FROM Owners AS o JOIN Dogs AS d ON o.owner_id = d.owner_id JOIN Treatments AS t ON d.dog_id = t.dog_id GROUP BY o.owner_id, o.last_name ORDER BY COUNT(*) DESC LIMIT 1
SELECT O.owner_id, O.last_name FROM Owners AS O JOIN Dogs AS D ON O.owner_id = D.owner_id JOIN Treatments AS T ON D.dog_id = T.dog_id GROUP BY O.owner_id ORDER BY SUM(T.cost_of_treatment) DESC LIMIT 1
SELECT treatment_type_description FROM Treatment_Types JOIN Treatments ON Treatment_Types.treatment_type_code = Treatments.treatment_type_code GROUP BY treatment_type_description ORDER BY SUM(cost_of_treatment) ASC LIMIT 1
SELECT Treatment_Types.treatment_type_description FROM Treatment_Types JOIN Treatments ON Treatments.treatment_type_code = Treatment_Types.treatment_type_code GROUP BY Treatments.treatment_type_code ORDER BY SUM(Treatments.cost_of_treatment) ASC LIMIT 1
SELECT O.owner_id, O.zip_code FROM Owners AS O JOIN Dogs AS D ON O.owner_id = D.owner_id JOIN Treatments AS T ON D.dog_id = T.dog_id GROUP BY O.owner_id, O.zip_code ORDER BY SUM(T.cost_of_treatment) DESC LIMIT 1
SELECT o.owner_id, o.zip_code FROM Owners AS o JOIN Dogs AS d ON o.owner_id = d.owner_id JOIN Charges AS c ON d.dog_id = c.charge_id GROUP BY o.owner_id, o.zip_code ORDER BY SUM(c.charge_amount) DESC LIMIT 1
SELECT Professionals.professional_id, Professionals.cell_number FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id GROUP BY Professionals.professional_id, Professionals.cell_number HAVING COUNT(DISTINCT Treatments.treatment_type_code) >= 2
SELECT Professionals.professional_id, Professionals.cell_number FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id GROUP BY Professionals.professional_id, Professionals.cell_number HAVING COUNT(DISTINCT Treatments.treatment_type_code) >= 2
SELECT Professionals.first_name, Professionals.last_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id WHERE Treatments.cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM Treatments)
SELECT DISTINCT Professionals.first_name, Professionals.last_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id WHERE Treatments.cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM Treatments)
SELECT Treatments.date_of_treatment, Professionals.first_name FROM Treatments JOIN Professionals ON Treatments.professional_id = Professionals.professional_id
SELECT Treatments.date_of_treatment, Professionals.first_name FROM Treatments JOIN Professionals ON Treatments.professional_id = Professionals.professional_id
SELECT Treatments.cost_of_treatment, Treatment_Types.treatment_type_description FROM Treatments JOIN Treatment_Types ON Treatments.treatment_type_code = Treatment_Types.treatment_type_code
SELECT Treatments.cost_of_treatment, Treatment_Types.treatment_type_description FROM Treatments JOIN Treatment_Types ON Treatments.treatment_type_code = Treatment_Types.treatment_type_code
SELECT Owners.first_name, Owners.last_name, Sizes.size_description FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id JOIN Sizes ON Dogs.size_code = Sizes.size_code
SELECT Owners.first_name, Owners.last_name, Sizes.size_description FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id JOIN Sizes ON Dogs.size_code = Sizes.size_code
SELECT Owners.first_name, Dogs.name FROM Dogs JOIN Owners ON Dogs.owner_id = Owners.owner_id
SELECT Owners.first_name, Dogs.name FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id
SELECT 1
SELECT Dogs.name, Treatments.date_of_treatment FROM Dogs INNER JOIN Breeds ON Dogs.breed_code = Breeds.breed_code INNER JOIN Treatments ON Treatments.dog_id = Dogs.dog_id WHERE Dogs.breed_code = (SELECT Breeds.breed_code FROM Dogs INNER JOIN Breeds ON Dogs.breed_code = Breeds.breed_code GROUP BY Dogs.breed_code ORDER BY COUNT(*) ASC LIMIT 1)
SELECT Owners.first_name, Dogs.name FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id WHERE Owners.state = 'Virginia'
SELECT Owners.first_name, Dogs.name FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id WHERE Owners.state = 'Virginia'
SELECT date_arrived, date_departed FROM Dogs WHERE dog_id IN (SELECT dog_id FROM Treatments)
SELECT date_arrived, date_departed FROM Dogs WHERE dog_id IN (SELECT dog_id FROM Treatments)
SELECT last_name FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id ORDER BY Dogs.age ASC LIMIT 1
SELECT Owners.last_name FROM Dogs JOIN Owners ON Dogs.owner_id = Owners.owner_id ORDER BY Dogs.age ASC LIMIT 1
SELECT email_address FROM Professionals WHERE state = 'Hawaii' OR state = 'Wisconsin'
SELECT email_address FROM Professionals WHERE state = 'Hawaii' OR state = 'Wisconsin'
SELECT date_arrived, date_departed FROM Dogs
SELECT date_arrived, date_departed FROM Dogs
SELECT COUNT(DISTINCT Treatments.dog_id) FROM Treatments
SELECT COUNT(*) FROM Treatments
SELECT COUNT(DISTINCT professional_id) AS count FROM Treatments JOIN Dogs ON Treatments.dog_id = Dogs.dog_id
SELECT COUNT(DISTINCT Professionals.professional_id) FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id
SELECT role_code, street, city, state FROM Professionals WHERE city LIKE '%West%'
SELECT role_code, street, city, state FROM Professionals WHERE city LIKE '%West%'
SELECT first_name, last_name, email_address FROM Owners WHERE state LIKE '%North%'
SELECT first_name, last_name, email_address FROM Owners WHERE state LIKE '%North%'
SELECT COUNT(*) AS count FROM Dogs WHERE age < (SELECT AVG(age) FROM Dogs)
SELECT COUNT(*) AS count FROM Dogs WHERE age < (SELECT AVG(age) FROM Dogs)
SELECT cost_of_treatment FROM Treatments ORDER BY date_of_treatment DESC LIMIT 1
SELECT cost_of_treatment FROM Treatments ORDER BY date_of_treatment DESC LIMIT 1
SELECT COUNT(*) AS count FROM Dogs WHERE NOT dog_id IN (SELECT dog_id FROM Treatments)
SELECT COUNT(*) AS number_of_dogs FROM Dogs WHERE NOT dog_id IN (SELECT dog_id FROM Treatments)
SELECT COUNT(*) FROM Owners WHERE NOT owner_id IN (SELECT owner_id FROM Dogs)
SELECT COUNT(owner_id) FROM Owners WHERE NOT owner_id IN (SELECT owner_id FROM Dogs)
SELECT COUNT(professional_id) FROM Professionals WHERE NOT professional_id IN (SELECT professional_id FROM Treatments WHERE NOT dog_id IS NULL)
SELECT COUNT(*) AS number_of_professionals FROM Professionals WHERE NOT professional_id IN (SELECT professional_id FROM Treatments)
SELECT name, age, weight FROM Dogs WHERE abandoned_yn = '1'
SELECT name, age, weight FROM Dogs WHERE abandoned_yn = '1'
SELECT AVG(age) AS average_age FROM Dogs
SELECT AVG(age) AS average_age FROM Dogs
SELECT MAX(age) AS age FROM Dogs
SELECT MAX(age) FROM Dogs
SELECT charge_type, charge_amount FROM Charges
SELECT charge_type, charge_amount FROM Charges
SELECT MAX(charge_amount) FROM Charges ORDER BY charge_amount DESC
SELECT MAX(charge_amount) FROM Charges ORDER BY charge_amount DESC
SELECT email_address, cell_number, home_phone FROM Professionals
SELECT email_address, cell_number, home_phone FROM Professionals
SELECT Breeds.breed_name, Sizes.size_description FROM Dogs JOIN Breeds ON Dogs.breed_code = Breeds.breed_code JOIN Sizes ON Dogs.size_code = Sizes.size_code
SELECT Breeds.breed_name, Sizes.size_description FROM Dogs JOIN Breeds ON Dogs.breed_code = Breeds.breed_code JOIN Sizes ON Dogs.size_code = Sizes.size_code GROUP BY Breeds.breed_name, Sizes.size_description
SELECT Professionals.first_name, Treatment_Types.treatment_type_description FROM Treatments JOIN Professionals ON Treatments.professional_id = Professionals.professional_id JOIN Treatment_Types ON Treatments.treatment_type_code = Treatment_Types.treatment_type_code
SELECT Professionals.first_name, Treatment_Types.treatment_type_description FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id JOIN Treatment_Types ON Treatments.treatment_type_code = Treatment_Types.treatment_type_code
