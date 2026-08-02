select count(*) from Pets where weight > 10	pets_1
select count(*) from Pets where weight > 10	pets_1
select weight from Pets order by pet_age asc limit 1	pets_1
SELECT weight FROM pets ORDER BY pet_age LIMIT 1	pets_1
select max(weight), PetType from Pets group by PetType	pets_1
select max(weight), PetType from Pets group by PetType	pets_1
SELECT count(*) FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid WHERE T1.age  >  20	pets_1
SELECT count(*) FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid WHERE T1.age  >  20	pets_1
select count(*) from Student join Has_Pet on Student.StuID = Has_Pet.StuID join Pets on Has_Pet.PetID = Pets.PetID where Student.Sex = "F" and Pets.PetType = "dog"	pets_1
SELECT count(*) FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid JOIN pets AS T3 ON T2.petid  =  T3.petid WHERE T1.sex  =  'F' AND T3.pettype  =  'dog'	pets_1
select count(distinct PetType) from Pets	pets_1
select count(distinct PetType) from Pets	pets_1
SELECT DISTINCT T1.Fname FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid JOIN pets AS T3 ON T3.petid  =  T2.petid WHERE T3.pettype  =  'cat' OR T3.pettype  =  'dog'	pets_1
SELECT DISTINCT T1.Fname FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid JOIN pets AS T3 ON T3.petid  =  T2.petid WHERE T3.pettype  =  'cat' OR T3.pettype  =  'dog'	pets_1
select S.Fname from Student S join Has_Pet HP on S.StuID = HP.StuID join Pets P on HP.PetID = P.PetID where P.PetType = "cat" intersect select S.Fname from Student S join Has_Pet HP on S.StuID = HP.StuID join Pets P on HP.PetID = P.PetID where P.PetType = "dog"	pets_1
select Fname from Student join Has_Pet on Student.StuID = Has_Pet.StuID join Pets on Has_Pet.PetID = Pets.PetID where PetType = "cat" intersect select Fname from Student join Has_Pet on Student.StuID = Has_Pet.StuID join Pets on Has_Pet.PetID = Pets.PetID where PetType = "dog"	pets_1
SELECT Major, Age FROM Student WHERE NOT StuID IN (SELECT T1.StuID FROM Has_Pet AS T1 JOIN Pets AS T2 ON T1.PetID = T2.PetID WHERE T2.PetType = 'cat')	pets_1
SELECT Student.Major, Student.Age FROM Student WHERE NOT Student.StuID IN (SELECT Has_Pet.StuID FROM Has_Pet JOIN Pets ON Has_Pet.PetID = Pets.PetID WHERE Pets.PetType = 'cat')	pets_1
SELECT stuid FROM student EXCEPT SELECT T1.stuid FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid JOIN pets AS T3 ON T3.petid  =  T2.petid WHERE T3.pettype  =  'cat'	pets_1
SELECT stuid FROM student EXCEPT SELECT T1.stuid FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid JOIN pets AS T3 ON T3.petid  =  T2.petid WHERE T3.pettype  =  'cat'	pets_1
SELECT T1.fname ,  T1.age FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid JOIN pets AS T3 ON T3.petid  =  T2.petid WHERE T3.pettype  =  'dog' AND T1.stuid NOT IN (SELECT T1.stuid FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid JOIN pets AS T3 ON T3.petid  =  T2.petid WHERE T3.pettype  =  'cat')	pets_1
SELECT DISTINCT S.Fname FROM Student AS S JOIN Has_Pet AS HP ON S.StuID = HP.StuID JOIN Pets AS P ON HP.PetID = P.PetID WHERE P.PetType = 'dog' AND NOT S.StuID IN (SELECT HP2.StuID FROM Has_Pet AS HP2 JOIN Pets AS P2 ON HP2.PetID = P2.PetID WHERE P2.PetType = 'cat')	pets_1
select PetType, weight from Pets order by pet_age asc limit 1	pets_1
select PetType, weight from Pets order by pet_age asc limit 1	pets_1
select PetID, weight from Pets where pet_age > 1	pets_1
select PetID , weight from Pets where pet_age > 1	pets_1
select PetType, avg(pet_age), max(pet_age) from Pets group by PetType	pets_1
select PetType, avg(pet_age), max(pet_age) from Pets group by PetType	pets_1
select PetType, avg(weight) from Pets group by PetType	pets_1
select PetType, avg(weight) from Pets group by PetType	pets_1
select T1.Fname, T1.Age from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID	pets_1
select T1.Fname, T1.Age from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID	pets_1
select Pets.PetID from Student join Has_Pet on Student.StuID = Has_Pet.StuID join Pets on Has_Pet.PetID = Pets.PetID where Student.LName = "Smith"	pets_1
SELECT T2.petid FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid WHERE T1.Lname  =  'Smith'	pets_1
select Student.StuID, count(*) from Student join Has_Pet on Student.StuID = Has_Pet.StuID group by Student.StuID	pets_1
select count(*) ,  t1.stuid from student as t1 join has_pet as t2 on t1.stuid  =  t2.stuid group by t1.stuid	pets_1
SELECT T1.fname ,  T1.sex FROM student AS T1 JOIN has_pet AS T2 ON T1.stuid  =  T2.stuid GROUP BY T1.stuid HAVING count(*)  >  1	pets_1
SELECT Student.Fname, Student.Sex FROM Student INNER JOIN Has_Pet ON Student.StuID = Has_Pet.StuID GROUP BY Student.StuID HAVING COUNT(Has_Pet.PetID) > 1	pets_1
select T1.LName from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" and T3.pet_age = 3	pets_1
select T1.LName from Student as T1 join Has_Pet as T2 on T1.StuID = T2.StuID join Pets as T3 on T2.PetID = T3.PetID where T3.PetType = "cat" and T3.pet_age = 3	pets_1
select avg(T1.Age) from Student as T1 left join Has_Pet as T2 on T1.StuID = T2.StuID where T2.StuID is null	pets_1
select avg(T1.Age) from Student as T1 left join Has_Pet as T2 on T1.StuID = T2.StuID where T2.StuID is null	pets_1
