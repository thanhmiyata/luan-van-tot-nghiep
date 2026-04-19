select count(*) from continents	car_1
select count(ContId) from continents	car_1
select T1.ContId, T1.Continent, count(T2.CountryId) from continents as T1 join countries as T2 on T1.ContId = T2.Continent group by T1.ContId, T1.Continent	car_1
select T1.ContId, T1.Continent, count(T2.CountryId) from continents as T1 join countries as T2 on T1.ContId = T2.Continent group by T1.ContId, T1.Continent	car_1
select count(*) from countries	car_1
select count(*) from countries	car_1
select T1.FullName, T1.Id, count(T2.Model) from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.FullName, T1.Id	car_1
select T1.FullName, T1.Id, count(T2.ModelId) from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.Id, T1.FullName	car_1
select T1.Model from car_names as T1 inner join cars_data as T2 on T1.MakeId = T2.Id order by CAST(T2.Horsepower as NUMERIC) asc limit 1	car_1
select T1.Model from car_names as T1 join cars_data as T2 on T1.MakeId = T2.Id order by CAST(T2.Horsepower as INTEGER) asc limit 1	car_1
select T1.Model from car_names as T1 join cars_data as T2 on T1.MakeId = T2.Id where T2.Weight < (select avg(Weight) from cars_data)	car_1
select T1.Model from car_names as T1 join cars_data as T2 on T1.MakeId = T2.Id where T2.Weight < (select avg(Weight) from cars_data)	car_1
select distinct T3.Maker from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId inner join model_list as T4 on T2.Model = T4.Model inner join car_makers as T3 on T4.Maker = T3.Id where T1.Year = 1970	car_1
select distinct T1.Maker from car_makers as T1 inner join model_list as T2 on T1.Id = T2.Maker inner join car_names as T3 on T2.Model = T3.Model inner join cars_data as T4 on T3.MakeId = T4.Id where T4.Year = 1970	car_1
select T1.Make, T2.Year from car_names as T1 inner join cars_data as T2 on T1.MakeId = T2.Id where T2.Year = (select min(Year) from cars_data)	car_1
select T4.Maker, T1.Year from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId inner join model_list as T3 on T2.Model = T3.Model inner join car_makers as T4 on T3.Maker = T4.Id order by T1.Year asc limit 1	car_1
select distinct T1.Model from car_names as T1 join cars_data as T2 on T1.MakeId = T2.Id where T2.Year > 1980	car_1
select distinct T1.Model from car_names as T1 inner join cars_data as T2 on T1.MakeId = T2.Id where T2.Year > 1980	car_1
select T3.Continent, count(T1.Id) from car_makers as T1 join countries as T2 on T1.Country = T2.CountryId join continents as T3 on T2.Continent = T3.ContId group by T3.Continent	car_1
select T1.Continent, count(T3.Id) from continents as T1 join countries as T2 on T1.ContId = T2.Continent join car_makers as T3 on T2.CountryId = T3.Country group by T1.Continent	car_1
select T2.CountryName from car_makers as T1 join countries as T2 on T1.Country = T2.CountryId group by T2.CountryName order by count(T1.Id) desc limit 1	car_1
select T1.CountryName from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country group by T1.CountryName order by count(T2.Id) desc limit 1	car_1
select T2.FullName, count(T1.ModelId) from model_list as T1 join car_makers as T2 on T1.Maker = T2.Id group by T2.FullName	car_1
select T1.Id, T1.FullName, count(T2.ModelId) from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.Id, T1.FullName	car_1
select T1.Accelerate from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T2.Make = "amc hornet sportabout (sw)"	car_1
select T1.Accelerate from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T2.Model = "amc hornet sportabout (sw)"	car_1
select count(*) from car_makers as T1 join countries as T2 on T1.Country = T2.CountryId where T2.CountryName = "France"	car_1
select count(T1.Maker) from car_makers as T1 inner join countries as T2 on T1.Country = T2.CountryId where T2.CountryName = "France"	car_1
select count(T1.Model) from model_list as T1 inner join car_makers as T2 on T1.Maker = T2.Id inner join countries as T3 on T2.Country = T3.CountryId where T3.CountryName = "usa"	car_1
select count(T1.Model) from model_list as T1 inner join car_makers as T2 on T1.Maker = T2.Id inner join countries as T3 on T2.Country = T3.CountryId where T3.CountryName = "United States"	car_1
select avg(CAST(MPG as REAL)) from cars_data where Cylinders = 4	car_1
select avg(CAST(MPG as REAL)) from cars_data where Cylinders = 4	car_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	car_1
select min(Weight) from cars_data where Cylinders = 8 and Year = 1974	car_1
select T1.Maker, T2.Model from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker	car_1
select T1.Maker, T2.Model from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker	car_1
select T2.CountryName, T2.CountryId from car_makers as T1 join countries as T2 on T1.Country = T2.CountryId	car_1
select T1.CountryName, T1.CountryId from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country	car_1
select count(*) from cars_data where Horsepower > 150	car_1
select count(*) from cars_data where Horsepower > 150	car_1
select avg(Weight), Year from cars_data group by Year	car_1
select Year, avg(Weight), avg(Year) from cars_data group by Year	car_1
select T1.CountryName from countries as T1 inner join continents as T2 on T1.Continent = T2.ContId inner join car_makers as T3 on T1.CountryId = T3.Country where T2.Continent = "Europe" group by T1.CountryName having count(T3.Id) >= 3	car_1
select T1.CountryName from countries as T1 inner join continents as T2 on T1.Continent = T2.ContId inner join car_makers as T3 on T1.CountryId = T3.Country where T2.Continent = "Europe" group by T1.CountryName having count(T3.Id) >= 3	car_1
select T2.Make, max(T1.Horsepower) from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T1.Cylinders = 3	car_1
select T2.Make, T1.Horsepower from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T1.Cylinders = 3 order by T1.Horsepower desc limit 1	car_1
select T1.Model from car_names as T1 inner join cars_data as T2 on T1.MakeId = T2.Id where T2.MPG != "NA" order by CAST(T2.MPG as REAL) desc limit 1	car_1
select T1.Model from car_names as T1 inner join cars_data as T2 on T1.MakeId = T2.Id order by CAST(T2.MPG as REAL) desc limit 1	car_1
select avg(CAST(Horsepower as REAL)) from cars_data where Year < 1980	car_1
select avg(CAST(Horsepower as REAL)) from cars_data where Year < 1980	car_1
select avg(T1.Edispl) from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T2.Model = "volvo"	car_1
select avg(T1.Edispl) from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T2.Make = "volvo"	car_1
select max(Accelerate), Cylinders from cars_data group by Cylinders	car_1
select Cylinders, max(Accelerate) from cars_data group by Cylinders	car_1
select Model from car_names group by Model order by count(Make) desc limit 1	car_1
select Model from car_names group by Model order by count(Make) desc limit 1	car_1
select count(*) from cars_data where Cylinders > 4	car_1
select count(*) from cars_data where Cylinders > 4	car_1
select count(*) from cars_data where Year = 1980	car_1
select count(*) from cars_data where Year = 1980	car_1
select count(T1.ModelId) from model_list as T1 inner join car_makers as T2 on T1.Maker = T2.Id where T2.FullName = "American Motor Company"	car_1
select count(T1.Model) from model_list as T1 inner join car_makers as T2 on T1.Maker = T2.Id where T2.FullName = "American Motor Company"	car_1
select T1.FullName, T1.Id from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.Id having count(T2.ModelId) > 3	car_1
select T1.Maker, T1.Id from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.Id having count(T2.ModelId) > 3	car_1
select distinct T1.Model from model_list as T1 left join car_makers as T2 on T1.Maker = T2.Id left join car_names as T3 on T1.Model = T3.Model left join cars_data as T4 on T3.MakeId = T4.Id where T2.FullName = "General Motors" or T4.Weight > 3500	car_1
select distinct T1.Model from model_list as T1 left join car_makers as T2 on T1.Maker = T2.Id left join car_names as T3 on T1.Model = T3.Model left join cars_data as T4 on T3.MakeId = T4.Id where T2.FullName = "General Motors" or T4.Weight > 3500	car_1
select distinct Year from cars_data where Weight >= 3000 and Weight <= 4000	car_1
select Year from cars_data where Weight < 4000 intersect select Year from cars_data where Weight > 3000	car_1
select Horsepower from cars_data order by Accelerate desc limit 1	car_1
select Horsepower from cars_data order by Accelerate desc limit 1	car_1
select T1.Cylinders from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T2.Model = "volvo" order by T1.Accelerate asc limit 1	car_1
select T1.Cylinders from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T2.Make = "volvo" order by T1.Accelerate asc limit 1	car_1
select count(Id) from cars_data where Accelerate > (select Accelerate from cars_data where CAST(Horsepower as REAL) = (select max(CAST(Horsepower as REAL)) from cars_data) limit 1)	car_1
select count(*) from cars_data where Accelerate > (select Accelerate from cars_data order by CAST(Horsepower as INTEGER) desc limit 1)	car_1
select count(T1.Country) from car_makers as T1 group by T1.Country having count(T1.Maker) > 2	car_1
select count(Country) from car_makers group by Country having count(Id) > 2	car_1
select count(*) from cars_data where Cylinders > 6	car_1
select count(*) from cars_data where Cylinders > 6	car_1
select T1.Model from car_names as T1 inner join cars_data as T2 on T1.MakeId = T2.Id where T2.Cylinders = 4 order by CAST(T2.Horsepower as INTEGER) desc limit 1	car_1
select T2.Model from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId where T1.Cylinders = 4 order by T1.Horsepower desc limit 1	car_1
select T1.MakeId, T1.Make from car_names as T1 inner join cars_data as T2 on T1.MakeId = T2.Id where CAST(T2.Horsepower as INTEGER) > ( select min(CAST(Horsepower as INTEGER)) from cars_data where Horsepower != "NA" ) and T2.Cylinders <= 3	car_1
select T1.MakeId, T1.Model from car_names as T1 inner join cars_data as T2 on T1.MakeId = T2.Id where T2.Cylinders < 4 and CAST(T2.Horsepower as NUMERIC) > (select min(CAST(Horsepower as NUMERIC)) from cars_data)	car_1
select max(CAST(MPG as REAL)) from cars_data where Cylinders = 8 or Year < 1980	car_1
select max(CAST(MPG as REAL)) from cars_data where Cylinders = 8 or Year < 1980	car_1
select distinct T1.Model from model_list as T1 inner join car_makers as T2 on T1.Maker = T2.Id inner join car_names as T3 on T1.Model = T3.Model inner join cars_data as T4 on T3.MakeId = T4.Id where T4.Weight < 3500 and T2.FullName != "Ford Motor Company"	car_1
select distinct T3.Model from cars_data as T1 inner join car_names as T2 on T1.Id = T2.MakeId inner join model_list as T3 on T2.Model = T3.Model inner join car_makers as T4 on T3.Maker = T4.Id where T1.Weight < 3500 and T4.FullName != "Ford Motor Company"	car_1
select CountryName from countries where CountryId not in (select Country from car_makers)	car_1
select CountryName from countries where CountryId not in (select Country from car_makers)	car_1
ite WITH EligibleMakers as ( select T1.Id, T1.Maker from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker group by T1.Id, T1.Maker having count(T2.ModelId) >= 2 ) select Id, Maker from EligibleMakers where ( select count(*) from EligibleMakers ) > 3	car_1
select T1.Id, T1.Maker from car_makers as T1 join model_list as T2 on T1.Id = T2.Maker join car_names as T3 on T2.Model = T3.Model join cars_data as T4 on T3.MakeId = T4.Id group by T1.Id, T1.Maker having	car_1
select T1.CountryId, T1.CountryName from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country group by T1.CountryId having count(T2.Id) > 3 union select T1.CountryId, T1.CountryName from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country join model_list as T3 on T2.Id = T3.Maker where T3.Model = "fiat"	car_1
select T1.CountryId, T1.CountryName from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country group by T1.CountryId having count(T2.Id) > 3 union select T1.CountryId, T1.CountryName from countries as T1 join car_makers as T2 on T1.CountryId = T2.Country join model_list as T3 on T2.Id = T3.Maker where T3.Model = "fiat"	car_1
