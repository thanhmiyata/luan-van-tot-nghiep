select count(distinct Continent) from continents	car_1
select count(distinct Continent) from continents	car_1
select continents.ContId, continents.Continent, count(countries.CountryId) from continents inner join countries on continents.ContId = countries.Continent group by continents.ContId, continents.Continent	car_1
select T1.ContId, T1.Continent, count(distinct T2.CountryId) from continents as T1 join countries as T2 on T1.ContId = T2.Continent group by T1.ContId	car_1
select count(*) from countries	car_1
select count(*) from countries	car_1
select T1.FullName, T1.Id, count(*) from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.Id	car_1
select car_makers.FullName, car_makers.Id, count(*) from car_makers left join model_list on car_makers.Id = model_list.Maker group by car_makers.Id	car_1
select T2.Model from cars_data as T1 join model_list as T2 on T1.Id = T2.ModelId order by T1.Horsepower asc limit 1	car_1
select car_names.Model from cars_data join car_names on cars_data.Id = car_names.MakeId order by cars_data.Horsepower asc limit 1	car_1
select T1.Model from model_list as T1 join cars_data as T2 on T1.ModelId = T2.Id where T2.Weight < (select avg(Weight) from cars_data)	car_1
select model_list.Model from cars_data join model_list on model_list.ModelId = cars_data.ModelId where cars_data.Weight < (select avg(Weight) from cars_data)	car_1
select distinct T1.Maker from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker join car_names as T3 on T2.Model = T3.Model join cars_data as T4 on T3.MakeId = T4.Id where T4.Year = 1970	car_1
select distinct car_makers.Maker from car_makers join model_list on car_makers.Id = model_list.Maker join car_names on model_list.ModelId = car_names.MakeId join cars_data on car_names.Id = cars_data.Id where cars_data.Year = 1970	car_1
select T1.Make, T2.Year from car_names as T1 join cars_data as T2 on T1.MakeId = T2.Id where T2.Year = (select min(Year) from cars_data) order by T2.Year asc	car_1
select car_makers.Maker, cars_data.Year from cars_data join car_makers on cars_data.MakeId = car_makers.Id order by cars_data.Year asc limit 1	car_1
select distinct T1.Model from model_list as T1 join car_names as T2 on T1.Model = T2.Model join cars_data as T3 on T2.MakeId = T3.Id where T3.Year > 1980	car_1
select distinct T1.Model from model_list as T1 join car_names as T2 on T1.Model = T2.Model join cars_data as T3 on T2.MakeId = T3.Id where T3.Year > 1980	car_1
select continents.Continent, count(distinct car_makers.Maker) from continents join countries on continents.ContId = countries.Continent join car_makers on countries.CountryId = car_makers.Country group by continents.Continent	car_1
select continents.Continent, count(car_makers.Id) from continents join countries on continents.ContId = countries.Continent join car_makers on countries.CountryId = car_makers.Country group by continents.Continent	car_1
select countries.CountryName from countries join car_makers on countries.CountryId = car_makers.Country group by countries.CountryName order by count(*) desc limit 1	car_1
select T1.CountryName from countries as T1 join car_makers as T2 on T2.Country = T1.CountryId group by T1.CountryName order by count(T2.Id) desc limit 1	car_1
select T1.FullName, count(T2.ModelId) as "Model count" from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.FullName	car_1
select count(distinct model_list.ModelId), car_makers.Id, car_makers.FullName from car_makers join model_list on model_list.Maker = car_makers.Id group by car_makers.Id	car_1
select T2.Accelerate from car_names as T1 join cars_data as T2 on T1.MakeId = T2.Id where T1.Make = "amc hornet sportabout (sw)"	car_1
select T1.Accelerate from cars_data as T1 join car_names as T2 on T1.Id = T2.MakeId where T2.Model = "amc hornet sportabout (sw)"	car_1
select count(distinct Id) from car_makers where Country = "France"	car_1
select count(distinct Maker) from car_makers where Country = "France"	car_1
select count(*) from model_list join car_makers on model_list.Maker = car_makers.Id where car_makers.Country = "USA"	car_1
select count(model_list.ModelId) from model_list join car_makers on model_list.Maker = car_makers.Id join countries on car_makers.Country = countries.CountryId where countries.CountryName = "United States"	car_1
select avg(MPG) from cars_data where Cylinders = 4	car_1
select avg(MPG) from cars_data where Cylinders = 4	car_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	car_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	car_1
select 1	car_1
select car_makers.Maker, model_list.Model from car_makers join model_list on model_list.Maker = car_makers.Id	car_1
select distinct T1.CountryName, T1.CountryId from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country	car_1
select distinct countries.CountryName, countries.CountryId from countries join car_makers on countries.CountryId = car_makers.Country	car_1
select count(*) from cars_data where Horsepower > 150	car_1
select count(*) from cars_data where Horsepower > 150	car_1
select Year, avg(Weight) from cars_data group by Year	car_1
select avg(Weight), Year from cars_data group by Year	car_1
select T1.CountryName from countries as T1 join continents as T2 on T1.Continent = T2.ContId join car_makers as T3 on T1.CountryId = T3.Country where T2.Continent = "Europe" group by T1.CountryName having count(distinct T3.Id) >= 3	car_1
select T1.CountryName from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country where T1.Continent = "European" group by T1.CountryName having count(T2.Id) >= 3	car_1
select T1.Horsepower, T3.Maker from cars_data as T1 join car_names as T2 on T1.Id = T2.MakeId join car_makers as T3 on T2.MakeId = T3.Id where T1.Cylinders = 3 order by T1.Horsepower desc limit 1	car_1
select T1.Horsepower, T4.Maker from cars_data as T1 join car_names as T2 on T1.Id = T2.MakeId join model_list as T3 on T2.Model = T3.Model join car_makers as T4 on T3.Maker = T4.Id where T1.Cylinders = 3 order by T1.Horsepower desc limit 1	car_1
select T1.Model, T2.MPG from model_list as T1 join cars_data as T2 on T1.ModelId = T2.Id order by T2.MPG desc limit 1	car_1
select T1.Model from model_list as T1 inner join cars_data as T2 on T1.ModelId = T2.Id order by T2.MPG desc limit 1	car_1
select avg(Horsepower) from cars_data where Year < 1980	car_1
select avg(Horsepower) from cars_data where Year < 1980	car_1
select avg(T2.Edispl) from model_list as T1 join cars_data as T2 on T1.ModelId = T2.ModelId where T1.Model = "volvo"	car_1
select avg(T1.Edispl) from cars_data as T1 join model_list as T2 on T1.Id = T2.Model join car_makers as T3 on T2.Maker = T3.Id where T3.Maker = "Volvo"	car_1
select Cylinders, max(Accelerate) from cars_data group by Cylinders	car_1
select max(Accelerate) from cars_data group by Cylinders	car_1
select T1.Model, count(T2.Make) from model_list as T1 join car_names as T2 on T1.ModelId = T2.ModelId group by T1.Model order by version_count desc limit 1	car_1
select model_list.Model from model_list join car_names on model_list.ModelId = car_names.Model group by model_list.ModelId order by count(*) desc limit 1	car_1
select count(*) from cars_data where Cylinders > 4	car_1
select count(*) from cars_data where Cylinders > 4	car_1
select count(*) from cars_data where Year = 1980	car_1
select count(*) from cars_data where Year = 1980	car_1
select count(*) from model_list join car_makers on model_list.Maker = car_makers.Id where car_makers.FullName = "American Motor Company"	car_1
select count(*) from car_makers join model_list on model_list.Maker = car_makers.Id where car_makers.Maker = "American Motor Company"	car_1
select car_makers.FullName, car_makers.Id from car_makers join model_list on model_list.Maker = car_makers.Id group by car_makers.FullName, car_makers.Id having count(model_list.ModelId) > 3	car_1
select car_makers.Maker, car_makers.Id from car_makers join model_list on model_list.Maker = car_makers.Id group by car_makers.Id having count(model_list.ModelId) > 3	car_1
select distinct T2.Model from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker join car_names as T3 on T2.Model = T3.Model join cars_data as T4 on T3.MakeId = T4.Id where T1.FullName = "General Motors" or T4.Weight > 3500	car_1
select distinct model_list.Model from model_list join car_makers on model_list.Maker = car_makers.Id join cars_data on cars_data.Model = model_list.ModelId where car_makers.Maker = "General Motors" or cars_data.Weight > 3500	car_1
select distinct Year from cars_data where Weight between 3000 and 4000	car_1
select distinct Year from cars_data where Weight < 4000 intersect select distinct Year from cars_data where Weight > 3000	car_1
select Horsepower from cars_data order by Accelerate desc limit 1	car_1
select Horsepower from cars_data order by Accelerate desc limit 1	car_1
select T1.Cylinders from cars_data as T1 join car_names as T2 on T1.Id = T2.MakeId join model_list as T3 on T2.Model = T3.Model where T3.Model like "%volvo%" order by T1.Accelerate asc limit 1	car_1
select cars_data.Cylinders from car_makers join cars_data on car_makers.Id = cars_data.Id where car_makers.Maker like "Volvo" order by cars_data.Accelerate asc limit 1	car_1
select count(*) from cars_data where Accelerate > (select max(Horsepower) from cars_data)	car_1
select count(*) from cars_data where Accelerate > (select max(Horsepower) from cars_data)	car_1
select count(T1.CountryName) from countries as T1 join (select T2.Country from car_makers as T2 group by T2.Country having count(T2.Id) > 2) on T1.CountryName = subquery.Country	car_1
select count(*) from (select T1.CountryId from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country group by T1.CountryId having count(T2.Id) > 2)	car_1
select count(*) from cars_data where Cylinders > 6	car_1
select count(*) from cars_data where Cylinders > 6	car_1
select car_names.Model from cars_data join car_names on cars_data.Id = car_names.MakeId where cars_data.Cylinders = 4 order by cars_data.Horsepower desc limit 1	car_1
select model_list.Model, cars_data.Horsepower from cars_data join model_list on cars_data.Id = model_list.ModelId where cars_data.Cylinders = 4 order by cars_data.Horsepower desc limit 1	car_1
select T1.Id , T1.FullName from car_makers as T1 join cars_data as T2 on T2.MakeId = T1.Id where T2.Horsepower > (select min(Horsepower) from cars_data) and T2.Cylinders <= 3	car_1
select T1.MakeId, T1.Make from car_names as T1 join cars_data as T2 on T1.MakeId = T2.MakeId where T2.Horsepower <> (select min(Horsepower) from cars_data) and T2.Cylinders < 4	car_1
select max(MPG) from cars_data where Cylinders = 8 or Year < 1980	car_1
select max(MPG) from cars_data where Cylinders = 8 or Year < 1980	car_1
select T3.Model from cars_data as T1 join car_names as T2 on T1.Id = T2.MakeId join model_list as T3 on T2.Model = T3.Model join car_makers as T4 on T3.Maker = T4.Id where T1.Weight < 3500 and T4.Maker <> "Ford Motor Company"	car_1
select distinct model_list.Model from cars_data join model_list on cars_data.Model = model_list.Id join car_makers on model_list.Maker = car_makers.Id where cars_data.Weight < 3500 and car_makers.Maker <> "Ford Motor Company"	car_1
select CountryName from countries left join car_makers on countries.CountryId = car_makers.Country where car_makers.Country is null	car_1
select T1.CountryName from countries as T1 left join car_makers as T2 on T1.CountryId = T2.Country where T2.Country is null	car_1
select T1.Id, T1.Maker from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.Id, T1.Maker having count(T2.ModelId) >= 2 and (select count(T3.Id) from car_makers as T3) > 3	car_1
select car_makers.Id, car_makers.Maker from car_makers join model_list on car_makers.Id = model_list.Maker join car_names on car_makers.Id = car_names.MakeId group by car_makers.Id, car_makers.Maker having count(distinct model_list.Model) >= 2 and count(car_names.Model) > 3	car_1
select countries.CountryId, countries.CountryName from countries join car_makers on countries.CountryId = car_makers.Country left join model_list on car_makers.Id = model_list.Maker where EXISTS (select 1 from car_makers cm where cm.Country = countries.CountryId group by cm.Country having count(distinct cm.Id) > 3) or model_list.Model = "fiat"	car_1
select countries.CountryId, countries.CountryName from countries where countries.CountryId in (select car_makers.Country from car_makers group by car_makers.Country having count(distinct car_makers.Id) > 3) or countries.CountryId in (select car_makers.Country from car_makers join model_list on car_makers.Id = model_list.Maker where model_list.Model = "fiat")	car_1
