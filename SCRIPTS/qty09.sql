USE sakila;
-- 9) Presentar la renta por Store (tienda) sujeto a que el dinero pagado (recaudado por la tienda) 
-- sea mayor que 5000.

alter view vw_tienda_renta as
select 
	concat(staff.first_name,' ',staff.last_name,'''s store') nombre_tienda,
    staff.staff_id codigo_empleado,
    store.store_id codigo_tienda,
    sum(amount) total_recaudado
from store
inner join staff
	on  store.store_id = staff.store_id
inner join payment
	on store.manager_staff_id = payment.staff_id
group by store.store_id,staff.first_name,staff.last_name,staff.staff_id
HAVING SUM(amount) > 5000