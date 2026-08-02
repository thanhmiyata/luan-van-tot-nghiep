select count(player_id) from players	wta_1
select count(player_id) from players	wta_1
select count(*) from matches	wta_1
select count(*) from matches	wta_1
select first_name, birth_date from players where country_code = "USA"	wta_1
select first_name, birth_date from players where country_code = "USA"	wta_1
select avg(age) from (select loser_age from matches union ALL select winner_age from matches)	wta_1
select avg(loser_age), avg(winner_age) from matches	wta_1
select avg(winner_rank) from matches	wta_1
select avg(winner_rank) from matches	wta_1
select max(loser_rank) from matches	wta_1
select min(loser_rank) from matches	wta_1
select count(distinct country_code) from players	wta_1
select count(distinct country_code) from players	wta_1
select count(distinct loser_name) from matches	wta_1
select count(distinct loser_name) from matches	wta_1
select tourney_name from matches group by tourney_name having count(match_num) > 10	wta_1
select tourney_name from matches group by tourney_name having count(match_num) > 10	wta_1
select distinct T1.first_name, T1.last_name from players as T1 join matches as T2 on T1.player_id = T2.winner_id where T2.year = 2013 intersect select T1.first_name, T1.last_name from players as T1 join matches as T2 on T1.player_id = T2.winner_id where T2.year = 2016	wta_1
select T1.first_name, T1.last_name from players as T1 join matches as T2 on T1.player_id = T2.winner_id where T2.year = 2013 intersect select T1.first_name, T1.last_name from players as T1 join matches as T2 on T1.player_id = T2.winner_id where T2.year = 2016	wta_1
select count(*) from matches where year = 2013 or year = 2016	wta_1
select count(*) from matches where year = 2013 or year = 2016	wta_1
select T1.country_code, T1.first_name from players as T1 join matches as T2 on T1.player_id = T2.winner_id where T2.tourney_name = "WTA Championships" intersect select T1.country_code, T1.first_name from players as T1 join matches as T2 on T1.player_id = T2.winner_id where T2.tourney_name = "Australian Open"	wta_1
select T1.first_name, T1.country_code from players as T1 inner join matches as T2 on T1.player_id = T2.winner_id where T2.tourney_name = "WTA Championships" intersect select T1.first_name, T1.country_code from players as T1 inner join matches as T2 on T1.player_id = T2.winner_id where T2.tourney_name = "Australian Open"	wta_1
select first_name, country_code from players order by birth_date asc limit 1	wta_1
select first_name, country_code from players order by birth_date asc limit 1	wta_1
select first_name, last_name from players order by birth_date	wta_1
select first_name, last_name from players order by birth_date	wta_1
select first_name, last_name from players where hand = "L" order by birth_date	wta_1
select first_name, last_name from players where hand = "L" order by birth_date	wta_1
select T1.first_name, T1.country_code from players as T1 inner join rankings as T2 on T1.player_id = T2.player_id group by T1.player_id order by sum(T2.tours) desc limit 1	wta_1
select T1.first_name, T1.country_code from players as T1 inner join rankings as T2 on T1.player_id = T2.player_id group by T1.player_id order by sum(T2.tours) desc limit 1	wta_1
select year from matches group by year order by count(match_num) desc limit 1	wta_1
select year from matches group by year order by count(match_num) desc limit 1	wta_1
select T1.first_name, T1.last_name, ( select ranking_points from rankings where player_id = T1.player_id order by ranking_date desc limit 1 ) from players as T1 where T1.player_id = ( select winner_id from matches group by winner_id order by count(*) desc limit 1 )	wta_1
select winner_name, winner_rank_points from matches group by winner_id order by count(winner_id) desc limit 1	wta_1
select winner_name from matches where tourney_name = "Australian Open" order by winner_rank_points desc limit 1	wta_1
select winner_name from matches where tourney_name = "Australian Open" order by winner_rank_points desc limit 1	wta_1
select winner_name, loser_name from matches order by minutes desc limit 1	wta_1
select winner_name, loser_name from matches order by minutes desc limit 1	wta_1
select T1.first_name, avg(T2.ranking) from players as T1 inner join rankings as T2 on T1.player_id = T2.player_id group by T1.player_id, T1.first_name	wta_1
select T1.first_name, avg(T2.ranking) from players as T1 inner join rankings as T2 on T1.player_id = T2.player_id group by T1.player_id	wta_1
select T1.first_name, sum(T2.ranking_points) from players as T1 inner join rankings as T2 on T1.player_id = T2.player_id group by T1.player_id, T1.first_name	wta_1
select T1.first_name, sum(T2.ranking_points) from players as T1 inner join rankings as T2 on T1.player_id = T2.player_id group by T1.first_name	wta_1
select count(player_id), country_code from players group by country_code	wta_1
select count(*) , country_code from players group by country_code	wta_1
select country_code from players group by country_code order by count(player_id) desc limit 1	wta_1
select country_code from players group by country_code order by count(player_id) desc limit 1	wta_1
select country_code from players group by country_code having count(player_id) > 50	wta_1
select country_code from players group by country_code having count(player_id) > 50	wta_1
select ranking_date, sum(tours) from rankings group by ranking_date	wta_1
select ranking_date, sum(tours) from rankings group by ranking_date	wta_1
select year, count(*) from matches group by year	wta_1
select year, count(*) from matches group by year	wta_1
select winner_name, winner_rank from matches order by winner_age asc limit 3	wta_1
select winner_name, winner_rank from matches order by winner_age asc limit 3	wta_1
select count(distinct T1.winner_id) from matches as T1 inner join players as T2 on T1.winner_id = T2.player_id where T1.tourney_name = "WTA Championships" and T2.hand = "L"	wta_1
select count(distinct winner_id) from matches where winner_hand = "L" and tourney_name = "WTA Championships"	wta_1
select T1.first_name, T1.country_code, T1.birth_date from players as T1 inner join matches as T2 on T1.player_id = T2.winner_id order by T2.winner_rank_points desc limit 1	wta_1
select T1.first_name, T1.country_code, T1.birth_date from players as T1 inner join matches as T2 on T1.player_id = T2.winner_id order by T2.winner_rank_points desc limit 1	wta_1
select hand, count(player_id) from players group by hand	wta_1
select hand, count(player_id) from players group by hand	wta_1
