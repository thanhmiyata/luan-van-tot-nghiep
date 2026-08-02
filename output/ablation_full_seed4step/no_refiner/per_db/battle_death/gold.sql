SELECT count(*) FROM ship WHERE disposition_of_ship  =  'Captured'	battle_death
SELECT name ,  tonnage FROM ship ORDER BY name DESC	battle_death
SELECT name ,  date FROM battle	battle_death
SELECT max(killed) ,  min(killed) FROM death	battle_death
SELECT avg(injured) FROM death	battle_death
SELECT T1.killed ,  T1.injured FROM death AS T1 JOIN ship AS t2 ON T1.caused_by_ship_id  =  T2.id WHERE T2.tonnage  =  't'	battle_death
SELECT name ,  RESULT FROM battle WHERE bulgarian_commander != 'Boril'	battle_death
SELECT DISTINCT T1.id ,  T1.name FROM battle AS T1 JOIN ship AS T2 ON T1.id  =  T2.lost_in_battle WHERE T2.ship_type  =  'Brig'	battle_death
SELECT T1.id ,  T1.name FROM battle AS T1 JOIN ship AS T2 ON T1.id  =  T2.lost_in_battle JOIN death AS T3 ON T2.id  =  T3.caused_by_ship_id GROUP BY T1.id HAVING sum(T3.killed)  >  10	battle_death
SELECT T2.id ,  T2.name FROM death AS T1 JOIN ship AS t2 ON T1.caused_by_ship_id  =  T2.id GROUP BY T2.id ORDER BY count(*) DESC LIMIT 1	battle_death
SELECT name FROM battle WHERE bulgarian_commander  =  'Kaloyan' AND latin_commander  =  'Baldwin I'	battle_death
SELECT count(DISTINCT RESULT) FROM battle	battle_death
SELECT count(*) FROM battle WHERE id NOT IN ( SELECT lost_in_battle FROM ship WHERE tonnage  =  '225' );	battle_death
SELECT T1.name ,  T1.date FROM battle AS T1 JOIN ship AS T2 ON T1.id  =  T2.lost_in_battle WHERE T2.name  =  'Lettice' INTERSECT SELECT T1.name ,  T1.date FROM battle AS T1 JOIN ship AS T2 ON T1.id  =  T2.lost_in_battle WHERE T2.name  =  'HMS Atalanta'	battle_death
SELECT name ,  RESULT ,  bulgarian_commander FROM battle EXCEPT SELECT T1.name ,  T1.result ,  T1.bulgarian_commander FROM battle AS T1 JOIN ship AS T2 ON T1.id  =  T2.lost_in_battle WHERE T2.location  =  'English Channel'	battle_death
SELECT note FROM death WHERE note LIKE '%East%'	battle_death
