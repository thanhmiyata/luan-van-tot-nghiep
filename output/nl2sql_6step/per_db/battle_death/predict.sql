select count(*) from ship where disposition_of_ship = "Captured"	battle_death
select name, tonnage from ship order by name desc	battle_death
select name, date, result from battle	battle_death
select max(killed) as "maximum death toll", min(killed) as "minimum death toll" from death	battle_death
select avg(injured) from death	battle_death
select T2.killed, T2.injured from ship as T1 join death as T2 on T1.id = T2.caused_by_ship_id where T1.tonnage = "t"	battle_death
SELECT name ,  RESULT FROM battle WHERE bulgarian_commander != 'Boril'	battle_death
select T1.id, T1.name from battle as T1 join ship as T2 on T1.id = T2.lost_in_battle where T2.ship_type = "Brig"	battle_death
SELECT T1.id ,  T1.name FROM battle AS T1 JOIN ship AS T2 ON T1.id  =  T2.lost_in_battle JOIN death AS T3 ON T2.id  =  T3.caused_by_ship_id GROUP BY T1.id HAVING sum(T3.killed)  >  10	battle_death
select ship.id , ship.name from ship join death on death.caused_by_ship_id = ship.id group by ship.id order by sum(death.injured) desc limit 1	battle_death
select distinct name from battle where bulgarian_commander = "Kaloyan" and latin_commander = "Baldwin I"	battle_death
select count(distinct result) from battle	battle_death
select count(*) from battle where battle.id not in (select lost_in_battle from ship where tonnage = "225")	battle_death
select battle.name, battle.date from battle join ship on battle.id = ship.lost_in_battle where ship.name = "Lettice" intersect select battle.name, battle.date from battle join ship on battle.id = ship.lost_in_battle where ship.name = "HMS Atalanta"	battle_death
select T1.name, T1.result, T1.bulgarian_commander from battle as T1 where not EXISTS (select 1 from ship as T2 where T2.lost_in_battle = T1.id and T2.location = "English Channel")	battle_death
select note from death where note like "%East%"	battle_death
