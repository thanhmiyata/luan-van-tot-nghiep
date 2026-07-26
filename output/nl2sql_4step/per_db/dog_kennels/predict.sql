select state from Owners intersect select state from Professionals	dog_kennels
select state from Owners intersect select state from Professionals	dog_kennels
select avg(Dogs.age) from Dogs join Treatments on Dogs.dog_id = Treatments.dog_id	dog_kennels
select T1.age from Dogs as T1 where T1.dog_id in (select T2.dog_id from Treatments as T2)	dog_kennels
select P.professional_id, P.last_name, P.cell_number from Professionals as P where P.state = "Indiana" or (select count(*) from Treatments where professional_id = P.professional_id) > 2	dog_kennels
select professional_id, last_name, cell_number from Professionals where state = "Indiana" or professional_id in (select professional_id from Treatments group by professional_id having count(*) > 2)	dog_kennels
select name from Dogs where dog_id not in (select dog_id from Treatments where cost_of_treatment > 1000)	dog_kennels
select T1.name from Dogs as T1 where T1.dog_id not in (select T2.dog_id from Treatments as T2 group by T2.dog_id having sum(T2.cost_of_treatment) > 1000)	dog_kennels
select first_name from (select first_name from Owners union select first_name from Professionals) where first_name not in (select name from Dogs)	dog_kennels
(select first_name from Owners) union (select first_name from Professionals) except (select name from Dogs)	dog_kennels
select professional_id, role_code, email_address from Professionals where professional_id not in (select professional_id from Treatments)	dog_kennels
select professional_id, role_code, email_address from Professionals where professional_id not in (select professional_id from Treatments)	dog_kennels
select o.owner_id, o.first_name, o.last_name from Owners as o join Dogs as d on o.owner_id = d.owner_id group by o.owner_id order by count(*) desc limit 1	dog_kennels
select T1.owner_id, T1.first_name, T1.last_name from Owners as T1 join Dogs as T2 on T1.owner_id = T2.owner_id group by T1.owner_id, T1.first_name, T1.last_name order by count(T2.dog_id) desc limit 1	dog_kennels
select T1.professional_id, T1.role_code, T1.first_name from Professionals as T1 join Treatments as T2 on T1.professional_id = T2.professional_id group by T1.professional_id, T1.role_code, T1.first_name having count(*) >= 2	dog_kennels
select P.professional_id, P.role_code, P.first_name from Professionals as P join Treatments as T on P.professional_id = T.professional_id group by P.professional_id having count(*) >= 2	dog_kennels
select b.breed_name from Breeds b join Dogs d on b.breed_code = d.breed_code group by b.breed_name order by count(*) desc limit 1	dog_kennels
select b.breed_name from Breeds b join Dogs d on b.breed_code = d.breed_code group by b.breed_name order by count(*) desc limit 1	dog_kennels
select T1.owner_id, T1.last_name from Owners as T1 join Dogs as T2 on T1.owner_id = T2.owner_id join Treatments as T3 on T2.dog_id = T3.dog_id group by T1.owner_id, T1.last_name order by count(*) desc limit 1	dog_kennels
select O.owner_id, O.last_name from Owners as O join Dogs as D on O.owner_id = D.owner_id join Treatments as T on D.dog_id = T.dog_id group by O.owner_id, O.last_name order by sum(T.cost_of_treatment) desc limit 1	dog_kennels
select T1.treatment_type_description from Treatment_Types as T1 join Treatments as T2 on T1.treatment_type_code = T2.treatment_type_code group by T1.treatment_type_description order by sum(T2.cost_of_treatment) asc limit 1	dog_kennels
select T1.treatment_type_description from Treatment_Types as T1 join Treatments as T2 on T1.treatment_type_code = T2.treatment_type_code group by T1.treatment_type_code, T1.treatment_type_description order by sum(T2.cost_of_treatment) asc limit 1	dog_kennels
select O.owner_id, O.zip_code from Owners as O join Dogs as D on O.owner_id = D.owner_id join Treatments as T on D.dog_id = T.dog_id group by O.owner_id, O.zip_code order by sum(T.cost_of_treatment) desc limit 1	dog_kennels
select T1.owner_id, T1.zip_code from Owners as T1 join Dogs as T2 on T1.owner_id = T2.owner_id join Treatments as T3 on T2.dog_id = T3.dog_id group by T1.owner_id, T1.zip_code order by sum(T3.cost_of_treatment) desc limit 1	dog_kennels
select Professionals.professional_id, Professionals.cell_number from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id group by Professionals.professional_id, Professionals.cell_number having count(distinct Treatments.treatment_type_code) >= 2	dog_kennels
select Professionals.professional_id, Professionals.cell_number from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id group by Professionals.professional_id, Professionals.cell_number having count(distinct Treatments.treatment_type_code) >= 2	dog_kennels
select distinct T1.first_name, T1.last_name from Professionals as T1 join Treatments as T2 on T1.professional_id = T2.professional_id where T2.cost_of_treatment < (select avg(cost_of_treatment) from Treatments)	dog_kennels
select Professionals.first_name, Professionals.last_name from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id where Treatments.cost_of_treatment < (select avg(cost_of_treatment) from Treatments)	dog_kennels
select T1.date_of_treatment, T2.first_name from Treatments as T1 join Professionals as T2 on T1.professional_id = T2.professional_id	dog_kennels
select Treatments.date_of_treatment, Professionals.first_name from Treatments join Professionals on Treatments.professional_id = Professionals.professional_id	dog_kennels
select Treatments.cost_of_treatment, Treatment_Types.treatment_type_description from Treatments join Treatment_Types on Treatments.treatment_type_code = Treatment_Types.treatment_type_code	dog_kennels
select T1.cost_of_treatment, T2.treatment_type_description from Treatments as T1 join Treatment_Types as T2 on T1.treatment_type_code = T2.treatment_type_code	dog_kennels
select Owners.first_name, Owners.last_name, Sizes.size_description from Owners join Dogs on Owners.owner_id = Dogs.owner_id join Sizes on Dogs.size_code = Sizes.size_code	dog_kennels
select T1.first_name, T1.last_name, T3.size_description from Owners as T1 join Dogs as T2 on T1.owner_id = T2.owner_id join Sizes as T3 on T2.size_code = T3.size_code	dog_kennels
select T1.first_name, T2.name from Owners as T1 join Dogs as T2 on T1.owner_id = T2.owner_id	dog_kennels
select T1.first_name, T2.name from Owners as T1 join Dogs as T2 on T1.owner_id = T2.owner_id	dog_kennels
select T1.name, T2.date_of_treatment from Dogs as T1 join Treatments as T2 on T1.dog_id = T2.dog_id where T1.breed_code = (select T1_sub.breed_code from Breeds as T1_sub join Dogs as T2_sub on T1_sub.breed_code = T2_sub.breed_code group by T1_sub.breed_code order by count(T2_sub.dog_id) asc limit 1)	dog_kennels
select T1.name, T3.date_of_treatment from Dogs as T1 join Breeds as T2 on T1.breed_code = T2.breed_code join Treatments as T3 on T1.dog_id = T3.dog_id where T2.breed_code = (select T2.breed_code from Breeds as T2 left join Dogs as T1 on T2.breed_code = T1.breed_code group by T2.breed_code order by count(T1.dog_id) asc limit 1)	dog_kennels
select T1.first_name, T2.name from Owners as T1 join Dogs as T2 on T1.owner_id = T2.owner_id where T1.state = "Virginia"	dog_kennels
select T1.first_name, T2.name from Owners as T1 join Dogs as T2 on T1.owner_id = T2.owner_id where T1.state = "Virginia"	dog_kennels
select date_arrived, date_departed from Dogs where dog_id in (select dog_id from Treatments)	dog_kennels
select date_arrived, date_departed from Dogs where dog_id in (select dog_id from Treatments)	dog_kennels
select T1.last_name from Owners as T1 join Dogs as T2 on T1.owner_id = T2.owner_id order by T2.age asc limit 1	dog_kennels
select T1.last_name from Owners as T1 join Dogs as T2 on T1.owner_id = T2.owner_id order by CAST(T2.age as INTEGER) asc limit 1	dog_kennels
select email_address from Professionals where state = "Hawaii" or state = "Wisconsin"	dog_kennels
select email_address from Professionals where state = "Hawaii" or state = "Wisconsin"	dog_kennels
select date_arrived, date_departed from Dogs	dog_kennels
select date_arrived, date_departed from Dogs	dog_kennels
select count(distinct Treatments.dog_id) from Treatments	dog_kennels
select count(distinct dog_id) from Treatments	dog_kennels
select count(distinct professional_id) from Treatments	dog_kennels
select count(distinct T1.professional_id) from Professionals as T1 join Treatments as T2 on T1.professional_id = T2.professional_id	dog_kennels
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
select count(owner_id) from Owners where owner_id not in (select owner_id from Dogs)	dog_kennels
select count(professional_id) from Professionals where professional_id not in (select professional_id from Treatments where dog_id is not null)	dog_kennels
select count(*) from Professionals where professional_id not in (select professional_id from Treatments)	dog_kennels
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
select distinct T1.breed_name, T2.size_description from Breeds as T1 join Dogs as T3 on T1.breed_code = T3.breed_code join Sizes as T2 on T3.size_code = T2.size_code	dog_kennels
select Professionals.first_name, Treatment_Types.treatment_type_description from Treatments join Professionals on Treatments.professional_id = Professionals.professional_id join Treatment_Types on Treatments.treatment_type_code = Treatment_Types.treatment_type_code	dog_kennels
select Professionals.first_name, Treatment_Types.treatment_type_description from Professionals join Treatments on Professionals.professional_id = Treatments.professional_id join Treatment_Types on Treatments.treatment_type_code = Treatment_Types.treatment_type_code	dog_kennels
