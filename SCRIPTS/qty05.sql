USE sakila;

-- 5) De la tabla film presentar las películas que son PG-13, PG, PG-17 y el rental_duration está entre 4 y 7. Presentar la categoría de la película y ordenar por esta.
alter view vw_pelicula_categoria as
select 
	film.film_id codigo_pelicula,
	film.title pelicula,
    category.category_id codigo_categoria,
    category.name categoria,
    film.rating rating     
from film
inner join film_category
	on film.film_id = film_category.film_id
inner join category
	on film_category.category_id = category.category_id
where 
	film.rating in ('PG-13', 'PG', 'PG-17') 
   and film.rental_duration between 4 and 7
group by film.title, category.name, film.rating, film.film_id, category.category_id
order by category.name;