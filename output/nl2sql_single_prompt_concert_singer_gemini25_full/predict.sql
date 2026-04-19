select count(*) from singer	concert_singer
select count(*) from singer	concert_singer
select Name, Country, Age from singer order by Age desc	concert_singer
select Name, Country, Age from singer order by Age desc	concert_singer
select avg(Age), min(Age), max(Age) from singer where Country = "France"	concert_singer
select avg(Age), min(Age), max(Age) from singer where Country = "France"	concert_singer
select Song_Name, Song_release_year from singer order by Age asc limit 1	concert_singer
select Song_Name, Song_release_year from singer where Age = (select min(Age) from singer)	concert_singer
select distinct Country from singer where Age > 20	concert_singer
select distinct Country from singer where Age > 20	concert_singer
select Country, count(*) from singer group by Country	concert_singer
select Country, count(*) from singer group by Country	concert_singer
select Song_Name from singer where Age > (select avg(Age) from singer)	concert_singer
select Song_Name from singer where Age > (select avg(Age) from singer)	concert_singer
select Location, Name from stadium where Capacity between 5000 and 10000	concert_singer
select Location, Name from stadium where Capacity between 5000 and 10000	concert_singer
select max(Capacity), avg(Capacity) from stadium	concert_singer
select avg(Capacity), max(Capacity) from stadium	concert_singer
select Name, Capacity from stadium order by Average desc limit 1	concert_singer
select Name, Capacity from stadium order by Average desc limit 1	concert_singer
select count(*) from concert where Year = "2014" or Year = "2015"	concert_singer
select count(*) from concert where Year = "2014" or Year = "2015"	concert_singer
select T1.Name, count(T2.concert_ID) from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID group by T1.Name	concert_singer
select T1.Name, count(T2.concert_ID) from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID group by T1.Stadium_ID	concert_singer
select T1.Name, T1.Capacity from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year >= 2014 group by T1.Stadium_ID order by count(T2.concert_ID) desc limit 1	concert_singer
select T1.Name, T1.Capacity from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year > "2013" group by T1.Stadium_ID order by count(T2.concert_ID) desc limit 1	concert_singer
select Year from concert group by Year order by count(concert_ID) desc limit 1	concert_singer
select Year from concert group by Year order by count(*) desc limit 1	concert_singer
select Name from stadium except select T1.Name from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID	concert_singer
select Name from stadium except select T1.Name from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID	concert_singer
select T1.Country from singer as T1 where T1.Age > 40 intersect select T2.Country from singer as T2 where T2.Age < 30	concert_singer
select Name from stadium except select T1.Name from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year = "2014"	concert_singer
select Name from stadium except select T1.Name from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year = "2014"	concert_singer
select T1.concert_Name, T1.Theme, count(T2.Singer_ID) from concert as T1 join singer_in_concert as T2 on T1.concert_ID = T2.concert_ID group by T1.concert_ID	concert_singer
select T1.concert_Name, T1.Theme, count(T2.Singer_ID) from concert as T1 join singer_in_concert as T2 on T1.concert_ID = T2.concert_ID group by T1.concert_ID	concert_singer
select T1.Name, count(T2.concert_ID) from singer as T1 join singer_in_concert as T2 on T1.Singer_ID = T2.Singer_ID group by T1.Name	concert_singer
select T1.Name, count(T2.concert_ID) from singer as T1 join singer_in_concert as T2 on T1.Singer_ID = T2.Singer_ID group by T1.Name	concert_singer
select distinct T1.Name from singer as T1 inner join singer_in_concert as T2 on T1.Singer_ID = T2.Singer_ID inner join concert as T3 on T2.concert_ID = T3.concert_ID where T3.Year = "2014"	concert_singer
select T1.Name from singer as T1 inner join singer_in_concert as T2 on T1.Singer_ID = T2.Singer_ID inner join concert as T3 on T2.concert_ID = T3.concert_ID where T3.Year = "2014"	concert_singer
select Name, Country from singer where Song_Name like "%Hey%"	concert_singer
select Name, Country from singer where Song_Name like "%Hey%"	concert_singer
select T1.Name, T1.Location from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year in ("2014", "2015") group by T1.Stadium_ID having count(distinct T2.Year) = 2	concert_singer
select T1.Name, T1.Location from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year = "2014" intersect select T1.Name, T1.Location from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year = "2015"	concert_singer
select count(*) from concert where Stadium_ID = (select Stadium_ID from stadium order by Capacity desc limit 1)	concert_singer
select count(*) from concert where Stadium_ID = (select Stadium_ID from stadium order by Capacity desc limit 1)	concert_singer
