select Country from airlines where Airline = "JetBlue Airways"	flight_2
select Country from airlines where Airline = "Jetblue Airways"	flight_2
select Abbreviation from airlines where Airline = "JetBlue Airways"	flight_2
select Abbreviation from airlines where Airline = "Jetblue Airways"	flight_2
select Airline, Abbreviation from airlines where Country = "USA"	flight_2
select Airline, Abbreviation from airlines where Country = "USA"	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select count(*) from airlines	flight_2
select count(*) from airlines	flight_2
select count(*) from airports	flight_2
select count(*) from airports	flight_2
select count(*) from flights	flight_2
select count(*) from flights	flight_2
select Airline from airlines where Abbreviation = "UAL"	flight_2
select Airline from airlines where Abbreviation = "UAL"	flight_2
select count(*) from airlines where Country = "USA"	flight_2
select count(*) from airlines where Country = "USA"	flight_2
select City, Country from airports where AirportName = "Alton airport"	flight_2
select City, Country from airports where AirportName = "Alton airport"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select AirportName from airports where City = "Aberdeen"	flight_2
select AirportName from airports where City = "Aberdeen"	flight_2
select count(*) from flights where SourceAirport = "APG"	flight_2
select count(*) from flights where SourceAirport = "APG"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights as T1 join airports as T2 on T1.SourceAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select count(*) from flights as T1 join airports as T2 on T1.SourceAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select count(*) from flights as T1 join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select count(*) from flights as T1 join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select count(*) from flights as T1 inner join airports as T2 on T1.SourceAirport = T2.AirportCode inner join airports as T3 on T1.DestAirport = T3.AirportCode where T2.City = "Aberdeen" and T3.City = "Ashley"	flight_2
select count(*) from flights as T1 inner join airports as T2 on T1.SourceAirport = T2.AirportCode inner join airports as T3 on T1.DestAirport = T3.AirportCode where T2.City = "Aberdeen" and T3.City = "Ashley"	flight_2
select count(*) from flights as T1 join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "JetBlue Airways"	flight_2
select count(*) from flights as T1 join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "Jetblue Airways"	flight_2
select count(*) from flights as T1 join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines" and T1.DestAirport = "ASY"	flight_2
select count(*) from flights as T1 join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines" and T1.DestAirport = "ASY"	flight_2
select count(*) from flights as T1 join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines" and T1.SourceAirport = "AHD"	flight_2
select count(*) from flights as T1 inner join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines" and T1.SourceAirport = "AHD"	flight_2
select count(T1.FlightNo) from flights as T1 inner join airlines as T2 on T1.Airline = T2.uid inner join airports as T3 on T1.DestAirport = T3.AirportCode where T2.Airline = "United Airlines" and T3.City = "Aberdeen"	flight_2
select count(*) from flights as T1 inner join airlines as T2 on T1.Airline = T2.uid inner join airports as T3 on T1.DestAirport = T3.AirportCode where T2.Airline = "United Airlines" and T3.City = "Aberdeen"	flight_2
select T2.City from flights as T1 join airports as T2 on T1.DestAirport = T2.AirportCode group by T2.City order by count(T1.FlightNo) desc limit 1	flight_2
select T1.City from airports as T1 join flights as T2 on T1.AirportCode = T2.DestAirport group by T1.City order by count(T2.DestAirport) desc limit 1	flight_2
select T2.City from flights as T1 join airports as T2 on T1.SourceAirport = T2.AirportCode group by T2.City order by count(T1.FlightNo) desc limit 1	flight_2
select T1.City from airports as T1 join flights as T2 on T1.AirportCode = T2.SourceAirport group by T1.City order by count(T2.SourceAirport) desc limit 1	flight_2
select AirportCode from (select SourceAirport from flights union ALL select DestAirport from flights) group by AirportCode order by count(AirportCode) desc limit 1	flight_2
select AirportCode from (select SourceAirport from flights union ALL select DestAirport from flights) group by AirportCode order by count(AirportCode) desc limit 1	flight_2
select AirportCode from (select SourceAirport from flights union ALL select DestAirport from flights) group by AirportCode order by count(AirportCode) asc limit 1	flight_2
select AirportCode from (select SourceAirport from flights union ALL select DestAirport from flights) group by AirportCode order by count(*) asc limit 1	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline order by count(T2.FlightNo) desc limit 1	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline order by count(T2.FlightNo) desc limit 1	flight_2
select T1.Abbreviation, T1.Country from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.uid order by count(T2.FlightNo) asc limit 1	flight_2
select T1.Abbreviation, T1.Country from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.uid order by count(*) asc limit 1	flight_2
select distinct T1.Airline from airlines as T1 inner join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "AHD"	flight_2
select distinct T1.Airline from airlines as T1 inner join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "AHD"	flight_2
select distinct T1.Airline from airlines as T1 inner join flights as T2 on T1.uid = T2.Airline where T2.DestAirport = "AHD"	flight_2
select distinct T1.Airline from airlines as T1 inner join flights as T2 on T1.uid = T2.Airline where T2.DestAirport = "AHD"	flight_2
select T1.Airline from airlines as T1 inner join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport in ("APG", "CVO") group by T1.Airline having count(distinct T2.SourceAirport) = 2	flight_2
select T1.Airline from airlines as T1 inner join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "APG" intersect select T1.Airline from airlines as T1 inner join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "CVO"	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "CVO" except select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "APG"	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "CVO" except select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "APG"	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline having count(T2.FlightNo) >= 10	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline having count(*) >= 10	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline having count(*) < 200	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline having count(T2.FlightNo) < 200	flight_2
select T1.FlightNo from flights as T1 inner join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines"	flight_2
select T1.FlightNo from flights as T1 inner join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines"	flight_2
select FlightNo from flights where SourceAirport = "APG"	flight_2
select FlightNo from flights where SourceAirport = "APG"	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select T1.FlightNo from flights as T1 inner join airports as T2 on T1.SourceAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select T1.FlightNo from flights as T1 inner join airports as T2 on T1.SourceAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select T1.FlightNo from flights as T1 inner join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select T1.FlightNo from flights as T1 inner join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select count(*) from flights as T1 join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen" or T2.City = "Abilene"	flight_2
select count(*) from flights as T1 join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen" or T2.City = "Abilene"	flight_2
select AirportName from airports where AirportCode not in (select SourceAirport from flights) and AirportCode not in (select DestAirport from flights)	flight_2
select AirportCode from airports except select SourceAirport from flights union select DestAirport from flights	flight_2
