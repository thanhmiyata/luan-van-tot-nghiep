select state from Owners intersect select state from Professionals	dog_kennels
select distinct state from Owners intersect select distinct state from Professionals	dog_kennels
SELECT AVG(Dogs.age) FROM Dogs INNER JOIN Treatments ON Dogs.dog_id = Treatments.dog_id	dog_kennels
select avg(T1.age) from Dogs as T1 where T1.dog_id in (select T2.dog_id from Treatments as T2)	dog_kennels
select T1.professional_id, T1.last_name, T1.cell_number from Professionals as T1 where T1.state = "Indiana" or (select count(*) from Treatments as T2 where T2.professional_id = T1.professional_id) > 2	dog_kennels
select P.professional_id, P.last_name, P.cell_number from Professionals as P left join Treatments as T on P.professional_id = T.professional_id group by P.professional_id, P.last_name, P.cell_number having count(T.treatment_id) > 2 or max(P.state = "Indiana") = 1	dog_kennels
select name from Dogs where dog_id not in (select dog_id from Treatments group by dog_id having sum(cost_of_treatment) > 1000)	dog_kennels
SELECT Dogs.name FROM Dogs WHERE NOT Dogs.dog_id IN (SELECT dog_id FROM Treatments GROUP BY dog_id HAVING SUM(cost_of_treatment) > 1000)	dog_kennels
SELECT first_name FROM (SELECT first_name FROM Owners UNION SELECT first_name FROM Professionals) AS combined WHERE NOT first_name IN (SELECT name FROM Dogs)	dog_kennels
select first_name from Owners except select name from Dogs union select first_name from Professionals except select name from Dogs	dog_kennels
select professional_id, role_code, email_address from Professionals where professional_id not in (select professional_id from Treatments)	dog_kennels
select professional_id, role_code, email_address from Professionals where professional_id not in (select professional_id from Treatments)	dog_kennels
select Owners.owner_id, Owners.first_name, Owners.last_name from Owners join Dogs on Owners.owner_id = Dogs.owner_id group by Owners.owner_id order by count(*) desc limit 1	dog_kennels
SELECT T1.owner_id ,  T2.first_name ,  T2.last_name FROM Dogs AS T1 JOIN Owners AS T2 ON T1.owner_id  =  T2.owner_id GROUP BY T1.owner_id ORDER BY count(*) DESC LIMIT 1	dog_kennels
select Professionals.professional_id, Professionals.role_code, Professionals.first_name from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id group by Professionals.professional_id having count(*) >= 2	dog_kennels
select Professionals.professional_id , Professionals.role_code, Professionals.first_name from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id group by Professionals.professional_id having count(*) >= 2	dog_kennels
SELECT T1.breed_name FROM Breeds AS T1 JOIN Dogs AS T2 ON T1.breed_code  =  T2.breed_code GROUP BY T1.breed_name ORDER BY count(*) DESC LIMIT 1	dog_kennels
SELECT T1.breed_name FROM Breeds AS T1 JOIN Dogs AS T2 ON T1.breed_code  =  T2.breed_code GROUP BY T1.breed_name ORDER BY count(*) DESC LIMIT 1	dog_kennels
SELECT o.owner_id, o.last_name FROM Owners AS o JOIN Dogs AS d ON o.owner_id = d.owner_id JOIN Treatments AS t ON d.dog_id = t.dog_id GROUP BY o.owner_id, o.last_name ORDER BY COUNT(*) DESC LIMIT 1	dog_kennels
SELECT O.owner_id, O.last_name FROM Owners AS O JOIN Dogs AS D ON O.owner_id = D.owner_id JOIN Treatments AS T ON D.dog_id = T.dog_id GROUP BY O.owner_id, O.last_name ORDER BY SUM(T.cost_of_treatment) DESC LIMIT 1	dog_kennels
SELECT T1.treatment_type_description FROM Treatment_types AS T1 JOIN Treatments AS T2 ON T1.treatment_type_code  =  T2.treatment_type_code GROUP BY T1.treatment_type_code ORDER BY sum(cost_of_treatment) ASC LIMIT 1	dog_kennels
select T1.treatment_type_description from Treatment_Types as T1 join Treatments as T2 on T1.treatment_type_code = T2.treatment_type_code group by T1.treatment_type_code order by sum(T2.cost_of_treatment) asc limit 1	dog_kennels
SELECT Owners.owner_id, Owners.zip_code FROM Owners JOIN Dogs ON Dogs.owner_id = Owners.owner_id JOIN Charges ON Charges.charge_id = Dogs.dog_id GROUP BY Owners.owner_id, Owners.zip_code ORDER BY SUM(Charges.charge_amount) DESC LIMIT 1	dog_kennels
SELECT T1.owner_id ,  T1.zip_code FROM Owners AS T1 JOIN Dogs AS T2 ON T1.owner_id  =  T2.owner_id JOIN Treatments AS T3 ON T2.dog_id  =  T3.dog_id GROUP BY T1.owner_id ORDER BY sum(T3.cost_of_treatment) DESC LIMIT 1	dog_kennels
select Professionals.professional_id, Professionals.cell_number from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id group by Professionals.professional_id, Professionals.cell_number having count(distinct Treatments.treatment_type_code) >= 2	dog_kennels
select Professionals.professional_id, Professionals.cell_number from Professionals join Treatments on Treatments.professional_id = Professionals.professional_id join Treatment_Types on Treatments.treatment_type_code = Treatment_Types.treatment_type_code group by Professionals.professional_id, Professionals.cell_number having count(distinct Treatment_Types.treatment_type_code) >= 2	dog_kennels
SELECT Professionals.first_name, Professionals.last_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id WHERE Treatments.cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM Treatments)	dog_kennels
SELECT Professionals.first_name, Professionals.last_name FROM Professionals JOIN Treatments ON Professionals.professional_id = Treatments.professional_id WHERE Treatments.cost_of_treatment < (SELECT AVG(cost_of_treatment) FROM Treatments)	dog_kennels
select T1.date_of_treatment, T2.first_name from Treatments as T1 join Professionals as T2 on T1.professional_id = T2.professional_id	dog_kennels
select Treatments.date_of_treatment, Professionals.first_name from Treatments join Professionals on Treatments.professional_id = Professionals.professional_id	dog_kennels
select Treatments.cost_of_treatment, Treatment_Types.treatment_type_description from Treatments join Treatment_Types on Treatments.treatment_type_code = Treatment_Types.treatment_type_code	dog_kennels
select Treatments.cost_of_treatment, Treatment_Types.treatment_type_description from Treatments join Treatment_Types on Treatments.treatment_type_code = Treatment_Types.treatment_type_code	dog_kennels
SELECT Owners.first_name, Owners.last_name, Sizes.size_description FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id JOIN Sizes ON Dogs.size_code = Sizes.size_code	dog_kennels
SELECT Owners.first_name, Owners.last_name, Sizes.size_description FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id JOIN Sizes ON Dogs.size_code = Sizes.size_code	dog_kennels
select T1.first_name, T2.name from Owners as T1 join Dogs as T2 on T1.owner_id = T2.owner_id	dog_kennels
select Owners.first_name, Dogs.name from Owners join Dogs on Owners.owner_id = Dogs.owner_id	dog_kennels
select Dogs.name, Treatments.date_of_treatment from Dogs join Treatments on Dogs.dog_id = Treatments.dog_id where Dogs.breed_code = (select breed_code from (select breed_code, count(*) from Dogs group by breed_code order by breed_count asc limit 1)) order by Treatments.date_of_treatment asc	dog_kennels
select Dogs.name, Treatments.date_of_treatment from Dogs join Treatments on Dogs.dog_id = Treatments.dog_id where Dogs.breed_code = (select Breeds.breed_code from Breeds left join Dogs on Dogs.breed_code = Breeds.breed_code group by Breeds.breed_code order by count(Dogs.dog_id) asc limit 1)	dog_kennels
select T1.first_name, T2.name from Owners as T1 join Dogs as T2 on T1.owner_id = T2.owner_id where T1.state = "Virginia"	dog_kennels
select Owners.first_name, Dogs.name from Owners join Dogs on Owners.owner_id = Dogs.owner_id where Owners.state = "Virginia"	dog_kennels
select Dogs.date_arrived, Dogs.date_departed from Dogs join Treatments on Dogs.dog_id = Treatments.dog_id	dog_kennels
select T1.date_arrived, T1.date_departed from Dogs as T1 join Treatments as T2 on T1.dog_id = T2.dog_id	dog_kennels
SELECT last_name FROM Owners JOIN Dogs ON Owners.owner_id = Dogs.owner_id ORDER BY Dogs.age ASC LIMIT 1	dog_kennels
SELECT Owners.last_name FROM Dogs JOIN Owners ON Dogs.owner_id = Owners.owner_id ORDER BY Dogs.age ASC LIMIT 1	dog_kennels
SELECT email_address FROM Professionals WHERE state  =  'Hawaii' OR state  =  'Wisconsin'	dog_kennels
SELECT email_address FROM Professionals WHERE state  =  'Hawaii' OR state  =  'Wisconsin'	dog_kennels
select date_arrived, date_departed from Dogs	dog_kennels
select date_arrived, date_departed from Dogs	dog_kennels
SELECT count(DISTINCT dog_id) FROM Treatments	dog_kennels
select count(distinct Dogs.dog_id) from Dogs join Treatments on Dogs.dog_id = Treatments.dog_id	dog_kennels
select count(distinct T2.professional_id) from Treatments as T1 join Professionals as T2 on T1.professional_id = T2.professional_id where T1.dog_id is not null	dog_kennels
select count(distinct T1.professional_id) from Professionals as T1 join Treatments as T2 on T1.professional_id = T2.professional_id join Dogs as T3 on T2.dog_id = T3.dog_id	dog_kennels
select role_code, street, city, state from Professionals where city like "%West%"	dog_kennels
select role_code, street, city, state from Professionals where city like "%West%"	dog_kennels
select first_name, last_name, email_address from Owners where state like "%North%"	dog_kennels
select first_name, last_name, email_address from Owners where state like "%North%"	dog_kennels
select count(*) from Dogs where age < (select avg(age) from Dogs)	dog_kennels
select count(*) from Dogs where age < (select avg(age) from Dogs)	dog_kennels
select cost_of_treatment from Treatments order by date_of_treatment desc limit 1	dog_kennels
select cost_of_treatment from Treatments order by date_of_treatment desc limit 1	dog_kennels
select count(*) from Dogs where dog_id not in (select dog_id from Treatments)	dog_kennels
select count(*) from Dogs where dog_id not in (select dog_id from Treatments)	dog_kennels
select count(*) from Owners where owner_id not in (select owner_id from Dogs)	dog_kennels
select count(*) from Owners where not EXISTS (select 1 from Dogs where Dogs.owner_id = Owners.owner_id)	dog_kennels
SELECT count(*) FROM Professionals WHERE professional_id NOT IN ( SELECT professional_id FROM Treatments )	dog_kennels
select count(*) from Professionals where professional_id not in (select professional_id from Treatments)	dog_kennels
select name, age, weight from Dogs where abandoned_yn = 1	dog_kennels
select name, age, weight from Dogs where abandoned_yn = "1"	dog_kennels
select avg(age) from Dogs	dog_kennels
select avg(age) from Dogs	dog_kennels
select max(age) from Dogs	dog_kennels
select max(age) from Dogs	dog_kennels
select charge_type, charge_amount from Charges	dog_kennels
select charge_type, charge_amount from Charges	dog_kennels
select charge_amount from Charges order by charge_amount desc limit 1	dog_kennels
select charge_amount from Charges order by charge_amount desc limit 1	dog_kennels
select email_address, cell_number, home_phone from Professionals	dog_kennels
select email_address, cell_number, home_phone from Professionals	dog_kennels
SELECT Breeds.breed_name, Sizes.size_description FROM Dogs JOIN Breeds ON Dogs.breed_code = Breeds.breed_code JOIN Sizes ON Dogs.size_code = Sizes.size_code	dog_kennels
SELECT Breeds.breed_name, Sizes.size_description FROM Dogs JOIN Breeds ON Dogs.breed_code = Breeds.breed_code JOIN Sizes ON Dogs.size_code = Sizes.size_code GROUP BY Breeds.breed_name, Sizes.size_description	dog_kennels
select Professionals.first_name, Treatment_Types.treatment_type_description from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id join Treatment_Types on Treatments.treatment_type_code = Treatment_Types.treatment_type_code	dog_kennels
select Professionals.first_name, Treatment_Types.treatment_type_description from Treatments join Professionals on Treatments.professional_id = Professionals.professional_id join Treatment_Types on Treatments.treatment_type_code = Treatment_Types.treatment_type_code	dog_kennels
