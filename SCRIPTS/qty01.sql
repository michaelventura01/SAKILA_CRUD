USE sakila;
-- 1) Haga un query que presente los últimos 10 países, cuyas cantidad de ciudades son mayores que 2. Preséntelos en forma descendentemente.
create view vw_paises_ciudades as
select 
	country.country_id codigo_pais,
    country.country pais,
	count(city.city)  total_ciudades
from city
inner join country 
	on city.country_id = country.country_id
group by country.country, country.country_id
having count(city.city) > 2
order by count(city.city) desc
limit 10;