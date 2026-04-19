select T1.state from Owners as T1 intersect select T1.state from Professionals as T1	dog_kennels
select state from Owners intersect select state from Professionals	dog_kennels
select avg(T1.age) from Dogs as T1 inner join Treatments as T2 on T1.dog_id = T2.dog_id	dog_kennels
select avg(T1.age) from Dogs as T1 inner join Treatments as T2 on T1.dog_id = T2.dog_id	dog_kennels
select professional_id, last_name, cell_number from Professionals where state = "in" union select T1.professional_id, T1.last_name, T1.cell_number from Professionals as T1 join Treatments as T2 on T1.professional_id = T2.professional_id group by T1.professional_id having count(T2.treatment_id) > 2	dog_kennels
select professional_id, last_name, cell_number from Professionals where state = "in" union select T1.professional_id, T1.last_name, T1.cell_number from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id group by T1.professional_id having count(T2.treatment_id) > 2	dog_kennels
select T1.name from Dogs as T1 join Treatments as T2 on T1.dog_id = T2.dog_id group by T1.dog_id having sum(T2.cost_of_treatment) <= 1000	dog_kennels
select T1.name from Dogs as T1 inner join Treatments as T2 on T1.dog_id = T2.dog_id group by T1.dog_id having sum(T2.cost_of_treatment) <= 1000	dog_kennels
select first_name from Professionals union select first_name from Owners except select name from Dogs	dog_kennels
select first_name from Professionals union select first_name from Owners except select name from Dogs	dog_kennels
select professional_id, role_code, email_address from Professionals where professional_id not in (select professional_id from Treatments)	dog_kennels
select professional_id, role_code, email_address from Professionals where professional_id not in (select professional_id from Treatments)	dog_kennels
select T1.owner_id, T1.first_name, T1.last_name from Owners as T1 join Dogs as T2 on T1.owner_id = T2.owner_id group by T1.owner_id order by count(T2.dog_id) desc limit 1	dog_kennels
select T1.owner_id, T1.first_name, T1.last_name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id group by T1.owner_id order by count(T2.dog_id) desc limit 1	dog_kennels
select T1.professional_id, T1.role_code, T1.first_name from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id group by T1.professional_id, T1.role_code, T1.first_name having count(T2.treatment_id) >= 2	dog_kennels
select T1.professional_id, T1.role_code, T1.first_name from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id group by T1.professional_id having count(T2.treatment_id) >= 2	dog_kennels
select T1.breed_name from Breeds as T1 join Dogs as T2 on T1.breed_code = T2.breed_code group by T1.breed_name order by count(T2.dog_id) desc limit 1	dog_kennels
select T1.breed_name from Breeds as T1 inner join Dogs as T2 on T1.breed_code = T2.breed_code group by T1.breed_name order by count(T2.dog_id) desc limit 1	dog_kennels
select T1.owner_id, T1.last_name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id inner join Treatments as T3 on T2.dog_id = T3.dog_id group by T1.owner_id, T1.last_name order by count(T3.treatment_id) desc limit 1	dog_kennels
select T1.owner_id, T1.last_name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id inner join Treatments as T3 on T2.dog_id = T3.dog_id group by T1.owner_id order by sum(T3.cost_of_treatment) desc limit 1	dog_kennels
select T2.treatment_type_description from Treatments as T1 inner join Treatment_Types as T2 on T1.treatment_type_code = T2.treatment_type_code group by T1.treatment_type_code order by sum(T1.cost_of_treatment) asc limit 1	dog_kennels
select T2.treatment_type_description from Treatments as T1 join Treatment_Types as T2 on T1.treatment_type_code = T2.treatment_type_code group by T2.treatment_type_description order by sum(T1.cost_of_treatment) asc limit 1	dog_kennels
select T1.owner_id, T1.zip_code from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id inner join Treatments as T3 on T2.dog_id = T3.dog_id group by T1.owner_id order by sum(T3.cost_of_treatment) desc limit 1	dog_kennels
select T1.owner_id, T1.zip_code from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id inner join Treatments as T3 on T2.dog_id = T3.dog_id group by T1.owner_id order by sum(T3.cost_of_treatment) desc limit 1	dog_kennels
select T1.professional_id, T1.cell_number from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id group by T1.professional_id having count(distinct T2.treatment_type_code) >= 2	dog_kennels
select T1.professional_id, T1.cell_number from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id group by T1.professional_id, T1.cell_number having count(distinct T2.treatment_type_code) >= 2	dog_kennels
select T1.first_name, T1.last_name from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id where T2.cost_of_treatment < (select avg(cost_of_treatment) from Treatments) group by T1.professional_id	dog_kennels
select T1.first_name, T1.last_name from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id where T2.cost_of_treatment < ( select avg(cost_of_treatment) from Treatments )	dog_kennels
select T1.date_of_treatment, T2.first_name from Treatments as T1 inner join Professionals as T2 on T1.professional_id = T2.professional_id	dog_kennels
select T1.date_of_treatment, T2.first_name from Treatments as T1 inner join Professionals as T2 on T1.professional_id = T2.professional_id	dog_kennels
select T1.cost_of_treatment, T2.treatment_type_description from Treatments as T1 inner join Treatment_Types as T2 on T1.treatment_type_code = T2.treatment_type_code	dog_kennels
select T1.cost_of_treatment, T2.treatment_type_description from Treatments as T1 inner join Treatment_Types as T2 on T1.treatment_type_code = T2.treatment_type_code	dog_kennels
select T1.first_name, T1.last_name, T3.size_description from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id inner join Sizes as T3 on T2.size_code = T3.size_code	dog_kennels
select T1.first_name, T1.last_name, T3.size_description from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id inner join Sizes as T3 on T2.size_code = T3.size_code	dog_kennels
select T1.first_name, T2.name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id	dog_kennels
select T1.first_name, T2.name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id	dog_kennels
ite select T1.name, T2.date_of_treatment from Dogs as T1 inner join Treatments as T2 on T1.dog_id = T2.dog_id where T1.breed_code = ( select breed_code from Dogs group by breed_code order by count(breed_code) asc limit 1 )	dog_kennels
select T1.name, T2.date_of_treatment from Dogs as T1 inner join Treatments as T2 on T1.dog_id = T2.dog_id where T1.breed_code in ( select breed_code from Dogs group by breed_code having count(dog_id) = ( select min(count_per_breed) from ( select count(dog_id) from Dogs group by breed_code ) ) )	dog_kennels
select T1.first_name, T2.name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id where T1.state = "VA"	dog_kennels
select T1.first_name, T2.name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id where T1.state = "VA"	dog_kennels
select distinct T1.date_arrived, T1.date_departed from Dogs as T1 inner join Treatments as T2 on T1.dog_id = T2.dog_id	dog_kennels
select T1.date_arrived, T1.date_departed from Dogs as T1 inner join Treatments as T2 on T1.dog_id = T2.dog_id	dog_kennels
select T1.last_name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id order by T2.date_of_birth desc limit 1	dog_kennels
select T1.last_name from Owners as T1 inner join Dogs as T2 on T1.owner_id = T2.owner_id order by T2.date_of_birth desc limit 1	dog_kennels
select email_address from Professionals where state = "Hawaii" or state = "Wisconsin"	dog_kennels
select email_address from Professionals where state = "HI" or state = "WI"	dog_kennels
select date_arrived, date_departed from Dogs	dog_kennels
select date_arrived, date_departed from Dogs	dog_kennels
select count(distinct dog_id) from Treatments	dog_kennels
select count(distinct dog_id) from Treatments	dog_kennels
select count(distinct professional_id) from Treatments	dog_kennels
select count(distinct professional_id) from Treatments	dog_kennels
select role_code, street, city, state from Professionals where city like "%West%"	dog_kennels
select role_code, street, city, state from Professionals where city like "%West%"	dog_kennels
select first_name, last_name, email_address from Owners where state like "%North%"	dog_kennels
select first_name, last_name, email_address from Owners where state like "%North%"	dog_kennels
select count(dog_id) from Dogs where age < (select avg(age) from Dogs)	dog_kennels
select count(dog_id) from Dogs where age < (select avg(age) from Dogs)	dog_kennels
select cost_of_treatment from Treatments order by date_of_treatment desc limit 1	dog_kennels
select cost_of_treatment from Treatments order by date_of_treatment desc limit 1	dog_kennels
select count(dog_id) from Dogs where dog_id not in (select dog_id from Treatments)	dog_kennels
select count(dog_id) from Dogs where dog_id not in (select dog_id from Treatments)	dog_kennels
select count(T1.owner_id) from Owners as T1 where T1.owner_id not in ( select T2.owner_id from Dogs as T2 where T2.date_adopted is null and T2.date_departed is null )	dog_kennels
select count(T1.owner_id) from Owners as T1 where T1.owner_id not in ( select T2.owner_id from Dogs as T2 where T2.date_adopted is null and T2.date_departed is null )	dog_kennels
select count(professional_id) from Professionals where professional_id not in (select professional_id from Treatments)	dog_kennels
select count(professional_id) from Professionals where professional_id not in (select professional_id from Treatments)	dog_kennels
select name, age, weight from Dogs where abandoned_yn = "1"	dog_kennels
select name, age, weight from Dogs where abandoned_yn = "1"	dog_kennels
select avg(age) from Dogs	dog_kennels
select avg(age) from Dogs	dog_kennels
select max(age) from Dogs	dog_kennels
select max(age) from Dogs	dog_kennels
select charge_type, charge_amount from Charges	dog_kennels
select charge_type, charge_amount from Charges	dog_kennels
select max(charge_amount) from Charges	dog_kennels
select max(charge_amount) from Charges	dog_kennels
select email_address, cell_number, home_phone from Professionals	dog_kennels
select email_address, cell_number, home_phone from Professionals	dog_kennels
select T1.breed_name, T2.size_description from Breeds as T1 CROSS join Sizes as T2	dog_kennels
select distinct T1.breed_name, T2.size_description from Breeds as T1 inner join Sizes as T2 inner join Dogs as T3 on T1.breed_code = T3.breed_code and T2.size_code = T3.size_code	dog_kennels
select T1.first_name, T3.treatment_type_description from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id inner join Treatment_Types as T3 on T2.treatment_type_code = T3.treatment_type_code	dog_kennels
select T1.first_name, T3.treatment_type_description from Professionals as T1 inner join Treatments as T2 on T1.professional_id = T2.professional_id inner join Treatment_Types as T3 on T2.treatment_type_code = T3.treatment_type_code	dog_kennels
