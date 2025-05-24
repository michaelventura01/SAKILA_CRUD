USE sakila;
-- 6) Presentar los clientes con su dirección, indicando país y ciudad. Ordenar por país, ciudad y nombre de cliente.

create view vw_cliente_direccion as
select 
	customer.customer_id codigo_Cliente,
	customer.first_name nombre,
    customer.last_name apellido,
    city.city_id codigo_ciudad,
    city.city ciudad,
    country.country_id codigo_pais,
    country.country pais,
    address.address direccion
from customer
inner join address
	on customer.address_id = address.address_id
inner join city
	on address.city_id = city.city_id
inner join country
	on city.country_id = country.country_id
order by country.country,city.city, customer.first_name,customer.last_name