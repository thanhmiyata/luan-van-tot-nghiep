select count(distinct ContId) from continents	car_1
select count(*) from continents	car_1
select T1.ContId, T1.Continent, count(distinct T2.CountryId) from continents as T1 left join countries as T2 on T1.ContId = T2.Continent group by T1.ContId, T1.Continent	car_1
select continents.ContId, continents.Continent, count(distinct countries.CountryId) from continents left join countries on continents.ContId = countries.Continent group by continents.ContId, continents.Continent	car_1
select count(*) from countries	car_1
select count(distinct CountryId) from countries	car_1
select car_makers.FullName, car_makers.Id, count(model_list.ModelId) from car_makers join model_list on car_makers.Id = model_list.Maker group by car_makers.Id, car_makers.FullName	car_1
select car_makers.FullName, car_makers.Id, count(distinct model_list.ModelId) from car_makers left join model_list on car_makers.Id = model_list.Maker group by car_makers.FullName, car_makers.Id	car_1
select T1.Model from model_list as T1 join car_names as T2 on T1.Model = T2.Model join cars_data as T3 on T2.MakeId = T3.Id order by T3.Horsepower asc limit 1	car_1
select T1.Model from model_list as T1 join car_names as T2 on T1.ModelId = T2.ModelId join cars_data as T3 on T2.MakeId = T3.Id order by T3.Horsepower asc limit 1	car_1
select T3.Model from cars_data as T1 join car_names as T2 on T1.Id = T2.MakeId join model_list as T3 on T2.Model = T3.Model where T1.Weight < (select avg(Weight) from cars_data)	car_1
select model_list.Model from model_list join cars_data on model_list.ModelId = cars_data.Id where cars_data.Weight < (select avg(Weight) from cars_data)	car_1
select distinct T1.Maker from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker join car_names as T3 on T2.ModelId = T3.MakeId join cars_data as T4 on T3.Id = T4.Id where T4.Year = 1970	car_1
select distinct T1.Maker from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker join car_names as T3 on T2.ModelId = T3.Model join cars_data as T4 on T3.MakeId = T4.Id where T4.Year = 1970	car_1
select T3.Maker, T1.Year from cars_data as T1 join car_names as T2 on T1.Id = T2.MakeId join model_list as T3 on T2.Model = T3.Model where T1.Year = (select min(Year) from cars_data)	car_1
select T0.Maker, T3.Year from cars_data as T3 join car_names as T2 on T3.Id = T2.MakeId join model_list as T1 on T2.Model = T1.Model join car_makers as T0 on T1.Maker = T0.Id order by T3.Year asc limit 1	car_1
select distinct model_list.Model from model_list join cars_data on model_list.ModelId = cars_data.ModelId where cars_data.Year > 1980	car_1
select distinct T1.Model from model_list as T1 join car_names as T2 on T1.Model = T2.Model join cars_data as T3 on T3.Id = T2.MakeId where T3.Year > 1980	car_1
select continents.Continent, count(distinct car_makers.Id) from continents join countries on continents.ContId = countries.Continent join car_makers on countries.CountryId = car_makers.Country group by continents.Continent	car_1
select T1.Continent, count(distinct T3.Id) from continents as T1 join countries as T2 on T1.ContId = T2.Continent join car_makers as T3 on T2.CountryId = T3.Country group by T1.Continent	car_1
select countries.CountryName from countries join car_makers on countries.CountryId = car_makers.Country group by countries.CountryName order by count(car_makers.Id) desc limit 1	car_1
select countries.CountryName from countries join car_makers on countries.CountryId = car_makers.Country group by countries.CountryName order by count(distinct car_makers.Id) desc limit 1	car_1
select count(distinct model_list.ModelId), car_makers.FullName from model_list join car_makers on model_list.Maker = car_makers.Id group by car_makers.FullName	car_1
select car_makers.Id, car_makers.FullName, count(distinct model_list.ModelId) from car_makers join model_list on car_makers.Id = model_list.Maker group by car_makers.Id, car_makers.FullName	car_1
select cars_data.Accelerate from car_names join cars_data on car_names.MakeId = cars_data.Id where car_names.Make = "amc hornet sportabout (sw)"	car_1
select Accelerate from cars_data where Id = (select MakeId from car_names where Model = "hornet sportabout (sw)")	car_1
select count(distinct Id) from car_makers where Country = "france"	car_1
select count(distinct Maker) from car_makers where Country = "France"	car_1
select count(distinct model_list.ModelId) from model_list join car_makers on model_list.Maker = car_makers.Id where car_makers.Country = "usa"	car_1
select count(distinct model_list.ModelId) from model_list join car_makers on model_list.Maker = car_makers.Id where car_makers.Country = "United States"	car_1
select avg(MPG) from cars_data where Cylinders = 4	car_1
select avg(cars_data.MPG) from cars_data where cars_data.Cylinders = 4	car_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	car_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	car_1
select T1.Maker, T2.Model from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker	car_1
select car_makers.Maker, model_list.Model from car_makers join model_list on car_makers.Id = model_list.Maker	car_1
select distinct T1.CountryName, T1.CountryId from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country	car_1
select c.CountryName, c.CountryId from countries as c where c.CountryId in (select cm.Country from car_makers as cm)	car_1
select count(distinct Id) from cars_data where Horsepower > 150	car_1
select count(*) from cars_data where Horsepower > 150	car_1
select Year, avg(Weight) from cars_data group by Year	car_1
select avg(Weight), Year from cars_data group by Year	car_1
select T1.CountryName from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country where T1.Continent = "Europe" group by T1.CountryName having count(distinct T2.Id) >= 3	car_1
select T1.CountryName from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country where T1.Continent = "Europe" group by T1.CountryName having count(distinct T2.Id) >= 3	car_1
select T1.Horsepower, T3.Maker from cars_data as T1 join model_list as T2 on T1.Id = T2.ModelId join car_makers as T3 on T2.Maker = T3.Maker where T1.Cylinders = 3 and T1.Horsepower = (select max(Horsepower) from cars_data where Cylinders = 3)	car_1
select max(T1.Horsepower), T2.Maker from cars_data as T1 join car_makers as T2 on T1.MakeId = T2.Id where T1.Cylinders = 3 group by T2.Maker order by max(T1.Horsepower) desc limit 1	car_1
select Id , MPG from cars_data order by MPG desc limit 1	car_1
select model_list.Model from cars_data join model_list on cars_data.ModelId = model_list.ModelId order by cars_data.MPG desc limit 1	car_1
select avg(Horsepower) from cars_data where Year < 1980	car_1
select avg(Horsepower) from cars_data where Year < 1980	car_1
select avg(T3.Edispl) from model_list as T1 join car_names as T2 on T1.ModelId = T2.MakeId join cars_data as T3 on T2.ModelId = T3.Id where T1.Model = "volvo"	car_1
select avg(T1.Edispl) from cars_data as T1 join car_makers as T2 on T1.MakeId = T2.Id where T2.Maker = "Volvo"	car_1
select Cylinders, max(Accelerate) from cars_data group by Cylinders	car_1
select max(Accelerate) from cars_data group by Cylinders	car_1
select T1.Model, count(distinct T2.Make) from model_list as T1 join car_names as T2 on T1.ModelId = T2.Model group by T1.Model order by count(distinct T2.Make) desc limit 1	car_1
select model_list.Model, count(distinct car_names.Model) from model_list join car_names on model_list.ModelId = car_names.MakeId group by model_list.Model order by Number_of_Versions desc limit 1	car_1
select count(distinct Id) from cars_data where Cylinders > 4	car_1
select count(*) from cars_data where Cylinders > 4	car_1
select count(distinct Id) from cars_data where Year = 1980	car_1
select count(distinct Id) from cars_data where Year = 1980	car_1
select count(distinct model_list.ModelId) from model_list join car_makers on model_list.Maker = car_makers.Id where car_makers.FullName = "American Motor Company"	car_1
select count(distinct T1.ModelId) from model_list as T1 join car_makers as T2 on T1.Maker = T2.Id where T2.Maker = "American Motor Company"	car_1
select T1.FullName, T1.Id from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.FullName, T1.Id having count(distinct T2.ModelId) > 3	car_1
select car_makers.Maker, car_makers.Id from car_makers join model_list on car_makers.Id = model_list.Maker group by car_makers.Maker, car_makers.Id having count(distinct model_list.ModelId) > 3	car_1
select 1	car_1
select distinct T2.Model from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker join cars_data as T3 on T2.Id = T3.Model where T1.Maker = "General Motors" or T3.Weight > 3500	car_1
select Year from cars_data where Weight between 3000 and 4000	car_1
select Year from cars_data group by Year having min(Weight) < 4000 and max(Weight) > 3000	car_1
select Horsepower from cars_data order by Accelerate desc limit 1	car_1
select Horsepower from cars_data order by Accelerate desc limit 1	car_1
select T1.Cylinders from cars_data as T1 join model_list as T2 on T1.Id = T2.ModelId where T2.Model = "volvo" order by T1.Accelerate asc limit 1	car_1
select T1.Cylinders from cars_data as T1 join car_names as T2 on T1.Id = T2.ModelId join model_list as T3 on T2.MakeId = T3.Id where T3.Maker = "volvo" order by T1.Accelerate asc limit 1	car_1
select count(*) from cars_data where Accelerate > (select max(CAST(Horsepower as REAL)) from cars_data)	car_1
select count(distinct Id) from cars_data where Accelerate > (select max(Horsepower) from cars_data)	car_1
select count(T1.CountryId) from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country group by T1.CountryId having count(T2.Id) > 2	car_1
select count(distinct T1.CountryId) from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country group by T2.Country having count(T2.Id) > 2	car_1
select count(distinct Id) from cars_data where Cylinders > 6	car_1
select count(distinct Id) from cars_data where Cylinders > 6	car_1
select model_list.Model, cars_data.Horsepower from cars_data inner join model_list on cars_data.ModelId = model_list.ModelId where cars_data.Cylinders = 4 order by cars_data.Horsepower desc limit 1	car_1
select cars_data.Horsepower, model_list.Model from cars_data join model_list on cars_data.Id = model_list.ModelId where cars_data.Cylinders = 4 order by cars_data.Horsepower desc limit 1	car_1
select T2.MakeId, T3.Maker from cars_data as T1 inner join car_names as T2 on T1.MakeId = T2.MakeId inner join car_makers as T3 on T2.MakeId = T3.Id where T1.Horsepower > (select min(Horsepower) from cars_data) and T1.Cylinders <= 3	car_1
select T1.MakeId, T1.Make from car_names as T1 join cars_data as T2 on T1.MakeId = T2.MakeId where T2.Cylinders < 4 and T2.Horsepower <> (select min(Horsepower) from cars_data)	car_1
select max(MPG) from cars_data where Cylinders = 8 or Year < 1980	car_1
select max(MPG) from cars_data where Cylinders = 8 or Year < 1980	car_1
select model_list.Model from cars_data join car_names on cars_data.Id = car_names.MakeId join model_list on car_names.ModelId = model_list.ModelId where cars_data.Weight < 3500 and car_names.Make <> "Ford Motor Company"	car_1
select distinct T3.Model from model_list as T3 join cars_data as T4 on T3.ModelId = T4.Id join car_makers as T1 on T3.Maker = T1.Id where T4.Weight < 3500 and T1.Maker <> "Ford"	car_1
select CountryName from countries where CountryId not in (select distinct Country from car_makers)	car_1
select CountryName from countries where CountryId not in (select distinct Country from car_makers)	car_1
select T1.Id, T1.Maker from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.Id, T1.Maker having count(T2.ModelId) >= 2	car_1
select T1.Id, T1.Maker from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker join cars_data as T3 on T1.Id = T3.MakeId group by T1.Id, T1.Maker having count(distinct T2.ModelId) >= 2 and count(distinct T3.Id) > 3	car_1
select T1.CountryId, T1.CountryName from countries as T1 where T1.CountryId in (select T2.Country from car_makers as T2 group by T2.Country having count(distinct T2.Id) > 3) or T1.CountryId in (select T2.Country from car_makers as T2 join model_list as T3 on T2.Id = T3.Maker where T3.Model = "fiat")	car_1
select T1.CountryId, T1.CountryName from countries as T1 left join car_makers as T2 on T1.CountryId = T2.Country left join model_list as T3 on T2.Id = T3.Maker group by T1.CountryId, T1.CountryName having count(distinct T2.Id) > 3 or sum(CASE WHEN T3.Model = "fiat" THEN 1 ELSE 0 END) > 0	car_1
