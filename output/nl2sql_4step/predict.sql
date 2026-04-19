select Airline from airlines where Abbreviation = "UAL"	flight_2
select Abbreviation from airlines where Airline = "Jetblue Airways"	flight_2
select count(*) from flights where Airline = "JetBlue Airways"	flight_2
select count(*) from flights where DestAirport = "Aberdeen"	flight_2
select count(T1.Airline) from flights as T1 join airports as T2 on T1.SourceAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select count(distinct uid) from airlines where Country = "USA"	flight_2
select count(*) from flights	flight_2
select FlightNo from flights where SourceAirport = "APG"	flight_2
select count(distinct AirportCode) from airports	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "AHD"	flight_2
select Airline, Abbreviation from airlines where Country = "USA"	flight_2
select T1.AirportName from airports as T1 left join flights as T2 on T1.AirportCode = T2.SourceAirport or T1.AirportCode = T2.DestAirport where T2.SourceAirport is null and T2.DestAirport is null	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select a.Airline from airlines as a join flights as f on a.uid = f.Airline group by a.Airline having count(distinct f.uid) < 200	flight_2
select FlightNo from flights where SourceAirport = "APG"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City in ("Aberdeen", "Abilene")	flight_2
select count(distinct FlightNo) from flights	flight_2
select a.City from airports a join flights f on a.AirportCode = f.SourceAirport group by a.City order by count(distinct f.SourceAirport) desc limit 1	flight_2
select count(T1.Airline) from flights as T1 join airlines as T2 on T1.Airline = T2.uid join airports as T3 on T1.DestAirport = T3.AirportCode where T2.Airline = "United Airlines" and T3.City = "Aberdeen"	flight_2
select T1.City from airports as T1 join flights as T2 on T1.AirportCode = T2.SourceAirport group by T1.City order by count(*) desc limit 1	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "JetBlue Airways"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select a.AirportCode, a.AirportName from airports a left join flights f1 on a.AirportCode = f1.SourceAirport left join flights f2 on a.AirportCode = f2.DestAirport where f1.SourceAirport is null and f2.DestAirport is null	flight_2
select FlightNo from flights where DestAirport = "Aberdeen"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "United Airlines" and flights.DestAirport = "ASY"	flight_2
select flights.FlightNo from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select a.Airline from airlines as a join flights as f on a.uid = f.Airline group by a.Airline order by count(f.Airline) desc limit 1	flight_2
select Country from airlines where Airline = "JetBlue Airways"	flight_2
select T1.AirportCode from airports as T1 join (select airport_code, count(*) from (select SourceAirport from flights union ALL select DestAirport from flights) group by airport_code order by flight_count asc limit 1) on T1.AirportCode = T2.airport_code	flight_2
select count(distinct AirportCode) from airports	flight_2
select a.Airline from airlines a join flights f on a.uid = f.Airline where f.SourceAirport in ("APG", "CVO") group by a.Airline having count(distinct f.SourceAirport) = 2	flight_2
select FlightNo from flights where Airline = "United Airlines"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select T1.Abbreviation, T1.Country from airlines as T1 join flights as T2 on T1.Airline = T2.Airline group by T1.Airline order by count(T2.Airline) asc limit 1	flight_2
select count(distinct uid) from airlines	flight_2
select FlightNo from flights where SourceAirport = (select AirportCode from airports where City = "Aberdeen")	flight_2
select distinct T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline where T2.SourceAirport = "CVO" and T1.Airline not in (select Airline from flights where SourceAirport = "APG")	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select Airline, Abbreviation from airlines where Country = "USA"	flight_2
select count(*) from flights where SourceAirport = "APG"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where flights.Airline = "United Airlines" and airports.City = "Aberdeen"	flight_2
select AirportName from airports where City = "Aberdeen"	flight_2
select count(*) from flights where Airline = "United Airlines" and DestAirport = "ASY"	flight_2
select count(*) from airlines where Country = "USA"	flight_2
select Abbreviation from airlines where Airline = "JetBlue Airways"	flight_2
select a.Airline from airlines as a join flights as f on a.uid = f.Airline group by a.Airline having count(distinct f.uid) < 200	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select count(*) from flights as T1 join airports as T2 on T1.SourceAirport = T2.AirportCode join airports as T3 on T1.DestAirport = T3.AirportCode where T2.City = "Aberdeen" and T3.City = "Ashley"	flight_2
