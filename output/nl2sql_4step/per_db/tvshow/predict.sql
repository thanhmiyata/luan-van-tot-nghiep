select Title from Cartoon order by Title asc	tvshow
select Title from Cartoon order by Title asc	tvshow
select Title from Cartoon where Directed_by = "Ben Jones"	tvshow
select Title from Cartoon where Directed_by = "Ben Jones"	tvshow
select count(id) from Cartoon where Written_by = "Joseph Kuhr"	tvshow
select count(*) from Cartoon where Written_by = "Joseph Kuhr"	tvshow
select Title, Directed_by from Cartoon order by Original_air_date asc	tvshow
select Title, Directed_by from Cartoon order by Original_air_date asc	tvshow
select Title from Cartoon where Directed_by = "Ben Jones" or Directed_by = "Brandon Vietti"	tvshow
select Title from Cartoon where Directed_by = "Ben Jones" or Directed_by = "Brandon Vietti"	tvshow
select Country, count(id) from TV_Channel group by Country order by number_of_TV_Channels desc limit 1	tvshow
select Country, count(id) from TV_Channel group by Country order by count desc limit 1	tvshow
select count(distinct series_name), count(distinct Content) from TV_Channel	tvshow
select count(distinct series_name), count(distinct Content) from TV_Channel	tvshow
select Content from TV_Channel where series_name = "Sky Radio"	tvshow
select Content from TV_Channel where series_name = "Sky Radio"	tvshow
select Package_Option from TV_Channel where series_name = "Sky Radio"	tvshow
select Package_Option from TV_Channel where series_name = "Sky Radio"	tvshow
select count(Language) from TV_Channel where Language = "English"	tvshow
select count(*) from TV_Channel where Language = "English"	tvshow
select Language, count(id) as "TV Channel count" from TV_Channel group by Language order by count(id) asc	tvshow
select Language, count(id) from TV_Channel group by Language order by channel_count asc limit 1	tvshow
select Language, count(*) as "number of TV Channels" from TV_Channel group by Language	tvshow
select Language, count(id) from TV_Channel group by Language	tvshow
select Cartoon.Channel, TV_Channel.series_name from Cartoon join TV_Channel on Cartoon.Channel = TV_Channel.id where Cartoon.Title = "The Rise of the Blue Beetle!"	tvshow
select series_name from TV_Channel where id = (select Channel from Cartoon where Title = "The Rise of the Blue Beetle!")	tvshow
select Cartoon.Title from Cartoon join TV_Channel on Cartoon.Channel = TV_Channel.id where TV_Channel.series_name = "Sky Radio"	tvshow
select T1.Title from Cartoon as T1 join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select Episode from TV_series order by Rating asc	tvshow
select Episode, Rating from TV_series order by Rating desc	tvshow
select Episode, Rating from TV_series order by Rating desc limit 3	tvshow
select Episode, Rating from TV_series order by Rating desc limit 3	tvshow
select min(Share), max(Share) from TV_series	tvshow
select max(Share), min(Share) from TV_series	tvshow
select Air_Date from TV_series where Episode = "A Love of a Lifetime"	tvshow
select Original_air_date from Cartoon where Title = "A Love of a Lifetime"	tvshow
select Weekly_Rank from TV_series where Episode = "A Love of a Lifetime"	tvshow
select Weekly_Rank from TV_series where Episode = "A Love of a Lifetime"	tvshow
select T1.Channel, T2.series_name from TV_series as T1 join TV_Channel as T2 on T1.Channel = T2.id where T1.Episode = "A Love of a Lifetime"	tvshow
select series_name from TV_Channel where id = (select Channel from TV_series where Episode = "A Love of a Lifetime")	tvshow
select T1.Episode from TV_series as T1 join TV_Channel as T2 on T1.Channel = T2.id where T2.series_name = "Sky Radio"	tvshow
select Episode from TV_series join TV_Channel on TV_series.Channel = TV_Channel.id where TV_Channel.series_name = "Sky Radio"	tvshow
select Directed_by, count(id) from Cartoon group by Directed_by	tvshow
select Directed_by, count(id) from Cartoon group by Directed_by	tvshow
select Production_code, Channel from Cartoon order by Original_air_date desc limit 1	tvshow
select Production_code, Channel from Cartoon order by Original_air_date desc limit 1	tvshow
select Package_Option, series_name from TV_Channel where Hight_definition_TV = "yes"	tvshow
select Package_Option, series_name from TV_Channel where Hight_definition_TV = "yes"	tvshow
select T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Written_by = "Todd Casey"	tvshow
select TV_Channel.Country from Cartoon join TV_Channel on Cartoon.Channel = TV_Channel.id where Cartoon.Written_by = "Todd Casey"	tvshow
select TV_Channel.Country from TV_Channel where TV_Channel.id not in (select Cartoon.Channel from Cartoon where Cartoon.Written_by = "Todd Casey")	tvshow
select T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Written_by != "Todd Casey"	tvshow
select TV_Channel.series_name, TV_Channel.Country from TV_Channel join Cartoon on TV_Channel.id = Cartoon.Channel where Cartoon.Directed_by = "Ben Jones" or Cartoon.Directed_by = "Michael Chang"	tvshow
select T1.series_name, T1.Country from TV_Channel as T1 join Cartoon as T2 on T1.id = T2.Channel where T2.Directed_by in ("Ben Jones", "Michael Chang") group by T1.id, T1.series_name, T1.Country having count(distinct T2.Directed_by) = 2	tvshow
select Pixel_aspect_ratio_PAR, Country from TV_Channel where Language <> "English"	tvshow
select Pixel_aspect_ratio_PAR, Country from TV_Channel where Language <> "English"	tvshow
select id from TV_Channel where Country in (select Country from TV_Channel group by Country having count(*) > 2)	tvshow
select T1.id from TV_Channel as T1 join TV_series as T2 on T1.id = T2.Channel group by T1.id having count(*) > 2	tvshow
select id from TV_Channel where id not in (select Channel from Cartoon where Directed_by = "Ben Jones")	tvshow
select id from TV_Channel where id not in (select Channel from Cartoon where Directed_by = "Ben Jones")	tvshow
select Package_Option from TV_Channel where id not in (select Channel from Cartoon where Directed_by = "Ben Jones")	tvshow
select T1.Package_Option from TV_Channel as T1 where T1.id not in (select T2.Channel from Cartoon as T2 where T2.Directed_by = "Ben Jones")	tvshow
