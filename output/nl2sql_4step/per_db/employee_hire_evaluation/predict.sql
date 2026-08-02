select count(Employee_ID) from employee	employee_hire_evaluation
select count(*) from employee	employee_hire_evaluation
select Name from employee order by Age asc	employee_hire_evaluation
select Name, Age from employee order by Age asc	employee_hire_evaluation
select City, count(Employee_ID) from employee group by City	employee_hire_evaluation
select City, count(Employee_ID) from employee group by City	employee_hire_evaluation
select City from employee where Age < 30 group by City having count(*) > 1	employee_hire_evaluation
select City from employee where Age < 30 group by City having count(*) > 1	employee_hire_evaluation
select Location, count(Shop_ID) from shop group by Location	employee_hire_evaluation
select count(Shop_ID) as "Number of shops", Location from shop group by Location	employee_hire_evaluation
select Manager_name, District from shop order by Number_products desc limit 1	employee_hire_evaluation
select Manager_name, District from shop order by Number_products desc limit 1	employee_hire_evaluation
select min(Number_products), max(Number_products) from shop	employee_hire_evaluation
select min(Number_products), max(Number_products) from shop	employee_hire_evaluation
select Name, Location, District from shop order by Number_products desc	employee_hire_evaluation
select Name, Location, District from shop order by Number_products desc	employee_hire_evaluation
select Name from shop where Number_products > (select avg(Number_products) from shop)	employee_hire_evaluation
select Name from shop where Number_products > (select avg(Number_products) from shop)	employee_hire_evaluation
select employee.Name from employee join evaluation on employee.Employee_ID = evaluation.Employee_ID group by employee.Employee_ID order by count(evaluation.Employee_ID) desc limit 1	employee_hire_evaluation
select e.Name from employee e join evaluation ev on e.Employee_ID = ev.Employee_ID group by e.Name order by count(*) desc limit 1	employee_hire_evaluation
select employee.Name from employee join evaluation on employee.Employee_ID = evaluation.Employee_ID order by evaluation.Bonus desc limit 1	employee_hire_evaluation
select T1.Name from employee as T1 join evaluation as T2 on T1.Employee_ID = T2.Employee_ID order by T2.Bonus desc limit 1	employee_hire_evaluation
select Name from employee where Employee_ID not in (select Employee_ID from evaluation)	employee_hire_evaluation
select Name from employee where Employee_ID not in (select Employee_ID from evaluation)	employee_hire_evaluation
select T1.Name from shop as T1 join hiring as T2 on T1.Shop_ID = T2.Shop_ID group by T1.Shop_ID order by count(T2.Employee_ID) desc limit 1	employee_hire_evaluation
select T1.Name from shop as T1 join hiring as T2 on T1.Shop_ID = T2.Shop_ID group by T1.Shop_ID order by count(*) desc limit 1	employee_hire_evaluation
select Name from shop where Shop_ID not in (select Shop_ID from hiring)	employee_hire_evaluation
select Name from shop where Shop_ID not in (select Shop_ID from hiring)	employee_hire_evaluation
select shop.Name, count(*) from shop join hiring on shop.Shop_ID = hiring.Shop_ID group by shop.Name	employee_hire_evaluation
select T1.Name, count(T2.Employee_ID) from shop as T1 left join hiring as T2 on T1.Shop_ID = T2.Shop_ID group by T1.Name	employee_hire_evaluation
select sum(Bonus) from evaluation	employee_hire_evaluation
select sum(Bonus) from evaluation	employee_hire_evaluation
select Shop_ID, Employee_ID, Start_from, Is_full_time from hiring	employee_hire_evaluation
select Shop_ID, Employee_ID, Start_from, Is_full_time from hiring	employee_hire_evaluation
select distinct District from shop where District in (select District from shop where Number_products < 3000) and District in (select District from shop where Number_products > 10000)	employee_hire_evaluation
select District from shop where Number_products < 3000 intersect select District from shop where Number_products > 10000	employee_hire_evaluation
select count(distinct Location) from shop	employee_hire_evaluation
select count(distinct Location) from shop	employee_hire_evaluation
