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
