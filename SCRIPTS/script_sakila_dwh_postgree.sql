create schema metadata;
create schema staging;
create schema dwh;


create table dwh.categorias_unicas_pg13(
    id serial primary key,
    fecha_Carga date not null,
    codigo_categoria int not null,
    categoria varchar(250) not null,
    rating varchar(250) not null
);

create table dwh.cliente_direccion(
    id serial PRIMARY key,
    codigo_Cliente int not null,
    nombre varchar(250) not null,
    apellido varchar(250) not null,
    codigo_ciudad int not null,
    ciudad varchar(250) not null,
    codigo_pais int not null,
    pais varchar(250) not null,
    direccion varchar(250) not null,
    fecha_Carga date not null
);

create table dwh.clientes_rentas_categoria(
    id serial primary key,
    codigo_Cliente int not null,
    nombre_cliente varchar(250) not null,
    apellido_cliente varchar(250) not null,
    total_facturado decimal(10,2) not null,
    total_renta int not null,
    categoria_cliente varchar(250) not null,
    fecha_Carga date not null
);

create table dwh.pais_ciudad_eri(
    id serial primary key,
    codigo_pais int not null,
    pais varchar(250) not null,
    codigo_ciudad int not null,
    ciudad varchar(250) not null,
    fecha_Carga date not null
);

create table dwh.paises_ciudades(
    id serial primary key,
    codigo_pais int not null,
    pais varchar(250) not null,
    total_ciudades int not null,
    fecha_Carga date not null
);

create table dwh.pelicula_categoria(
    id serial primary key,
    codigo_pelicula int not null,
    pelicula varchar(250) not null,
    codigo_categoria int not null,
    categoria varchar(250) not null,
    rating varchar(250) not null,
    fecha_Carga date not null
);

create table dwh.pelicula_elenco_detalle(
    id serial PRIMARY key,
    pelicula varchar(250) not null,	
    codigo_pelicula	int not null,
    total_recaudado	decimal(10,2) not null,
    promedio_renta	decimal(10,2) not null,	
    total_actores int not null,	
    codigo_primer_Actor	int not null,
    primer_Actor varchar(250) not null,		
    codigo_segundo_Actor int not null,	
    segundo_Actor varchar(250) not null,	
    fecha_Carga date not null
);

create table dwh.peliculas_rentadas_ciudades(
    id serial primary key,
    codigo_pelicula	int not null,
    pelicula varchar(250) not null,
    ciudades_distintas int not null,
    total_2005 decimal(10,2) not null,
    total_2006 decimal(10,2) not null,	
    porcentaje_crecimiento decimal(10,2) not null,
    fecha_Carga date not null
);

create table dwh.peliculas_rima_paises(
    id serial primary key,
    codigo_pelicula int not null,
    pelicula VARCHAR(250) not null,
    total_renta int not null,
    fecha_Carga date not null
);

create table dwh.tienda_renta(
    id serial PRIMARY key,
    nombre_tienda VARCHAR(250) not null,
    codigo_empleado int not null,
    codigo_tienda int not null,
    total_recaudado decimal(10,2) not null,
    fecha_Carga date not null
)

CREATE TABLE metadata.historico_carga (
  id serial PRIMARY KEY,
  tabla varchar(250) NOT NULL,
  esquema varchar(250) NOT NULL,
  fecha_carga datetime NOT NULL,
  estado varchar(250) NOT NULL,
  total int NOT NULL DEFAULT 0
) 

CREATE OR REPLACE PROCEDURE dwh.sp_cargar_categorias_unicas_pg13()
LANGUAGE plpgsql
AS $BODY$
DECLARE
    v_total_registros INT;
BEGIN
    insert into dwh.categorias_unicas_pg13(codigo_categoria,categoria,rating,fecha_carga)
    select codigo_categoria,categoria,rating,now() from staging.stg_categorias_unicas_pg13;
    SELECT COUNT(*) INTO v_total_registros FROM staging.stg_categorias_unicas_pg13;
    CALL metadata.sp_agregar_carga('categorias_unicas_pg13', 'dwh', 'COMPLETADO', v_total_registros);
END;
$BODY$;
ALTER PROCEDURE dwh.sp_cargar_categorias_unicas_pg13()
    OWNER TO root;


