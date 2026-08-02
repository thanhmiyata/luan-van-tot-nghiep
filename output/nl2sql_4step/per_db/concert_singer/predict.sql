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
