select Country from airlines where Airline = "JetBlue Airways"	flight_2
select Country from airlines where Airline = "Jetblue Airways"	flight_2
select Abbreviation from airlines where Airline = "JetBlue Airways"	flight_2
select Abbreviation from airlines where Airline = "Jetblue Airways"	flight_2
select Airline, Abbreviation from airlines where Country = "USA"	flight_2
select Airline, Abbreviation from airlines where Country = "USA"	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select count(distinct Airline) from airlines	flight_2
select count(distinct Airline) from airlines	flight_2
select count(*) from airports	flight_2
select count(*) from airports	flight_2
select count(*) from flights	flight_2
select count(*) from flights	flight_2
select Airline from airlines where Abbreviation = "UAL"	flight_2
select Airline from airlines where Abbreviation = "UAL"	flight_2
select count(*) from airlines where Country = "USA"	flight_2
select count(uid) from airlines where Country = "USA"	flight_2
select City, Country from airports where AirportName = "Alton"	flight_2
select City, Country from airports where AirportName = "Alton"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select AirportName from airports where TRIM(City) = "Aberdeen"	flight_2
select AirportName from airports where City = "Aberdeen"	flight_2
select count(*) from flights where SourceAirport = " APG"	flight_2
select count(*) from flights where SourceAirport = " APG"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select count(*) from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen "	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select count(*) from flights join airports as source_airport on flights.SourceAirport = source_airport.AirportCode join airports as dest_airport on flights.DestAirport = dest_airport.AirportCode where source_airport.City = "Aberdeen " and dest_airport.City = "Ashley"	flight_2
select count(*) from flights as T1 join airports as T2 on T1.SourceAirport = T2.AirportCode join airports as T3 on T1.DestAirport = T3.AirportCode where T2.City = "Aberdeen" and T3.City = "Ashley"	flight_2
select count(*) from flights where Airline = "JetBlue Airways"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "Jetblue Airways"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "United Airlines" and flights.DestAirport = " ASY"	flight_2
select count(*) from flights where Airline = "United Airlines" and DestAirport = " ASY"	flight_2
select count(*) from flights where Airline = "United Airlines" and SourceAirport = "AHD"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where flights.SourceAirport = "AHD" and airlines.Airline = "United Airlines"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid join airports on flights.DestAirport = airports.AirportCode where airlines.Airline = "United Airlines" and airports.City = "Aberdeen "	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where flights.Airline = "United Airlines" and airports.City = "Aberdeen"	flight_2
select airports.City from airports join flights on airports.AirportCode = flights.DestAirport group by airports.City order by count(*) desc limit 1	flight_2
select a.City from flights as f join airports as a on f.DestAirport = a.AirportCode group by a.City order by count(*) desc limit 1	flight_2
select a.City from airports a join flights f on f.SourceAirport = a.AirportCode group by a.City order by count(*) desc limit 1	flight_2
select City from airports join flights on airports.AirportCode = flights.SourceAirport group by City order by count(*) desc limit 1	flight_2
select a.AirportCode from airports as a join flights as f on a.AirportCode = f.SourceAirport group by a.AirportCode order by count(*) desc limit 1	flight_2
select T1.AirportCode from airports as T1 join flights as T2 on T1.AirportCode = T2.SourceAirport group by T1.AirportCode order by count(T2.SourceAirport) desc limit 1	flight_2
select a.AirportCode from airports as a join flights as f on a.AirportCode = f.SourceAirport group by a.AirportCode order by count(*) asc limit 1	flight_2
select AirportCode from airports where AirportCode = (select SourceAirport from flights group by SourceAirport order by count(*) asc limit 1)	flight_2
select Airline from flights group by Airline order by count(*) desc limit 1	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline order by count(*) desc limit 1	flight_2
select a.Abbreviation, a.Country from airlines a join flights f on a.Airline = f.Airline group by a.Abbreviation, a.Country order by count(*) asc limit 1	flight_2
select a.Abbreviation, a.Country from airlines as a join flights as f on a.uid = f.Airline group by a.uid order by count(*) asc limit 1	flight_2
select distinct airlines.Airline from airlines join flights on airlines.Airline = flights.Airline where flights.SourceAirport = "AHD"	flight_2
select distinct T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline where T2.SourceAirport = "AHD"	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline where T2.DestAirport = "AHD"	flight_2
select Airline from airlines where uid in (select Airline from flights where DestAirport = "AHD")	flight_2
select Airline from flights where SourceAirport in ("APG", "CVO") group by Airline having count(distinct SourceAirport) = 2	flight_2
select a.Airline from airlines as a join flights as f on a.Airline = f.Airline where f.SourceAirport = "APG" intersect select a.Airline from airlines as a join flights as f on a.Airline = f.Airline where f.SourceAirport = "CVO"	flight_2
select distinct f1.Airline from flights f1 where f1.SourceAirport = "CVO" and f1.Airline not in (select f2.Airline from flights f2 where f2.SourceAirport = "APG")	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline where T2.SourceAirport = "CVO" except select T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline where T2.SourceAirport = "APG"	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline group by T1.Airline having count(*) >= 10	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline group by T1.Airline having count(*) >= 10	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline having count(*) < 200	flight_2
select a.Airline from airlines as a join flights as f on a.Airline = f.Airline group by a.Airline having count(*) < 200	flight_2
select FlightNo from flights where Airline = "United Airlines"	flight_2
select T1.FlightNo from flights as T1 join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines"	flight_2
select FlightNo from flights where SourceAirport = "APG"	flight_2
select FlightNo from flights where SourceAirport = "APG"	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select FlightNo from flights where SourceAirport in (select AirportCode from airports where City = "Aberdeen ")	flight_2
select T1.FlightNo from flights as T1 inner join airports as T2 on T1.SourceAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select f.FlightNo from flights f join airports a on f.DestAirport = a.AirportCode where a.City = "Aberdeen"	flight_2
select T1.FlightNo from flights as T1 join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen " or airports.City = "Abilene "	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen " or airports.City = "Abilene "	flight_2
select AirportName from airports where AirportCode not in (select SourceAirport from flights union select DestAirport from flights)	flight_2
select AirportName from airports where AirportCode not in (select SourceAirport from flights union select DestAirport from flights)	flight_2
