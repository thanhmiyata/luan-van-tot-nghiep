select count(*) from continents	car_1
select count(*) from continents	car_1
select continents.ContId, continents.Continent, count(*) from continents join countries on countries.Continent = continents.ContId group by continents.ContId, continents.Continent	car_1
select continents.ContId, continents.Continent, count(*) from continents join countries on countries.Continent = continents.ContId group by continents.ContId, continents.Continent	car_1
select count(*) from countries	car_1
select count(*) from countries	car_1
select car_makers.FullName, car_makers.Id, count(*) from car_makers join model_list on model_list.Maker = car_makers.Id group by car_makers.FullName, car_makers.Id	car_1
select T1.FullName, T1.Id, count(T2.ModelId) from car_makers as T1 join model_list as T2 on T2.Maker = T1.Id group by T1.FullName, T1.Id	car_1
select T1.Model from model_list as T1 join car_names as T2 on T2.Model = T1.Model join cars_data as T3 on T3.Id = T2.MakeId order by T3.Horsepower asc limit 1	car_1
select model_list.Model from model_list join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId order by cars_data.Horsepower asc limit 1	car_1
select model_list.Model from model_list join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where cars_data.Weight < (select avg(Weight) from cars_data)	car_1
select model_list.Model from model_list join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where cars_data.Weight < (select avg(Weight) from cars_data)	car_1
select distinct T1.Maker, T1.FullName from car_makers as T1 inner join model_list as T2 on T2.Maker = T1.Id inner join car_names as T3 on T3.Model = T2.Model inner join cars_data as T4 on T4.Id = T3.MakeId where T4.Year = 1970	car_1
select distinct car_makers.Maker from car_makers inner join model_list on model_list.Maker = car_makers.Id inner join car_names on car_names.Model = model_list.Model inner join cars_data on cars_data.Id = car_names.MakeId where cars_data.Year = 1970	car_1
select T4.Maker, T1.Year from cars_data as T1 join car_names as T2 on T1.Id = T2.MakeId join model_list as T3 on T2.Model = T3.Model join car_makers as T4 on T3.Maker = T4.Id where T1.Year = (select min(Year) from cars_data)	car_1
select car_makers.Maker, cars_data.Year from cars_data join car_names on cars_data.Id = car_names.MakeId join model_list on car_names.Model = model_list.Model join car_makers on model_list.Maker = car_makers.Id order by cars_data.Year asc limit 1	car_1
select distinct model_list.Model from model_list join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where cars_data.Year > 1980	car_1
select distinct model_list.Model from model_list inner join car_names on car_names.Model = model_list.Model inner join cars_data on cars_data.Id = car_names.MakeId where cars_data.Year > 1980	car_1
select continents.Continent, count(*) from continents join countries on countries.Continent = continents.ContId join car_makers on car_makers.Country = countries.CountryId group by continents.Continent	car_1
select continents.Continent, count(*) from continents join countries on countries.Continent = continents.ContId join car_makers on car_makers.Country = countries.CountryId group by continents.Continent	car_1
select CountryName from countries join car_makers on countries.CountryId = car_makers.Country group by CountryName order by count(*) desc limit 1	car_1
select T1.CountryName from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country group by T1.CountryName order by count(T2.Id) desc limit 1	car_1
select count(*), T1.FullName from car_makers as T1 inner join model_list as T2 on T1.Id = T2.Maker group by T1.FullName	car_1
select car_makers.Id, car_makers.FullName, count(*) from car_makers inner join model_list on model_list.Maker = car_makers.Id group by car_makers.Id, car_makers.FullName	car_1
select cars_data.Accelerate from car_names inner join cars_data on cars_data.Id = car_names.MakeId where car_names.Make = "amc hornet sportabout (sw)"	car_1
select cars_data.Accelerate from car_names join cars_data on cars_data.Id = car_names.MakeId where car_names.Make = "amc hornet sportabout (sw)"	car_1
select count(*) from countries join car_makers on car_makers.Country = countries.CountryId where countries.CountryName = "france"	car_1
select count(*) from car_makers join countries on car_makers.Country = countries.CountryId where countries.CountryName = "france"	car_1
select count(*) from model_list join car_makers on model_list.Maker = car_makers.Id join countries on car_makers.Country = countries.CountryId where countries.CountryName = "usa"	car_1
select count(*) from countries join car_makers on car_makers.Country = countries.CountryId join model_list on model_list.Maker = car_makers.Id where countries.CountryName = "usa"	car_1
select avg(MPG) from cars_data where Cylinders = 4	car_1
select avg(cars_data.MPG) from cars_data where cars_data.Cylinders = 4	car_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	car_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	car_1
select car_makers.Maker, model_list.Model from car_makers join model_list on model_list.Maker = car_makers.Id	car_1
select T1.Maker, T2.Model from car_makers as T1 inner join model_list as T2 on T2.Maker = T1.Id	car_1
select T1.CountryName, T1.CountryId from countries as T1 join car_makers as T2 on T2.Country = T1.CountryId group by T1.CountryName, T1.CountryId having count(*) >= 1	car_1
select countries.CountryName, countries.CountryId from countries inner join car_makers on car_makers.Country = countries.CountryId group by countries.CountryId having count(car_makers.Id) > 0	car_1
select count(*) from cars_data where Horsepower > 150	car_1
select count(*) from cars_data where Horsepower > 150	car_1
select Year, avg(Weight) from cars_data group by Year	car_1
select avg(Weight), Year from cars_data group by Year	car_1
select T1.CountryName from countries as T1 join continents as T2 on T1.Continent = T2.ContId join car_makers as T3 on T3.Country = T1.CountryId where T2.Continent = "europe" group by T1.CountryName having count(T3.Id) >= 3	car_1
select countries.CountryName from countries join continents on countries.Continent = continents.ContId join car_makers on car_makers.Country = countries.CountryId where continents.Continent = "europe" group by countries.CountryName having count(*) >= 3	car_1
select T2.Horsepower, T1.Make from car_names as T1 join cars_data as T2 on T1.MakeId = T2.Id where T2.Cylinders = 3 order by T2.Horsepower desc limit 1	car_1
select max(cars_data.Horsepower), car_makers.Maker from cars_data inner join car_names on cars_data.Id = car_names.MakeId inner join model_list on car_names.Model = model_list.Model inner join car_makers on model_list.Maker = car_makers.Id where cars_data.Cylinders = 3	car_1
select car_names.Model from car_names join cars_data on cars_data.Id = car_names.MakeId order by cars_data.MPG desc limit 1	car_1
select T1.Model from model_list as T1 inner join car_names as T2 on T2.Model = T1.Model inner join cars_data as T3 on T3.Id = T2.MakeId order by T3.MPG desc limit 1	car_1
select avg(Horsepower) from cars_data where Year < 1980	car_1
select avg(Horsepower) from cars_data where Year < 1980	car_1
select avg(T3.Edispl) from model_list as T1 join car_names as T2 on T1.Model = T2.Model join cars_data as T3 on T2.MakeId = T3.Id where T1.Model = "volvo"	car_1
select avg(cars_data.Edispl) from car_makers inner join model_list on model_list.Maker = car_makers.Id inner join car_names on car_names.Model = model_list.Model inner join cars_data on cars_data.Id = car_names.MakeId where car_makers.Maker = "volvo"	car_1
select Cylinders, max(Accelerate) from cars_data group by Cylinders	car_1
select Cylinders, max(Accelerate) from cars_data group by Cylinders	car_1
select model_list.Model, count(car_names.Make) from model_list join car_names on model_list.Model = car_names.Model group by model_list.Model order by count(car_names.Make) desc limit 1	car_1
select model_list.Model from model_list join car_names on model_list.Model = car_names.Model group by model_list.Model order by count(distinct car_names.MakeId) desc limit 1	car_1
select count(*) from cars_data where Cylinders > 4	car_1
select count(*) from cars_data where Cylinders > 4	car_1
select count(*) from cars_data where Year = 1980	car_1
select count(*) from cars_data where Year = 1980	car_1
select count(*) from car_makers join model_list on model_list.Maker = car_makers.Id where car_makers.FullName = "American Motor Company"	car_1
select count(*) from car_makers inner join model_list on model_list.Maker = car_makers.Id where car_makers.FullName = "American Motor Company"	car_1
select car_makers.FullName, car_makers.Id from car_makers join model_list on car_makers.Id = model_list.Maker group by car_makers.FullName, car_makers.Id having count(model_list.Model) > 3	car_1
select car_makers.Maker, car_makers.Id from car_makers join model_list on car_makers.Id = model_list.Maker group by car_makers.Maker, car_makers.Id having count(model_list.ModelId) > 3	car_1
select distinct T1.Model from model_list as T1 join car_makers as T2 on T1.Maker = T2.Id left join car_names as T3 on T3.Model = T1.Model left join cars_data as T4 on T3.MakeId = T4.Id where T2.FullName = "General Motors" or T4.Weight > 3500	car_1
select distinct model_list.Model from model_list left join car_makers on model_list.Maker = car_makers.Id left join car_names on car_names.Model = model_list.Model left join cars_data on cars_data.Id = car_names.MakeId where car_makers.FullName = "General Motors" or cars_data.Weight > 3500	car_1
select Year from cars_data where Weight >= 3000 and Weight <= 4000	car_1
select distinct Year from cars_data where Weight < 4000 intersect select distinct Year from cars_data where Weight > 3000	car_1
select Horsepower from cars_data order by Accelerate desc limit 1	car_1
select Horsepower from cars_data order by Accelerate desc limit 1	car_1
select T4.Cylinders from car_makers as T1 inner join model_list as T2 on T2.Maker = T1.Id inner join car_names as T3 on T3.Model = T2.Model inner join cars_data as T4 on T4.Id = T3.MakeId where T1.Maker = "volvo" order by T4.Accelerate asc limit 1	car_1
select cars_data.Cylinders from car_makers inner join model_list on model_list.Maker = car_makers.Id inner join car_names on car_names.Model = model_list.Model inner join cars_data on cars_data.Id = car_names.MakeId where car_makers.Maker = "volvo" order by cars_data.Accelerate asc limit 1	car_1
select count(*) from cars_data where Accelerate > (select max(Horsepower) from cars_data)	car_1
select count(*) from cars_data where Accelerate > (select max(Horsepower) from cars_data)	car_1
select count(*) from (select T1.CountryId from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country group by T1.CountryId having count(T2.Id) > 2)	car_1
select count(*) from countries join car_makers on car_makers.Country = countries.CountryId group by countries.CountryId having count(car_makers.Id) > 2	car_1
select count(*) from cars_data where Cylinders > 6	car_1
select count(*) from cars_data where Cylinders > 6	car_1
select car_names.Model from cars_data inner join car_names on cars_data.Id = car_names.MakeId where cars_data.Cylinders = 4 order by cars_data.Horsepower desc limit 1	car_1
select car_names.Model from cars_data join car_names on cars_data.Id = car_names.MakeId where cars_data.Cylinders = 4 order by cars_data.Horsepower desc limit 1	car_1
select car_makers.Id, car_makers.FullName from car_makers join model_list on model_list.Maker = car_makers.Id join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where cars_data.Horsepower > (select min(Horsepower) from cars_data) and cars_data.Cylinders <= 3	car_1
select car_makers.Id, car_makers.FullName from car_makers join model_list on model_list.Maker = car_makers.Id join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where cars_data.Horsepower <> (select min(Horsepower) from cars_data) and cars_data.Cylinders < 4	car_1
select max(MPG) from cars_data where (Cylinders = 8) or (Year < 1980)	car_1
select max(MPG) from cars_data where Cylinders = 8 or Year < 1980	car_1
select model_list.Model from model_list join car_makers on model_list.Maker = car_makers.Id join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where cars_data.Weight < 3500 and car_makers.FullName <> "Ford Motor Company"	car_1
select distinct model_list.Model from model_list join car_makers on model_list.Maker = car_makers.Id join car_names on car_names.Model = model_list.Model join cars_data on cars_data.Id = car_names.MakeId where cars_data.Weight < 3500 and car_makers.FullName <> "Ford Motor Company"	car_1
select CountryName from countries where CountryId not in (select Country from car_makers)	car_1
select countries.CountryName from countries left join car_makers on countries.CountryId = car_makers.Country where car_makers.Country is null	car_1
select car_makers.Id, car_makers.Maker from car_makers join model_list on model_list.Maker = car_makers.Id group by car_makers.Id, car_makers.Maker having count(model_list.ModelId) >= 2 and (select count(distinct car_makers.Id) from car_makers) > 3	car_1
select car_makers.Id, car_makers.Maker from car_makers join model_list on model_list.Maker = car_makers.Id join car_names on car_names.Model = model_list.Model group by car_makers.Id, car_makers.Maker having count(distinct model_list.Model) >= 2 and count(car_names.MakeId) > 3	car_1
select countries.CountryId, countries.CountryName from countries join car_makers on car_makers.Country = countries.CountryId where car_makers.Id in (select Maker from model_list where model_list.Model = "fiat") union select countries.CountryId, countries.CountryName from countries join car_makers on car_makers.Country = countries.CountryId group by countries.CountryId, countries.CountryName having count(*) > 3	car_1
select countries.CountryId, countries.CountryName from countries where countries.CountryId in (select car_makers.Country from car_makers group by car_makers.Country having count(*) > 3) or countries.CountryId in (select car_makers.Country from car_makers join model_list on model_list.Maker = car_makers.Id where model_list.Model = "fiat")	car_1
