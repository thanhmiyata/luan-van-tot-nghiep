select count(*) from employee	employee_hire_evaluation
select count(*) from employee	employee_hire_evaluation
select Name from employee order by Age asc	employee_hire_evaluation
select Name from employee order by Age asc	employee_hire_evaluation
select count(*), City from employee group by City	employee_hire_evaluation
select City, count(*) from employee group by City	employee_hire_evaluation
select City from employee where Age < 30 group by City having count(*) > 1	employee_hire_evaluation
select City from employee where Age < 30 group by City having count(*) > 1	employee_hire_evaluation
select Location, count(*) from shop group by Location	employee_hire_evaluation
select count(*), Location from shop group by Location	employee_hire_evaluation
select Manager_name, District from shop order by Number_products desc limit 1	employee_hire_evaluation
select Manager_name, District from shop order by Number_products desc limit 1	employee_hire_evaluation
select min(Number_products), max(Number_products) from shop	employee_hire_evaluation
select min(Number_products), max(Number_products) from shop	employee_hire_evaluation
select Name, Location, District from shop order by Number_products desc	employee_hire_evaluation
select Name, Location, District from shop order by Number_products desc	employee_hire_evaluation
select Name from shop where Number_products > (select avg(Number_products) from shop)	employee_hire_evaluation
select Name from shop where Number_products > (select avg(Number_products) from shop)	employee_hire_evaluation
select e.Name from employee as e join evaluation as ev on e.Employee_ID = ev.Employee_ID group by e.Employee_ID order by count(*) desc limit 1	employee_hire_evaluation
select T1.Name from employee as T1 join evaluation as T2 on T1.Employee_ID = T2.Employee_ID group by T1.Employee_ID order by count(*) desc limit 1	employee_hire_evaluation
select employee.Name from employee join evaluation on employee.Employee_ID = evaluation.Employee_ID order by evaluation.Bonus desc limit 1	employee_hire_evaluation
select employee.Name from employee join evaluation on employee.Employee_ID = evaluation.Employee_ID order by evaluation.Bonus desc limit 1	employee_hire_evaluation
select employee.Name from employee left join evaluation on employee.Employee_ID = evaluation.Employee_ID where evaluation.Employee_ID is null	employee_hire_evaluation
select employee.Name from employee left join evaluation on employee.Employee_ID = evaluation.Employee_ID where evaluation.Employee_ID is null	employee_hire_evaluation
SELECT t2.name FROM hiring AS t1 JOIN shop AS t2 ON t1.shop_id  =  t2.shop_id GROUP BY t1.shop_id ORDER BY count(*) DESC LIMIT 1	employee_hire_evaluation
select shop.Name from shop join hiring on shop.Shop_ID = hiring.Shop_ID group by shop.Shop_ID order by count(*) desc limit 1	employee_hire_evaluation
select shop.Name from shop where shop.Shop_ID not in (select Shop_ID from hiring)	employee_hire_evaluation
select T1.Name from shop as T1 left join hiring as T2 on T1.Shop_ID = T2.Shop_ID where T2.Shop_ID is null	employee_hire_evaluation
SELECT count(*) ,  t2.name FROM hiring AS t1 JOIN shop AS t2 ON t1.shop_id  =  t2.shop_id GROUP BY t2.name	employee_hire_evaluation
select shop.Name, count(hiring.Employee_ID) from shop join hiring on shop.Shop_ID = hiring.Shop_ID group by shop.Name	employee_hire_evaluation
select sum(Bonus) from evaluation	employee_hire_evaluation
select sum(Bonus) from evaluation	employee_hire_evaluation
select Employee_ID, Shop_ID, Start_from, Is_full_time from hiring	employee_hire_evaluation
select Shop_ID, Employee_ID, Start_from, Is_full_time from hiring	employee_hire_evaluation
select District from shop where Number_products < 3000 intersect select District from shop where Number_products > 10000	employee_hire_evaluation
select District from shop where Number_products < 3000 intersect select District from shop where Number_products > 10000	employee_hire_evaluation
select count(distinct Location) from shop	employee_hire_evaluation
select count(distinct Location) from shop	employee_hire_evaluation
