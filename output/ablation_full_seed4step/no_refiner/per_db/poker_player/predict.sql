SELECT COUNT(Poker_Player_ID) FROM poker_player
SELECT COUNT(*) FROM poker_player
SELECT Earnings FROM poker_player ORDER BY Earnings DESC
SELECT Earnings FROM poker_player ORDER BY Earnings DESC
SELECT Final_Table_Made, Best_Finish FROM poker_player
SELECT Final_Table_Made, Best_Finish FROM poker_player
SELECT AVG(Earnings) FROM poker_player
SELECT AVG(Earnings) FROM poker_player
SELECT Money_Rank FROM poker_player ORDER BY Earnings DESC LIMIT 1
SELECT Money_Rank FROM poker_player ORDER BY Earnings DESC LIMIT 1
SELECT MAX(Final_Table_Made) AS MaxFinalTableMade FROM poker_player WHERE Earnings < 200000
SELECT MAX(Final_Table_Made) FROM poker_player WHERE Earnings < 200000
SELECT Name FROM people
SELECT Name FROM people JOIN poker_player ON people.People_ID = poker_player.People_ID
SELECT Name FROM people INNER JOIN poker_player ON people.People_ID = poker_player.People_ID WHERE poker_player.Earnings > 300000
SELECT people.Name FROM poker_player INNER JOIN people ON poker_player.People_ID = people.People_ID WHERE poker_player.Earnings > 300000
SELECT people.Name FROM poker_player JOIN people ON poker_player.People_ID = people.People_ID ORDER BY poker_player.Final_Table_Made ASC
SELECT Name FROM people JOIN poker_player ON people.People_ID = poker_player.People_ID ORDER BY Final_Table_Made ASC
SELECT people.Birth_Date FROM poker_player JOIN people ON poker_player.People_ID = people.People_ID ORDER BY poker_player.Earnings ASC LIMIT 1
SELECT Birth_Date FROM people JOIN poker_player ON people.People_ID = poker_player.People_ID ORDER BY Earnings ASC LIMIT 1
SELECT po.Money_Rank FROM poker_player AS po JOIN people AS pe ON po.People_ID = pe.People_ID ORDER BY pe.Height DESC LIMIT 1
SELECT p.Money_Rank FROM poker_player AS p JOIN people AS pe ON p.People_ID = pe.People_ID ORDER BY pe.Height DESC LIMIT 1
SELECT AVG(poker_player.Earnings) AS average_earnings FROM poker_player JOIN people ON poker_player.People_ID = people.People_ID WHERE people.Height > 200
SELECT AVG(Earnings) FROM poker_player JOIN people ON poker_player.People_ID = people.People_ID WHERE Height > 200
SELECT people.Name FROM poker_player JOIN people ON poker_player.People_ID = people.People_ID ORDER BY poker_player.Earnings DESC
SELECT Name FROM people JOIN poker_player ON people.People_ID = poker_player.People_ID ORDER BY Earnings DESC
SELECT Nationality, COUNT(People_ID) AS number_of_people FROM people GROUP BY Nationality
SELECT Nationality, COUNT(*) AS Count FROM people GROUP BY Nationality
SELECT Nationality FROM people GROUP BY Nationality ORDER BY COUNT(*) DESC LIMIT 1
SELECT Nationality FROM people GROUP BY Nationality ORDER BY COUNT(*) DESC LIMIT 1
SELECT Nationality FROM people GROUP BY Nationality HAVING COUNT(*) >= 2
SELECT Nationality FROM people GROUP BY Nationality HAVING COUNT(*) >= 2
SELECT Name, Birth_Date FROM people ORDER BY Name ASC
SELECT Name, Birth_Date FROM people ORDER BY Name ASC
SELECT Name FROM people WHERE Nationality <> 'Russia'
SELECT Name FROM people WHERE Nationality <> 'Russia'
SELECT Name FROM people WHERE NOT People_ID IN (SELECT People_ID FROM poker_player)
SELECT Name FROM people WHERE NOT People_ID IN (SELECT People_ID FROM poker_player)
SELECT COUNT(DISTINCT Nationality) FROM people
SELECT COUNT(DISTINCT Nationality) FROM people
