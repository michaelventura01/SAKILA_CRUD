USE sakila;

-- 4)Presente todas las ciudades por país, sujeto a que en el país (nombre) exista 'eri'. Presentar ascendentemente por país y ciudad.

alter view vw_pais_ciudad_eri as
select 
	country.country_id codigo_pais,
	country.country pais,
    city.city_id codigo_ciudad,
    city.city ciudad
from city 
JOIN country 
	ON city.country_id = country.country_id
where country.country like '%eri%'
order by country.country, city.city