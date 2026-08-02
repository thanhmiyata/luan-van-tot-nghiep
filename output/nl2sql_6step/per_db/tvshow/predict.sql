select Title from Cartoon order by Title asc	tvshow
select Title from Cartoon order by Title asc	tvshow
select Title from Cartoon where Directed_by = "Ben Jones"	tvshow
select Title from Cartoon where Directed_by = "Ben Jones"	tvshow
select count(*) from Cartoon where Written_by = "Joseph Kuhr"	tvshow
select count(*) from Cartoon where Written_by = "Joseph Kuhr"	tvshow
select Title, Directed_by from Cartoon order by Original_air_date asc	tvshow
select Title, Directed_by from Cartoon order by Original_air_date asc	tvshow
SELECT Title FROM Cartoon WHERE Directed_by = "Ben Jones" OR Directed_by = "Brandon Vietti";	tvshow
select Title from Cartoon where Directed_by = "Ben Jones" or Directed_by = "Brandon Vietti"	tvshow
SELECT Country, COUNT(*) FROM TV_Channel GROUP BY Country ORDER BY COUNT(*) DESC LIMIT 1	tvshow
SELECT Country, COUNT(*) FROM TV_Channel GROUP BY Country ORDER BY COUNT(*) DESC LIMIT 1	tvshow
select count(distinct series_name), count(distinct Content) from TV_Channel	tvshow
select count(distinct series_name), count(distinct Content) from TV_Channel	tvshow
select Content from TV_Channel where series_name = "Sky Radio"	tvshow
select Content from TV_Channel where series_name = "Sky Radio"	tvshow
select Package_Option from TV_Channel where series_name = "Sky Radio"	tvshow
select Package_Option from TV_Channel where series_name = "Sky Radio"	tvshow
select count(*) from TV_Channel where Language = "English"	tvshow
select count(*) from TV_Channel where Language = "English"	tvshow
SELECT Language, COUNT(*) FROM TV_Channel GROUP BY Language ORDER BY COUNT(*) ASC LIMIT 1	tvshow
SELECT LANGUAGE ,  count(*) FROM TV_Channel GROUP BY LANGUAGE ORDER BY count(*) ASC LIMIT 1;	tvshow
SELECT LANGUAGE ,  count(*) FROM TV_Channel GROUP BY LANGUAGE	tvshow
select Language, count(*) from TV_Channel group by Language	tvshow
select T1.series_name from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Title = "The Rise of the Blue Beetle!"	tvshow
SELECT T1.series_name FROM TV_Channel AS T1 JOIN Cartoon AS T2 ON T1.id = T2.Channel WHERE T2.Title = "The Rise of the Blue Beetle!";	tvshow
select T1.Title from Cartoon as T1 join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select T1.Title from Cartoon as T1 join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select Episode from TV_series order by Rating asc	tvshow
SELECT Episode, Rating FROM TV_series ORDER BY Rating DESC	tvshow
select Episode, Rating from TV_series order by Rating desc limit 3	tvshow
select Episode, Rating from TV_series order by Rating desc limit 3	tvshow
select min(Share), max(Share) from TV_series	tvshow
select max(Share), min(Share) from TV_series	tvshow
select Air_Date from TV_series where Episode = "A Love of a Lifetime"	tvshow
SELECT Original_air_date FROM Cartoon WHERE Title = 'A Love of a Lifetime'	tvshow
select Weekly_Rank from TV_series where Episode = "A Love of a Lifetime"	tvshow
select Weekly_Rank from TV_series where Episode = "A Love of a Lifetime"	tvshow
SELECT TV_series.Channel, TV_Channel.series_name FROM TV_series JOIN TV_Channel ON TV_series.Channel = TV_Channel.id WHERE TV_series.Episode = 'A Love of a Lifetime'	tvshow
select T1.series_name from TV_Channel as T1 join TV_series as T2 on T1.id = T2.Channel where T2.Episode = "A Love of a Lifetime"	tvshow
select T1.Episode from TV_series as T1 join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select Episode from TV_series where Channel = (select id from TV_Channel where series_name = "Sky Radio")	tvshow
select Directed_by, count(*) from Cartoon group by Directed_by	tvshow
select Directed_by, count(*) from Cartoon group by Directed_by	tvshow
select Production_code, Channel from Cartoon order by Original_air_date desc limit 1	tvshow
select Production_code, Channel from Cartoon order by Original_air_date desc limit 1	tvshow
select Package_Option, series_name from TV_Channel where Hight_definition_TV = "yes"	tvshow
select Package_Option, series_name from TV_Channel where Hight_definition_TV = "yes"	tvshow
select TV_Channel.Country from TV_Channel join Cartoon on TV_Channel.id = Cartoon.Channel where Cartoon.Written_by = "Todd Casey"	tvshow
SELECT TV_Channel.Country FROM Cartoon JOIN TV_Channel ON Cartoon.Channel = TV_Channel.id WHERE Cartoon.Written_by = 'Todd Casey'	tvshow
select Country from TV_Channel except select TV_Channel.Country from TV_Channel join Cartoon on TV_Channel.id = Cartoon.Channel where Cartoon.Written_by = "Todd Casey"	tvshow
SELECT Country FROM TV_Channel WHERE NOT id IN (SELECT Channel FROM Cartoon WHERE Written_by = 'Todd Casey')	tvshow
SELECT TV_Channel.series_name, TV_Channel.Country FROM TV_Channel JOIN Cartoon ON TV_Channel.id = Cartoon.Channel WHERE Cartoon.Directed_by = 'Ben Jones' OR Cartoon.Directed_by = 'Michael Chang'	tvshow
select T1.series_name, T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Directed_by = "Ben Jones" intersect select T1.series_name, T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Directed_by = "Michael Chang"	tvshow
SELECT Pixel_aspect_ratio_PAR ,  country FROM tv_channel WHERE LANGUAGE != 'English'	tvshow
SELECT Pixel_aspect_ratio_PAR ,  country FROM tv_channel WHERE LANGUAGE != 'English'	tvshow
SELECT id FROM TV_Channel WHERE Country IN (SELECT Country FROM TV_Channel GROUP BY Country HAVING COUNT(*) > 2)	tvshow
SELECT TV_Channel.id FROM TV_Channel JOIN TV_series ON TV_Channel.id = TV_series.Channel GROUP BY TV_Channel.id HAVING COUNT(*) > 2	tvshow
SELECT id FROM TV_Channel EXCEPT SELECT channel FROM cartoon WHERE directed_by  =  'Ben Jones'	tvshow
SELECT id FROM TV_Channel EXCEPT SELECT channel FROM cartoon WHERE directed_by  =  'Ben Jones'	tvshow
SELECT Package_Option FROM TV_Channel WHERE NOT EXISTS(SELECT 1 FROM Cartoon WHERE Directed_by = 'Ben Jones' AND Cartoon.Channel = TV_Channel.id)	tvshow
SELECT TV_Channel.Package_Option FROM TV_Channel WHERE NOT TV_Channel.id IN (SELECT Cartoon.Channel FROM Cartoon WHERE Cartoon.Directed_by = 'Ben Jones')	tvshow
