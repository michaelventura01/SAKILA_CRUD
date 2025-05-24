USE sakila;
-- 7) Presentar todas las categorías (únicas) de film que tienen películas PG-13.

create view vw_categorias_unicas_pg13 as
select distinct 
	category.category_id codigo_categoria, 
    category.name categoria,
    film.rating rating
from film
inner join film_category
	on film.film_id = film_category.film_id
inner join category
	on film_category.category_id = category.category_id
where film.rating in ('PG-13')