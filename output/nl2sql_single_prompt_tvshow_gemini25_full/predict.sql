select Title from Cartoon order by Title	tvshow
select Title from Cartoon order by Title	tvshow
select Title from Cartoon where Directed_by = "Ben Jones"	tvshow
select Title from Cartoon where Directed_by = "Ben Jones"	tvshow
select count(*) from Cartoon where Written_by = "Joseph Kuhr"	tvshow
select count(*) from Cartoon where Written_by = "Joseph Kuhr"	tvshow
select Title, Directed_by from Cartoon order by Original_air_date	tvshow
select Title, Directed_by from Cartoon order by Original_air_date	tvshow
select Title from Cartoon where Directed_by = "Ben Jones" or Directed_by = "Brandon Vietti"	tvshow
select Title from Cartoon where Directed_by = "Ben Jones" or Directed_by = "Brandon Vietti"	tvshow
select Country, count(id) from TV_Channel group by Country order by count(id) desc limit 1	tvshow
select Country, count(id) from TV_Channel group by Country order by count(id) desc limit 1	tvshow
select count(distinct series_name), count(distinct Content) from TV_Channel	tvshow
select count(distinct series_name), count(distinct Content) from TV_Channel	tvshow
select Content from TV_Channel where series_name = "Sky Radio"	tvshow
select Content from TV_Channel where series_name = "Sky Radio"	tvshow
select Package_Option from TV_Channel where series_name = "Sky Radio"	tvshow
select Package_Option from TV_Channel where series_name = "Sky Radio"	tvshow
select count(*) from TV_Channel where Language = "English"	tvshow
select count(id) from TV_Channel where Language = "English"	tvshow
select Language, count(id) from TV_Channel group by Language order by count(id) asc limit 1	tvshow
select Language, count(id) from TV_Channel group by Language having count(id) = (select min(channel_count) from (select count(id) from TV_Channel group by Language))	tvshow
select Language, count(id) from TV_Channel group by Language	tvshow
select Language, count(id) from TV_Channel group by Language	tvshow
select T1.series_name from TV_Channel as T1 inner join Cartoon as T2 on T1.id = T2.Channel where T2.Title = "The Rise of the Blue Beetle!"	tvshow
select T1.series_name from TV_Channel as T1 inner join Cartoon as T2 on T1.id = T2.Channel where T2.Title = "The Rise of the Blue Beetle"	tvshow
select T1.Title from Cartoon as T1 inner join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select T1.Title from Cartoon as T1 inner join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select Episode from TV_series order by Rating	tvshow
select Episode from TV_series order by Rating	tvshow
ite select Episode, Rating from TV_series order by Rating desc limit 3	tvshow
select Episode, Rating from TV_series order by Rating desc limit 3	tvshow
select min(Share), max(Share) from TV_series	tvshow
select max(Share), min(Share) from TV_series	tvshow
select Air_Date from TV_series where Episode = "A Love of a Lifetime"	tvshow
select Air_Date from TV_series where Episode = "A Love of a Lifetime"	tvshow
select Weekly_Rank from TV_series where Episode = "A Love of a Lifetime"	tvshow
select Weekly_Rank from TV_series where Episode = "A Love of a Lifetime"	tvshow
select T1.series_name from TV_Channel as T1 join TV_series as T2 on T1.id = T2.Channel where T2.Episode = "A Love of a Lifetime"	tvshow
select T1.series_name from TV_Channel as T1 inner join TV_series as T2 on T1.id = T2.Channel where T2.Episode = "A Love of a Lifetime"	tvshow
select T1.Episode from TV_series as T1 inner join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select T1.Episode from TV_series as T1 inner join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select Directed_by, count(id) from Cartoon group by Directed_by	tvshow
select Directed_by, count(Title) from Cartoon group by Directed_by	tvshow
select Production_code, Channel from Cartoon order by Original_air_date desc limit 1	tvshow
select Production_code, Channel from Cartoon order by Original_air_date desc limit 1	tvshow
select Package_Option, series_name from TV_Channel where Hight_definition_TV = "Yes"	tvshow
select Package_Option, series_name from TV_Channel where Hight_definition_TV = "Yes"	tvshow
select distinct T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Written_by = "Todd Casey"	tvshow
select distinct T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Written_by = "Todd Casey"	tvshow
select Country from TV_Channel except select T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Written_by = "Todd Casey"	tvshow
select distinct Country from TV_Channel where id not in (select Channel from Cartoon where Written_by = "Todd Casey")	tvshow
select T1.series_name, T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Directed_by = "Ben Jones" or T2.Directed_by = "Michael Chang"	tvshow
select T1.series_name, T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Directed_by in ("Ben Jones", "Michael Chang") group by T1.id having count(distinct T2.Directed_by) = 2	tvshow
select Pixel_aspect_ratio_PAR, Country from TV_Channel where Language != "English"	tvshow
select Pixel_aspect_ratio_PAR, Country from TV_Channel where Language != "English"	tvshow
select id from TV_Channel where Country in ( select Country from TV_Channel group by Country having count(id) > 2 )	tvshow
select id from TV_Channel group by id having count(id) > 2	tvshow
select id from TV_Channel except select Channel from Cartoon where Directed_by = "Ben Jones"	tvshow
select id from TV_Channel except select Channel from Cartoon where Directed_by = "Ben Jones"	tvshow
select Package_Option from TV_Channel where id not in ( select Channel from Cartoon where Directed_by = "Ben Jones" )	tvshow
select Package_Option from TV_Channel where id not in ( select Channel from Cartoon where Directed_by = "Ben Jones" )	tvshow
