SELECT COUNT(*) FROM singer
SELECT COUNT(Singer_ID) AS count FROM singer
SELECT Name FROM singer ORDER BY Net_Worth_Millions ASC
SELECT Name FROM singer ORDER BY Net_Worth_Millions ASC
SELECT Birth_Year, Citizenship FROM singer
SELECT Birth_Year, Citizenship FROM singer
SELECT Name FROM singer WHERE Citizenship <> 'France'
SELECT Name FROM singer WHERE Citizenship <> 'France'
SELECT Name FROM singer WHERE Birth_Year = 1948 OR Birth_Year = 1949
SELECT Name FROM singer WHERE Birth_Year = 1948 OR Birth_Year = 1949
SELECT Name FROM singer ORDER BY Net_Worth_Millions DESC LIMIT 1
SELECT Name FROM singer ORDER BY Net_Worth_Millions DESC LIMIT 1
SELECT Citizenship, COUNT(Singer_ID) AS number_of_singers FROM singer GROUP BY Citizenship
SELECT Citizenship, COUNT(Singer_ID) AS count FROM singer GROUP BY Citizenship
SELECT Citizenship FROM singer GROUP BY Citizenship ORDER BY COUNT(*) DESC LIMIT 1
SELECT Citizenship, COUNT(Singer_ID) FROM singer GROUP BY Citizenship ORDER BY COUNT(Singer_ID) DESC LIMIT 1
SELECT Citizenship, MAX(Net_Worth_Millions) FROM singer GROUP BY Citizenship
SELECT Citizenship, MAX(Net_Worth_Millions) FROM singer GROUP BY Citizenship
SELECT song.Title, singer.Name FROM song JOIN singer ON song.Singer_ID = singer.Singer_ID
SELECT song.Title, singer.Name FROM song JOIN singer ON song.Singer_ID = singer.Singer_ID
SELECT DISTINCT singer.Name FROM singer JOIN song ON singer.Singer_ID = song.Singer_ID WHERE song.Sales > 300000
SELECT DISTINCT singer.Name FROM singer JOIN song ON singer.Singer_ID = song.Singer_ID WHERE song.Sales > 300000
SELECT singer.Name FROM singer JOIN song ON singer.Singer_ID = song.Singer_ID GROUP BY singer.Name HAVING COUNT(*) > 1
SELECT Name FROM singer JOIN song ON singer.Singer_ID = song.Singer_ID GROUP BY singer.Singer_ID, Name HAVING COUNT(*) > 1
SELECT singer.Name, SUM(song.Sales) AS Total_Sales FROM singer JOIN song ON singer.Singer_ID = song.Singer_ID GROUP BY singer.Name
SELECT singer.Name, SUM(song.Sales) AS total_sales FROM singer JOIN song ON singer.Singer_ID = song.Singer_ID GROUP BY singer.Name
SELECT Name FROM singer WHERE NOT Singer_ID IN (SELECT Singer_ID FROM song)
SELECT Name FROM singer WHERE NOT Singer_ID IN (SELECT Singer_ID FROM song)
SELECT Citizenship FROM singer WHERE Birth_Year < 1945 OR Birth_Year > 1955 GROUP BY Citizenship
SELECT Citizenship FROM singer WHERE (Birth_Year < 1945) INTERSECT SELECT Citizenship FROM singer WHERE (Birth_Year > 1955)