CREATE OR REPLACE PROCEDURE dwh.sp_cargar_cliente_direccion()
LANGUAGE plpgsql
AS $BODY$
DECLARE
    v_total_registros INT;
BEGIN
    insert into dwh.cliente_direccion(codigo_cliente,nombre,apellido,codigo_ciudad,ciudad,codigo_pais,pais,direccion,fecha_carga)
    select *,now() from staging.stg_cliente_direccion;
    SELECT COUNT(*) INTO v_total_registros FROM staging.stg_cliente_direccion;
    CALL metadata.sp_agregar_carga('cliente_direccion', 'dwh', 'COMPLETADO', v_total_registros);
END;
$BODY$;
ALTER PROCEDURE dwh.sp_cargar_cliente_direccion()
    OWNER TO root;

CREATE OR REPLACE PROCEDURE dwh.sp_cargar_clientes_rentas_categoria()
LANGUAGE plpgsql
AS $BODY$
DECLARE
    v_total_registros INT;
BEGIN
    INSERT INTO dwh.clientes_rentas_categoria(
        codigo_cliente,
        nombre_cliente,
        apellido_cliente,
        total_facturado,
        total_renta,
        categoria_cliente,
        fecha_carga
    )
    SELECT
        codigo_cliente,
        nombre_cliente,
        apellido_cliente,
        total_facturado,
        total_renta,
        categoria_cliente,
        NOW()
    FROM staging.stg_clientes_rentas_categoria;
    SELECT COUNT(*) INTO v_total_registros FROM staging.stg_clientes_rentas_categoria;
    CALL metadata.sp_agregar_carga('clientes_rentas_categoria', 'dwh', 'COMPLETADO', v_total_registros);
END;
$BODY$;
ALTER PROCEDURE dwh.sp_cargar_clientes_rentas_categoria()
    OWNER TO root;


CREATE OR REPLACE PROCEDURE dwh.sp_cargar_pais_ciudad_eri()
LANGUAGE plpgsql
AS $BODY$
DECLARE
    v_total_registros INT;
BEGIN
    insert into dwh.pais_ciudad_eri(codigo_pais,pais,codigo_ciudad,ciudad,fecha_carga)
    select codigo_pais,pais,codigo_ciudad,ciudad,now() from staging.stg_pais_ciudad_eri;
    SELECT COUNT(*) INTO v_total_registros FROM staging.stg_pais_ciudad_eri;
    CALL metadata.sp_agregar_carga('pais_ciudad_eri', 'dwh', 'COMPLETADO', v_total_registros);
END;
$BODY$;
ALTER PROCEDURE dwh.sp_cargar_pais_ciudad_eri()
    OWNER TO root;


CREATE OR REPLACE PROCEDURE dwh.sp_cargar_paises_ciudades()
LANGUAGE plpgsql
AS $BODY$
DECLARE
    v_total_registros INT;
BEGIN
    INSERT INTO dwh.paises_ciudades(
        codigo_pais,
        pais,
        total_ciudades,
        fecha_Carga
    )
    SELECT
        codigo_pais,
        pais,
        total_ciudades,
        NOW()
    FROM staging.stg_paises_ciudades;
    SELECT COUNT(*) INTO v_total_registros FROM staging.stg_paises_ciudades;
    CALL metadata.sp_agregar_carga('paises_ciudades', 'dwh', 'COMPLETADO', v_total_registros);
END;
$BODY$;
ALTER PROCEDURE dwh.sp_cargar_paises_ciudades()
    OWNER TO root;


CREATE OR REPLACE PROCEDURE dwh.sp_cargar_pelicula_categoria()
LANGUAGE plpgsql
AS $BODY$
DECLARE
    v_total_registros INT;
BEGIN
    insert into dwh.pelicula_categoria(codigo_pelicula,pelicula,codigo_categoria,categoria,rating,fecha_carga)
    select codigo_pelicula,pelicula,codigo_categoria,categoria,rating,now() from staging.stg_pelicula_categoria;
    SELECT COUNT(*) INTO v_total_registros FROM staging.stg_pelicula_categoria;
    CALL metadata.sp_agregar_carga('pelicula_categoria', 'dwh', 'COMPLETADO', v_total_registros);
END;
$BODY$;
ALTER PROCEDURE dwh.sp_cargar_pelicula_categoria()
    OWNER TO root;


