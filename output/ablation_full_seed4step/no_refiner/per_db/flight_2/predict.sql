SELECT Country FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT Country FROM airlines WHERE Airline = 'Jetblue Airways'
SELECT Abbreviation FROM airlines WHERE Airline = 'JetBlue Airways'
SELECT Abbreviation FROM airlines WHERE Airline = 'Jetblue Airways'
SELECT Airline, Abbreviation FROM airlines WHERE Country = 'USA'
SELECT Airline, Abbreviation FROM airlines WHERE Country = 'USA'
SELECT AirportCode, AirportName FROM airports WHERE City = 'Anthony'
SELECT AirportCode, AirportName FROM airports WHERE City = 'Anthony'
SELECT COUNT(DISTINCT Airline) FROM airlines
SELECT COUNT(*) AS count FROM airlines
SELECT COUNT(*) AS number_of_airports FROM airports
SELECT COUNT(*) FROM airports
SELECT COUNT(*) FROM flights
SELECT COUNT(*) AS number_of_flights FROM flights
SELECT Airline FROM airlines WHERE Abbreviation = 'UAL'
SELECT Airline FROM airlines WHERE Abbreviation = 'UAL'
SELECT COUNT(*) AS count FROM airlines WHERE Country = 'USA'
SELECT COUNT(uid) FROM airlines WHERE Country = 'USA'
SELECT City, Country FROM airports WHERE AirportName = 'Alton'
SELECT City, Country FROM airports WHERE AirportName = 'Alton'
SELECT AirportName FROM airports WHERE AirportCode = 'AKO'
SELECT AirportName FROM airports WHERE AirportCode = 'AKO'
SELECT AirportName FROM airports WHERE City = 'Aberdeen'
SELECT AirportName FROM airports WHERE City = 'Aberdeen'
SELECT COUNT(*) AS flights_count FROM flights WHERE SourceAirport = ' APG'
SELECT COUNT(*) FROM flights WHERE SourceAirport = ' APG'
SELECT COUNT(*) FROM flights WHERE DestAirport = 'ATO'
SELECT COUNT(*) FROM flights WHERE DestAirport = 'ATO'
SELECT COUNT(*) FROM flights JOIN airports ON flights.SourceAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT COUNT(*) FROM flights JOIN airports ON flights.SourceAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT COUNT(*) AS count FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT COUNT(*) AS number_of_flights FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT COUNT(*) FROM flights JOIN airports AS source_airport ON flights.SourceAirport = source_airport.AirportCode JOIN airports AS dest_airport ON flights.DestAirport = dest_airport.AirportCode WHERE source_airport.City = 'Aberdeen' AND dest_airport.City = 'Ashley'
SELECT COUNT(*) FROM flights WHERE SourceAirport = 'ABERDEEN' AND DestAirport = 'ASHLEY'
SELECT COUNT(*) FROM flights WHERE Airline = 'JetBlue Airways'
SELECT COUNT(*) FROM flights WHERE Airline = 'Jetblue Airways'
SELECT COUNT(*) FROM flights JOIN airlines ON flights.Airline = airlines.uid WHERE airlines.Airline = 'United Airlines' AND flights.DestAirport = 'ASY'
SELECT COUNT(*) AS count FROM flights WHERE Airline = 'United Airlines' AND DestAirport = ' ASY'
SELECT COUNT(*) FROM flights JOIN airlines ON flights.Airline = airlines.Airline WHERE airlines.Airline = 'United Airlines' AND flights.SourceAirport = 'AHD'
SELECT COUNT(*) FROM flights JOIN airlines ON flights.Airline = airlines.uid WHERE flights.SourceAirport = 'AHD' AND airlines.Airline = 'United Airlines'
SELECT COUNT(*) FROM flights JOIN airlines ON flights.Airline = airlines.uid JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airlines.Airline = 'United Airlines' AND airports.City = 'Aberdeen'
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE flights.Airline = 'United Airlines' AND airports.City = 'Aberdeen'
SELECT airports.City, COUNT(*) FROM airports INNER JOIN flights ON flights.DestAirport = airports.AirportCode GROUP BY airports.City ORDER BY COUNT(*) DESC LIMIT 1
SELECT a.City FROM flights AS f JOIN airports AS a ON f.DestAirport = a.AirportCode GROUP BY a.City ORDER BY COUNT(*) DESC LIMIT 1
SELECT a.City FROM airports AS a JOIN flights AS f ON f.SourceAirport = a.AirportCode GROUP BY a.City ORDER BY COUNT(*) DESC LIMIT 1
SELECT City FROM airports JOIN flights ON airports.AirportCode = flights.SourceAirport GROUP BY City ORDER BY COUNT(*) DESC LIMIT 1
SELECT airports.AirportCode FROM airports INNER JOIN flights ON airports.AirportCode = flights.SourceAirport GROUP BY airports.AirportCode ORDER BY COUNT(*) DESC LIMIT 1
SELECT airports.AirportCode FROM flights INNER JOIN airports ON flights.SourceAirport = airports.AirportCode GROUP BY airports.AirportCode ORDER BY COUNT(*) DESC LIMIT 1
SELECT airports.AirportCode FROM airports JOIN flights ON flights.SourceAirport = airports.AirportCode GROUP BY flights.SourceAirport ORDER BY COUNT(*) ASC LIMIT 1
SELECT AirportCode FROM airports WHERE AirportCode = (SELECT SourceAirport FROM flights GROUP BY SourceAirport ORDER BY COUNT(*) ASC LIMIT 1)
SELECT airlines.Airline FROM flights INNER JOIN airlines ON flights.Airline = airlines.uid GROUP BY airlines.Airline ORDER BY COUNT(*) DESC LIMIT 1
SELECT airlines."Airline" FROM flights JOIN airlines ON flights."Airline" = airlines."Airline" GROUP BY airlines."Airline" ORDER BY COUNT(*) DESC LIMIT 1
SELECT a.Abbreviation, a.Country FROM airlines AS a JOIN flights AS f ON a.Airline = f.Airline GROUP BY a.Abbreviation, a.Country ORDER BY COUNT(*) ASC LIMIT 1
SELECT a.Abbreviation, a.Country FROM airlines AS a JOIN flights AS f ON a.Airline = f.Airline GROUP BY a.Abbreviation, a.Country ORDER BY COUNT(*) ASC LIMIT 1
SELECT airlines.Airline FROM airlines JOIN flights ON airlines.Airline = flights.Airline WHERE flights.SourceAirport = 'AHD'
SELECT airlines.Airline FROM airlines JOIN flights ON airlines.Airline = flights.Airline WHERE flights.SourceAirport = 'AHD'
SELECT airlines.Airline FROM airlines JOIN flights ON airlines.Airline = flights.Airline WHERE flights.DestAirport = 'AHD'
SELECT Airline FROM airlines WHERE uid IN (SELECT Airline FROM flights WHERE DestAirport = 'AHD')
SELECT DISTINCT airlines.Airline FROM flights INNER JOIN airlines ON flights.Airline = airlines.uid WHERE flights.SourceAirport = 'APG' INTERSECT SELECT DISTINCT airlines.Airline FROM flights INNER JOIN airlines ON flights.Airline = airlines.uid WHERE flights.SourceAirport = 'CVO'
SELECT a.Airline FROM airlines AS a JOIN flights AS f ON a.Airline = f.Airline WHERE f.SourceAirport = 'APG' INTERSECT SELECT a.Airline FROM airlines AS a JOIN flights AS f ON a.Airline = f.Airline WHERE f.SourceAirport = 'CVO'
SELECT DISTINCT airlines.Airline FROM flights INNER JOIN airlines ON flights.Airline = airlines.Airline WHERE flights.SourceAirport = 'CVO' EXCEPT SELECT DISTINCT airlines.Airline FROM flights INNER JOIN airlines ON flights.Airline = airlines.Airline WHERE flights.SourceAirport = 'APG'
SELECT a.Airline FROM airlines AS a WHERE a.Airline IN (SELECT Airline FROM flights WHERE SourceAirport = 'CVO') AND NOT a.Airline IN (SELECT Airline FROM flights WHERE SourceAirport = 'APG')
SELECT a.Airline FROM airlines AS a JOIN flights AS f ON a.Airline = f.Airline GROUP BY a.Airline HAVING COUNT(*) >= 10
SELECT a.Airline FROM airlines AS a JOIN flights AS f ON a.Airline = f.Airline GROUP BY a.Airline HAVING COUNT(*) >= 10
SELECT airlines.Airline FROM airlines JOIN flights ON airlines.uid = flights.Airline GROUP BY airlines.Airline HAVING COUNT(*) < 200
SELECT a.Airline FROM airlines AS a JOIN flights AS f ON a.Airline = f.Airline GROUP BY a.Airline HAVING COUNT(f.FlightNo) < 200
SELECT FlightNo FROM flights WHERE Airline = 'United Airlines'
SELECT flights.FlightNo FROM flights JOIN airlines ON flights.Airline = airlines.Airline WHERE airlines.Airline = 'United Airlines'
SELECT FlightNo FROM flights WHERE SourceAirport = 'APG'
SELECT FlightNo FROM flights WHERE SourceAirport = 'APG'
SELECT FlightNo FROM flights WHERE DestAirport = 'APG'
SELECT FlightNo FROM flights WHERE DestAirport = 'APG'
SELECT FlightNo FROM flights WHERE SourceAirport IN (SELECT AirportCode FROM airports WHERE City = 'Aberdeen ')
SELECT FlightNo FROM flights INNER JOIN airports ON flights.SourceAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT f.FlightNo FROM flights AS f JOIN airports AS a ON f.DestAirport = a.AirportCode WHERE a.City = 'Aberdeen'
SELECT FlightNo FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen'
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen' OR airports.City = 'Abilene'
SELECT COUNT(*) FROM flights JOIN airports ON flights.DestAirport = airports.AirportCode WHERE airports.City = 'Aberdeen ' OR airports.City = 'Abilene '
SELECT AirportName FROM airports WHERE NOT AirportCode IN (SELECT SourceAirport FROM flights UNION SELECT DestAirport FROM flights)
SELECT AirportName FROM airports WHERE NOT AirportCode IN (SELECT SourceAirport FROM flights UNION SELECT DestAirport FROM flights)
