select count(distinct Continent) from continents	car_1
select count(distinct ContId) from continents	car_1
select c.ContId, c.Continent, count(*) from continents c join countries cn on c.ContId = cn.Continent group by c.ContId, c.Continent	car_1
select continents.ContId, continents.Continent, count(countries.CountryId) from continents left join countries on continents.ContId = countries.Continent group by continents.ContId, continents.Continent	car_1
select count(*) from countries	car_1
select count(*) from countries	car_1
select car_makers.FullName, car_makers.Id, count(model_list.ModelId) from car_makers join model_list on car_makers.Id = model_list.Maker group by car_makers.Id, car_makers.FullName	car_1
select T1.FullName, T1.Id, count(T2.ModelId) from car_makers as T1 left join model_list as T2 on T1.Id = T2.Maker group by T1.FullName, T1.Id	car_1
select T1.Model from model_list as T1 join car_names as T2 on T1.Model = T2.Model join cars_data as T3 on T2.MakeId = T3.Id order by T3.Horsepower asc limit 1	car_1
select T1.Model from model_list as T1 join cars_data as T2 on T1.ModelId = T2.Id order by T2.Horsepower asc limit 1	car_1
select m.Model from model_list m join cars_data c on m.ModelId = c.Id where c.Weight < (select avg(Weight) from cars_data)	car_1
select model_list.Model from cars_data join model_list on cars_data.Id = model_list.ModelId where cars_data.Weight < (select avg(Weight) from cars_data)	car_1
select distinct car_makers.Maker from car_makers join model_list on car_makers.Id = model_list.Maker join car_names on model_list.ModelId = car_names.MakeId join cars_data on car_names.Id = cars_data.Id where cars_data.Year = 1970	car_1
select distinct T4.Maker from cars_data as T1 join car_names as T2 on T1.Id = T2.MakeId join model_list as T3 on T2.Model = T3.Model join car_makers as T4 on T3.Maker = T4.Id where T1.Year = 1970	car_1
select T1.Maker, T4.Year from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker join car_names as T3 on T2.ModelId = T3.Model join cars_data as T4 on T3.MakeId = T4.Id where T4.Year = (select min(Year) from cars_data)	car_1
select T1.Maker, T4.Year from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker join car_names as T3 on T2.ModelId = T3.Model join cars_data as T4 on T3.MakeId = T4.Id order by T4.Year asc limit 1	car_1
select distinct T1.Model from model_list as T1 join car_names as T2 on T1.Model = T2.Model join cars_data as T3 on T2.MakeId = T3.Id where T3.Year > 1980	car_1
select distinct T1.Model from model_list as T1 join car_names as T2 on T1.Model = T2.Model join cars_data as T3 on T3.Id = T2.MakeId where T3.Year > 1980	car_1
select T1.Continent, count(T3.Id) from continents as T1 join countries as T2 on T1.ContId = T2.Continent join car_makers as T3 on T2.CountryId = T3.Country group by T1.Continent	car_1
select c.Continent, count(*) from continents as c join countries as co on c.ContId = co.ContinentId join car_makers as cm on co.CountryId = cm.Country group by c.Continent	car_1
select CountryName from countries join car_makers on countries.CountryId = car_makers.Country group by CountryName order by count(*) desc limit 1	car_1
select CountryName from countries join car_makers on countries.CountryId = car_makers.Country group by CountryName order by count(*) desc limit 1	car_1
select count(*), car_makers.FullName from car_makers join model_list on car_makers.Id = model_list.Maker group by car_makers.FullName	car_1
select count(model_list.ModelId), car_makers.Id, car_makers.FullName from car_makers join model_list on car_makers.Id = model_list.Maker group by car_makers.Id, car_makers.FullName	car_1
select cars_data.Accelerate from car_names join cars_data on car_names.MakeId = cars_data.Id where car_names.Make = "amc" and car_names.Model = "hornet sportabout (sw)"	car_1
select Accelerate from cars_data where Id = (select MakeId from car_names where Make = "amc hornet sportabout (sw)")	car_1
select count(distinct Maker) from car_makers where Country = "france"	car_1
select count(distinct Maker) from car_makers where Country = "France"	car_1
select count(*) from model_list join car_makers on model_list.Maker = car_makers.Id where car_makers.Country = "usa"	car_1
select count(*) from model_list join car_makers on model_list.Maker = car_makers.Id where car_makers.Country = "usa"	car_1
select avg(MPG) from cars_data where Cylinders = 4	car_1
select avg(MPG) from cars_data where Cylinders = 4	car_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	car_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	car_1
select car_makers.Maker, model_list.Model from model_list join car_makers on model_list.Maker = car_makers.Maker	car_1
select Maker, Model from model_list	car_1
select CountryName, CountryId from countries where CountryId in (select distinct Country from car_makers)	car_1
select countries.CountryName, countries.CountryId from countries join car_makers on countries.CountryId = car_makers.Country	car_1
select count(*) from cars_data where Horsepower > 150	car_1
select count(*) from cars_data where Horsepower > 150	car_1
select avg(Weight), Year from cars_data group by Year	car_1
select avg(Weight), Year from cars_data group by Year	car_1
select T1.CountryName from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country where T1.Continent = "europe" group by T1.CountryName having count(*) >= 3	car_1
select T1.CountryName from countries as T1 join continents as T2 on T1.Continent = T2.ContId join car_makers as T3 on T1.CountryId = T3.Country where T2.Continent = "europe" group by T1.CountryName having count(*) >= 3	car_1
select T2.Horsepower, T1.Make from car_names as T1 join cars_data as T2 on T1.MakeId = T2.Id where T2.Cylinders = 3 order by T2.Horsepower desc limit 1	car_1
select T1.Horsepower, T3.Maker from cars_data as T1 join model_list as T2 on T1.Id = T2.ModelId join car_makers as T3 on T2.Maker = T3.Id where T1.Cylinders = 3 order by T1.Horsepower desc limit 1	car_1
select T1.Model from model_list as T1 join car_names as T2 on T1.Model = T2.Model join cars_data as T3 on T2.MakeId = T3.Id order by T3.MPG desc limit 1	car_1
select T1.Model from model_list as T1 join car_names as T2 on T1.ModelId = T2.Model join cars_data as T3 on T2.MakeId = T3.Id order by T3.MPG desc limit 1	car_1
select avg(Horsepower) from cars_data where Year < 1980	car_1
select avg(Horsepower) from cars_data where Year < 1980	car_1
select avg(T1.Edispl) from cars_data as T1 join car_names as T2 on T1.Id = T2.Model join model_list as T3 on T2.MakeId = T3.ModelId where T3.Model = "volvo"	car_1
select avg(T1.Edispl) from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId inner join model_list as T3 on T2.Model = T3.ModelId inner join car_makers as T4 on T3.Maker = T4.Id where T4.Maker = "volvo"	car_1
select max(Accelerate), Cylinders from cars_data group by Cylinders	car_1
select max(Accelerate) from cars_data group by Cylinders	car_1
select m.Model from model_list m join car_names c on m.ModelId = c.Model group by m.Model order by count(*) desc limit 1	car_1
select ml.Model from model_list as ml join car_names as cn on ml.Model = cn.Model group by ml.Model order by count(distinct cn.MakeId) desc limit 1	car_1
select count(*) from cars_data where Cylinders > 4	car_1
select count(*) from cars_data where Cylinders > 4	car_1
select count(*) from cars_data where Year = 1980	car_1
select count(*) from cars_data where Year = 1980	car_1
select count(*) from model_list join car_makers on model_list.Maker = car_makers.Id where car_makers.FullName = "American Motor Company"	car_1
select count(*) from model_list as T1 join car_makers as T2 on T1.Maker = T2.Id where T2.Maker = "amc"	car_1
select car_makers.FullName, car_makers.Id from car_makers join model_list on car_makers.Id = model_list.Maker group by car_makers.Id having count(model_list.ModelId) > 3	car_1
select T1.Maker, T1.Id from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.Maker, T1.Id having count(*) > 3	car_1
select distinct T1.Model from model_list as T1 join car_makers as T2 on T1.Maker = T2.Id left join cars_data as T3 on T1.ModelId = T3.Id where T2.FullName = "General Motors" or T3.Weight > 3500	car_1
select distinct Model from model_list where Maker = (select Id from car_makers where FullName = "General Motors") or ModelId in (select ModelId from cars_data where Weight > 3500)	car_1
select Year from cars_data where Weight >= 3000 and Weight <= 4000	car_1
select distinct Year from cars_data where Weight < 4000 intersect select distinct Year from cars_data where Weight > 3000	car_1
select Horsepower from cars_data order by Accelerate desc limit 1	car_1
select Horsepower from cars_data order by Accelerate desc limit 1	car_1
select cars_data.Cylinders from cars_data join model_list on model_list.ModelId = cars_data.Id where model_list.Maker = "volvo" order by cars_data.Accelerate asc limit 1	car_1
select T3.Cylinders from model_list as T1 join car_names as T2 on T1.Model = T2.Model join cars_data as T3 on T2.MakeId = T3.Id where T1.Maker = "volvo" order by T3.Accelerate asc limit 1	car_1
select count(*) from cars_data where Accelerate > (select max(Horsepower) from cars_data)	car_1
select count(*) as "Number of cars" from cars_data where Accelerate > (select max(CAST(Horsepower as REAL)) from cars_data)	car_1
select count(*) from (select Country from car_makers group by Country having count(*) > 2)	car_1
select count(*) from (select Country from car_makers group by Country having count(*) > 2)	car_1
select count(*) from cars_data where Cylinders > 6	car_1
select count(*) from cars_data where Cylinders > 6	car_1
select T1.Model from model_list as T1 join cars_data as T2 on T1.ModelId = T2.Id where T2.Cylinders = 4 order by T2.Horsepower desc limit 1	car_1
select model_list.Model from model_list join cars_data on model_list.ModelId = cars_data.Id where cars_data.Cylinders = 4 order by cars_data.Horsepower desc limit 1	car_1
select T2.MakeId, T4.FullName from cars_data as T1 join car_names as T2 on T1.Id = T2.Model join model_list as T3 on T2.MakeId = T3.ModelId join car_makers as T4 on T3.Maker = T4.Id where T1.Horsepower > (select min(Horsepower) from cars_data) and T1.Cylinders <= 3	car_1
select T1.MakeId, T1.Make from car_names as T1 join cars_data as T2 on T1.MakeId = T2.Id where T2.Cylinders < 4 and T2.Horsepower <> (select min(Horsepower) from cars_data)	car_1
select max(MPG) from cars_data where Cylinders = 8 or Year < 1980	car_1
select max(MPG) from cars_data where Cylinders = 8 or Year < 1980	car_1
select T1.Model from model_list as T1 join car_makers as T2 on T1.Maker = T2.Id join car_names as T3 on T1.Model = T3.Model join cars_data as T4 on T3.MakeId = T4.Id where T4.Weight < 3500 and T2.Maker <> "Ford Motor Company"	car_1
select distinct T1.Model from model_list as T1 join cars_data as T2 on T1.ModelId = T2.Id join car_makers as T3 on T1.Maker = T3.Id where T2.Weight < 3500 and T3.FullName <> "Ford Motor Company"	car_1
select CountryName from countries where CountryId not in (select Country from car_makers)	car_1
select CountryName from countries where CountryId not in (select Country from car_makers)	car_1
select c.Id, c.Maker from car_makers as c where (select count(*) from model_list as m where m.Maker = c.Maker) >= 2 having count(distinct c.Maker) > 3	car_1
select T1.Id, T1.Maker from car_makers as T1 where (select count(distinct T2.Model) from model_list as T2 where T2.Maker = T1.Id) >= 2 and (select count(*) from car_names as T3 where T3.MakeId = T1.Id) > 3	car_1
select T1.CountryId, T1.CountryName from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country left join model_list as T3 on T2.Id = T3.Maker where T2.Country in (select Country from car_makers group by Country having count(*) > 3) or T3.Model = "fiat"	car_1
select CountryId, CountryName from countries where CountryId in (select Country from car_makers group by Country having count(*) > 3) or CountryId in (select Country from car_makers inner join model_list on car_makers.Maker = model_list.Maker where model_list.Model = "fiat")	car_1
