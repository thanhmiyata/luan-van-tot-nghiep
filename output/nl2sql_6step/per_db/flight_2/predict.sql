select Country from airlines where Airline = "JetBlue Airways"	flight_2
select Country from airlines where Airline = "JetBlue Airways"	flight_2
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
SELECT count(*) FROM AIRLINES WHERE Country  =  "USA"	flight_2
select City, Country from airports where AirportName = "Alton"	flight_2
select City, Country from airports where AirportName = "Alton"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select AirportName from airports where City = "Aberdeen"	flight_2
select AirportName from airports where City = "Aberdeen"	flight_2
select count(*) from flights where SourceAirport = " APG"	flight_2
select count(*) from flights where SourceAirport = "APG"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
SELECT count(*) FROM FLIGHTS AS T1 JOIN AIRPORTS AS T2 ON T1.SourceAirport  =  T2.AirportCode WHERE T2.City  =  "Aberdeen"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen "	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen "	flight_2
select count(*) from flights join airports as source_airport on flights.SourceAirport = source_airport.AirportCode join airports as dest_airport on flights.DestAirport = dest_airport.AirportCode where source_airport.City = "Aberdeen " and dest_airport.City = "Ashley"	flight_2
select count(*) from flights where SourceAirport = "APG" and DestAirport = "ASY"	flight_2
select count(*) from flights where Airline = "JetBlue Airways"	flight_2
SELECT count(*) FROM FLIGHTS AS T1 JOIN AIRLINES AS T2 ON T1.Airline  =  T2.uid WHERE T2.Airline = "JetBlue Airways"	flight_2
select count(*) from flights as T1 join airlines as T2 on T1.Airline = T2.uid where T2.Airline = "United Airlines" and T1.DestAirport = " ASY"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "United Airlines" and flights.DestAirport = "ASY"	flight_2
SELECT count(*) FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T2.Airline  =  T1.uid WHERE T1.Airline  =  "United Airlines" AND T2.SourceAirport  =  "AHD"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where flights.SourceAirport = "AHD" and airlines.Airline = "United Airlines"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid join airports on flights.DestAirport = airports.AirportCode where airlines.Airline = "United Airlines" and airports.City = "Aberdeen"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where flights.Airline = "United Airlines" and airports.City = "Aberdeen "	flight_2
SELECT T1.City FROM AIRPORTS AS T1 JOIN FLIGHTS AS T2 ON T1.AirportCode  =  T2.DestAirport GROUP BY T1.City ORDER BY count(*) DESC LIMIT 1	flight_2
select airports.City from flights inner join airports on flights.DestAirport = airports.AirportCode group by airports.City order by count(*) desc limit 1	flight_2
select T1.City from airports as T1 join flights as T2 on T2.SourceAirport = T1.AirportCode group by T1.City order by count(*) desc limit 1	flight_2
select airports.City from flights join airports on flights.SourceAirport = airports.AirportCode group by airports.City order by count(*) desc limit 1	flight_2
SELECT T1.AirportCode FROM AIRPORTS AS T1 JOIN FLIGHTS AS T2 ON T1.AirportCode  =  T2.DestAirport OR T1.AirportCode  =  T2.SourceAirport GROUP BY T1.AirportCode ORDER BY count(*) DESC LIMIT 1	flight_2
select a.AirportCode from airports as a join flights as f on f.SourceAirport = a.AirportCode group by a.AirportCode order by count(*) desc limit 1	flight_2
select a.AirportCode from airports as a join flights as f on a.AirportCode = f.SourceAirport group by a.AirportCode order by count(*) asc limit 1	flight_2
select a.AirportCode from airports as a join flights as f on a.AirportCode = f.SourceAirport group by a.AirportCode order by count(*) asc limit 1	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.Airline order by count(*) desc limit 1	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline group by T1.uid order by count(T2.Airline) desc limit 1	flight_2
SELECT T1.Abbreviation ,  T1.Country FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T1.uid  =  T2.Airline GROUP BY T1.Airline ORDER BY count(*) LIMIT 1	flight_2
SELECT T1.Abbreviation ,  T1.Country FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T1.uid  =  T2.Airline GROUP BY T1.Airline ORDER BY count(*) LIMIT 1	flight_2
select distinct airlines.Airline from airlines join flights on airlines.Airline = flights.Airline where flights.SourceAirport = "AHD"	flight_2
select distinct T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline where T2.SourceAirport = "AHD"	flight_2
select distinct airlines.Airline from airlines join flights on airlines.Airline = flights.Airline where flights.DestAirport = "AHD"	flight_2
select distinct airlines.Airline from airlines join flights on airlines.Airline = flights.Airline where flights.DestAirport = "AHD"	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "APG" intersect select T1.Airline from airlines as T1 join flights as T2 on T1.uid = T2.Airline where T2.SourceAirport = "CVO"	flight_2
select distinct Airline from flights where SourceAirport = "APG" intersect select distinct Airline from flights where SourceAirport = "CVO"	flight_2
SELECT T1.Airline FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T1.uid  =  T2.Airline WHERE T2.SourceAirport  =  "CVO" EXCEPT SELECT T1.Airline FROM AIRLINES AS T1 JOIN FLIGHTS AS T2 ON T1.uid  =  T2.Airline WHERE T2.SourceAirport  =  "APG"	flight_2
select T1.Airline from airlines as T1 join (select distinct Airline from flights where SourceAirport = "CVO" except select distinct Airline from flights where SourceAirport = "APG") on T1.Airline = T2.Airline	flight_2
select airlines.Airline from airlines join flights on airlines.Airline = flights.Airline group by airlines.Airline having count(*) >= 10	flight_2
select airlines.Airline from flights join airlines on flights.Airline = airlines.Airline group by airlines.Airline having count(*) >= 10	flight_2
select airlines.Airline from airlines join flights on airlines.Airline = flights.Airline group by airlines.Airline having count(*) < 200	flight_2
select T1.Airline from airlines as T1 join flights as T2 on T1.Airline = T2.Airline group by T1.Airline having count(*) < 200	flight_2
select flights.FlightNo from flights join airlines on flights.Airline = airlines.Airline where airlines.Airline = "United Airlines"	flight_2
select FlightNo from flights where Airline = "United Airlines"	flight_2
select FlightNo from flights where SourceAirport = " APG"	flight_2
select FlightNo from flights where SourceAirport = " APG"	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select flights.FlightNo from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen "	flight_2
SELECT T1.FlightNo FROM FLIGHTS AS T1 JOIN AIRPORTS AS T2 ON T1.SourceAirport   =  T2.AirportCode WHERE T2.City  =  "Aberdeen"	flight_2
select T1.FlightNo from flights as T1 join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen "	flight_2
select T1.FlightNo from flights as T1 join airports as T2 on T1.DestAirport = T2.AirportCode where T2.City = "Aberdeen"	flight_2
SELECT count(*) FROM Flights AS T1 JOIN Airports AS T2 ON T1.DestAirport  =  T2.AirportCode WHERE T2.city  =  "Aberdeen" OR T2.city  =  "Abilene"	flight_2
SELECT count(*) FROM Flights AS T1 JOIN Airports AS T2 ON T1.DestAirport  =  T2.AirportCode WHERE T2.city  =  "Aberdeen" OR T2.city  =  "Abilene"	flight_2
select AirportName from airports where AirportCode not in (select SourceAirport from flights union select DestAirport from flights)	flight_2
select AirportCode, AirportName from airports where AirportCode not in (select SourceAirport from flights union select DestAirport from flights)	flight_2
