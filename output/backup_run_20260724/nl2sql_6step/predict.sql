select Abbreviation from airlines where Airline = "Jetblue Airways"	flight_2
select count(*) from flights where flights.Airline = (select uid from airlines where Airline = "Jetblue Airways")	flight_2
select count(*) from flights where DestAirport = "Aberdeen"	flight_2
select count(*) from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select count(*) from airlines where Country = "USA"	flight_2
select count(*) from flights	flight_2
select FlightNo from flights where SourceAirport = "APG"	flight_2
select count(*) from airports	flight_2
select distinct T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "AHD"	flight_2
select Airline, Abbreviation from airlines where Country = "USA"	flight_2
select T1.AirportName from airports as T1 left join flights as T2 on T1.AirportCode = T2.SourceAirport or T1.AirportCode = T2.DestAirport where T2.FlightNo is null	flight_2
select flights.FlightNo from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select a.Airline from airlines as a join flights as f on a.uid = f.Airline group by a.uid having count(f.Airline) < 200	flight_2
select FlightNo from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select count(*) from flights where SourceAirport = "APG"	flight_2
select T1.City from airports as T1 join flights as T2 on T1.AirportCode = T2.SourceAirport group by T1.City order by count(*) desc limit 1	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid join airports on flights.DestAirport = airports.AirportCode where airlines.Airline = "United Airlines" and airports.City = "Aberdeen"	flight_2
select T1.City from flights as T2 join airports as T1 on T2.SourceAirport = T1.AirportCode group by T1.City order by count(*) desc limit 1	flight_2
select count(*) from flights where Airline = "JetBlue Airways"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select Airline from airlines where Abbreviation = "UAL"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City in ("Aberdeen", "Abilene")	flight_2
select T1.count from flights as T1 inner join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines" and T1.DestAirport = "ASY"	flight_2
select flights.FlightNo from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline group by T1.Airline order by count(*) desc limit 1	flight_2
select Country from airlines where Airline = "JetBlue Airways"	flight_2
select airports.AirportCode from flights join airports on flights.SourceAirport = airports.AirportCode group by airports.AirportCode order by count(flights.FlightNo) asc limit 1	flight_2
select count(*) from airports	flight_2
select distinct airlines.Airline from flights join airlines on airlines.uid = flights.Airline where flights.SourceAirport = "CVO" except select distinct airlines.Airline from flights join airlines on airlines.uid = flights.Airline where flights.SourceAirport = "APG"	flight_2
select T1.FlightNo from flights as T1 join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select count(*) from airlines	flight_2
select flights.FlightNo from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select airports.AirportCode from flights join airports on flights.SourceAirport = airports.AirportCode group by airports.AirportCode order by count(*) desc limit 1	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select Airline, Abbreviation from airlines where Country = "USA"	flight_2
select count(*) from flights where SourceAirport = "APG"	flight_2
select airports.City from airports join flights on flights.DestAirport = airports.AirportCode group by airports.City order by count(flights.DestAirport) desc limit 1	flight_2
select AirportName from airports where City = "Aberdeen"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "United Airlines" and flights.SourceAirport = "AHD"	flight_2
select count(*) from airlines where Country = "USA"	flight_2
select Abbreviation from airlines where Airline = "JetBlue Airways"	flight_2
select T1.FlightNo from flights as T1 join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines"	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where flights.Airline = "United Airlines" and airports.City = "Aberdeen"	flight_2
select distinct a.Airline from airlines as a join flights as f1 on a.Airline = f1.Airline where f1.SourceAirport = "CVO" except select distinct a.Airline from airlines as a join flights as f2 on a.Airline = f2.Airline where f2.SourceAirport = "APG"	flight_2
select a.AirportCode from airports as a join flights as f on a.AirportCode = f.SourceAirport or a.AirportCode = f.DestAirport group by a.AirportCode order by count(*) desc limit 1	flight_2
