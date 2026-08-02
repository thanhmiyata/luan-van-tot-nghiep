select Country from airlines where Airline = "JetBlue Airways"	flight_2
select Country from airlines where Airline = "Jetblue Airways"	flight_2
select Abbreviation from airlines where Airline = "JetBlue Airways"	flight_2
select Abbreviation from airlines where Airline = "Jetblue Airways"	flight_2
select a.Airline, a.Abbreviation from airlines a where a.Country = "USA"	flight_2
select Airline, Abbreviation from airlines where Country = "USA"	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select AirportCode, AirportName from airports where City = "Anthony"	flight_2
select count(*) from airlines	flight_2
select count(*) from airlines	flight_2
select count(distinct AirportCode) from airports	flight_2
select count(*) from airports	flight_2
select count(*) from flights	flight_2
select count(*) from flights	flight_2
select Airline from airlines where Abbreviation = "UAL"	flight_2
select Airline from airlines where Abbreviation = "UAL"	flight_2
select count(*) from airlines where Country = "USA"	flight_2
select count(*) from airlines where Country = "USA"	flight_2
select City, Country from airports where AirportName = "Alton"	flight_2
select City, Country from airports where AirportName = "Alton"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select AirportName from airports where AirportCode = "AKO"	flight_2
select AirportName from airports where City = "Aberdeen"	flight_2
select AirportName from airports where City = "Aberdeen"	flight_2
select count(*) from flights where SourceAirport = "APG"	flight_2
select count(*) from flights where SourceAirport = "APG"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights where DestAirport = "ATO"	flight_2
select count(*) from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select count(*) from flights join airports on flights.SourceAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City = "Aberdeen"	flight_2
select count(*) from flights f join airports a1 on f.SourceAirport = a1.AirportCode join airports a2 on f.DestAirport = a2.AirportCode where a1.City = "Aberdeen" and a2.City = "Ashley"	flight_2
select count(*) from flights f join airports a1 on f.SourceAirport = a1.AirportCode join airports a2 on f.DestAirport = a2.AirportCode where a1.City = "Aberdeen" and a2.City = "Ashley"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "JetBlue Airways"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "Jetblue Airways"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "United Airlines" and flights.DestAirport = "ASY"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "United Airlines" and flights.DestAirport = "ASY"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "United Airlines" and flights.SourceAirport = "AHD"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid where airlines.Airline = "United Airlines" and flights.SourceAirport = "AHD"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid join airports on flights.DestAirport = airports.AirportCode where airlines.Airline = "United Airlines" and airports.City = "Aberdeen"	flight_2
select count(*) from flights join airlines on flights.Airline = airlines.uid join airports on flights.DestAirport = airports.AirportCode where airlines.Airline = "United Airlines" and airports.City = "Aberdeen"	flight_2
select airports.City from flights join airports on flights.DestAirport = airports.AirportCode group by airports.City order by count(flights.FlightNo) desc limit 1	flight_2
select a.City from flights f join airports a on f.DestAirport = a.AirportCode group by a.City order by count(*) desc limit 1	flight_2
select a.City from airports a join flights f on a.AirportCode = f.SourceAirport group by a.City order by count(f.FlightNo) desc limit 1	flight_2
select SourceAirport, City, count(*) from flights join airports on flights.SourceAirport = airports.AirportCode group by SourceAirport order by flight_count desc limit 1	flight_2
select SourceAirport from flights group by SourceAirport order by count(*) desc limit 1	flight_2
select SourceAirport from flights group by SourceAirport order by count(*) desc limit 1	flight_2
select AirportCode from airports join ( select SourceAirport , count(*) from flights group by SourceAirport union ALL select DestAirport , count(*) from flights group by DestAirport ) on airports.AirportCode = FlightCounts.AirportCode group by AirportCode order by sum(FlightCount) asc limit 1	flight_2
select AirportCode from airports left join ( select SourceAirport , count(*) from flights group by SourceAirport union ALL select DestAirport , count(*) from flights group by DestAirport ) on airports.AirportCode = FlightCounts.Airport group by AirportCode order by COALESCE(sum(FlightCount), 0) asc limit 1	flight_2
select a.Airline from airlines a join flights f on a.uid = f.Airline group by a.Airline order by count(f.FlightNo) desc limit 1	flight_2
select a.Airline from airlines a join flights f on a.uid = f.Airline group by a.Airline order by count(f.FlightNo) desc limit 1	flight_2
select a.Abbreviation, a.Country from airlines a join flights f on a.uid = f.Airline group by a.uid order by count(f.FlightNo) asc limit 1	flight_2
select a.Abbreviation, a.Country from airlines a join flights f on a.uid = f.Airline group by a.uid order by count(f.FlightNo) asc limit 1	flight_2
select distinct a.Airline from airlines a join flights f on a.uid = f.Airline where f.SourceAirport = "AHD"	flight_2
select distinct a.Airline from airlines a join flights f on a.uid = f.Airline where f.SourceAirport = "AHD"	flight_2
select distinct a.Airline from airlines a join flights f on a.uid = f.Airline where f.DestAirport = "AHD"	flight_2
select distinct a.Airline from airlines a join flights f on a.uid = f.Airline where f.DestAirport = "AHD"	flight_2
select distinct a.Airline from airlines a join flights f1 on a.uid = f1.Airline join flights f2 on a.uid = f2.Airline where f1.SourceAirport = "APG" and f2.SourceAirport = "CVO"	flight_2
select distinct a.Airline from airlines a join flights f1 on a.uid = f1.Airline join flights f2 on a.uid = f2.Airline where f1.SourceAirport = "APG" and f2.SourceAirport = "CVO"	flight_2
select distinct a.Airline from airlines a join flights f on a.uid = f.Airline where f.SourceAirport = "CVO" and a.uid not in ( select f2.Airline from flights f2 where f2.SourceAirport = "APG" )	flight_2
select distinct a.Airline from airlines a join flights f on a.uid = f.Airline where f.SourceAirport = "CVO" and a.uid not in ( select f2.Airline from flights f2 where f2.SourceAirport = "APG" )	flight_2
select a.Airline from airlines a join flights f on a.uid = f.Airline group by a.Airline having count(f.FlightNo) >= 10	flight_2
select a.Airline from airlines a join flights f on a.uid = f.Airline group by a.Airline having count(f.FlightNo) >= 10	flight_2
select a.Airline from airlines a join flights f on a.uid = f.Airline group by a.Airline having count(f.FlightNo) < 200	flight_2
select a.Airline from airlines a join flights f on a.uid = f.Airline group by a.Airline having count(f.FlightNo) < 200	flight_2
select f.FlightNo from flights f join airlines a on f.Airline = a.uid where a.Airline = "United Airlines"	flight_2
select f.FlightNo from flights f join airlines a on f.Airline = a.uid where a.Airline = "United Airlines"	flight_2
select FlightNo from flights where SourceAirport = "APG"	flight_2
select FlightNo from flights where SourceAirport = "APG"	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select FlightNo from flights where DestAirport = "APG"	flight_2
select f.FlightNo from flights f join airports a on f.SourceAirport = a.AirportCode where a.City = "Aberdeen "	flight_2
select FlightNo from flights where SourceAirport = (select AirportCode from airports where City = "Aberdeen")	flight_2
select f.FlightNo from flights f join airports a on f.DestAirport = a.AirportCode where a.City = "Aberdeen"	flight_2
select f.FlightNo from flights f join airports a on f.DestAirport = a.AirportCode where a.City = "Aberdeen"	flight_2
select count(*) from flights join airports on flights.DestAirport = airports.AirportCode where airports.City in ("Aberdeen", "Abilene")	flight_2
select count(*) from flights where DestAirport in ( select AirportCode from airports where City in ("Aberdeen", "Abilene") )	flight_2
select AirportName from airports where AirportCode not in ( select SourceAirport from flights union select DestAirport from flights )	flight_2
select a.AirportName from airports a left join flights f1 on a.AirportCode = f1.SourceAirport left join flights f2 on a.AirportCode = f2.DestAirport where f1.SourceAirport is null and f2.DestAirport is null	flight_2
