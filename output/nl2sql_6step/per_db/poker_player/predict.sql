select count(*) from poker_player	poker_player
select count(*) from poker_player	poker_player
select Earnings from poker_player order by Earnings desc	poker_player
select Earnings from poker_player order by Earnings desc	poker_player
select Final_Table_Made, Best_Finish from poker_player	poker_player
select Final_Table_Made, Best_Finish from poker_player	poker_player
select avg(Earnings) from poker_player	poker_player
select avg(Earnings) from poker_player	poker_player
select Money_Rank from poker_player order by Earnings desc limit 1	poker_player
select Money_Rank from poker_player order by Earnings desc limit 1	poker_player
select max(Final_Table_Made) from poker_player where Earnings < 200000	poker_player
select max(Final_Table_Made) from poker_player where Earnings < 200000	poker_player
select people.Name from poker_player join people on poker_player.People_ID = people.People_ID	poker_player
select T1.Name from people as T1 join poker_player as T2 on T1.People_ID = T2.People_ID	poker_player
select people.Name from poker_player join people on poker_player.People_ID = people.People_ID where poker_player.Earnings > 300000	poker_player
select T1.Name from people as T1 join poker_player as T2 on T1.People_ID = T2.People_ID where T2.Earnings > 300000	poker_player
select people.Name from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Final_Table_Made asc	poker_player
select people.Name from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Final_Table_Made asc	poker_player
select people.Birth_Date from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Earnings asc limit 1	poker_player
select people.Birth_Date from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Earnings asc limit 1	poker_player
select T1.Money_Rank from poker_player as T1 join people as T2 on T1.People_ID = T2.People_ID order by T2.Height desc limit 1	poker_player
select T1.Money_Rank from poker_player as T1 join people as T2 on T1.People_ID = T2.People_ID order by T2.Height desc limit 1	poker_player
select avg(poker_player.Earnings) from poker_player join people on poker_player.People_ID = people.People_ID where people.Height > 200	poker_player
select avg(poker_player.Earnings) from poker_player join people on poker_player.People_ID = people.People_ID where people.Height > 200	poker_player
select people.Name from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Earnings desc	poker_player
select people.Name from poker_player join people on poker_player.People_ID = people.People_ID order by poker_player.Earnings desc	poker_player
select Nationality, count(*) from people group by Nationality	poker_player
SELECT Nationality ,  COUNT(*) FROM people GROUP BY Nationality	poker_player
select Nationality from people group by Nationality order by count(*) desc limit 1	poker_player
select Nationality from people group by Nationality order by count(*) desc limit 1	poker_player
select Nationality from people group by Nationality having count(*) >= 2	poker_player
select Nationality from people group by Nationality having count(*) >= 2	poker_player
select Name, Birth_Date from people order by Name asc	poker_player
select Name, Birth_Date from people order by Name asc	poker_player
SELECT Name FROM people WHERE Nationality != "Russia"	poker_player
SELECT Name FROM people WHERE Nationality != "Russia"	poker_player
select people.Name from people left join poker_player on people.People_ID = poker_player.People_ID where poker_player.People_ID is null	poker_player
select people.Name from people left join poker_player on people.People_ID = poker_player.People_ID where poker_player.People_ID is null	poker_player
select count(distinct Nationality) from people	poker_player
select count(distinct Nationality) from people	poker_player
