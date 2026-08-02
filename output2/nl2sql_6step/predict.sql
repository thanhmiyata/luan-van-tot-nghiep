select distinct car_names.MakeId, car_names.Make from cars_data join car_names on cars_data.Id = car_names.MakeId where cars_data.Horsepower > (select min(Horsepower) from cars_data) and cars_data.Cylinders < 4	car_1
select car_names.Make, cars_data.Year from cars_data join car_names on cars_data.Id = car_names.MakeId where cars_data.Year = (select min(Year) from cars_data)	car_1
