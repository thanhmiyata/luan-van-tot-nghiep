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
select Name from stadium where Stadium_ID not in ( select Stadium_ID from concert )	concert_singer
select Name from stadium except select T1.Name from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID	concert_singer
select T1.Country from singer as T1 where T1.Age > 40 intersect select T2.Country from singer as T2 where T2.Age < 30	concert_singer
select Name from stadium where Stadium_ID not in ( select Stadium_ID from concert where Year = "2014" )	concert_singer
select Name from stadium except select T1.Name from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year = "2014"	concert_singer
select T1.concert_Name, T1.Theme, count(T2.Singer_ID) from concert as T1 join singer_in_concert as T2 on T1.concert_ID = T2.concert_ID group by T1.concert_ID	concert_singer
select T1.concert_Name, T1.Theme, count(T2.Singer_ID) from concert as T1 join singer_in_concert as T2 on T1.concert_ID = T2.concert_ID group by T1.concert_ID	concert_singer
select T1.Name, count(T2.concert_ID) from singer as T1 join singer_in_concert as T2 on T1.Singer_ID = T2.Singer_ID group by T1.Name	concert_singer
select T1.Name, count(T2.concert_ID) from singer as T1 join singer_in_concert as T2 on T1.Singer_ID = T2.Singer_ID group by T1.Name	concert_singer
select distinct T1.Name from singer as T1 inner join singer_in_concert as T2 on T1.Singer_ID = T2.Singer_ID inner join concert as T3 on T2.concert_ID = T3.concert_ID where T3.Year = "2014"	concert_singer
select T1.Name from singer as T1 inner join singer_in_concert as T2 on T1.Singer_ID = T2.Singer_ID inner join concert as T3 on T2.concert_ID = T3.concert_ID where T3.Year = "2014"	concert_singer
select Name, Country from singer where Song_Name like "%Hey%"	concert_singer
select Name, Country from singer where Song_Name like "%Hey%"	concert_singer
select T1.Name, T1.Location from stadium as T1 inner join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year in ("2014", "2015") group by T1.Stadium_ID having count(distinct T2.Year) = 2	concert_singer
select T1.Name, T1.Location from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year = "2014" intersect select T1.Name, T1.Location from stadium as T1 join concert as T2 on T1.Stadium_ID = T2.Stadium_ID where T2.Year = "2015"	concert_singer
select count(*) from concert where Stadium_ID = (select Stadium_ID from stadium order by Capacity desc limit 1)	concert_singer
select count(*) from concert where Stadium_ID = (select Stadium_ID from stadium order by Capacity desc limit 1)	concert_singer
select count(*) from Pets where weight > 10	pets_1
select count(*) from Pets where weight > 10	pets_1
select weight from Pets where PetType = "dog" order by pet_age asc limit 1	pets_1
select weight from Pets where PetType = "Dog" order by pet_age asc limit 1	pets_1
select max(weight), PetType from Pets group by PetType	pets_1
select PetType, max(weight) from Pets group by PetType	pets_1
select count(T1.PetID) from Has_Pet as T1 inner join Student as T2 on T1.StuID = T2.StuID where T2.Age > 20	pets_1
select count(T2.PetID) from Student as T1 inner join Has_Pet as T2 on T1.StuID = T2.StuID where T1.Age > 20	pets_1
select count(T1.PetID) from Pets as T1 inner join Has_Pet as T2 on T1.PetID = T2.PetID inner join Student as T3 on T2.StuID = T3.StuID where T1.PetType = "dog" and T3.Sex = "F"	pets_1
select count(T1.PetID) from Pets as T1 inner join Has_Pet as T2 on T1.PetID = T2.PetID inner join Student as T3 on T2.StuID = T3.StuID where T1.PetType = "dog" and T3.Sex = "F"	pets_1
select count(distinct PetType) from Pets	pets_1
select count(distinct PetType) from Pets	pets_1
select distinct T1.Fname from Student as T1 inner join Has_Pet as T2 on T1.StuID = T2.StuID inner join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" or T3.PetType = "dog"	pets_1
select T1.Fname from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" or T3.PetType = "dog"	pets_1
select T1.Fname from Student as T1 inner join Has_Pet as T2 on T1.StuID = T2.StuID inner join Pets as T3 on T2.PetID = T3.PetID where T3.PetType in ("cat", "dog") group by T1.StuID having count(distinct T3.PetType) = 2	pets_1
select T1.Fname from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" intersect select T1.Fname from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "dog"	pets_1
select Major, Age from Student where StuID not in ( select T1.StuID from Has_Pet as T1 join Pets as T2 on T1.PetID = T2.PetID where T2.PetType = "cat" )	pets_1
select Major, Age from Student where StuID not in ( select T1.StuID from Has_Pet as T1 join Pets as T2 on T1.PetID = T2.PetID where T2.PetType = "cat" )	pets_1
select StuID from Student except select T1.StuID from Student as T1 inner join Has_Pet as T2 on T1.StuID = T2.StuID inner join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat"	pets_1
select StuID from Student except select T1.StuID from Has_Pet as T1 inner join Pets as T2 on T1.PetID = T2.PetID where T2.PetType = "cat"	pets_1
select T1.Fname, T1.Age from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "dog" and T1.StuID not in ( select T1.StuID from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" )	pets_1
select T1.Fname from Student as T1 where T1.StuID in ( select T2.StuID from Has_Pet as T2 inner join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "Dog" ) and T1.StuID not in ( select T2.StuID from Has_Pet as T2 inner join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "Cat" )	pets_1
