USE sakila;

-- 3) Auxiliando de la clausula Exist o IN, 
--    saque la lista de películas que se rentaron más de 19 veces, 
--    la rima de la los pais donde se rento es asonante [termina en vocal] 
--    y nunca se han rentado en países de rima consonante [termina en consonante]

create view vw_peliculas_rima_paises as
SELECT
	film.film_id AS codigo_pelicula,
    film.title AS pelicula,
    COUNT(rental.rental_id) AS total_renta
FROM rental 
JOIN inventory 
	ON rental.inventory_id = inventory.inventory_id
JOIN film 
	ON inventory.film_id = film.film_id
JOIN customer 
	ON rental.customer_id = customer.customer_id
JOIN address 
	ON customer.address_id = address.address_id
JOIN city 
	ON address.city_id = city.city_id
JOIN country 
	ON city.country_id = country.country_id
WHERE RIGHT(TRIM(country.country), 1) IN ('a', 'e', 'i', 'o', 'u') -- rima asonante
GROUP BY film.title, film.film_id
-- HAVING COUNT(rental.rental_id) > 19;