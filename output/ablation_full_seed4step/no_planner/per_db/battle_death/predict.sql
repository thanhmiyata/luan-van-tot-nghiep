SELECT COUNT(id) FROM ship WHERE disposition_of_ship = 'Captured'
SELECT name, tonnage FROM ship ORDER BY name DESC
SELECT name, date, result FROM battle
SELECT MAX(killed) AS maximum_death_toll, MIN(killed) AS minimum_death_toll FROM death
SELECT AVG(injured) AS average_injuries FROM death
SELECT death.killed, death.injured FROM ship JOIN death ON ship.id = death.caused_by_ship_id WHERE ship.tonnage = 't'
SELECT name, result FROM battle WHERE bulgarian_commander <> 'Boril'
SELECT battle.id, battle.name FROM battle JOIN ship ON battle.id = ship.lost_in_battle WHERE ship.ship_type = 'Brig'
SELECT battle.id, battle.name FROM battle JOIN death ON battle.id = death.id GROUP BY battle.id, battle.name HAVING SUM(death.killed) > 10
SELECT ship.id, ship.name FROM ship JOIN death ON ship.id = death.caused_by_ship_id GROUP BY ship.id, ship.name ORDER BY SUM(death.injured) DESC LIMIT 1
SELECT DISTINCT name FROM battle WHERE bulgarian_commander = 'Kaloyan' AND latin_commander = 'Baldwin I'
SELECT COUNT(DISTINCT result) FROM battle
SELECT COUNT(*) FROM battle WHERE NOT id IN (SELECT lost_in_battle FROM ship WHERE tonnage = '225')
SELECT b.name, b.date FROM battle AS b JOIN ship AS s ON b.id = s.lost_in_battle WHERE s.name = 'Lettice' OR s.name = 'HMS Atalanta' GROUP BY b.name, b.date HAVING COUNT(DISTINCT s.id) = 2
SELECT battle.name, battle.result, battle.bulgarian_commander FROM battle JOIN ship ON battle.id = ship.lost_in_battle WHERE ship.lost_in_battle = 0 AND ship.location = 'English Channel'
SELECT note FROM death WHERE note LIKE '%East%'
