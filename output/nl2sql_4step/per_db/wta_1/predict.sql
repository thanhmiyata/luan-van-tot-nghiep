select count(*) from players	wta_1
select count(*) from players	wta_1
select count(*) from matches	wta_1
select count(*) from matches	wta_1
select first_name, birth_date from players where country_code = "USA"	wta_1
select first_name, birth_date from players where country_code = "USA"	wta_1
select avg(winner_age), avg(loser_age) from matches	wta_1
select avg(loser_age), avg(winner_age) from matches	wta_1
select avg(winner_rank) from matches	wta_1
select avg(winner_rank) as "average rank" from matches	wta_1
select max(loser_rank) from matches	wta_1
select min(loser_rank) from matches	wta_1
select count(distinct country_code) from players	wta_1
select count(distinct country_code) from players	wta_1
select count(distinct loser_name) from matches	wta_1
select count(distinct loser_name) from matches	wta_1
select tourney_name from matches group by tourney_id, tourney_name having count(*) > 10	wta_1
select tourney_name from matches group by tourney_name having count(*) > 10	wta_1
select winner_name from matches where year = 2013 intersect select winner_name from matches where year = 2016	wta_1
select winner_name from matches where year = 2013 intersect select winner_name from matches where year = 2016	wta_1
select count(*) from matches where year in (2013, 2016)	wta_1
select count(*) from matches where year in (2013, 2016)	wta_1
select T1.country_code, T1.first_name from players as T1 join matches as T2 on T1.player_id = T2.winner_id where T2.tourney_name = "WTA Championships" intersect select T1.country_code, T1.first_name from players as T1 join matches as T2 on T1.player_id = T2.winner_id where T2.tourney_name = "Australian Open"	wta_1
select players.first_name, players.country_code from players inner join matches as m1 on players.player_id = m1.winner_id and m1.tourney_name = "WTA Championships" inner join matches as m2 on players.player_id = m2.winner_id and m2.tourney_name = "Australian Open"	wta_1
select first_name, country_code from players order by birth_date asc limit 1	wta_1
select first_name, country_code from players order by birth_date asc limit 1	wta_1
select first_name, last_name from players order by birth_date asc	wta_1
select first_name, last_name from players order by birth_date asc	wta_1
select first_name, last_name from players where hand = "L" order by birth_date asc	wta_1
select first_name, last_name from players where hand = "L" order by birth_date asc	wta_1
select p.first_name, p.country_code from players as p join rankings as r on p.player_id = r.player_id order by r.tours desc limit 1	wta_1
select p.first_name, p.country_code from players p join rankings r on p.player_id = r.player_id order by r.tours desc limit 1	wta_1
select year from matches group by year order by count(*) desc limit 1	wta_1
select year from matches group by year order by count(*) desc limit 1	wta_1
select winner_name, winner_rank_points from matches group by winner_name, winner_rank_points order by count(*) desc limit 1	wta_1
select T1.winner_name, T2.ranking_points from (select winner_id, winner_name, count(*) from matches group by winner_id, winner_name order by num_wins desc limit 1) join rankings as T2 on T1.winner_id = T2.player_id limit 1	wta_1
select winner_name from matches where tourney_name = "Australian Open" order by winner_rank_points desc limit 1	wta_1
select winner_name from matches where tourney_name = "Australian Open" order by winner_rank_points desc limit 1	wta_1
select loser_name, winner_name from matches order by minutes desc limit 1	wta_1
select winner_name, loser_name from matches order by minutes desc limit 1	wta_1
select avg(T1.ranking), T2.first_name from players as T2 join rankings as T1 on T2.player_id = T1.player_id group by T2.player_id	wta_1
select players.first_name, avg(rankings.ranking) from players join rankings on players.player_id = rankings.player_id group by players.first_name	wta_1
select T1.first_name, sum(T2.ranking_points) from players as T1 join rankings as T2 on T1.player_id = T2.player_id group by T1.first_name	wta_1
select players.first_name, sum(rankings.ranking_points) from players join rankings on players.player_id = rankings.player_id group by players.first_name	wta_1
select country_code, count(*) from players group by country_code	wta_1
select country_code, count(player_id) from players group by country_code	wta_1
select country_code from players group by country_code order by count(*) desc limit 1	wta_1
select country_code from players group by country_code order by count(*) desc limit 1	wta_1
select country_code from players group by country_code having count(*) > 50	wta_1
select country_code from players group by country_code having count(*) > 50	wta_1
select count(*), ranking_date from rankings group by ranking_date	wta_1
select sum(tours) as "Total Tours", ranking_date as "Ranking Date" from rankings group by ranking_date	wta_1
select year, count(*) from matches group by year	wta_1
select year, count(*) from matches group by year	wta_1
select winner_name, winner_rank from matches order by winner_age asc limit 3	wta_1
select winner_name, winner_rank from matches order by winner_age asc limit 3	wta_1
select count(distinct winner_id) from matches where tourney_name = "WTA Championships" and winner_hand = "L"	wta_1
select count(*) from matches where winner_hand = "L" and tourney_name = "WTA Championships"	wta_1
select p.first_name, p.country_code, p.birth_date from players as p join matches as m on p.player_id = m.winner_id order by m.winner_rank_points desc limit 1	wta_1
select T1.first_name, T1.country_code, T1.birth_date from players as T1 join matches as T2 on T1.player_id = T2.winner_id order by T2.winner_rank_points desc limit 1	wta_1
select hand, count(player_id) from players group by hand	wta_1
select hand , count(*) from players group by hand	wta_1
