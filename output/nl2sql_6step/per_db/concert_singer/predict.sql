select count(*) from singer	concert_singer
select count(*) from singer	concert_singer
select Name, Country, Age from singer order by Age desc	concert_singer
select Name, Country, Age from singer order by Age desc	concert_singer
select avg(Age), min(Age), max(Age) from singer where Country = "France"	concert_singer
select avg(Age), min(Age), max(Age) from singer where Country = "France"	concert_singer
select Name, Song_release_year from singer order by Age asc limit 1	concert_singer
SELECT song_name ,  song_release_year FROM singer ORDER BY age LIMIT 1	concert_singer
select distinct Country from singer where Age > 20	concert_singer
select distinct Country from singer where Age > 20	concert_singer
select Country, count(*) from singer group by Country	concert_singer
select Country, count(*) from singer group by Country	concert_singer
select Song_Name from singer where Age > (select avg(Age) from singer)	concert_singer
select Song_Name from singer where Age > (select avg(Age) from singer)	concert_singer
select Location, Name from stadium where Capacity between 5000 and 10000	concert_singer
select Location, Name from stadium where Capacity between 5000 and 10000	concert_singer
select max(Capacity), avg(Average) from stadium	concert_singer
select avg(Capacity), max(Capacity) from stadium	concert_singer
select Name, Capacity from stadium order by Average desc limit 1	concert_singer
select Name, Capacity from stadium order by Average desc limit 1	concert_singer
SELECT count(*) FROM concert WHERE YEAR  =  2014 OR YEAR  =  2015	concert_singer
SELECT count(*) FROM concert WHERE YEAR  =  2014 OR YEAR  =  2015	concert_singer
select stadium.Name, count(concert.concert_ID) from stadium inner join concert on stadium.Stadium_ID = concert.Stadium_ID group by stadium.Name	concert_singer
SELECT T2.name ,  count(*) FROM concert AS T1 JOIN stadium AS T2 ON T1.stadium_id  =  T2.stadium_id GROUP BY T1.stadium_id	concert_singer
SELECT T2.name ,  T2.capacity FROM concert AS T1 JOIN stadium AS T2 ON T1.stadium_id  =  T2.stadium_id WHERE T1.year  >=  2014 GROUP BY T2.stadium_id ORDER BY count(*) DESC LIMIT 1	concert_singer
select T1.Name, T1.Capacity from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year > 2013 group by T1.Stadium_ID order by count(*) desc limit 1	concert_singer
select Year from concert group by Year order by count(*) desc limit 1	concert_singer
select Year from concert group by Year order by count(*) desc limit 1	concert_singer
select T1.Name from stadium as T1 left join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Stadium_ID is null	concert_singer
select Name from stadium where Stadium_ID not in (select Stadium_ID from concert)	concert_singer
select distinct Country from singer where Age > 40 intersect select distinct Country from singer where Age < 30	concert_singer
select Name from stadium where Stadium_ID not in (select Stadium_ID from concert where Year = "2014")	concert_singer
select Name from stadium where Stadium_ID not in (select Stadium_ID from concert where Year = 2014)	concert_singer
select T1.concert_Name, T1.Theme, count(*) from concert as T1 join singer_in_concert as T2 on T1.concert_ID = T2.concert_ID group by T1.concert_ID	concert_singer
select t2.concert_name ,  t2.theme ,  count(*) from singer_in_concert as t1 join concert as t2 on t1.concert_id  =  t2.concert_id group by t2.concert_id	concert_singer
select singer.Name, count(singer_in_concert.concert_ID) from singer join singer_in_concert on singer.Singer_ID = singer_in_concert.Singer_ID group by singer.Singer_ID	concert_singer
SELECT T2.name ,  count(*) FROM singer_in_concert AS T1 JOIN singer AS T2 ON T1.singer_id  =  T2.singer_id GROUP BY T2.singer_id	concert_singer
select singer.Name from singer join singer_in_concert on singer.Singer_ID = singer_in_concert.Singer_ID join concert on singer_in_concert.concert_ID = concert.concert_ID where concert.Year = 2014	concert_singer
select singer.Name from singer join singer_in_concert on singer.Singer_ID = singer_in_concert.Singer_ID join concert on singer_in_concert.concert_ID = concert.concert_ID where concert.Year = 2014	concert_singer
select Name, Country from singer where Song_Name like "%Hey%"	concert_singer
select Name, Country from singer where Song_Name like "%Hey%"	concert_singer
select T1.Name, T1.Location from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year = "2014" intersect select T1.Name, T1.Location from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year = "2015"	concert_singer
select stadium.Name, stadium.Location from stadium join concert on stadium.Stadium_ID = concert.Stadium_ID where concert.Year = 2014 intersect select stadium.Name, stadium.Location from stadium join concert on stadium.Stadium_ID = concert.Stadium_ID where concert.Year = 2015	concert_singer
select count(*) as "Number of Concerts" from concert join stadium on concert.Stadium_ID = stadium.Stadium_ID where stadium.Capacity = (select max(Capacity) from stadium)	concert_singer
select count(*) from concert join stadium on concert.Stadium_ID = stadium.Stadium_ID where stadium.Capacity = (select max(Capacity) from stadium)	concert_singer
