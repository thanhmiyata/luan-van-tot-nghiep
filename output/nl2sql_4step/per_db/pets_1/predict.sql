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
