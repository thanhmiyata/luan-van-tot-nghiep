select count(id) from ship where disposition_of_ship = "Captured"	battle_death
select name, tonnage from ship order by name desc	battle_death
select name, date, result from battle	battle_death
select max(killed), min(killed) from death	battle_death
select avg(injured) from death	battle_death
select T2.killed, T2.injured from ship as T1 join death as T2 on T1.id = T2.caused_by_ship_id where T1.tonnage = "t"	battle_death
select name, result from battle where bulgarian_commander <> "Boril"	battle_death
select T1.id, T1.name from battle as T1 join ship as T2 on T1.id = T2.lost_in_battle where T2.ship_type = "Brig"	battle_death
select T1.id, T1.name from battle as T1 join death as T2 on T1.id = T2.id group by T1.id, T1.name having sum(T2.killed) > 10	battle_death
select T1.id, T1.name from ship as T1 join death as T2 on T1.id = T2.caused_by_ship_id group by T1.id order by sum(T2.injured) desc limit 1	battle_death
select distinct name from battle where bulgarian_commander = "Kaloyan" and latin_commander = "Baldwin I"	battle_death
select count(distinct result) from battle	battle_death
select count(T1.id) from battle as T1 where not EXISTS (select 1 from ship as T2 where T2.lost_in_battle = T1.id and T2.tonnage = "225")	battle_death
select b.name, b.date from battle as b join ship as s on b.id = s.lost_in_battle where s.name = "Lettice" or s.name = "HMS Atalanta" group by b.id having count(distinct s.id) = 2	battle_death
select T1.name, T1.result, T1.bulgarian_commander from battle as T1 left join ship as T2 on T1.id = T2.lost_in_battle and T2.location = "English Channel" where T2.id is null	battle_death
select note from death where note like "%East%"	battle_death
