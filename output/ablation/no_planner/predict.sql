select Airline from airlines where Abbreviation = "UAL"	flight_2
select Abbreviation from airlines where Airline = "Jetblue Airways"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "Jetblue Airways"	flight_2
select count(*) from flights where DestAirport = "Aberdeen"	flight_2
select count(*) from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select count(distinct uid) from airlines where Country = "USA"	flight_2
select count(*) from flights	flight_2
select FlightNo from flights where SourceAirport = "APG"	flight_2
select count(*) from airports	flight_2
select distinct T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "AHD"	flight_2
select Airline, Abbreviation from airlines where Country = "USA"	flight_2
select AirportName from airports where AirportCode not in (select SourceAirport from flights union select DestAirport from flights)	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline having count(T2.Airline) < 200	flight_2
select FlightNo from flights where SourceAirport = "APG"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City in ("Aberdeen", "Abilene")	flight_2
select count(*) from flights	flight_2
select airports.City from flights join airports on flights.SourceAirport = airports.AirportCode group by airports.City order by count(flights.SourceAirport) desc limit 1	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid join airports on flights.DestAirport = airports.AirportCode where airlines.Airline = "United Airlines" and airports.City = "Aberdeen"	flight_2
select T1.City from airports as T1 join flights as T2 on T1.AirportCode = T2.SourceAirport group by T1.City order by count(T2.SourceAirport) desc limit 1	flight_2
select count(*) from flights where Airline = "JetBlue Airways"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select AirportName from airports where AirportCode not in (select SourceAirport from flights union select DestAirport from flights)	flight_2
select flights.FlightNo from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select count(*) from flights where Airline = "United Airlines" and DestAirport = "ASY"	flight_2
select T1.FlightNo from flights as T1 join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline order by count(T2.Airline) desc limit 1	flight_2
select Country from airlines where Airline = "JetBlue Airways"	flight_2
select a.AirportCode from airports as a left join flights as f on a.AirportCode = f.SourceAirport group by a.AirportCode order by count(f.FlightNo) asc limit 1	flight_2
select count(*) from airports	flight_2
select distinct a.Airline from airlines as a join flights as f on a.uid = f.Airline where f.SourceAirport = "APG" intersect select distinct a.Airline from airlines as a join flights as f on a.uid = f.Airline where f.SourceAirport = "CVO"	flight_2
select FlightNo from flights where Airline = "United Airlines"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select T1.Abbreviation, T1.Country from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.uid order by count(T2.Airline) asc limit 1	flight_2
select count(*) from airlines	flight_2
select T1.FlightNo from flights as T1 join airports as T2 on T1.SourceAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline where T2.SourceAirport = "CVO" except select T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline where T2.SourceAirport = "APG"	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select Airline, Abbreviation from airlines where Country = "USA"	flight_2
select count(*) from flights where SourceAirport = "APG"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where flights.Airline = "United Airlines" and airports.City = "Aberdeen"	flight_2
select AirportName from airports where City = "Aberdeen"	flight_2
select count(*) from flights as T1 inner join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines" and T1.DestAirport = "ASY"	flight_2
select count(*) from airlines where Country = "USA"	flight_2
select Abbreviation from airlines where Airline = "JetBlue Airways"	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline having count(*) < 200	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select count(*) from flights join airports as source_airport on flights.SourceAirport = source_airport.AirportCode join airports as dest_airport on flights.DestAirport = dest_airport.AirportCode where source_airport.City = "Aberdeen" and dest_airport.City = "Ashley"	flight_2
