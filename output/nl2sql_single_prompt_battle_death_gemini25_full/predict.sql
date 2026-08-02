select count(*) from ship where disposition_of_ship = "Captured"	battle_death
select name, tonnage from ship order by name desc	battle_death
select name, date, result from battle	battle_death
select max(Killed), min(Killed) from death	battle_death
select avg(Injured) from death	battle_death
select T1.killed, T1.injured from death as T1 inner join ship as T2 on T1.caused_by_ship_id = T2.id where T2.tonnage = "t"	battle_death
select name, result from battle where bulgarian_commander != "Boril"	battle_death
select distinct T1.id, T1.name from battle as T1 inner join ship as T2 on T1.id = T2.lost_in_battle where T2.ship_type = "Brig"	battle_death
select T1.id, T1.name from battle as T1 join ship as T2 on T1.id = T2.lost_in_battle join death as T3 on T2.id = T3.caused_by_ship_id group by T1.id having sum(T3.killed) > 10	battle_death
select T1.id, T1.name from ship as T1 join death as T2 on T1.id = T2.caused_by_ship_id group by T1.id order by sum(T2.injured) desc limit 1	battle_death
select distinct name from battle where bulgarian_commander = "Kaloyan" and latin_commander = "Baldwin I"	battle_death
select count(distinct result) from battle	battle_death
select count(id) from battle where id not in ( select lost_in_battle from ship where tonnage = "225" )	battle_death
select T1.name, T1.date from battle as T1 inner join ship as T2 on T1.id = T2.lost_in_battle inner join ship as T3 on T1.id = T3.lost_in_battle where T2.name = "Lettice" and T3.name = "HMS Atalanta"	battle_death
select name, result, bulgarian_commander from battle where id not in ( select lost_in_battle from ship where location = "English Channel" )	battle_death
select note from death where note like "%East%"	battle_death
