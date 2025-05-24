USE sakila;
-- 2) Presente todas las películas conjuntamente con la cantidad de ciudades distintas donde se han rentado, el total de dinero en 2006, asi el total de dinero en 2005. Debes sacar el % de crecimiento en los dos años.
create view vw_peliculas_rentadas_ciudades as
SELECT
	film.film_id as codigo_pelicula,
    film.title AS pelicula,
    COUNT(DISTINCT city.city_id) AS ciudades_distintas,
    SUM(CASE 
        WHEN YEAR(payment.payment_date) = 2005 THEN payment.amount 
        ELSE 0 
    END) AS total_2005,
    SUM(CASE 
        WHEN YEAR(payment.payment_date) = 2006 THEN payment.amount 
        ELSE 0 
    END) AS total_2006,
    CASE 
        WHEN SUM(CASE WHEN YEAR(payment.payment_date) = 2005 THEN payment.amount ELSE 0 END) = 0 THEN NULL
        ELSE ROUND(
            ((SUM(CASE WHEN YEAR(payment.payment_date) = 2006 THEN payment.amount ELSE 0 END) - 
              SUM(CASE WHEN YEAR(payment.payment_date) = 2005 THEN payment.amount ELSE 0 END)
             ) / 
             SUM(CASE WHEN YEAR(payment.payment_date) = 2005 THEN payment.amount ELSE 0 END)
            ) * 100, 
        2)
    END AS porcentaje_crecimiento
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
JOIN store ON inventory.store_id = store.store_id
JOIN address ON store.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
GROUP BY film.title, film.film_id
ORDER BY porcentaje_crecimiento DESC;