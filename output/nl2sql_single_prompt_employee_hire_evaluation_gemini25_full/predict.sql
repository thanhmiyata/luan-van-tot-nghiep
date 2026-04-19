select count(*) from employee	employee_hire_evaluation
select count(*) from employee	employee_hire_evaluation
select Name from employee order by Age asc	employee_hire_evaluation
select Name from employee order by Age asc	employee_hire_evaluation
select count(*) , City from employee group by City	employee_hire_evaluation
select count(*) , City from employee group by City	employee_hire_evaluation
select City from employee where Age < 30 group by City having count(Employee_ID) > 1	employee_hire_evaluation
select City from employee where Age < 30 group by City having count(Employee_ID) > 1	employee_hire_evaluation
select count(*) , Location from shop group by Location	employee_hire_evaluation
select count(*) , Location from shop group by Location	employee_hire_evaluation
select Manager_name , District from shop order by Number_products desc limit 1	employee_hire_evaluation
select Manager_name , District from shop order by Number_products desc limit 1	employee_hire_evaluation
select min(Number_products), max(Number_products) from shop	employee_hire_evaluation
select min(Number_products), max(Number_products) from shop	employee_hire_evaluation
select Name, Location, District from shop order by Number_products desc	employee_hire_evaluation
select Name, Location, District from shop order by Number_products desc	employee_hire_evaluation
select Name from shop where Number_products > (select avg(Number_products) from shop)	employee_hire_evaluation
select Name from shop where Number_products > (select avg(Number_products) from shop)	employee_hire_evaluation
select T1.Name from employee as T1 join evaluation as T2 on T1.Employee_ID = T2.Employee_ID group by T1.Employee_ID order by count(T2.Employee_ID) desc limit 1	employee_hire_evaluation
select T1.Name from employee as T1 join evaluation as T2 on T1.Employee_ID = T2.Employee_ID group by T1.Employee_ID order by count(T2.Year_awarded) desc limit 1	employee_hire_evaluation
select T1.Name from employee as T1 inner join evaluation as T2 on T1.Employee_ID = T2.Employee_ID order by T2.Bonus desc limit 1	employee_hire_evaluation
select T1.Name from employee as T1 inner join evaluation as T2 on T1.Employee_ID = T2.Employee_ID order by T2.Bonus desc limit 1	employee_hire_evaluation
select Name from employee where Employee_ID not in ( select Employee_ID from evaluation )	employee_hire_evaluation
select Name from employee where Employee_ID not in (select Employee_ID from evaluation)	employee_hire_evaluation
select T1.Name from shop as T1 join hiring as T2 on T1.Shop_ID = T2.Shop_ID group by T1.Shop_ID order by count(T2.Employee_ID) desc limit 1	employee_hire_evaluation
select T1.Name from shop as T1 join hiring as T2 on T1.Shop_ID = T2.Shop_ID group by T1.Shop_ID order by count(T2.Employee_ID) desc limit 1	employee_hire_evaluation
select Name from shop except select T1.Name from shop as T1 join hiring as T2 on T1.Shop_ID = T2.Shop_ID	employee_hire_evaluation
select T1.Name from shop as T1 left join hiring as T2 on T1.Shop_ID = T2.Shop_ID where T2.Shop_ID is null	employee_hire_evaluation
select T1.Name, count(T2.Employee_ID) from shop as T1 join hiring as T2 on T1.Shop_ID = T2.Shop_ID group by T1.Shop_ID	employee_hire_evaluation
select T1.Name, count(T2.Employee_ID) from shop as T1 join hiring as T2 on T1.Shop_ID = T2.Shop_ID group by T1.Shop_ID	employee_hire_evaluation
select sum(Bonus) from evaluation	employee_hire_evaluation
select sum(Bonus) from evaluation	employee_hire_evaluation
select * from hiring	employee_hire_evaluation
select * from hiring	employee_hire_evaluation
select District from shop where Number_products < 3000 intersect select District from shop where Number_products > 10000	employee_hire_evaluation
select T1.District from shop as T1 where T1.Number_products < 3000 intersect select T1.District from shop as T1 where T1.Number_products > 10000	employee_hire_evaluation
select count(distinct Location) from shop	employee_hire_evaluation
select count(distinct Location) from shop	employee_hire_evaluation