CREATE OR REPLACE PROCEDURE dwh.sp_cargar_pelicula_elenco_detalle()
LANGUAGE plpgsql
AS $BODY$
DECLARE
    v_total_registros INT;
BEGIN
    insert into dwh.pelicula_elenco_detalle(pelicula,codigo_pelicula,total_recaudado,promedio_renta,total_actores,codigo_primer_actor,primer_actor,codigo_segundo_actor,segundo_actor,fecha_carga)
    select *,now() from staging.stg_pelicula_elenco_detalle;
    SELECT COUNT(*) INTO v_total_registros FROM staging.stg_pelicula_elenco_detalle;
    CALL metadata.sp_agregar_carga('pelicula_elenco_detalle', 'dwh', 'COMPLETADO', v_total_registros);
END;
$BODY$;
ALTER PROCEDURE dwh.sp_cargar_pelicula_elenco_detalle()
    OWNER TO root;

CREATE OR REPLACE PROCEDURE dwh.sp_cargar_peliculas_rentadas_ciudades()
LANGUAGE plpgsql
AS $BODY$
DECLARE
    v_total_registros INT;
BEGIN
    insert into dwh.peliculas_rentadas_ciudades(codigo_pelicula,pelicula,ciudades_distintas,total_2005,total_2006,porcentaje_crecimiento,fecha_carga)
    select codigo_pelicula,pelicula,ciudades_distintas,total_2005,total_2006,porcentaje_crecimiento,now() from staging.stg_peliculas_rentadas_ciudades;
    SELECT COUNT(*) INTO v_total_registros FROM staging.stg_peliculas_rentadas_ciudades;
    CALL metadata.sp_agregar_carga('peliculas_rentadas_ciudades', 'dwh', 'COMPLETADO', v_total_registros);
END;
$BODY$;
ALTER PROCEDURE dwh.sp_cargar_peliculas_rentadas_ciudades()
    OWNER TO root;


CREATE OR REPLACE PROCEDURE dwh.sp_cargar_peliculas_rima_paises()
LANGUAGE plpgsql
AS $BODY$
DECLARE
    v_total_registros INT;
BEGIN
    insert into dwh.peliculas_rima_paises( codigo_pelicula,pelicula,total_renta,fecha_Carga)
    select  codigo_pelicula,pelicula,total_renta,now() from staging.stg_peliculas_rima_paises;
    SELECT COUNT(*) INTO v_total_registros FROM staging.stg_peliculas_rima_paises;
    CALL metadata.sp_agregar_carga('peliculas_rima_paises', 'dwh', 'COMPLETADO', v_total_registros);
END;
$BODY$;
ALTER PROCEDURE dwh.sp_cargar_peliculas_rima_paises()
    OWNER TO root;


CREATE OR REPLACE PROCEDURE dwh.sp_cargar_tienda_renta()
LANGUAGE plpgsql
AS $BODY$
DECLARE
    v_total_registros INT;
BEGIN
    insert into dwh.tienda_renta(nombre_tienda,codigo_empleado,codigo_tienda,total_recaudado,fecha_carga)
    select nombre_tienda,codigo_empleado,codigo_tienda,total_recaudado,now() from staging.stg_tienda_renta;
    SELECT COUNT(*) INTO v_total_registros FROM staging.stg_tienda_renta;
    CALL metadata.sp_agregar_carga('tienda_renta', 'dwh', 'COMPLETADO', v_total_registros);
END;
$BODY$;
ALTER PROCEDURE dwh.sp_cargar_tienda_renta()
    OWNER TO root;


CREATE OR REPLACE PROCEDURE metadata.sp_agregar_carga(
	IN p_tabla character varying,
	IN p_esquema character varying,
	IN p_estado character varying,
	IN p_total integer)
LANGUAGE plpgsql
AS $BODY$
BEGIN
    INSERT INTO metadata.historico_carga(tabla, esquema, fecha_carga, estado, total)
    VALUES (p_tabla, p_esquema, NOW(), p_estado,p_total);
END;
$BODY$;
ALTER PROCEDURE metadata.sp_agregar_carga(IN p_tabla character varying, IN p_esquema character varying, IN p_estado character varying, IN p_total integer)
    OWNER TO root;
