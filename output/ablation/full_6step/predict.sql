SELECT COUNT(*) AS count FROM poker_player;	poker_player
SELECT Abbreviation FROM airlines WHERE Airline = 'JetBlue Airways';	flight_2
SELECT COUNT(DISTINCT PetType) AS count_distinct_pet_types FROM Pets;	pets_1
SELECT AVG(LifeExpectancy) AS average_life_expectancy FROM country WHERE Region = 'Central Africa';	world_1
SELECT DISTINCT Template_Type_Code AS template_type_code FROM Templates;	cre_Doc_Template_Mgt
SELECT COUNT(*) AS document_count FROM Documents;	cre_Doc_Template_Mgt
SELECT SUM(Bonus) AS total_bonus FROM evaluation;	employee_hire_evaluation
SELECT COUNT(*) AS count_flights FROM flights;	flight_2
SELECT Continent AS continent_name FROM country WHERE Name = 'Anguilla';	world_1
SELECT Country FROM airlines WHERE Airline = 'JetBlue Airways';	flight_2
