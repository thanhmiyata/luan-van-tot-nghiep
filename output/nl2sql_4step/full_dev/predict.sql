select Name from country where IndepYear > 1950	world_1
select Name from country where IndepYear > 1950	world_1
select count(*) from country where GovernmentForm = "Republic"	world_1
select count(*) from country where GovernmentForm = "Republic"	world_1
select sum(SurfaceArea) from country where Region = "Caribbean"	world_1
select sum(SurfaceArea) from country where Region = "Caribbean"	world_1
select Continent from country where Name = "Anguilla"	world_1
select Continent from country where Name = "Anguilla"	world_1
select country.Region from city join country on city.CountryCode = country.Code where city.Name = "Kabul"	world_1
select country.Region from city inner join country on city.CountryCode = country.Code where city.Name = "Kabul"	world_1
select countrylanguage.Language from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where country.Name = "Aruba" order by countrylanguage.Percentage desc limit 1	world_1
select countrylanguage.Language from country join countrylanguage on country.Code = countrylanguage.CountryCode where country.Name = "Aruba"	world_1
select Population, LifeExpectancy from country where Name = "Brazil"	world_1
select Population, LifeExpectancy from country where Name = "Brazil"	world_1
select Region, Population from country where Name = "Angola"	world_1
select Region, Population from country where Name = "Angola"	world_1
select avg(LifeExpectancy) from country where Region = "Central Africa"	world_1
select avg(LifeExpectancy) from country where Region = "Central Africa"	world_1
select Name from country where Continent = "Asia" order by LifeExpectancy asc limit 1	world_1
select Name from country where Continent = "Asia" order by LifeExpectancy asc limit 1	world_1
select sum(Population), max(GNP) from country where Continent = "Asia"	world_1
select count(*), max(GNP) from country where Continent = "Asia"	world_1
select avg(LifeExpectancy) from country where Continent = "Africa" and GovernmentForm = "Republic"	world_1
select avg(LifeExpectancy) from country where Continent = "Africa" and GovernmentForm = "Republic"	world_1
select sum(SurfaceArea) from country where Continent = "Asia" or Continent = "Europe"	world_1
select sum(SurfaceArea) from country where Continent = "Asia" or Continent = "Europe"	world_1
select count(*) from city where District = "Gelderland"	world_1
select sum(Population) from city where District = "Gelderland"	world_1
select avg(GNP), sum(Population) from country where GovernmentForm = "US Territory"	world_1
select avg(GNP), sum(Population) from country where GovernmentForm = "US Territory"	world_1
select count(distinct Language) from countrylanguage	world_1
select count(distinct Language) from countrylanguage	world_1
select count(*) from (select distinct GovernmentForm from country where Continent = "Africa")	world_1
select count(distinct GovernmentForm) from country where Continent = "Africa"	world_1
select count(*) from country inner join countrylanguage on countrylanguage.CountryCode = country.Code where country.Name = "Aruba"	world_1
select count(*) from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where country.Name = "Aruba"	world_1
select count(*) from country join countrylanguage on country.Code = countrylanguage.CountryCode where country.Name = "Afghanistan" and countrylanguage.IsOfficial = "T"	world_1
select count(*) from countrylanguage inner join country on countrylanguage.CountryCode = country.Code where country.Name = "Afghanistan" and countrylanguage.IsOfficial = "T"	world_1
select country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Code, country.Name order by count(countrylanguage.Language) desc limit 1	world_1
select country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Code, country.Name order by count(countrylanguage.Language) desc limit 1	world_1
select country.Continent from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Continent order by count(distinct countrylanguage.Language) desc limit 1	world_1
select c.Continent from country c join countrylanguage cl on c.Code = cl.CountryCode group by c.Continent order by count(*) desc limit 1	world_1
select count(*) from (select CountryCode from countrylanguage where Language = "English" intersect select CountryCode from countrylanguage where Language = "Dutch")	world_1
select count(*) from (select CountryCode from countrylanguage where Language = "English" intersect select CountryCode from countrylanguage where Language = "Dutch")	world_1
select country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "English" intersect select country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "French"	world_1
select Name from country where Code in (select CountryCode from countrylanguage where Language = "English" intersect select CountryCode from countrylanguage where Language = "French")	world_1
select distinct c.Name from country c join countrylanguage cl1 on c.Code = cl1.CountryCode join countrylanguage cl2 on c.Code = cl2.CountryCode where cl1.Language = "English" and cl1.IsOfficial = "T" and cl2.Language = "French" and cl2.IsOfficial = "T"	world_1
select distinct country.Name from country join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.Language = "English" intersect select distinct country.Name from country join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.Language = "French"	world_1
select count(distinct country.Continent) from country join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.Language = "Chinese"	world_1
select count(*) from country inner join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.Language = "Chinese"	world_1
select distinct country.Region from country join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.Language = "English" or countrylanguage.Language = "Dutch"	world_1
select distinct country.Region from country join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.Language = "Dutch" or countrylanguage.Language = "English"	world_1
select distinct country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where (countrylanguage.Language = "English" and countrylanguage.IsOfficial = "T") union select distinct country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where (countrylanguage.Language = "Dutch" and countrylanguage.IsOfficial = "T")	world_1
select distinct country.Name from country join countrylanguage on country.Code = countrylanguage.CountryCode where (countrylanguage.Language = "English" and countrylanguage.IsOfficial = "T") or (countrylanguage.Language = "Dutch" and countrylanguage.IsOfficial = "T")	world_1
select countrylanguage.Language from countrylanguage join country on countrylanguage.CountryCode = country.Code where country.Continent = "Asia" order by countrylanguage.Percentage desc limit 1	world_1
select cl.Language from countrylanguage cl join country c on cl.CountryCode = c.Code where c.Continent = "Asia" group by cl.Language order by count(*) desc limit 1	world_1
select countrylanguage.Language from countrylanguage join country on countrylanguage.CountryCode = country.Code where country.GovernmentForm = "Republic" group by countrylanguage.Language having count(distinct countrylanguage.CountryCode) = 1	world_1
select Language from countrylanguage join country on countrylanguage.CountryCode = country.Code where country.GovernmentForm = "Republic" group by Language having count(countrylanguage.CountryCode) = 1	world_1
select city.Name from city join countrylanguage on city.CountryCode = countrylanguage.CountryCode where countrylanguage.Language = "English" order by city.Population desc limit 1	world_1
select city.Name from city join countrylanguage on city.CountryCode = countrylanguage.CountryCode where countrylanguage.Language = "English" order by city.Population desc limit 1	world_1
select Name, Population, LifeExpectancy from country where Continent = "Asia" order by SurfaceArea desc limit 1	world_1
select Name, Population, LifeExpectancy from country where Continent = "Asia" order by SurfaceArea desc limit 1	world_1
select avg(country.LifeExpectancy) from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English" and countrylanguage.IsOfficial = "T"	world_1
select avg(country.LifeExpectancy) as LifeExpectancy from country where not EXISTS (select 1 from countrylanguage where countrylanguage.CountryCode = country.Code and countrylanguage.Language = "English" and countrylanguage.IsOfficial = "T")	world_1
select sum(country.Population) from country where not EXISTS (select 1 from countrylanguage where country.Code = countrylanguage.CountryCode and countrylanguage.Language = "English")	world_1
select count(*) from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English"	world_1
select countrylanguage.Language from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where country.HeadOfState = "Beatrix"	world_1
select countrylanguage.Language from country join countrylanguage on countrylanguage.CountryCode = country.Code where country.HeadOfState = "Beatrix" and countrylanguage.IsOfficial = "T"	world_1
select count(distinct countrylanguage.Language) as count from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where country.IndepYear < 1930 and countrylanguage.IsOfficial = "T"	world_1
select count(distinct countrylanguage.Language) from country join countrylanguage on country.Code = countrylanguage.CountryCode where country.IndepYear < 1930	world_1
select country.Name from country where country.SurfaceArea > (select max(SurfaceArea) from country where Continent = "Europe")	world_1
select Name from country where SurfaceArea > (select max(SurfaceArea) from country where Continent = "Europe")	world_1
select Name from country where Continent = "Africa" and Population < (select min(Population) from country where Continent = "Asia")	world_1
select Name from country where Continent = "Africa" and Population < (select min(Population) from country where Continent = "Asia")	world_1
select Name from country where Continent = "Asia" and Population > (select max(Population) from country where Continent = "Africa")	world_1
select Name from country where Continent = "Asia" and Population > (select max(Population) from country where Continent = "Africa")	world_1
select distinct country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English"	world_1
select Code from country where not EXISTS (select 1 from countrylanguage where countrylanguage.CountryCode = country.Code and countrylanguage.Language = "English")	world_1
select country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English"	world_1
select distinct country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English"	world_1
select country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language <> "English" and country.GovernmentForm <> "Republic"	world_1
select country.Code from country join countrylanguage on countrylanguage.CountryCode = country.Code where countrylanguage.Language <> "English" and country.GovernmentForm <> "Republic"	world_1
select city.Name from city join country on city.CountryCode = country.Code join countrylanguage on country.Code = countrylanguage.CountryCode where country.Continent = "Europe" and countrylanguage.Language = "English" and countrylanguage.IsOfficial <> "T"	world_1
select city.Name from city join country on city.CountryCode = country.Code join countrylanguage on country.Code = countrylanguage.CountryCode where country.Continent = "Europe" and countrylanguage.IsOfficial = "T" and countrylanguage.Language <> "English"	world_1
select distinct city.Name from city join country on city.CountryCode = country.Code join countrylanguage on country.Code = countrylanguage.CountryCode where country.Continent = "Asia" and countrylanguage.Language = "Chinese" and countrylanguage.IsOfficial = "T"	world_1
select distinct city.Name from city inner join country on city.CountryCode = country.Code inner join countrylanguage on country.Code = countrylanguage.CountryCode where country.Continent = "Asia" and countrylanguage.Language = "Chinese" and countrylanguage.IsOfficial = "T"	world_1
select Name, IndepYear, SurfaceArea from country order by Population asc limit 1	world_1
select Name, IndepYear, SurfaceArea from country order by Population asc limit 1	world_1
select Population, Name, HeadOfState from country where SurfaceArea = (select max(SurfaceArea) from country)	world_1
select Name, Population, HeadOfState from country order by SurfaceArea desc limit 1	world_1
select country.Name, count(countrylanguage.Language) from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Name having count(countrylanguage.Language) >= 3	world_1
select country.Name, count(*) from country join countrylanguage on country.Code = countrylanguage.CountryCode group by country.Name having count(*) > 2	world_1
select District, count(*) as count from city where Population > (select avg(Population) from city) group by District	world_1
select District, count(*) from city where Population > (select avg(Population) from city) group by District	world_1
select GovernmentForm, sum(Population) from country group by GovernmentForm having avg(LifeExpectancy) > 72	world_1
select GovernmentForm, sum(Population) from country group by GovernmentForm having avg(LifeExpectancy) > (select avg(LifeExpectancy) from country)	world_1
select avg(LifeExpectancy), sum(Population) from country where LifeExpectancy < 72 group by Continent	world_1
select Continent, sum(Population), avg(LifeExpectancy) from country group by Continent having avg(LifeExpectancy) < 72	world_1
select Name, SurfaceArea from country order by SurfaceArea desc limit 5	world_1
select Name, SurfaceArea from country order by SurfaceArea desc limit 5	world_1
select Name from country order by Population desc limit 3	world_1
select Name from country order by Population desc limit 3	world_1
select Name from country order by Population asc limit 3	world_1
select Name from country order by Population asc limit 3	world_1
select count(*) from country where Continent = "Asia"	world_1
select count(*) from country where Continent = "Asia"	world_1
select Name from country where Continent = "Europe" and Population = 80000	world_1
select Name from country where Continent = "Europe" and Population = 80000	world_1
select sum(Population), avg(SurfaceArea) from country where Continent = "North America" and SurfaceArea > 3000	world_1
select sum(Population), avg(SurfaceArea) from country where Continent = "North America" and SurfaceArea > 3000	world_1
select Name from city where Population between 160000 and 900000	world_1
select Name from city where Population between 160000 and 900000	world_1
select Language from countrylanguage group by Language having count(*) = (select max(language_count) from (select count(*) as language_count from countrylanguage group by Language))	world_1
select Language from countrylanguage group by Language having count(*) = (select max(country_count) from (select Language, count(*) as country_count from countrylanguage group by Language))	world_1
select Language, CountryCode from countrylanguage where (CountryCode, Percentage) in (select CountryCode, max(Percentage) from countrylanguage group by CountryCode)	world_1
select country.Code, countrylanguage.Language from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Percentage = (select max(cl2.Percentage) from countrylanguage cl2 where cl2.CountryCode = countrylanguage.CountryCode)	world_1
select count(*) from (select CountryCode from countrylanguage where Language = "Spanish" order by Percentage desc limit 1)	world_1
select count(*) from country inner join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "Spanish"	world_1
select country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "Spanish" order by countrylanguage.Percentage desc limit 1	world_1
select country.Code from country join countrylanguage on country.Code = countrylanguage.CountryCode where countrylanguage.Language = "Spanish"	world_1
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
select count(*) from Documents	cre_Doc_Template_Mgt
select count(*) from Documents	cre_Doc_Template_Mgt
select Document_ID, Document_Name, Document_Description from Documents	cre_Doc_Template_Mgt
select Document_ID, Document_Name, Document_Description from Documents	cre_Doc_Template_Mgt
select Document_Name, Template_ID from Documents where Document_Description like "%w%"	cre_Doc_Template_Mgt
select Document_Name, Template_ID from Documents where Document_Description like "%w%"	cre_Doc_Template_Mgt
select Document_ID, Template_ID, Document_Description from Documents where Document_Name = "Robbin CV"	cre_Doc_Template_Mgt
select Document_ID, Template_ID, Document_Description from Documents where Document_Name = "Robbin CV"	cre_Doc_Template_Mgt
select count(distinct Documents.Template_ID) from Documents	cre_Doc_Template_Mgt
select count(distinct Template_Type_Code) from Templates	cre_Doc_Template_Mgt
select count(*) from Documents join Templates on Documents.Template_ID = Templates.Template_ID where Templates.Template_Type_Code = "PPT"	cre_Doc_Template_Mgt
select count(*) from Documents join Templates on Documents.Template_ID = Templates.Template_ID where Templates.Template_Type_Code = "PPT"	cre_Doc_Template_Mgt
select Templates.Template_ID, count(Documents.Document_ID) from Templates left join Documents on Templates.Template_ID = Documents.Template_ID group by Templates.Template_ID	cre_Doc_Template_Mgt
select Template_ID, count(*) from Documents group by Template_ID	cre_Doc_Template_Mgt
select Templates.Template_ID, Templates.Template_Type_Code from Templates join Documents on Templates.Template_ID = Documents.Template_ID group by Templates.Template_ID, Templates.Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Templates.Template_ID, Templates.Template_Type_Code from Templates join Documents on Templates.Template_ID = Documents.Template_ID group by Templates.Template_ID, Templates.Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Template_ID from Documents group by Template_ID having count(*) > 1	cre_Doc_Template_Mgt
select T2.Template_ID from Documents as T2 group by T2.Template_ID having count(T2.Template_ID) > 1	cre_Doc_Template_Mgt
select Template_ID from Templates where Template_ID not in (select Template_ID from Documents)	cre_Doc_Template_Mgt
select Template_ID from Templates where Template_ID not in (select Template_ID from Documents)	cre_Doc_Template_Mgt
select count(Template_ID) from Templates	cre_Doc_Template_Mgt
select count(*) from Templates	cre_Doc_Template_Mgt
select Template_ID, Version_Number, Template_Type_Code from Templates	cre_Doc_Template_Mgt
select Template_ID, Version_Number, Template_Type_Code from Templates	cre_Doc_Template_Mgt
select distinct Template_Type_Code from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_ID from Templates where Template_Type_Code in ("PP", "PPT")	cre_Doc_Template_Mgt
select Template_ID from Templates where Template_Type_Code in ("PP", "PPT")	cre_Doc_Template_Mgt
select count(*) from Templates where Template_Type_Code = "CV"	cre_Doc_Template_Mgt
select count(*) from Templates where Template_Type_Code = "CV"	cre_Doc_Template_Mgt
select Version_Number, Template_Type_Code from Templates where Version_Number > 5	cre_Doc_Template_Mgt
select Version_Number, Template_Type_Code from Templates where Version_Number > 5	cre_Doc_Template_Mgt
select Templates.Template_Type_Code, count(*) from Templates group by Templates.Template_Type_Code	cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code, count(Templates.Template_ID) as "count of Templates" from Ref_Template_Types left join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code group by Ref_Template_Types.Template_Type_Code	cre_Doc_Template_Mgt
select T.Template_Type_Code from Templates as T group by T.Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code from Templates group by Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code group by Ref_Template_Types.Template_Type_Code having count(*) < 3	cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code group by Ref_Template_Types.Template_Type_Code having count(*) < 3	cre_Doc_Template_Mgt
select min(Version_Number), Template_Type_Code from Templates group by Template_Type_Code order by min(Version_Number) asc	cre_Doc_Template_Mgt
select min(Version_Number), Template_Type_Code from Templates group by Template_Type_Code	cre_Doc_Template_Mgt
select T2.Template_Type_Code from Documents as T1 join Templates as T3 on T1.Template_ID = T3.Template_ID join Ref_Template_Types as T2 on T3.Template_Type_Code = T2.Template_Type_Code where T1.Document_Name = "Data base"	cre_Doc_Template_Mgt
select T1.Template_Type_Code from Ref_Template_Types as T1 join Templates as T2 on T1.Template_Type_Code = T2.Template_Type_Code join Documents as T3 on T2.Template_ID = T3.Template_ID where T3.Document_Name = "Data base"	cre_Doc_Template_Mgt
select Document_Name from Documents join Templates on Documents.Template_ID = Templates.Template_ID where Templates.Template_Type_Code = "BK"	cre_Doc_Template_Mgt
select T1.Document_Name from Documents as T1 join Templates as T2 on T1.Template_ID = T2.Template_ID where T2.Template_Type_Code = "BK"	cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code, count(*) from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code join Documents on Templates.Template_ID = Documents.Template_ID group by Ref_Template_Types.Template_Type_Code	cre_Doc_Template_Mgt
select Ref_Template_Types.Template_Type_Code, count(*) from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code join Documents on Templates.Template_ID = Documents.Template_ID group by Ref_Template_Types.Template_Type_Code	cre_Doc_Template_Mgt
select T.Template_Type_Code from Templates as T join Documents as D on T.Template_ID = D.Template_ID group by T.Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code from Templates group by Template_Type_Code order by count(*) desc limit 1	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Code not in (select Template_Type_Code from Templates where Template_ID in (select Template_ID from Documents))	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Code not in (select T.Template_Type_Code from Documents as D join Templates as T on D.Template_ID = T.Template_ID)	cre_Doc_Template_Mgt
select Template_Type_Code, Template_Type_Description from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_Type_Code, Template_Type_Description from Ref_Template_Types	cre_Doc_Template_Mgt
select Template_Type_Description from Ref_Template_Types where Template_Type_Code = "AD"	cre_Doc_Template_Mgt
select Template_Type_Description from Ref_Template_Types where Template_Type_Code = "AD"	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Description = "Book"	cre_Doc_Template_Mgt
select Template_Type_Code from Ref_Template_Types where Template_Type_Description = "Book"	cre_Doc_Template_Mgt
select distinct Ref_Template_Types.Template_Type_Description from Ref_Template_Types join Templates on Ref_Template_Types.Template_Type_Code = Templates.Template_Type_Code join Documents on Templates.Template_ID = Documents.Template_ID	cre_Doc_Template_Mgt
select distinct T1.Template_Type_Description from Ref_Template_Types as T1 join Templates as T2 on T1.Template_Type_Code = T2.Template_Type_Code join Documents as T3 on T2.Template_ID = T3.Template_ID	cre_Doc_Template_Mgt
select Templates.Template_ID from Templates join Ref_Template_Types on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code where Ref_Template_Types.Template_Type_Description = "Presentation"	cre_Doc_Template_Mgt
select Templates.Template_ID from Templates join Ref_Template_Types on Templates.Template_Type_Code = Ref_Template_Types.Template_Type_Code where Ref_Template_Types.Template_Type_Description = "Presentation"	cre_Doc_Template_Mgt
select count(*) from Paragraphs	cre_Doc_Template_Mgt
select count(*) from Paragraphs	cre_Doc_Template_Mgt
select count(*) from Paragraphs join Documents on Paragraphs.Document_ID = Documents.Document_ID where Documents.Document_Name = "Summer Show"	cre_Doc_Template_Mgt
select count(*) from Paragraphs inner join Documents on Paragraphs.Document_ID = Documents.Document_ID where Documents.Document_Name = "Summer Show"	cre_Doc_Template_Mgt
select Paragraph_ID, Document_ID, Paragraph_Text, Other_Details from Paragraphs where Paragraph_Text = "Korea"	cre_Doc_Template_Mgt
select Paragraph_ID, Document_ID, Paragraph_Text, Other_Details from Paragraphs where Paragraph_Text like "%Korea%"	cre_Doc_Template_Mgt
select T1.Paragraph_ID, T1.Paragraph_Text from Paragraphs as T1 join Documents as T2 on T1.Document_ID = T2.Document_ID where T2.Document_Name = "Welcome to NY"	cre_Doc_Template_Mgt
select Paragraphs.Paragraph_ID, Paragraphs.Paragraph_Text from Paragraphs join Documents on Paragraphs.Document_ID = Documents.Document_ID where Documents.Document_Name = "Welcome to NY"	cre_Doc_Template_Mgt
select Paragraph_Text from Paragraphs join Documents on Paragraphs.Document_ID = Documents.Document_ID where Document_Name = "Customer reviews"	cre_Doc_Template_Mgt
select T2.Paragraph_Text from Documents as T1 join Paragraphs as T2 on T1.Document_ID = T2.Document_ID where T1.Document_Name = "Customer reviews"	cre_Doc_Template_Mgt
select Documents.Document_ID, count(Paragraphs.Paragraph_ID) from Documents left join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID order by Documents.Document_ID asc	cre_Doc_Template_Mgt
select p.Document_ID, count(*) from Paragraphs as p group by p.Document_ID order by p.Document_ID asc	cre_Doc_Template_Mgt
select Documents.Document_ID, Documents.Document_Name, count(Paragraphs.Paragraph_ID) from Documents left join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID, Documents.Document_Name	cre_Doc_Template_Mgt
select Documents.Document_ID, Documents.Document_Name, count(Paragraphs.Paragraph_ID) from Documents left join Paragraphs on Documents.Document_ID = Paragraphs.Document_ID group by Documents.Document_ID, Documents.Document_Name	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID having count(*) >= 2	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID having count(*) >= 2	cre_Doc_Template_Mgt
select T1.Document_ID, T1.Document_Name from Documents as T1 join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID, T1.Document_Name order by count(T2.Paragraph_ID) desc limit 1	cre_Doc_Template_Mgt
select d.Document_ID, d.Document_Name from Documents d inner join Paragraphs p on d.Document_ID = p.Document_ID group by d.Document_ID, d.Document_Name order by count(*) desc limit 1	cre_Doc_Template_Mgt
select p.Document_ID from Paragraphs p group by p.Document_ID order by count(*) asc limit 1	cre_Doc_Template_Mgt
select d.Document_ID from Documents d join Paragraphs p on d.Document_ID = p.Document_ID group by d.Document_ID order by count(*) asc limit 1	cre_Doc_Template_Mgt
select T1.Document_ID from Documents as T1 join Paragraphs as T2 on T1.Document_ID = T2.Document_ID group by T1.Document_ID having count(*) between 1 and 2	cre_Doc_Template_Mgt
select Document_ID from Paragraphs group by Document_ID having count(*) between 1 and 2	cre_Doc_Template_Mgt
select Document_ID from Paragraphs where Paragraph_Text like "%Brazil%" intersect select Document_ID from Paragraphs where Paragraph_Text like "%Ireland%"	cre_Doc_Template_Mgt
select Document_ID from Paragraphs where Paragraph_Text like "%Brazil%" intersect select Document_ID from Paragraphs where Paragraph_Text like "%Ireland%"	cre_Doc_Template_Mgt
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
select Country from airlines where Airline = "JetBlue Airways"	flight_2
select Country from airlines where Airline = "Jetblue Airways"	flight_2
select Abbreviation from airlines where Airline = "JetBlue Airways"	flight_2
select Abbreviation from airlines where Airline = "Jetblue Airways"	flight_2
select Airline, Abbreviation from airlines where Country = "USA"	flight_2
select Airline, Abbreviation from airlines where Country = "USA"	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select count(distinct Airline) from airlines	flight_2
select count(distinct Airline) from airlines	flight_2
select count(*) from airports	flight_2
select count(*) from airports	flight_2
select count(*) from flights	flight_2
select count(*) from flights	flight_2
select Airline from airlines where Abbreviation = "UAL"	flight_2
select Airline from airlines where Abbreviation = "UAL"	flight_2
select count(*) from airlines where Country = "USA"	flight_2
select count(uid) from airlines where Country = "USA"	flight_2
select City, Country from airports where AirportName = "Alton"	flight_2
select City, Country from airports where AirportName = "Alton"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select AirportName from airports where TRIM(City) = "Aberdeen"	flight_2
select AirportName from airports where City = "Aberdeen"	flight_2
select count(*) from flights where SourceAirport = " APG"	flight_2
select count(*) from flights where SourceAirport = " APG"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select count(*) from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen "	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select count(*) from flights join airports as source_airport on flights.SourceAirport = source_airport.AirportCode join airports as dest_airport on flights.DestAirport = dest_airport.AirportCode where source_airport.City = "Aberdeen " and dest_airport.City = "Ashley"	flight_2
select count(*) from flights as T1 join airports as T2 on T1.SourceAirport = T2.AirportCode join airports as T3 on T1.DestAirport = T3.AirportCode where T2.City = "Aberdeen" and T3.City = "Ashley"	flight_2
select count(*) from flights where Airline = "JetBlue Airways"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "Jetblue Airways"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "United Airlines" and flights.DestAirport = " ASY"	flight_2
select count(*) from flights where Airline = "United Airlines" and DestAirport = " ASY"	flight_2
select count(*) from flights where Airline = "United Airlines" and SourceAirport = "AHD"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where flights.SourceAirport = "AHD" and airlines.Airline = "United Airlines"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid join airports on flights.DestAirport = airports.AirportCode where airlines.Airline = "United Airlines" and airports.City = "Aberdeen "	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where flights.Airline = "United Airlines" and airports.City = "Aberdeen"	flight_2
select airports.City from airports join flights on airports.AirportCode = flights.DestAirport group by airports.City order by count(*) desc limit 1	flight_2
select a.City from flights as f join airports as a on f.DestAirport = a.AirportCode group by a.City order by count(*) desc limit 1	flight_2
select a.City from airports a join flights f on f.SourceAirport = a.AirportCode group by a.City order by count(*) desc limit 1	flight_2
select City from airports join flights on airports.AirportCode = flights.SourceAirport group by City order by count(*) desc limit 1	flight_2
select a.AirportCode from airports as a join flights as f on a.AirportCode = f.SourceAirport group by a.AirportCode order by count(*) desc limit 1	flight_2
select T1.AirportCode from airports as T1 join flights as T2 on T1.AirportCode = T2.SourceAirport group by T1.AirportCode order by count(T2.SourceAirport) desc limit 1	flight_2
select a.AirportCode from airports as a join flights as f on a.AirportCode = f.SourceAirport group by a.AirportCode order by count(*) asc limit 1	flight_2
select AirportCode from airports where AirportCode = (select SourceAirport from flights group by SourceAirport order by count(*) asc limit 1)	flight_2
select Airline from flights group by Airline order by count(*) desc limit 1	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline order by count(*) desc limit 1	flight_2
select a.Abbreviation, a.Country from airlines a join flights f on a.Airline = f.Airline group by a.Abbreviation, a.Country order by count(*) asc limit 1	flight_2
select a.Abbreviation, a.Country from airlines as a join flights as f on a.uid = f.Airline group by a.uid order by count(*) asc limit 1	flight_2
select distinct airlines.Airline from airlines join flights on airlines.Airline = flights.Airline where flights.SourceAirport = "AHD"	flight_2
select distinct T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline where T2.SourceAirport = "AHD"	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline where T2.DestAirport = "AHD"	flight_2
select Airline from airlines where uid in (select Airline from flights where DestAirport = "AHD")	flight_2
select Airline from flights where SourceAirport in ("APG", "CVO") group by Airline having count(distinct SourceAirport) = 2	flight_2
select a.Airline from airlines as a join flights as f on a.Airline = f.Airline where f.SourceAirport = "APG" intersect select a.Airline from airlines as a join flights as f on a.Airline = f.Airline where f.SourceAirport = "CVO"	flight_2
select distinct f1.Airline from flights f1 where f1.SourceAirport = "CVO" and f1.Airline not in (select f2.Airline from flights f2 where f2.SourceAirport = "APG")	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline where T2.SourceAirport = "CVO" except select T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline where T2.SourceAirport = "APG"	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline group by T1.Airline having count(*) >= 10	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline group by T1.Airline having count(*) >= 10	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline having count(*) < 200	flight_2
select a.Airline from airlines as a join flights as f on a.Airline = f.Airline group by a.Airline having count(*) < 200	flight_2
select FlightNo from flights where Airline = "United Airlines"	flight_2
select T1.FlightNo from flights as T1 join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines"	flight_2
select FlightNo from flights where SourceAirport = "APG"	flight_2
select FlightNo from flights where SourceAirport = "APG"	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select FlightNo from flights where SourceAirport in (select AirportCode from airports where City = "Aberdeen ")	flight_2
select T1.FlightNo from flights as T1 inner join airports as T2 on T1.SourceAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select f.FlightNo from flights f join airports a on f.DestAirport = a.AirportCode where a.City = "Aberdeen"	flight_2
select T1.FlightNo from flights as T1 join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen " or airports.City = "Abilene "	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen " or airports.City = "Abilene "	flight_2
select AirportName from airports where AirportCode not in (select SourceAirport from flights union select DestAirport from flights)	flight_2
select AirportName from airports where AirportCode not in (select SourceAirport from flights union select DestAirport from flights)	flight_2
select line_1, line_2 from Addresses	student_transcripts_tracking
select line_1, line_2 from Addresses	student_transcripts_tracking
select count(*) from Courses	student_transcripts_tracking
select count(course_id) from Courses	student_transcripts_tracking
select course_description from Courses where course_name = "math"	student_transcripts_tracking
select course_description from Courses where course_name like "%math%"	student_transcripts_tracking
select zip_postcode from Addresses where city = "Port Chelsea"	student_transcripts_tracking
select zip_postcode from Addresses where city = "Port Chelsea"	student_transcripts_tracking
select T1.department_name, T1.department_id from Departments as T1 join Degree_Programs as T2 on T1.department_id = T2.department_id group by T1.department_id order by count(*) desc limit 1	student_transcripts_tracking
select d.department_name, d.department_id from Departments d join Degree_Programs dp on d.department_id = dp.department_id group by d.department_id order by count(*) desc limit 1	student_transcripts_tracking
select count(distinct Departments.department_id) from Departments join Degree_Programs on Departments.department_id = Degree_Programs.department_id	student_transcripts_tracking
select count(distinct department_id) from Degree_Programs	student_transcripts_tracking
select count(distinct degree_summary_name) from Degree_Programs	student_transcripts_tracking
select count(distinct degree_summary_name) from Degree_Programs	student_transcripts_tracking
select count(*) from Degree_Programs join Departments on Degree_Programs.department_id = Departments.department_id where Departments.department_name = "engineering"	student_transcripts_tracking
select count(*) from Degree_Programs join Departments on Degree_Programs.department_id = Departments.department_id where Departments.department_name = "engineering"	student_transcripts_tracking
select section_name, section_description from Sections	student_transcripts_tracking
select section_name, section_description from Sections	student_transcripts_tracking
select course_name, course_id from Courses where course_id in (select course_id from Sections group by course_id having count(*) <= 2)	student_transcripts_tracking
select course_name, course_id from Courses where course_id not in (select course_id from Sections group by course_id having count(section_id) >= 2)	student_transcripts_tracking
select section_name from Sections order by section_name desc	student_transcripts_tracking
select section_name from Sections order by section_name desc	student_transcripts_tracking
select Semesters.semester_name, Semesters.semester_id from Student_Enrolment join Semesters on Student_Enrolment.semester_id = Semesters.semester_id group by Semesters.semester_name, Semesters.semester_id order by count(*) desc limit 1	student_transcripts_tracking
select s.semester_name, s.semester_id from Semesters s join Student_Enrolment se on s.semester_id = se.semester_id group by s.semester_id, s.semester_name order by count(se.student_id) desc limit 1	student_transcripts_tracking
select department_description from Departments where department_name like "%the computer%"	student_transcripts_tracking
select department_description from Departments where department_name like "%computer%"	student_transcripts_tracking
select distinct T1.first_name, T1.middle_name, T1.last_name, T1.student_id from Students as T1 join Student_Enrolment as T2 on T1.student_id = T2.student_id group by T1.student_id, T1.first_name, T1.middle_name, T1.last_name, T2.semester_id having count(distinct T2.degree_program_id) = 2	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name, T1.student_id from Students as T1 join (select distinct student_id from Student_Enrolment group by student_id, semester_id having count(distinct degree_program_id) = 2) on T1.student_id = T2.student_id	student_transcripts_tracking
select Students.first_name, Students.middle_name, Students.last_name from Students join Student_Enrolment on Students.student_id = Student_Enrolment.student_id join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where Degree_Programs.degree_summary_name = "Bachelor"	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name from Students as T1 join Student_Enrolment as T2 on T1.student_id = T2.student_id join Degree_Programs as T3 on T2.degree_program_id = T3.degree_program_id where T3.degree_summary_name = "Bachelor"	student_transcripts_tracking
select degree_summary_name from Degree_Programs join Student_Enrolment on Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id group by degree_summary_name order by count(*) desc limit 1	student_transcripts_tracking
select degree_summary_name from Degree_Programs join Student_Enrolment on Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id group by degree_summary_name order by count(*) desc limit 1	student_transcripts_tracking
select Degree_Programs.degree_program_id, Degree_Programs.degree_summary_description from Degree_Programs join Student_Enrolment on Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id group by Degree_Programs.degree_program_id, Degree_Programs.degree_summary_description order by count(*) desc limit 1	student_transcripts_tracking
select Degree_Programs.degree_program_id, Degree_Programs.degree_summary_name from Degree_Programs join Student_Enrolment on Degree_Programs.degree_program_id = Student_Enrolment.degree_program_id group by Degree_Programs.degree_program_id, Degree_Programs.degree_summary_name order by count(*) desc limit 1	student_transcripts_tracking
select s.student_id, s.first_name, s.middle_name, s.last_name, count(se.student_id), s.student_id from Students s join Student_Enrolment se on s.student_id = se.student_id group by s.student_id, s.first_name, s.middle_name, s.last_name order by number_of_enrollments desc limit 1	student_transcripts_tracking
select S.first_name, S.middle_name, S.last_name, S.student_id, count(SE.student_enrolment_id) from Students as S join Student_Enrolment as SE on S.student_id = SE.student_id group by S.student_id, S.first_name, S.middle_name, S.last_name order by count(SE.student_enrolment_id) desc limit 1	student_transcripts_tracking
select semester_name from Semesters where semester_id not in (select semester_id from Student_Enrolment)	student_transcripts_tracking
select semester_name from Semesters where semester_id not in (select semester_id from Student_Enrolment)	student_transcripts_tracking
select course_name from Courses where course_id in (select course_id from Student_Enrolment_Courses)	student_transcripts_tracking
select course_name from Courses where course_id in (select distinct course_id from Student_Enrolment_Courses)	student_transcripts_tracking
select T1.course_name from Courses as T1 join Student_Enrolment_Courses as T2 on T1.course_id = T2.course_id group by T1.course_name order by count(T2.student_course_id) desc limit 1	student_transcripts_tracking
select T1.course_name from Courses as T1 join Student_Enrolment_Courses as T2 on T1.course_id = T2.course_id group by T1.course_name order by count(*) desc limit 1	student_transcripts_tracking
select Students.last_name from Students where Students.current_address_id in (select address_id from Addresses where state_province_county = "North Carolina") and Students.student_id not in (select student_id from Student_Enrolment)	student_transcripts_tracking
select S.last_name from Students S join Addresses A on S.current_address_id = A.address_id where A.state_province_county = "North Carolina" and S.student_id not in (select student_id from Student_Enrolment)	student_transcripts_tracking
select T1.transcript_date, T1.transcript_id from Transcripts as T1 join Transcript_Contents as T2 on T1.transcript_id = T2.transcript_id group by T1.transcript_id, T1.transcript_date having count(*) >= 2	student_transcripts_tracking
select T.transcript_date, T.transcript_id from Transcripts as T join Transcript_Contents as TC on T.transcript_id = TC.transcript_id group by T.transcript_id, T.transcript_date having count(*) >= 2	student_transcripts_tracking
select cell_mobile_number from Students where first_name = "Timmothy" and last_name = "Ward"	student_transcripts_tracking
select cell_mobile_number from Students where first_name = "Timmothy" and last_name = "Ward"	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	student_transcripts_tracking
select first_name, middle_name, last_name from Students order by date_first_registered asc limit 1	student_transcripts_tracking
select T1.first_name, T1.middle_name, T1.last_name from Students as T1 join Student_Enrolment as T2 on T1.student_id = T2.student_id join Student_Enrolment_Courses as T3 on T2.student_enrolment_id = T3.student_enrolment_id join Transcript_Contents as T4 on T3.student_course_id = T4.student_course_id join Transcripts as T5 on T4.transcript_id = T5.transcript_id order by T5.transcript_date asc limit 1	student_transcripts_tracking
select first_name from Students where current_address_id <> permanent_address_id	student_transcripts_tracking
select first_name from Students where current_address_id <> permanent_address_id	student_transcripts_tracking
select T1.address_id, T1.line_1, T1.line_2, T1.line_3 from Addresses as T1 join Students as T2 on T2.current_address_id = T1.address_id group by T1.address_id, T1.line_1, T1.line_2, T1.line_3 order by count(*) desc limit 1	student_transcripts_tracking
select T1.address_id, T1.line_1, T1.line_2 from Addresses as T1 join Students as T2 on T1.address_id = T2.current_address_id group by T1.address_id, T1.line_1, T1.line_2 order by count(T2.student_id) desc limit 1	student_transcripts_tracking
select avg(transcript_date) from Transcripts	student_transcripts_tracking
select avg(transcript_date) from Transcripts	student_transcripts_tracking
select transcript_date, other_details from Transcripts order by transcript_date asc limit 1	student_transcripts_tracking
select transcript_date, other_details from Transcripts where transcript_date = (select min(transcript_date) from Transcripts)	student_transcripts_tracking
select count(*) from Transcripts	student_transcripts_tracking
select count(*) from Transcripts	student_transcripts_tracking
select max(transcript_date) from Transcripts	student_transcripts_tracking
select max(transcript_date) from Transcripts	student_transcripts_tracking
select count(t2.transcript_id), t1.student_course_id from Student_Enrolment_Courses as t1 join Transcript_Contents as t2 on t1.student_course_id = t2.student_course_id group by t1.student_course_id order by max_count desc limit 1	student_transcripts_tracking
select count(*), T1.student_enrolment_id from Student_Enrolment_Courses as T1 join Transcript_Contents as T2 on T1.student_course_id = T2.student_course_id group by T1.course_id, T1.student_enrolment_id order by count(*) desc limit 1	student_transcripts_tracking
select T.transcript_date, T.transcript_id from Transcripts as T join Transcript_Contents as TC on T.transcript_id = TC.transcript_id group by T.transcript_id order by count(TC.transcript_id) asc limit 1	student_transcripts_tracking
select T.transcript_date, T.transcript_id from Transcripts as T join Transcript_Contents as TC on T.transcript_id = TC.transcript_id group by T.transcript_date, T.transcript_id order by count(*) asc limit 1	student_transcripts_tracking
select T1.semester_name from Semesters as T1 join Student_Enrolment as T2 on T1.semester_id = T2.semester_id join Degree_Programs as T3 on T2.degree_program_id = T3.degree_program_id where T3.degree_summary_name = "Master" intersect select T1.semester_name from Semesters as T1 join Student_Enrolment as T2 on T1.semester_id = T2.semester_id join Degree_Programs as T3 on T2.degree_program_id = T3.degree_program_id where T3.degree_summary_name = "Bachelor"	student_transcripts_tracking
select semester_id from Student_Enrolment join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where degree_summary_name = "Master" intersect select semester_id from Student_Enrolment join Degree_Programs on Student_Enrolment.degree_program_id = Degree_Programs.degree_program_id where degree_summary_name = "Bachelor"	student_transcripts_tracking
select count(distinct T1.address_id) from Addresses as T1 join Students as T2 on T1.address_id = T2.current_address_id	student_transcripts_tracking
select distinct A.line_1, A.line_2, A.line_3, A.city, A.zip_postcode, A.state_province_county, A.country, A.other_address_details from Addresses as A join Students as S on A.address_id = S.current_address_id or A.address_id = S.permanent_address_id	student_transcripts_tracking
select student_id, current_address_id, permanent_address_id, first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details from Students order by first_name desc	student_transcripts_tracking
select student_id, current_address_id, permanent_address_id, first_name, middle_name, last_name, cell_mobile_number, email_address, ssn, date_first_registered, date_left, other_student_details from Students order by last_name desc	student_transcripts_tracking
select section_name, section_description, other_details from Sections where section_name = "h"	student_transcripts_tracking
select section_description from Sections where section_name = "h"	student_transcripts_tracking
select T1.first_name from Students as T1 join Addresses as T2 on T1.permanent_address_id = T2.address_id where T2.country = "Haiti" or T1.cell_mobile_number = "09700166582"	student_transcripts_tracking
select first_name from Students where permanent_address_id in (select address_id from Addresses where country = "Haiti") or cell_mobile_number = "09700166582"	student_transcripts_tracking
select Title from Cartoon order by Title asc	tvshow
select Title from Cartoon order by Title asc	tvshow
select Title from Cartoon where Directed_by = "Ben Jones"	tvshow
select Title from Cartoon where Directed_by = "Ben Jones"	tvshow
select count(id) from Cartoon where Written_by = "Joseph Kuhr"	tvshow
select count(*) from Cartoon where Written_by = "Joseph Kuhr"	tvshow
select Title, Directed_by from Cartoon order by Original_air_date asc	tvshow
select Title, Directed_by from Cartoon order by Original_air_date asc	tvshow
select Title from Cartoon where Directed_by = "Ben Jones" or Directed_by = "Brandon Vietti"	tvshow
select Title from Cartoon where Directed_by = "Ben Jones" or Directed_by = "Brandon Vietti"	tvshow
select Country, count(id) from TV_Channel group by Country order by number_of_TV_Channels desc limit 1	tvshow
select Country, count(id) from TV_Channel group by Country order by count desc limit 1	tvshow
select count(distinct series_name), count(distinct Content) from TV_Channel	tvshow
select count(distinct series_name), count(distinct Content) from TV_Channel	tvshow
select Content from TV_Channel where series_name = "Sky Radio"	tvshow
select Content from TV_Channel where series_name = "Sky Radio"	tvshow
select Package_Option from TV_Channel where series_name = "Sky Radio"	tvshow
select Package_Option from TV_Channel where series_name = "Sky Radio"	tvshow
select count(Language) from TV_Channel where Language = "English"	tvshow
select count(*) from TV_Channel where Language = "English"	tvshow
select Language, count(id) as "TV Channel count" from TV_Channel group by Language order by count(id) asc	tvshow
select Language, count(id) from TV_Channel group by Language order by channel_count asc limit 1	tvshow
select Language, count(*) as "number of TV Channels" from TV_Channel group by Language	tvshow
select Language, count(id) from TV_Channel group by Language	tvshow
select Cartoon.Channel, TV_Channel.series_name from Cartoon join TV_Channel on Cartoon.Channel = TV_Channel.id where Cartoon.Title = "The Rise of the Blue Beetle!"	tvshow
select series_name from TV_Channel where id = (select Channel from Cartoon where Title = "The Rise of the Blue Beetle!")	tvshow
select Cartoon.Title from Cartoon join TV_Channel on Cartoon.Channel = TV_Channel.id where TV_Channel.series_name = "Sky Radio"	tvshow
select T1.Title from Cartoon as T1 join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select Episode from TV_series order by Rating asc	tvshow
select Episode, Rating from TV_series order by Rating desc	tvshow
select Episode, Rating from TV_series order by Rating desc limit 3	tvshow
select Episode, Rating from TV_series order by Rating desc limit 3	tvshow
select min(Share), max(Share) from TV_series	tvshow
select max(Share), min(Share) from TV_series	tvshow
select Air_Date from TV_series where Episode = "A Love of a Lifetime"	tvshow
select Original_air_date from Cartoon where Title = "A Love of a Lifetime"	tvshow
select Weekly_Rank from TV_series where Episode = "A Love of a Lifetime"	tvshow
select Weekly_Rank from TV_series where Episode = "A Love of a Lifetime"	tvshow
select T1.Channel, T2.series_name from TV_series as T1 join TV_Channel as T2 on T1.Channel = T2.id where T1.Episode = "A Love of a Lifetime"	tvshow
select series_name from TV_Channel where id = (select Channel from TV_series where Episode = "A Love of a Lifetime")	tvshow
select T1.Episode from TV_series as T1 join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select Episode from TV_series join TV_Channel on TV_series.Channel = TV_Channel.id where TV_Channel.series_name = "Sky Radio"	tvshow
select Directed_by, count(id) from Cartoon group by Directed_by	tvshow
select Directed_by, count(id) from Cartoon group by Directed_by	tvshow
select Production_code, Channel from Cartoon order by Original_air_date desc limit 1	tvshow
select Production_code, Channel from Cartoon order by Original_air_date desc limit 1	tvshow
select Package_Option, series_name from TV_Channel where Hight_definition_TV = "yes"	tvshow
select Package_Option, series_name from TV_Channel where Hight_definition_TV = "yes"	tvshow
select T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Written_by = "Todd Casey"	tvshow
select TV_Channel.Country from Cartoon join TV_Channel on Cartoon.Channel = TV_Channel.id where Cartoon.Written_by = "Todd Casey"	tvshow
select TV_Channel.Country from TV_Channel where TV_Channel.id not in (select Cartoon.Channel from Cartoon where Cartoon.Written_by = "Todd Casey")	tvshow
select T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Written_by != "Todd Casey"	tvshow
select TV_Channel.series_name, TV_Channel.Country from TV_Channel join Cartoon on TV_Channel.id = Cartoon.Channel where Cartoon.Directed_by = "Ben Jones" or Cartoon.Directed_by = "Michael Chang"	tvshow
select T1.series_name, T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Directed_by in ("Ben Jones", "Michael Chang") group by T1.id, T1.series_name, T1.Country having count(distinct T2.Directed_by) = 2	tvshow
select Pixel_aspect_ratio_PAR, Country from TV_Channel where Language <> "English"	tvshow
select Pixel_aspect_ratio_PAR, Country from TV_Channel where Language <> "English"	tvshow
select id from TV_Channel where Country in (select Country from TV_Channel group by Country having count(*) > 2)	tvshow
select T1.id from TV_Channel as T1 join TV_series as T2 on T1.id = T2.Channel group by T1.id having count(*) > 2	tvshow
select id from TV_Channel where id not in (select Channel from Cartoon where Directed_by = "Ben Jones")	tvshow
select id from TV_Channel where id not in (select Channel from Cartoon where Directed_by = "Ben Jones")	tvshow
select Package_Option from TV_Channel where id not in (select Channel from Cartoon where Directed_by = "Ben Jones")	tvshow
select T1.Package_Option from TV_Channel as T1 where T1.id not in (select T2.Channel from Cartoon as T2 where T2.Directed_by = "Ben Jones")	tvshow
select count(*) from players	wta_1
select count(*) from players	wta_1
select count(*) from matches	wta_1
select count(*) from matches	wta_1
select first_name, birth_date from players where country_code = "USA"	wta_1
select first_name, birth_date from players where country_code = "USA"	wta_1
select avg(winner_age), avg(loser_age) from matches	wta_1
select avg(loser_age), avg(winner_age) from matches	wta_1
select avg(winner_rank) from matches	wta_1
select avg(winner_rank) as "average rank" from matches	wta_1
select max(loser_rank) from matches	wta_1
select min(loser_rank) from matches	wta_1
select count(distinct country_code) from players	wta_1
select count(distinct country_code) from players	wta_1
select count(distinct loser_name) from matches	wta_1
select count(distinct loser_name) from matches	wta_1
select tourney_name from matches group by tourney_id, tourney_name having count(*) > 10	wta_1
select tourney_name from matches group by tourney_name having count(*) > 10	wta_1
select winner_name from matches where year = 2013 intersect select winner_name from matches where year = 2016	wta_1
select winner_name from matches where year = 2013 intersect select winner_name from matches where year = 2016	wta_1
select count(*) from matches where year in (2013, 2016)	wta_1
select count(*) from matches where year in (2013, 2016)	wta_1
select T1.country_code, T1.first_name from players as T1 join matches as T2 on T1.player_id = T2.winner_id where T2.tourney_name = "WTA Championships" intersect select T1.country_code, T1.first_name from players as T1 join matches as T2 on T1.player_id = T2.winner_id where T2.tourney_name = "Australian Open"	wta_1
select players.first_name, players.country_code from players inner join matches as m1 on players.player_id = m1.winner_id and m1.tourney_name = "WTA Championships" inner join matches as m2 on players.player_id = m2.winner_id and m2.tourney_name = "Australian Open"	wta_1
select first_name, country_code from players order by birth_date asc limit 1	wta_1
select first_name, country_code from players order by birth_date asc limit 1	wta_1
select first_name, last_name from players order by birth_date asc	wta_1
select first_name, last_name from players order by birth_date asc	wta_1
select first_name, last_name from players where hand = "L" order by birth_date asc	wta_1
select first_name, last_name from players where hand = "L" order by birth_date asc	wta_1
select p.first_name, p.country_code from players as p join rankings as r on p.player_id = r.player_id order by r.tours desc limit 1	wta_1
select p.first_name, p.country_code from players p join rankings r on p.player_id = r.player_id order by r.tours desc limit 1	wta_1
select year from matches group by year order by count(*) desc limit 1	wta_1
select year from matches group by year order by count(*) desc limit 1	wta_1
select winner_name, winner_rank_points from matches group by winner_name, winner_rank_points order by count(*) desc limit 1	wta_1
select T1.winner_name, T2.ranking_points from (select winner_id, winner_name, count(*) from matches group by winner_id, winner_name order by num_wins desc limit 1) join rankings as T2 on T1.winner_id = T2.player_id limit 1	wta_1
select winner_name from matches where tourney_name = "Australian Open" order by winner_rank_points desc limit 1	wta_1
select winner_name from matches where tourney_name = "Australian Open" order by winner_rank_points desc limit 1	wta_1
select loser_name, winner_name from matches order by minutes desc limit 1	wta_1
select winner_name, loser_name from matches order by minutes desc limit 1	wta_1
select avg(T1.ranking), T2.first_name from players as T2 join rankings as T1 on T2.player_id = T1.player_id group by T2.player_id	wta_1
select players.first_name, avg(rankings.ranking) from players join rankings on players.player_id = rankings.player_id group by players.first_name	wta_1
select T1.first_name, sum(T2.ranking_points) from players as T1 join rankings as T2 on T1.player_id = T2.player_id group by T1.first_name	wta_1
select players.first_name, sum(rankings.ranking_points) from players join rankings on players.player_id = rankings.player_id group by players.first_name	wta_1
select country_code, count(*) from players group by country_code	wta_1
select country_code, count(player_id) from players group by country_code	wta_1
select country_code from players group by country_code order by count(*) desc limit 1	wta_1
select country_code from players group by country_code order by count(*) desc limit 1	wta_1
select country_code from players group by country_code having count(*) > 50	wta_1
select country_code from players group by country_code having count(*) > 50	wta_1
select count(*), ranking_date from rankings group by ranking_date	wta_1
select sum(tours) as "Total Tours", ranking_date as "Ranking Date" from rankings group by ranking_date	wta_1
select year, count(*) from matches group by year	wta_1
select year, count(*) from matches group by year	wta_1
select winner_name, winner_rank from matches order by winner_age asc limit 3	wta_1
select winner_name, winner_rank from matches order by winner_age asc limit 3	wta_1
select count(distinct winner_id) from matches where tourney_name = "WTA Championships" and winner_hand = "L"	wta_1
select count(*) from matches where winner_hand = "L" and tourney_name = "WTA Championships"	wta_1
select p.first_name, p.country_code, p.birth_date from players as p join matches as m on p.player_id = m.winner_id order by m.winner_rank_points desc limit 1	wta_1
select T1.first_name, T1.country_code, T1.birth_date from players as T1 join matches as T2 on T1.player_id = T2.winner_id order by T2.winner_rank_points desc limit 1	wta_1
select hand, count(player_id) from players group by hand	wta_1
select hand , count(*) from players group by hand	wta_1
select count(ID) from Highschooler	network_1
select count(*) from Highschooler	network_1
select name, grade from Highschooler	network_1
select name, grade from Highschooler	network_1
select grade from Highschooler	network_1
select grade from Highschooler	network_1
select grade from Highschooler where name = "Kyle"	network_1
select grade from Highschooler where name = "Kyle"	network_1
select name from Highschooler where grade = 10	network_1
select name from Highschooler where grade = 10	network_1
select ID from Highschooler where name = "Kyle"	network_1
select ID from Highschooler where name = "Kyle"	network_1
select count(*) from Highschooler where grade in (9, 10)	network_1
select count(*) from Highschooler where grade in (9, 10)	network_1
select grade, count(*) from Highschooler group by grade	network_1
select grade, count(*) from Highschooler group by grade	network_1
select grade from Highschooler group by grade order by count(*) desc limit 1	network_1
select grade from Highschooler group by grade order by count(*) desc limit 1	network_1
select grade from Highschooler group by grade having count(*) >= 4	network_1
select grade from Highschooler group by grade having count(*) >= 4	network_1
select T1.ID, count(T2.friend_id) from Highschooler as T1 left join Friend as T2 on T1.ID = T2.student_id group by T1.ID	network_1
select Highschooler.name, count(Friend.friend_id) from Highschooler left join Friend on Highschooler.ID = Friend.student_id group by Highschooler.ID, Highschooler.name	network_1
select Highschooler.name, count(Friend.student_id) from Highschooler left join Friend on Highschooler.ID = Friend.student_id group by Highschooler.name	network_1
select Highschooler.name, count(Friend.friend_id) from Highschooler left join Friend on Highschooler.ID = Friend.student_id group by Highschooler.name	network_1
select H.name from Highschooler as H join Friend as F on H.ID = F.student_id group by H.ID order by count(*) desc limit 1	network_1
select Highschooler.name from Highschooler join Friend on Highschooler.ID = Friend.student_id group by Highschooler.ID, Highschooler.name order by count(*) desc limit 1	network_1
select T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id group by T1.ID having count(T2.friend_id) >= 3	network_1
select name from Highschooler where ID in (select student_id from Friend group by student_id having count(*) >= 3)	network_1
select T2.name from Highschooler as T1 join Friend as T3 on T1.ID = T3.student_id join Highschooler as T2 on T3.friend_id = T2.ID where T1.name = "Kyle"	network_1
select H2.name from Highschooler H1 join Friend F on H1.ID = F.student_id join Highschooler H2 on F.friend_id = H2.ID where H1.name = "Kyle"	network_1
select count(*) from Friend join Highschooler on Highschooler.ID = Friend.student_id where Highschooler.name = "Kyle"	network_1
select count(*) from Friend join Highschooler on Friend.student_id = Highschooler.ID where Highschooler.name = "Kyle"	network_1
select Highschooler.ID from Highschooler where Highschooler.ID not in (select student_id from Friend)	network_1
select Highschooler.ID from Highschooler left join Friend on (Highschooler.ID = Friend.student_id or Highschooler.ID = Friend.friend_id) where Friend.student_id is null and Friend.friend_id is null	network_1
select T1.name from Highschooler as T1 left join Friend as T2 on T1.ID = T2.student_id where T2.friend_id is null	network_1
select name from Highschooler where ID not in (select student_id from Friend)	network_1
select H.ID from Highschooler H where EXISTS (select 1 from Friend F where F.student_id = H.ID) and EXISTS (select 1 from Likes L where L.liked_id = H.ID)	network_1
select Highschooler.ID from Highschooler where Highschooler.ID in (select student_id from Friend) and Highschooler.ID in (select liked_id from Likes)	network_1
select distinct T1.name from Highschooler as T1 join Friend as T2 on T1.ID = T2.student_id join Likes as T3 on T1.ID = T3.liked_id	network_1
select name from Highschooler where ID in (select student_id from Friend) and ID in (select liked_id from Likes)	network_1
select student_id, count(*) from Likes group by student_id	network_1
select student_id, count(*) from Likes group by student_id	network_1
select Highschooler.name, count(Likes.liked_id) from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Highschooler.name	network_1
select Highschooler.name, count(Likes.student_id) from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Highschooler.ID	network_1
select Highschooler.name from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Highschooler.ID order by count(*) desc limit 1	network_1
select name from Highschooler join Likes on ID = liked_id group by name order by count(*) desc limit 1	network_1
select Highschooler.name from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Highschooler.ID, Highschooler.name having count(*) >= 2	network_1
select Highschooler.name from Highschooler join Likes on Highschooler.ID = Likes.student_id group by Highschooler.ID having count(*) >= 2	network_1
select name from Highschooler where grade > 5 and ID in (select student_id from Friend group by student_id having count(friend_id) >= 2)	network_1
select name from Highschooler where grade > 5 and ID in (select student_id from Friend group by student_id having count(friend_id) >= 2)	network_1
select count(*) from Likes join Highschooler on Likes.student_id = Highschooler.ID where Highschooler.name = "Kyle"	network_1
select count(*) from Likes join Highschooler on Likes.student_id = Highschooler.ID where Highschooler.name = "Kyle"	network_1
select avg(grade) from Highschooler where ID in (select student_id from Friend union select friend_id from Friend)	network_1
select avg(grade) from Highschooler where ID in (select student_id from Friend) or ID in (select friend_id from Friend)	network_1
select min(grade) from Highschooler where ID not in (select student_id from Friend)	network_1
select min(T1.grade) from Highschooler as T1 left join Friend as T2 on T1.ID = T2.student_id where T2.student_id is null	network_1
select count(Singer_ID) from singer	concert_singer
select count(Singer_ID) from singer	concert_singer
select Name, Country, Age from singer order by Age desc	concert_singer
select Name, Country, Age from singer order by Age desc	concert_singer
select avg(Age), min(Age), max(Age) from singer where Country = "France"	concert_singer
select avg(Age), min(Age), max(Age) from singer where Country = "France"	concert_singer
select Name, Song_release_year from singer order by Age asc limit 1	concert_singer
select Name, Song_release_year from singer where Age = (select min(Age) from singer)	concert_singer
select distinct Country from singer where Age > 20	concert_singer
select distinct Country from singer where Age > 20	concert_singer
select Country, count(Singer_ID) from singer group by Country	concert_singer
select Country, count(Singer_ID) from singer group by Country	concert_singer
select Song_Name from singer where Age > (select avg(Age) from singer)	concert_singer
select Song_Name from singer where Age > (select avg(Age) from singer)	concert_singer
select Location, Name from stadium where Capacity between 5000 and 10000	concert_singer
select Location, Name from stadium where Capacity between 5000 and 10000	concert_singer
select max(Capacity), avg(Average) from stadium	concert_singer
select avg(Capacity), max(Capacity) from stadium	concert_singer
select Name, Capacity from stadium order by Average desc limit 1	concert_singer
select Name, Capacity from stadium order by Average desc limit 1	concert_singer
select count(*) from concert where Year = "2014" or Year = "2015"	concert_singer
select count(*) from concert where Year in ("2014", "2015")	concert_singer
select T1.Name, count(T2.concert_ID) as "Number of Concerts" from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID group by T1.Name	concert_singer
select stadium.Name, count(concert.concert_ID) from stadium join concert on stadium.Stadium_ID = concert.Stadium_ID group by stadium.Name	concert_singer
select T1.Name, T1.Capacity from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year >= 2014 group by T1.Stadium_ID order by count(T2.concert_ID) desc limit 1	concert_singer
select T1.Name, T1.Capacity from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year > 2013 group by T1.Stadium_ID order by count(*) desc limit 1	concert_singer
select Year from concert group by Year order by count(*) desc limit 1	concert_singer
select Year from concert group by Year order by count(*) desc limit 1	concert_singer
select Name from stadium where Stadium_ID not in (select Stadium_ID from concert)	concert_singer
select Name from stadium where Stadium_ID not in (select Stadium_ID from concert)	concert_singer
select Country from singer where Age > 40 intersect select Country from singer where Age < 30	concert_singer
select Name from stadium where Stadium_ID not in (select Stadium_ID from concert where Year = "2014")	concert_singer
select Name from stadium where Stadium_ID not in (select Stadium_ID from concert where Year = "2014")	concert_singer
select T1.concert_Name, T1.Theme, count(T2.Singer_ID) from concert as T1 join singer_in_concert as T2 on T1.concert_ID = T2.concert_ID group by T1.concert_Name, T1.Theme	concert_singer
select concert.concert_Name, concert.Theme, count(distinct singer_in_concert.Singer_ID) from concert join singer_in_concert on concert.concert_ID = singer_in_concert.concert_ID group by concert.concert_Name, concert.Theme	concert_singer
select singer.Name, count(singer_in_concert.concert_ID) as "number of concerts" from singer join singer_in_concert on singer.Singer_ID = singer_in_concert.Singer_ID group by singer.Singer_ID	concert_singer
select s.Name, count(c.concert_ID) as "number of concerts" from singer as s join singer_in_concert as sic on s.Singer_ID = sic.Singer_ID join concert as c on sic.concert_ID = c.concert_ID group by s.Name	concert_singer
select T1.Name from singer as T1 join singer_in_concert as T2 on T1.Singer_ID = T2.Singer_ID join concert as T3 on T2.concert_ID = T3.concert_ID where T3.Year = "2014"	concert_singer
select Name from singer join singer_in_concert on singer.Singer_ID = singer_in_concert.Singer_ID join concert on singer_in_concert.concert_ID = concert.concert_ID where concert.Year = 2014	concert_singer
select Name, Country from singer where Song_Name like "%Hey%"	concert_singer
select Name, Country from singer where Song_Name like "%Hey%"	concert_singer
select s.Name, s.Location from stadium as s join concert as c on s.Stadium_ID = c.Stadium_ID where c.Year = "2014" intersect select s.Name, s.Location from stadium as s join concert as c on s.Stadium_ID = c.Stadium_ID where c.Year = "2015"	concert_singer
select T1.Name, T1.Location from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year = "2014" intersect select T1.Name, T1.Location from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year = "2015"	concert_singer
select count(*) from concert join stadium on concert.Stadium_ID = stadium.Stadium_ID where stadium.Capacity = (select max(Capacity) from stadium)	concert_singer
select count(*) from concert where Stadium_ID = (select Stadium_ID from stadium where Capacity = (select max(Capacity) from stadium))	concert_singer
select count(PetID) from Pets where weight > 10	pets_1
select count(*) from Pets where weight > 10	pets_1
select weight from Pets where PetType = "dog" order by pet_age asc limit 1	pets_1
select weight from Pets where PetType = "dog" order by pet_age asc limit 1	pets_1
select max(weight), PetType from Pets group by PetType	pets_1
select max(weight), PetType from Pets group by PetType	pets_1
select count(PetID) from Has_Pet where StuID in (select StuID from Student where Age > 20)	pets_1
select count(*) from Has_Pet where StuID in (select StuID from Student where Age > 20)	pets_1
select count(*) from Has_Pet join Student on Has_Pet.StuID = Student.StuID join Pets on Has_Pet.PetID = Pets.PetID where Student.Sex = "F" and Pets.PetType = "dog"	pets_1
select count(*) from Has_Pet join Student on Has_Pet.StuID = Student.StuID join Pets on Has_Pet.PetID = Pets.PetID where Student.Sex = "F" and Pets.PetType = "dog"	pets_1
select count(distinct PetType) from Pets	pets_1
select count(distinct PetType) from Pets	pets_1
select Student.Fname from Student join Has_Pet on Student.StuID = Has_Pet.StuID join Pets on Has_Pet.PetID = Pets.PetID where Pets.PetType = "cat" or Pets.PetType = "dog"	pets_1
select distinct Student.Fname from Student join Has_Pet on Student.StuID = Has_Pet.StuID join Pets on Has_Pet.PetID = Pets.PetID where Pets.PetType in ("cat", "dog")	pets_1
select T1.Fname from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" intersect select T1.Fname from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "dog"	pets_1
select Fname from Student where StuID in (select StuID from Has_Pet join Pets on Has_Pet.PetID = Pets.PetID where PetType = "cat") and StuID in (select StuID from Has_Pet join Pets on Has_Pet.PetID = Pets.PetID where PetType = "dog")	pets_1
select Student.Major, Student.Age from Student where Student.StuID not in (select Has_Pet.StuID from Has_Pet join Pets on Has_Pet.PetID = Pets.PetID where Pets.PetType = "cat")	pets_1
select Student.Major, Student.Age from Student where Student.StuID not in (select Has_Pet.StuID from Has_Pet join Pets on Has_Pet.PetID = Pets.PetID where Pets.PetType = "cat")	pets_1
select Student.StuID from Student where Student.StuID not in (select Has_Pet.StuID from Has_Pet join Pets on Has_Pet.PetID = Pets.PetID where Pets.PetType = "cat")	pets_1
select StuID from Student where StuID not in (select H.StuID from Has_Pet H join Pets P on H.PetID = P.PetID where P.PetType = "cat")	pets_1
select T1.Fname, T1.Age from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "dog" and T1.StuID not in (select T2.StuID from Has_Pet as T2 join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat")	pets_1
select Fname from Student where StuID in (select StuID from Has_Pet where PetID in (select PetID from Pets where PetType = "dog")) and StuID not in (select StuID from Has_Pet where PetID in (select PetID from Pets where PetType = "cat"))	pets_1
select PetType, weight from Pets where pet_age = (select min(pet_age) from Pets)	pets_1
select PetType, weight from Pets order by pet_age asc limit 1	pets_1
select PetID, weight from Pets where pet_age > 1	pets_1
select PetID, weight from Pets where pet_age > 1	pets_1
select PetType, avg(pet_age), max(pet_age) from Pets group by PetType	pets_1
select PetType, avg(pet_age), max(pet_age) from Pets group by PetType	pets_1
select PetType, avg(weight) from Pets group by PetType	pets_1
select PetType, avg(weight) from Pets group by PetType	pets_1
select T1.Fname, T1.Age from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID	pets_1
select Student.Fname, Student.Age from Student inner join Has_Pet on Student.StuID = Has_Pet.StuID	pets_1
select Has_Pet.PetID from Student join Has_Pet on Student.StuID = Has_Pet.StuID where Student.LName = "Smith"	pets_1
select T2.PetID from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID where T1.LName = "Smith"	pets_1
select Student.StuID, count(Has_Pet.PetID) from Student join Has_Pet on Student.StuID = Has_Pet.StuID group by Student.StuID	pets_1
select Student.StuID, count(Has_Pet.PetID) from Student join Has_Pet on Student.StuID = Has_Pet.StuID group by Student.StuID	pets_1
select Student.Fname, Student.Sex from Student join Has_Pet on Student.StuID = Has_Pet.StuID group by Student.StuID, Student.Fname, Student.Sex having count(*) > 1	pets_1
select Student.Fname, Student.Sex from Student where Student.StuID in (select StuID from Has_Pet group by StuID having count(PetID) > 1)	pets_1
select Student.LName from Student join Has_Pet on Student.StuID = Has_Pet.StuID join Pets on Has_Pet.PetID = Pets.PetID where Pets.PetType = "cat" and Pets.pet_age = 3	pets_1
select T1.LName from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.pet_age = 3 and T3.PetType = "cat"	pets_1
select avg(Age) from Student where StuID not in (select StuID from Has_Pet)	pets_1
select avg(T1.Age) from Student as T1 left join Has_Pet as T2 on T1.StuID = T2.StuID where T2.StuID is null	pets_1
select count(*) from conductor	orchestra
select count(*) from conductor	orchestra
select Name from conductor order by Age asc	orchestra
select Name from conductor order by Age asc	orchestra
select Name from conductor where Nationality <> "USA"	orchestra
select Name from conductor where Nationality <> "USA"	orchestra
select Record_Company, Year_of_Founded from orchestra order by Year_of_Founded desc	orchestra
select Record_Company from orchestra order by Year_of_Founded desc	orchestra
select avg(Attendance) from show	orchestra
select avg(Attendance) from show	orchestra
select max(Share), min(Share) from performance where Type <> "Live final"	orchestra
select max(Share), min(Share) from performance where Type <> "Live final"	orchestra
select count(distinct Nationality) from conductor	orchestra
select count(distinct Nationality) from conductor	orchestra
select Name, Year_of_Work from conductor order by Year_of_Work desc	orchestra
select Name from conductor order by Year_of_Work desc	orchestra
select Name from conductor order by Year_of_Work desc limit 1	orchestra
select Name from conductor order by Year_of_Work desc limit 1	orchestra
select conductor.Name, orchestra.Orchestra from conductor join orchestra on conductor.Conductor_ID = orchestra.Conductor_ID	orchestra
select T1.Name, T2.Orchestra from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID	orchestra
select Name from conductor where Conductor_ID in (select Conductor_ID from orchestra group by Conductor_ID having count(distinct Orchestra_ID) > 1)	orchestra
select Name from conductor where Conductor_ID in (select Conductor_ID from orchestra group by Conductor_ID having count(distinct Orchestra_ID) > 1)	orchestra
select T1.Name from conductor as T1 join orchestra as T2 on T1.Conductor_ID = T2.Conductor_ID group by T1.Conductor_ID order by count(T2.Orchestra_ID) desc limit 1	orchestra
select Name from conductor where Conductor_ID = (select Conductor_ID from orchestra group by Conductor_ID order by count(Orchestra_ID) desc limit 1)	orchestra
select conductor.Name from conductor join orchestra on conductor.Conductor_ID = orchestra.Conductor_ID where orchestra.Year_of_Founded > 2008	orchestra
select Name from conductor join orchestra on conductor.Conductor_ID = orchestra.Conductor_ID where Year_of_Founded > 2008	orchestra
select Record_Company, count(distinct Orchestra) from orchestra group by Record_Company	orchestra
select Record_Company, count(Orchestra_ID) from orchestra group by Record_Company	orchestra
select Major_Record_Format, count(*) from orchestra group by Major_Record_Format order by count(*) asc	orchestra
select Major_Record_Format, count(*) from orchestra group by Major_Record_Format order by frequency desc	orchestra
select Record_Company from orchestra group by Record_Company order by count(Orchestra_ID) desc limit 1	orchestra
select Record_Company from orchestra group by Record_Company order by count(*) desc limit 1	orchestra
select Orchestra from orchestra where Orchestra_ID not in (select Orchestra_ID from performance)	orchestra
select Orchestra from orchestra where Orchestra_ID not in (select Orchestra_ID from performance)	orchestra
select Record_Company from orchestra where Year_of_Founded < 2003 intersect select Record_Company from orchestra where Year_of_Founded > 2003	orchestra
select Record_Company from orchestra where Year_of_Founded < 2003 intersect select Record_Company from orchestra where Year_of_Founded > 2003	orchestra
select count(*) from orchestra where Major_Record_Format = "CD" or Major_Record_Format = "DVD"	orchestra
select count(*) from orchestra where Major_Record_Format = "CD" or Major_Record_Format = "DVD"	orchestra
select Year_of_Founded from orchestra where Orchestra_ID in (select Orchestra_ID from performance group by Orchestra_ID having count(*) > 1)	orchestra
select Year_of_Founded from orchestra where Orchestra_ID in (select Orchestra_ID from performance group by Orchestra_ID having count(*) > 1)	orchestra
select count(Poker_Player_ID) from poker_player	poker_player
select count(*) from poker_player	poker_player
select Earnings from poker_player order by Earnings desc	poker_player
select Earnings from poker_player order by Earnings desc	poker_player
select Final_Table_Made, Best_Finish from poker_player	poker_player
select Final_Table_Made, Best_Finish from poker_player	poker_player
select avg(Earnings) from poker_player	poker_player
select avg(Earnings) from poker_player	poker_player
select Money_Rank from poker_player order by Earnings desc limit 1	poker_player
select Money_Rank from poker_player order by Earnings desc limit 1	poker_player
select max(Final_Table_Made) from poker_player where Earnings < 200000	poker_player
select max(Final_Table_Made) from poker_player where Earnings < 200000	poker_player
select Name from people	poker_player
select Name from people join poker_player on people.People_ID = poker_player.People_ID	poker_player
select Name from people inner join poker_player on people.People_ID = poker_player.People_ID where poker_player.Earnings > 300000	poker_player
select people.Name from poker_player inner join people on poker_player.People_ID = people.People_ID where poker_player.Earnings > 300000	poker_player
select people.Name from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Final_Table_Made asc	poker_player
select T1.Name from people as T1 join poker_player as T2 on T1.People_ID = T2.People_ID order by T2.Final_Table_Made asc	poker_player
select people.Birth_Date from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Earnings asc limit 1	poker_player
select T1.Birth_Date from people as T1 join poker_player as T2 on T1.People_ID = T2.People_ID order by T2.Earnings asc limit 1	poker_player
select T1.Money_Rank from poker_player as T1 join people as T2 on T1.People_ID = T2.People_ID order by T2.Height desc limit 1	poker_player
select p.Money_Rank from poker_player as p join people as pe on p.People_ID = pe.People_ID order by pe.Height desc limit 1	poker_player
select avg(poker_player.Earnings) from poker_player join people on poker_player.People_ID = people.People_ID where people.Height > 200	poker_player
select avg(Earnings) from poker_player join people on poker_player.People_ID = people.People_ID where Height > 200	poker_player
select T1.Name from poker_player as T2 join people as T1 on T2.People_ID = T1.People_ID order by T2.Earnings desc	poker_player
select T1.Name from people as T1 join poker_player as T2 on T1.People_ID = T2.People_ID order by T2.Earnings desc	poker_player
select Nationality, count(People_ID) from people group by Nationality	poker_player
select Nationality, count(*) from people group by Nationality	poker_player
select Nationality from people group by Nationality order by count(*) desc limit 1	poker_player
select Nationality from people group by Nationality order by count(*) desc limit 1	poker_player
select Nationality from people group by Nationality having count(*) >= 2	poker_player
select Nationality from people group by Nationality having count(*) >= 2	poker_player
select Name, Birth_Date from people order by Name asc	poker_player
select Name, Birth_Date from people order by Name asc	poker_player
select Name from people where Nationality <> "Russia"	poker_player
select Name from people where Nationality <> "Russia"	poker_player
select Name from people where People_ID not in (select People_ID from poker_player)	poker_player
select T1.Name from people as T1 left join poker_player as T2 on T1.People_ID = T2.People_ID where T2.People_ID is null	poker_player
select count(distinct Nationality) from people	poker_player
select count(distinct Nationality) from people	poker_player
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
select count(Teacher_ID) from teacher	course_teach
select count(Teacher_ID) from teacher	course_teach
select Name from teacher order by Age asc	course_teach
select Name from teacher order by Age asc	course_teach
select Age, Hometown from teacher	course_teach
select Age, Hometown from teacher	course_teach
select Name from teacher where Hometown <> "Little Lever Urban District"	course_teach
select Name from teacher where Hometown <> "Little Lever Urban District"	course_teach
select Name from teacher where Age in (32, 33)	course_teach
select Name from teacher where Age = "32" or Age = "33"	course_teach
select Hometown from teacher order by Age asc limit 1	course_teach
select Hometown from teacher order by Age asc limit 1	course_teach
select Hometown, count(*) from teacher group by Hometown	course_teach
select Hometown, count(Teacher_ID) from teacher group by Hometown	course_teach
select Hometown from teacher group by Hometown order by count(*) desc limit 1	course_teach
select Hometown from teacher group by Hometown order by count(*) desc	course_teach
select Hometown from teacher group by Hometown having count(*) >= 2	course_teach
select Hometown from teacher group by Hometown having count(*) >= 2	course_teach
select teacher.Name, course.Course from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID join course on course_arrange.Course_ID = course.Course_ID	course_teach
select T1.Name, T3.Course from teacher as T1 join course_arrange as T2 on T1.Teacher_ID = T2.Teacher_ID join course as T3 on T2.Course_ID = T3.Course_ID	course_teach
select t.Name, c.Course from teacher as t join course_arrange as ca on t.Teacher_ID = ca.Teacher_ID join course as c on ca.Course_ID = c.Course_ID order by t.Name asc	course_teach
select T1.Name, T3.Course from teacher as T1 join course_arrange as T2 on T1.Teacher_ID = T2.Teacher_ID join course as T3 on T2.Course_ID = T3.Course_ID order by T1.Name asc	course_teach
select T2.Name from course as T1 join course_arrange as T3 on T1.Course_ID = T3.Course_ID join teacher as T2 on T3.Teacher_ID = T2.Teacher_ID where T1.Course = "Math"	course_teach
select teacher.Name from course join course_arrange on course.Course_ID = course_arrange.Course_ID join teacher on course_arrange.Teacher_ID = teacher.Teacher_ID where course.Course = "Math"	course_teach
select teacher.Name, count(course_arrange.Course_ID) from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID group by teacher.Name	course_teach
select T1.Name, count(T2.Course_ID) from teacher as T1 join course_arrange as T2 on T1.Teacher_ID = T2.Teacher_ID group by T1.Name	course_teach
select teacher.Name from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID group by teacher.Teacher_ID, teacher.Name having count(course_arrange.Course_ID) >= 2	course_teach
select teacher.Name from teacher join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID group by teacher.Teacher_ID having count(course_arrange.Course_ID) >= 2	course_teach
select Name from teacher where Teacher_ID not in (select Teacher_ID from course_arrange)	course_teach
select teacher.Name from teacher left join course_arrange on teacher.Teacher_ID = course_arrange.Teacher_ID where course_arrange.Course_ID is null	course_teach
select count(*) from singer	singer
select count(Singer_ID) from singer	singer
select Name from singer order by Net_Worth_Millions asc	singer
select Name from singer order by Net_Worth_Millions asc	singer
select Birth_Year, Citizenship from singer	singer
select Birth_Year, Citizenship from singer	singer
select Name from singer where Citizenship <> "France"	singer
select Name from singer where Citizenship <> "France"	singer
select Name from singer where Birth_Year = 1948 or Birth_Year = 1949	singer
select Name from singer where Birth_Year = 1948 or Birth_Year = 1949	singer
select Name from singer order by Net_Worth_Millions desc limit 1	singer
select Name from singer order by Net_Worth_Millions desc limit 1	singer
select Citizenship, count(Singer_ID) from singer group by Citizenship	singer
select Citizenship, count(Singer_ID) from singer group by Citizenship	singer
select Citizenship from singer group by Citizenship order by count(*) desc limit 1	singer
select Citizenship, count(Singer_ID) from singer group by Citizenship order by count(Singer_ID) desc limit 1	singer
select Citizenship, max(Net_Worth_Millions) from singer group by Citizenship	singer
select Citizenship, max(Net_Worth_Millions) from singer group by Citizenship	singer
select T1.Title, T2.Name from song as T1 join singer as T2 on T1.Singer_ID = T2.Singer_ID	singer
select song.Title, singer.Name from song join singer on song.Singer_ID = singer.Singer_ID	singer
select distinct T1.Name from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID where T2.Sales > 300000	singer
select distinct T1.Name from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID where T2.Sales > 300000	singer
select T1.Name from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID group by T1.Singer_ID having count(*) > 1	singer
select Name from singer join song on singer.Singer_ID = song.Singer_ID group by singer.Singer_ID having count(*) > 1	singer
select singer.Name, sum(song.Sales) from singer join song on singer.Singer_ID = song.Singer_ID group by singer.Name	singer
select singer.Name, sum(song.Sales) from singer join song on singer.Singer_ID = song.Singer_ID group by singer.Name	singer
select Name from singer where Singer_ID not in (select distinct Singer_ID from song)	singer
select Name from singer where Singer_ID not in (select Singer_ID from song)	singer
select Citizenship from singer group by Citizenship having sum(CASE WHEN Birth_Year < 1945 THEN 1 ELSE 0 END) > 0 and sum(CASE WHEN Birth_Year > 1955 THEN 1 ELSE 0 END) > 0	singer
select Citizenship from singer where (Birth_Year < 1945) intersect select Citizenship from singer where (Birth_Year > 1955)	singer
select count(*) from visitor where Age < 30	museum_visit
select Name from visitor where Level_of_membership > 4 order by Level_of_membership desc	museum_visit
select avg(Age) from visitor where Level_of_membership <= 4	museum_visit
select Name, Level_of_membership from visitor where Level_of_membership > 4 order by Age desc	museum_visit
select Museum_ID, Name from museum order by Num_of_Staff desc limit 1	museum_visit
select avg(Num_of_Staff) from museum where Open_Year < 2009	museum_visit
select Open_Year, Num_of_Staff from museum where Name = "Plaza Museum"	museum_visit
select Name from museum where Num_of_Staff > (select min(Num_of_Staff) from museum where Open_Year > 2010)	museum_visit
select visitor.ID, visitor.Name, visitor.Age from visitor join visit on visitor.ID = visit.visitor_ID group by visit.visitor_ID, visitor.ID, visitor.Name, visitor.Age having count(*) > 1	museum_visit
select visitor.ID, visitor.Name, visitor.Level_of_membership from visitor join visit on visitor.ID = visit.visitor_ID group by visitor.ID, visitor.Name, visitor.Level_of_membership order by sum(visit.Total_spent) desc limit 1	museum_visit
select museum.Museum_ID, museum.Name from museum join visit on museum.Museum_ID = visit.Museum_ID group by museum.Museum_ID, museum.Name order by sum(visit.Num_of_Ticket) desc limit 1	museum_visit
select Name from museum where Museum_ID not in (select Museum_ID from visit)	museum_visit
select visitor.Name, visitor.Age from visit join visitor on visit.visitor_ID = visitor.ID order by visit.Num_of_Ticket desc limit 1	museum_visit
select avg(Num_of_Ticket), max(Num_of_Ticket) from visit	museum_visit
select sum(visit.Total_spent) from visit join visitor on visit.visitor_ID = visitor.ID where visitor.Level_of_membership = 1	museum_visit
select T1.Name from visitor as T1 join visit as T2 on T1.ID = T2.visitor_ID join museum as T3 on T2.Museum_ID = T3.Museum_ID where T3.Open_Year < 2009 intersect select T1.Name from visitor as T1 join visit as T2 on T1.ID = T2.visitor_ID join museum as T3 on T2.Museum_ID = T3.Museum_ID where T3.Open_Year > 2011	museum_visit
select count(visitor.ID) from visitor where visitor.ID not in (select distinct visit.visitor_ID from visit join museum on visit.Museum_ID = museum.Museum_ID where museum.Open_Year > 2010)	museum_visit
select count(*) from museum where Open_Year > 2013 or Open_Year < 2008	museum_visit
select count(id) from ship where disposition_of_ship = "Captured"	battle_death
select name, tonnage from ship order by name desc	battle_death
select name, date, result from battle	battle_death
select max(killed), min(killed) from death	battle_death
select avg(injured) from death	battle_death
select T2.killed, T2.injured from ship as T1 join death as T2 on T1.id = T2.caused_by_ship_id where T1.tonnage = "t"	battle_death
select name, result from battle where bulgarian_commander <> "Boril"	battle_death
select T1.id, T1.name from battle as T1 join ship as T2 on T1.id = T2.lost_in_battle where T2.ship_type = "Brig"	battle_death
select T1.id, T1.name from battle as T1 join death as T2 on T1.id = T2.id group by T1.id, T1.name having sum(T2.killed) > 10	battle_death
select T1.id, T1.name from ship as T1 join death as T2 on T1.id = T2.caused_by_ship_id group by T1.id order by sum(T2.injured) desc limit 1	battle_death
select distinct name from battle where bulgarian_commander = "Kaloyan" and latin_commander = "Baldwin I"	battle_death
select count(distinct result) from battle	battle_death
select count(T1.id) from battle as T1 where not EXISTS (select 1 from ship as T2 where T2.lost_in_battle = T1.id and T2.tonnage = "225")	battle_death
select b.name, b.date from battle as b join ship as s on b.id = s.lost_in_battle where s.name = "Lettice" or s.name = "HMS Atalanta" group by b.id having count(distinct s.id) = 2	battle_death
select T1.name, T1.result, T1.bulgarian_commander from battle as T1 left join ship as T2 on T1.id = T2.lost_in_battle and T2.location = "English Channel" where T2.id is null	battle_death
select note from death where note like "%East%"	battle_death
select count(distinct state) from AREA_CODE_STATE	voter_1
select contestant_number, contestant_name from CONTESTANTS order by contestant_name desc	voter_1
select vote_id, phone_number, state from VOTES	voter_1
select max(area_code), min(area_code) from AREA_CODE_STATE	voter_1
select max(created) from VOTES where state = "CA"	voter_1
select contestant_name from CONTESTANTS where contestant_name <> "Jessie Alloway"	voter_1
select distinct state, created from VOTES	voter_1
select CONTESTANTS.contestant_number, CONTESTANTS.contestant_name from CONTESTANTS join VOTES on CONTESTANTS.contestant_number = VOTES.contestant_number group by CONTESTANTS.contestant_number, CONTESTANTS.contestant_name having count(*) >= 2	voter_1
select c.contestant_number, c.contestant_name from CONTESTANTS as c join VOTES as v on c.contestant_number = v.contestant_number group by c.contestant_number, c.contestant_name order by count(*) asc limit 1	voter_1
select count(vote_id) from VOTES where state in ("NY", "CA")	voter_1
select count(*) from CONTESTANTS left join VOTES on CONTESTANTS.contestant_number = VOTES.contestant_number where VOTES.contestant_number is null	voter_1
select area_code from AREA_CODE_STATE join VOTES on AREA_CODE_STATE.state = VOTES.state group by area_code order by count(*) desc limit 1	voter_1
select VOTES.created, VOTES.state, VOTES.phone_number from VOTES join CONTESTANTS on VOTES.contestant_number = CONTESTANTS.contestant_number where CONTESTANTS.contestant_name = "Tabatha Gehling"	voter_1
select area_code from AREA_CODE_STATE join VOTES on AREA_CODE_STATE.state = VOTES.state join CONTESTANTS on VOTES.contestant_number = CONTESTANTS.contestant_number where CONTESTANTS.contestant_name = "Tabatha Gehling" intersect select area_code from AREA_CODE_STATE join VOTES on AREA_CODE_STATE.state = VOTES.state join CONTESTANTS on VOTES.contestant_number = CONTESTANTS.contestant_number where CONTESTANTS.contestant_name = "Kelly Clauss"	voter_1
select contestant_name from CONTESTANTS where contestant_name like "%Al%"	voter_1
select count(feature_id) from Other_Available_Features	real_estate_properties
select T1.feature_type_name from Ref_Feature_Types as T1 join Other_Available_Features as T2 on T1.feature_type_code = T2.feature_type_code where T2.feature_name = "AirCon"	real_estate_properties
select Ref_Property_Types.property_type_description from Ref_Property_Types join Properties on Ref_Property_Types.property_type_code = Properties.property_type_code where Properties.property_type_code = "that code"	real_estate_properties
select P.property_name from Properties as P join Ref_Property_Types as R on P.property_type_code = R.property_type_code where P.room_count > 1 and R.property_type_description in ("House", "Apartment")	real_estate_properties
