select count(*) from singer	singer
select count(*) from singer	singer
select Name from singer order by Net_Worth_Millions asc	singer
select Name from singer order by Net_Worth_Millions asc	singer
select Birth_Year, Citizenship from singer	singer
select Birth_Year, Citizenship from singer	singer
SELECT Name FROM singer WHERE Citizenship != "France"	singer
SELECT Name FROM singer WHERE Citizenship != "France"	singer
SELECT Name FROM singer WHERE Birth_Year  =  1948 OR Birth_Year  =  1949	singer
SELECT Name FROM singer WHERE Birth_Year  =  1948 OR Birth_Year  =  1949	singer
select Name from singer order by Net_Worth_Millions desc limit 1	singer
select Name from singer order by Net_Worth_Millions desc limit 1	singer
SELECT Citizenship ,  COUNT(*) FROM singer GROUP BY Citizenship	singer
select Citizenship, count(*) from singer group by Citizenship	singer
select Citizenship from singer group by Citizenship order by count(*) desc limit 1	singer
select Citizenship from singer group by Citizenship order by count(*) desc limit 1	singer
select Citizenship, max(Net_Worth_Millions) from singer group by Citizenship	singer
select Citizenship, max(Net_Worth_Millions) from singer group by Citizenship	singer
SELECT T2.Title ,  T1.Name FROM singer AS T1 JOIN song AS T2 ON T1.Singer_ID  =  T2.Singer_ID	singer
select song.Title, singer.Name from song join singer on song.Singer_ID = singer.Singer_ID	singer
select distinct T1.Name from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID where T2.Sales > 300000	singer
select distinct singer.Name from singer join song on singer.Singer_ID = song.Singer_ID where song.Sales > 300000	singer
SELECT T1.Name FROM singer AS T1 JOIN song AS T2 ON T1.Singer_ID  =  T2.Singer_ID GROUP BY T1.Name HAVING COUNT(*)  >  1	singer
select s.Name from singer as s join song as sg on s.Singer_ID = sg.Singer_ID group by s.Name having count(*) > 1	singer
select singer.Name, sum(song.Sales) from singer join song on singer.Singer_ID = song.Singer_ID group by singer.Name	singer
select T1.Name, sum(T2.Sales) from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID group by T1.Name	singer
select Name from singer where Singer_ID not in (select Singer_ID from song)	singer
select T1.Name from singer as T1 left join song as T2 on T1.Singer_ID = T2.Singer_ID where T2.Singer_ID is null	singer
select Citizenship from singer where Birth_Year < 1945 intersect select Citizenship from singer where Birth_Year > 1955	singer
select Citizenship from singer where Birth_Year < 1945 intersect select Citizenship from singer where Birth_Year > 1955	singer
