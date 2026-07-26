SELECT count(*) FROM poker_player	poker_player
SELECT count(*) FROM poker_player	poker_player
SELECT Earnings FROM poker_player ORDER BY Earnings DESC	poker_player
SELECT Earnings FROM poker_player ORDER BY Earnings DESC	poker_player
SELECT Final_Table_Made ,  Best_Finish FROM poker_player	poker_player
SELECT Final_Table_Made ,  Best_Finish FROM poker_player	poker_player
SELECT avg(Earnings) FROM poker_player	poker_player
SELECT avg(Earnings) FROM poker_player	poker_player
SELECT Money_Rank FROM poker_player ORDER BY Earnings DESC LIMIT 1	poker_player
SELECT Money_Rank FROM poker_player ORDER BY Earnings DESC LIMIT 1	poker_player
SELECT max(Final_Table_Made) FROM poker_player WHERE Earnings  <  200000	poker_player
SELECT max(Final_Table_Made) FROM poker_player WHERE Earnings  <  200000	poker_player
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID  =  T2.People_ID	poker_player
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID  =  T2.People_ID	poker_player
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID  =  T2.People_ID WHERE T2.Earnings  >  300000	poker_player
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID  =  T2.People_ID WHERE T2.Earnings  >  300000	poker_player
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID  =  T2.People_ID ORDER BY T2.Final_Table_Made	poker_player
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID  =  T2.People_ID ORDER BY T2.Final_Table_Made	poker_player
SELECT T1.Birth_Date FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID  =  T2.People_ID ORDER BY T2.Earnings ASC LIMIT 1	poker_player
SELECT T1.Birth_Date FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID  =  T2.People_ID ORDER BY T2.Earnings ASC LIMIT 1	poker_player
SELECT T2.Money_Rank FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID  =  T2.People_ID ORDER BY T1.Height DESC LIMIT 1	poker_player
SELECT T2.Money_Rank FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID  =  T2.People_ID ORDER BY T1.Height DESC LIMIT 1	poker_player
SELECT avg(T2.Earnings) FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID  =  T2.People_ID WHERE T1.Height  >  200	poker_player
SELECT avg(T2.Earnings) FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID  =  T2.People_ID WHERE T1.Height  >  200	poker_player
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID  =  T2.People_ID ORDER BY T2.Earnings DESC	poker_player
SELECT T1.Name FROM people AS T1 JOIN poker_player AS T2 ON T1.People_ID  =  T2.People_ID ORDER BY T2.Earnings DESC	poker_player
SELECT Nationality ,  COUNT(*) FROM people GROUP BY Nationality	poker_player
SELECT Nationality ,  COUNT(*) FROM people GROUP BY Nationality	poker_player
SELECT Nationality FROM people GROUP BY Nationality ORDER BY COUNT(*) DESC LIMIT 1	poker_player
SELECT Nationality FROM people GROUP BY Nationality ORDER BY COUNT(*) DESC LIMIT 1	poker_player
SELECT Nationality FROM people GROUP BY Nationality HAVING COUNT(*)  >=  2	poker_player
SELECT Nationality FROM people GROUP BY Nationality HAVING COUNT(*)  >=  2	poker_player
SELECT Name ,  Birth_Date FROM people ORDER BY Name ASC	poker_player
SELECT Name ,  Birth_Date FROM people ORDER BY Name ASC	poker_player
SELECT Name FROM people WHERE Nationality != "Russia"	poker_player
SELECT Name FROM people WHERE Nationality != "Russia"	poker_player
SELECT Name FROM people WHERE People_ID NOT IN (SELECT People_ID FROM poker_player)	poker_player
SELECT Name FROM people WHERE People_ID NOT IN (SELECT People_ID FROM poker_player)	poker_player
SELECT count(DISTINCT Nationality) FROM people	poker_player
SELECT count(DISTINCT Nationality) FROM people	poker_player
