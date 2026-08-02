select count(*) from players	wta_1
select count(*) from players	wta_1
select count(*) from matches	wta_1
select count(*) from matches	wta_1
select first_name, birth_date from players where country_code = "USA"	wta_1
select players.first_name, players.birth_date from players where players.country_code = "USA"	wta_1
select avg(winner_age), avg(loser_age) from matches	wta_1
select avg(loser_age), avg(winner_age) from matches	wta_1
select avg(winner_rank) from matches	wta_1
SELECT avg(winner_rank) FROM matches	wta_1
SELECT MAX(loser_rank) FROM matches	wta_1
select loser_rank from matches order by loser_rank asc limit 1	wta_1
select count(distinct country_code) from players	wta_1
select count(distinct country_code) from players	wta_1
select count(distinct loser_name) from matches	wta_1
select count(distinct loser_name) from matches	wta_1
select tourney_name from matches group by tourney_name having count(*) > 10	wta_1
select tourney_name from matches group by tourney_name having count(*) > 10	wta_1
SELECT DISTINCT winner_name FROM matches WHERE year = 2013 AND winner_id IN (SELECT winner_id FROM matches WHERE year = 2016)	wta_1
SELECT DISTINCT winner_name FROM matches WHERE year = 2013 INTERSECT SELECT DISTINCT winner_name FROM matches WHERE year = 2016	wta_1
SELECT count(*) FROM matches WHERE YEAR  =  2013 OR YEAR  =  2016	wta_1
SELECT count(*) FROM matches WHERE YEAR  =  2013 OR YEAR  =  2016	wta_1
select p.country_code, p.first_name from players as p where p.player_id in (select winner_id from matches where tourney_name = "WTA Championships" intersect select winner_id from matches where tourney_name = "Australian Open")	wta_1
select p.first_name, p.country_code from players p join matches m1 on p.player_id = m1.winner_id where m1.tourney_name = "WTA Championships" intersect select p.first_name, p.country_code from players p join matches m2 on p.player_id = m2.winner_id where m2.tourney_name = "Australian Open"	wta_1
select first_name, country_code from players order by birth_date asc limit 1	wta_1
select first_name, country_code from players order by birth_date asc limit 1	wta_1
select first_name, last_name from players order by birth_date asc	wta_1
select first_name, last_name from players order by birth_date asc	wta_1
SELECT first_name ,  last_name FROM players WHERE hand  =  'L' ORDER BY birth_date	wta_1
select first_name, last_name from players where hand = "L" order by birth_date asc	wta_1
SELECT players.first_name, players.country_code FROM players JOIN rankings ON players.player_id = rankings.player_id ORDER BY rankings.tours DESC LIMIT 1	wta_1
SELECT players.first_name, players.country_code FROM players JOIN rankings ON players.player_id = rankings.player_id ORDER BY rankings.tours DESC LIMIT 1	wta_1
select year from matches group by year order by count(*) desc limit 1	wta_1
select year from matches group by year order by count(*) desc limit 1	wta_1
SELECT winner_name, winner_rank_points FROM matches GROUP BY winner_id ORDER BY COUNT(*) DESC LIMIT 1	wta_1
SELECT winner_name, winner_rank_points FROM matches WHERE winner_id = (SELECT winner_id FROM matches GROUP BY winner_id ORDER BY COUNT(*) DESC LIMIT 1) LIMIT 1	wta_1
select winner_name from matches where tourney_name = "Australian Open" order by winner_rank_points desc limit 1	wta_1
select winner_name from matches where tourney_name = "Australian Open" order by winner_rank_points desc limit 1	wta_1
select loser_name, winner_name from matches order by minutes desc limit 1	wta_1
select winner_name, loser_name from matches order by minutes desc limit 1	wta_1
SELECT AVG(rankings.ranking), players.first_name FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.player_id	wta_1
select players.first_name, avg(rankings.ranking) from players join rankings on players.player_id = rankings.player_id group by players.first_name	wta_1
SELECT players.first_name, SUM(rankings.ranking_points) FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.player_id	wta_1
SELECT players.first_name, SUM(rankings.ranking_points) FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.player_id, players.first_name	wta_1
select country_code, count(*) from players group by country_code	wta_1
select country_code, count(*) from players group by country_code	wta_1
select country_code from players group by country_code order by count(*) desc limit 1	wta_1
SELECT country_code FROM players GROUP BY country_code ORDER BY count(*) DESC LIMIT 1	wta_1
select country_code from players group by country_code having count(*) > 50	wta_1
select country_code from players group by country_code having count(*) > 50	wta_1
select ranking_date, sum(tours) from rankings group by ranking_date	wta_1
SELECT SUM(tours), ranking_date FROM rankings GROUP BY ranking_date	wta_1
select year, count(*) from matches group by year	wta_1
SELECT count(*) ,  YEAR FROM matches GROUP BY YEAR	wta_1
select winner_name, winner_rank from matches order by winner_age asc limit 3	wta_1
select winner_name, winner_rank from matches order by winner_age asc limit 3	wta_1
select count(distinct matches.winner_id) from matches join players on matches.winner_id = players.player_id where matches.tourney_name = "WTA Championships" and players.hand = "L"	wta_1
select count(*) from matches where winner_hand = "L" and tourney_name = "WTA Championships"	wta_1
select T1.first_name, T1.country_code, T1.birth_date from players as T1 join matches as T2 on T1.player_id = T2.winner_id order by T2.winner_rank_points desc limit 1	wta_1
select T1.first_name, T1.country_code, T1.birth_date from players as T1 join matches as T2 on T2.winner_id = T1.player_id order by T2.winner_rank_points desc limit 1	wta_1
select hand, count(*) from players group by hand	wta_1
select count(*), hand from players group by hand	wta_1
