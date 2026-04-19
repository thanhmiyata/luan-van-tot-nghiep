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
select T1.Fname from Student as T1 inner join Has_Pet as T2 on T1.StuID = T2.StuID inner join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" or T3.PetType = "dog"	pets_1
select T1.Fname from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType in ("cat", "dog") group by T1.StuID having count(distinct T3.PetType) = 2	pets_1
select T1.Fname from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" intersect select T1.Fname from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "dog"	pets_1
select Major, Age from Student where StuID not in ( select T1.StuID from Has_Pet as T1 inner join Pets as T2 on T1.PetID = T2.PetID where T2.PetType = "cat" )	pets_1
select Major, Age from Student where StuID not in ( select T1.StuID from Has_Pet as T1 inner join Pets as T2 on T1.PetID = T2.PetID where T2.PetType = "cat" )	pets_1
select StuID from Student except select T1.StuID from Has_Pet as T1 inner join Pets as T2 on T1.PetID = T2.PetID where T2.PetType = "cat"	pets_1
select StuID from Student except select T1.StuID from Has_Pet as T1 inner join Pets as T2 on T1.PetID = T2.PetID where T2.PetType = "cat"	pets_1
select T1.Fname, T1.Age from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "dog" and T1.StuID not in ( select T1.StuID from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" )	pets_1
select T1.Fname from Student as T1 where T1.StuID in ( select T2.StuID from Has_Pet as T2 inner join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "Dog" ) and T1.StuID not in ( select T2.StuID from Has_Pet as T2 inner join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "Cat" )	pets_1
select PetType, weight from Pets order by pet_age asc limit 1	pets_1
select PetType, weight from Pets order by pet_age asc limit 1	pets_1
select PetID, weight from Pets where pet_age > 1	pets_1
select PetID , weight from Pets where pet_age > 1	pets_1
select PetType, avg(pet_age), max(pet_age) from Pets group by PetType	pets_1
select PetType, avg(pet_age), max(pet_age) from Pets group by PetType	pets_1
select PetType, avg(weight) from Pets group by PetType	pets_1
select PetType, avg(weight) from Pets group by PetType	pets_1
select T1.Fname, T1.Age from Student as T1 inner join Has_Pet as T2 on T1.StuID = T2.StuID	pets_1
select distinct T1.Fname, T1.Age from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID	pets_1
select T1.PetID from Has_Pet as T1 inner join Student as T2 on T1.StuID = T2.StuID where T2.LName = "Smith"	pets_1
select T1.PetID from Has_Pet as T1 inner join Student as T2 on T1.StuID = T2.StuID where T2.LName = "Smith"	pets_1
select T1.StuID, count(T2.PetID) from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID group by T1.StuID	pets_1
select T1.StuID, count(T2.PetID) from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID group by T1.StuID	pets_1
select T1.Fname, T1.Sex from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID group by T1.StuID having count(T2.PetID) > 1	pets_1
select T1.Fname, T1.Sex from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID group by T1.StuID having count(T2.PetID) > 1	pets_1
select T1.LName from Student as T1 inner join Has_Pet as T2 on T1.StuID = T2.StuID inner join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" and T3.pet_age = 3	pets_1
select T1.LName from Student as T1 inner join Has_Pet as T2 on T1.StuID = T2.StuID inner join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" and T3.pet_age = 3	pets_1
select avg(Age) from Student where StuID not in ( select StuID from Has_Pet )	pets_1
select avg(Age) from Student where StuID not in (select StuID from Has_Pet)	pets_1
