select Airline from airlines where Abbreviation = "UAL"	flight_2
select Abbreviation from airlines where Airline = "Jetblue Airways"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "Jetblue Airways"	flight_2
select count(*) from flights inner join airports on flights.DestAirport = airports.AirportCode where airports.AirportName = "Aberdeen"	flight_2
select count(*) from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select count(*) from airlines where Country = "USA"	flight_2
select count(*) from flights	flight_2
select FlightNo from flights where SourceAirport = "APG"	flight_2
select count(*) from airports	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "AHD"	flight_2
select Airline, Abbreviation from airlines where Country = "USA"	flight_2
select AirportName from airports where AirportCode not in (select SourceAirport from flights) and AirportCode not in (select DestAirport from flights)	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select a.Airline from airlines a join flights f on a.Airline = f.Airline group by a.Airline having count(*) < 200	flight_2
select FlightNo from flights where SourceAirport = "APG"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City in ("Aberdeen", "Abilene")	flight_2
select count(*) from flights	flight_2
select airports.City from flights join airports on flights.SourceAirport = airports.AirportCode group by airports.City order by count(*) desc limit 1	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode join airlines on flights.Airline = airlines.uid where airports.City = "Aberdeen" and airlines.Airline = "United Airlines"	flight_2
select airports.City from airports join flights on flights.SourceAirport = airports.AirportCode group by airports.City order by count(flights.SourceAirport) desc limit 1	flight_2
select count(*) from flights as T1 join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "JetBlue Airways"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select AirportCode, AirportName from airports where AirportCode not in (select SourceAirport from flights where SourceAirport is not null union select DestAirport from flights where DestAirport is not null)	flight_2
select FlightNo from flights where DestAirport = "Aberdeen"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "United Airlines" and flights.DestAirport = "ASY"	flight_2
select flights.FlightNo from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select Airline, count(*) from flights group by Airline order by FlightCount desc limit 1	flight_2
select Country from airlines where Airline = "JetBlue Airways"	flight_2
select a.AirportCode from airports as a join flights as f on f.SourceAirport = a.AirportCode group by a.AirportCode order by count(*) asc limit 1	flight_2
select count(*) from airports	flight_2
select A.Airline from airlines as A join flights as F1 on A.uid = F1.Airline where F1.SourceAirport = "APG" intersect select A.Airline from airlines as A join flights as F2 on A.uid = F2.Airline where F2.SourceAirport = "CVO"	flight_2
select FlightNo from flights where Airline = "United Airlines"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select T1.Abbreviation, T1.Country from flights as T2 join airlines as T1 on T2.Airline = T1.uid group by T1.uid order by count(*) asc limit 1	flight_2
select count(*) from airlines	flight_2
select flights.FlightNo from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select distinct a.Airline from airlines as a join flights as f on a.uid = f.Airline where f.SourceAirport = "CVO" and a.Airline not in (select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "APG")	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select Airline, Abbreviation from airlines where Country = "USA"	flight_2
select count(*) from flights where SourceAirport = "APG"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where flights.Airline = "United Airlines" and airports.City = "Aberdeen"	flight_2
select AirportName from airports where City = "Aberdeen"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid join airports on flights.DestAirport = airports.AirportCode where airlines.Airline = "United Airlines" and airports.AirportCode = "ASY"	flight_2
select count(*) from airlines where Country = "USA"	flight_2
select Abbreviation from airlines where Airline = "JetBlue Airways"	flight_2
select airlines.Airline from airlines join flights on airlines.uid = flights.Airline group by airlines.Airline having count(flights.Airline) < 200	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select count(*) from flights join airports as source_airport on flights.SourceAirport = source_airport.AirportCode join airports as dest_airport on flights.DestAirport = dest_airport.AirportCode where source_airport.City = "Aberdeen" and dest_airport.City = "Ashley"	flight_2
