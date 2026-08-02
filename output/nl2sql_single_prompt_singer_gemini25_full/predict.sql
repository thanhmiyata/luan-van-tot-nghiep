select count(*) from singer	singer
select count(*) from singer	singer
select Name from singer order by Net_Worth_Millions asc	singer
select Name from singer order by Net_Worth_Millions asc	singer
select Birth_Year, Citizenship from singer	singer
select Birth_Year, Citizenship from singer	singer
select Name from singer where Citizenship != "France"	singer
select Name from singer where Citizenship != "French"	singer
select Name from singer where Birth_Year in (1948, 1949)	singer
select Name from singer where Birth_Year in (1948, 1949)	singer
select Name from singer order by Net_Worth_Millions desc limit 1	singer
select Name from singer order by Net_Worth_Millions desc limit 1	singer
select Citizenship, count(Singer_ID) from singer group by Citizenship	singer
select count(*) , Citizenship from singer group by Citizenship	singer
select Citizenship from singer group by Citizenship order by count(*) desc limit 1	singer
select Citizenship from singer group by Citizenship order by count(*) desc limit 1	singer
select Citizenship, max(Net_Worth_Millions) from singer group by Citizenship	singer
select Citizenship, max(Net_Worth_Millions) from singer group by Citizenship	singer
select T1.Title, T2.Name from song as T1 join singer as T2 on T1.Singer_ID = T2.Singer_ID	singer
select T1.Title, T2.Name from song as T1 join singer as T2 on T1.Singer_ID = T2.Singer_ID	singer
select distinct T1.Name from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID where T2.Sales > 300000	singer
select distinct T1.Name from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID where T2.Sales > 300000	singer
select T1.Name from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID group by T1.Singer_ID having count(T2.Song_ID) > 1	singer
select T1.Name from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID group by T1.Singer_ID having count(T2.Song_ID) > 1	singer
select T1.Name, sum(T2.Sales) from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID group by T1.Name	singer
select T1.Name, sum(T2.Sales) from singer as T1 join song as T2 on T1.Singer_ID = T2.Singer_ID group by T1.Name	singer
select T1.Name from singer as T1 left join song as T2 on T1.Singer_ID = T2.Singer_ID where T2.Song_ID is null	singer
select Name from singer where Singer_ID not in ( select Singer_ID from song )	singer
select Citizenship from singer where Birth_Year < 1945 intersect select Citizenship from singer where Birth_Year > 1955	singer
select Citizenship from singer where Birth_Year < 1945 intersect select Citizenship from singer where Birth_Year > 1955	singer
