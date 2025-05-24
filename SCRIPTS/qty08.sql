-- 8) Presentar el total dinero recaudado por película, 
-- el precio promedio de renta, el nombre y apellido del primer actor y segundo actor, 
-- de aquellas películas cuyo elenco tenga dos o mas integrantes.

alter view vw_pelicula_elenco_detalle as
WITH actores AS (
	SELECT 
		film_actor.film_id,
		actor.actor_id,
		CONCAT(actor.first_name,' ',actor.last_name) AS nombre_Actor,
		ROW_NUMBER() OVER (PARTITION BY film_actor.film_id ORDER BY actor.actor_id) AS orden
	FROM film_actor
	INNER JOIN actor ON film_actor.actor_id = actor.actor_id
),
elenco AS (
	SELECT 
		film_id,
		COUNT(actor_id) AS total_actores
	FROM actores
	GROUP BY film_id
)

SELECT 
	film.title AS pelicula,  
    film.film_id AS codigo_pelicula,
    ROUND(SUM(payment.amount), 2) AS total_recaudado,
    ROUND(AVG(payment.amount), 2) AS promedio_renta,
    elenco.total_actores,
    primerActor.actor_id AS codigo_primer_Actor,
    primerActor.nombre_Actor AS primer_Actor,
    segundoActor.actor_id AS codigo_segundo_Actor,
    segundoActor.nombre_Actor AS segundo_Actor
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
JOIN elenco ON film.film_id = elenco.film_id
JOIN actores AS primerActor ON film.film_id = primerActor.film_id AND primerActor.orden = 1
JOIN actores AS segundoActor ON film.film_id = segundoActor.film_id AND segundoActor.orden = 2
WHERE elenco.total_actores > 1
GROUP BY film.title, film.film_id, elenco.total_actores, primerActor.nombre_Actor, primerActor.actor_id, segundoActor.nombre_Actor, segundoActor.actor_id;