SELECT COUNT(*) AS total_number_of_players FROM players
SELECT COUNT(*) AS count FROM players
SELECT COUNT(*) AS total_number_of_matches FROM matches
SELECT COUNT(*) AS count FROM matches
SELECT first_name, birth_date FROM players WHERE country_code = 'USA'
SELECT first_name, birth_date FROM players WHERE country_code = 'USA'
SELECT AVG(winner_age), AVG(loser_age) FROM matches
SELECT AVG(loser_age) AS average_loser_age, AVG(winner_age) AS average_winner_age FROM matches
SELECT AVG(winner_rank) FROM matches
SELECT AVG(winner_rank) AS "average rank" FROM matches
SELECT MAX(loser_rank) FROM matches
SELECT MIN(loser_rank) FROM matches
SELECT COUNT(DISTINCT country_code) FROM players
SELECT COUNT(DISTINCT country_code) AS count_distinct_countries FROM players
SELECT COUNT(DISTINCT loser_name) AS distinct_name_count FROM matches
SELECT COUNT(DISTINCT loser_name) FROM matches
SELECT tourney_name FROM matches GROUP BY tourney_id, tourney_name HAVING COUNT(*) > 10
SELECT tourney_name FROM matches WHERE match_num > 10 GROUP BY tourney_name
SELECT winner_name FROM matches WHERE year = 2013 INTERSECT SELECT winner_name FROM matches WHERE year = 2016
SELECT winner_name FROM matches WHERE year = 2013 INTERSECT SELECT winner_name FROM matches WHERE year = 2016
SELECT COUNT(*) AS number_of_matches FROM matches WHERE year IN (2013, 2016)
SELECT COUNT(*) AS count FROM matches WHERE year IN (2013, 2016)
SELECT players.country_code, players.first_name FROM players JOIN matches ON players.player_id = matches.winner_id WHERE matches.tourney_name = 'WTA Championships' INTERSECT SELECT players.country_code, players.first_name FROM players JOIN matches ON players.player_id = matches.winner_id WHERE matches.tourney_name = 'Australian Open'
SELECT DISTINCT players.first_name, players.country_code FROM players INNER JOIN matches ON matches.winner_id = players.player_id WHERE matches.tourney_name = 'WTA Championships' INTERSECT SELECT DISTINCT players.first_name, players.country_code FROM players INNER JOIN matches ON matches.winner_id = players.player_id WHERE matches.tourney_name = 'Australian Open'
SELECT first_name, country_code FROM players ORDER BY birth_date ASC LIMIT 1
SELECT first_name, country_code FROM players ORDER BY birth_date ASC LIMIT 1
SELECT first_name, last_name FROM players ORDER BY birth_date ASC
SELECT first_name, last_name FROM players ORDER BY birth_date ASC
SELECT first_name, last_name FROM players WHERE hand = 'L' ORDER BY birth_date ASC
SELECT first_name, last_name FROM players WHERE hand = 'L' ORDER BY birth_date ASC
SELECT p.first_name, p.country_code FROM players AS p JOIN rankings AS r ON p.player_id = r.player_id ORDER BY r.tours DESC LIMIT 1
SELECT p.first_name, p.country_code FROM players AS p JOIN rankings AS r ON p.player_id = r.player_id ORDER BY r.tours DESC LIMIT 1
SELECT year FROM matches GROUP BY year ORDER BY COUNT(*) DESC LIMIT 1
SELECT year FROM matches GROUP BY year ORDER BY COUNT(*) DESC LIMIT 1
SELECT winner_name, winner_rank_points FROM matches GROUP BY winner_name ORDER BY COUNT(*) DESC LIMIT 1
SELECT m.winner_name, r.ranking_points FROM matches AS m JOIN rankings AS r ON m.winner_id = r.player_id GROUP BY m.winner_name ORDER BY COUNT(*) DESC LIMIT 1
SELECT winner_name FROM matches WHERE tourney_name = 'Australian Open' ORDER BY winner_rank_points DESC LIMIT 1
SELECT winner_name FROM matches WHERE tourney_name = 'Australian Open' ORDER BY winner_rank_points DESC LIMIT 1
SELECT loser_name, winner_name FROM matches ORDER BY minutes DESC LIMIT 1
SELECT winner_name, loser_name FROM matches ORDER BY minutes DESC LIMIT 1
SELECT AVG(rankings.ranking), players.first_name FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.player_id
SELECT players.first_name, AVG(rankings.ranking) AS average_ranking FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.first_name
SELECT players.first_name, SUM(rankings.ranking_points) AS total_ranking_points FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.first_name
SELECT players.first_name, SUM(rankings.ranking_points) AS total_ranking_points FROM players JOIN rankings ON players.player_id = rankings.player_id GROUP BY players.first_name
SELECT country_code, COUNT(*) AS player_count FROM players GROUP BY country_code
SELECT country_code, COUNT(player_id) AS count FROM players GROUP BY country_code
SELECT country_code FROM players GROUP BY country_code ORDER BY COUNT(*) DESC LIMIT 1
SELECT country_code FROM players GROUP BY country_code ORDER BY COUNT(*) DESC LIMIT 1
SELECT country_code FROM players GROUP BY country_code HAVING COUNT(*) > 50
SELECT country_code FROM players GROUP BY country_code HAVING COUNT(player_id) > 50
SELECT COUNT(*) AS total_number_of_tours, ranking_date FROM rankings GROUP BY ranking_date ORDER BY ranking_date ASC
SELECT SUM(tours) AS "Total Tours", ranking_date FROM rankings GROUP BY ranking_date
SELECT year, COUNT(*) AS number_of_matches FROM matches GROUP BY year
SELECT year, COUNT(*) AS count FROM matches GROUP BY year
SELECT winner_name, winner_rank FROM matches ORDER BY winner_age ASC LIMIT 3
SELECT winner_name, winner_rank FROM matches ORDER BY winner_age ASC LIMIT 3
SELECT COUNT(DISTINCT winner_id) FROM matches WHERE tourney_name = 'WTA Championships' AND winner_hand = 'L'
SELECT COUNT(*) AS count FROM matches WHERE winner_hand = 'L' AND tourney_name = 'WTA Championships'
SELECT p.first_name, p.country_code, p.birth_date FROM players AS p JOIN matches AS m ON p.player_id = m.winner_id ORDER BY m.winner_rank_points DESC LIMIT 1
SELECT p.first_name, p.country_code, p.birth_date FROM players AS p JOIN matches AS m ON p.player_id = m.winner_id ORDER BY m.winner_rank_points DESC LIMIT 1
SELECT hand, COUNT(player_id) FROM players GROUP BY hand
SELECT hand AS hands, COUNT(*) AS player_count FROM players GROUP BY hand
