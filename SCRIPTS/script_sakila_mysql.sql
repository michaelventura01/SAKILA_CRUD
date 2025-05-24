create schema metadata;
create schema staging;
create schema dwh;



create table dwh.categorias_unicas_pg13(
    id int primary key AUTO_INCREMENT,
    fecha_Carga date not null,
    codigo_categoria int not null,
    categoria varchar(250) not null,
    rating varchar(250) not null
);

create table dwh.cliente_direccion(
    id int PRIMARY key AUTO_INCREMENT,
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
    id int primary key AUTO_INCREMENT,
    codigo_Cliente int not null,
    nombre_cliente varchar(250) not null,
    apellido_cliente varchar(250) not null,
    total_facturado decimal(10,2) not null,
    total_renta int not null,
    categoria_cliente varchar(250) not null,
    fecha_Carga date not null
);

create table dwh.pais_ciudad_eri(
    id int primary key AUTO_INCREMENT,
    codigo_pais int not null,
    pais varchar(250) not null,
    codigo_ciudad int not null,
    ciudad varchar(250) not null,
    fecha_Carga date not null
);

create table dwh.paises_ciudades(
    id int primary key AUTO_INCREMENT,
    codigo_pais int not null,
    pais varchar(250) not null,
    total_ciudades int not null,
    fecha_Carga date not null
);

create table dwh.pelicula_categoria(
    id int primary key AUTO_INCREMENT,
    codigo_pelicula int not null,
    pelicula varchar(250) not null,
    codigo_categoria int not null,
    categoria varchar(250) not null,
    rating varchar(250) not null,
    fecha_Carga date not null
);

create table dwh.pelicula_elenco_detalle(
    id int PRIMARY key AUTO_INCREMENT,
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
    id int primary key AUTO_INCREMENT,
    codigo_pelicula	int not null,
    pelicula varchar(250) not null,
    ciudades_distintas int not null,
    total_2005 decimal(10,2) not null,
    total_2006 decimal(10,2) not null,	
    porcentaje_crecimiento decimal(10,2) not null,
    fecha_Carga date not null
);

create table dwh.peliculas_rima_paises(
    id int primary key AUTO_INCREMENT,
    codigo_pelicula int not null,
    pelicula VARCHAR(250) not null,
    total_renta int not null,
    fecha_Carga date not null
);

create table dwh.tienda_renta(
    id int PRIMARY key AUTO_INCREMENT,
    nombre_tienda VARCHAR(250) not null,
    codigo_empleado int not null,
    codigo_tienda int not null,
    total_recaudado decimal(10,2) not null,
    fecha_Carga date not null
)

CREATE TABLE metadata.historico_carga (
  id int PRIMARY KEY AUTO_INCREMENT,
  tabla varchar(250) NOT NULL,
  esquema varchar(250) NOT NULL,
  fecha_carga datetime NOT NULL,
  estado varchar(250) NOT NULL,
  total int NOT NULL DEFAULT 0
) 

create procedure dwh.sp_cargar_paises_ciudades()
begin
    insert into dwh.paises_ciudades(codigo_pais,pais,total_ciudades,fecha_carga)
    select codigo_pais,pais,total_ciudades,now() from staging.stg_paises_ciudades;
    CALL metadata.sp_agregar_carga('paises_ciudades', 'dwh', 'COMPLETADO',(select count(*) from staging.stg_paises_ciudades)); 
end;

create procedure dwh.sp_cargar_peliculas_rima_paises()
BEGIN
    insert into dwh.peliculas_rima_paises( codigo_pelicula,pelicula,total_renta,fecha_Carga)
    select  codigo_pelicula,pelicula,total_renta,now() from staging.stg_peliculas_rima_paises;
    CALL metadata.sp_agregar_carga('peliculas_rima_paises', 'dwh', 'COMPLETADO',(select  count(*) from staging.stg_peliculas_rima_paises)); 
end;
    
create procedure dwh.sp_cargar_pais_ciudad_eri()
BEGIN
    insert into dwh.pais_ciudad_eri(codigo_pais,pais,codigo_ciudad,ciudad,fecha_carga)
    select codigo_pais,pais,codigo_ciudad,ciudad,now() from staging.stg_pais_ciudad_eri;
    CALL metadata.sp_agregar_carga('pais_ciudad_eri', 'dwh', 'COMPLETADO',(select count(*) from staging.stg_pais_ciudad_eri)); 
end;

create procedure dwh.sp_cargar_pelicula_categoria()
begin
    insert into dwh.pelicula_categoria(codigo_pelicula,pelicula,codigo_categoria,categoria,rating,fecha_carga)
    select codigo_pelicula,pelicula,codigo_categoria,categoria,rating,now() from staging.stg_pelicula_categoria;
    CALL metadata.sp_agregar_carga('pelicula_categoria', 'dwh', 'COMPLETADO',(select count(*) from staging.stg_pelicula_categoria)); 
end;

create procedure dwh.sp_cargar_cliente_direccion()
begin
    insert into dwh.cliente_direccion(codigo_cliente,nombre,apellido,codigo_ciudad,ciudad,codigo_pais,pais,direccion,fecha_carga)
    select *,now() from staging.stg_cliente_direccion;
    CALL metadata.sp_agregar_carga('cliente_direccion', 'dwh', 'COMPLETADO',(select count(*) from staging.stg_cliente_direccion)); 
end;

create procedure dwh.sp_cargar_peliculas_rentadas_ciudades()
begin
    insert into dwh.peliculas_rentadas_ciudades(codigo_pelicula,pelicula,ciudades_distintas,total_2005,total_2006,porcentaje_crecimiento,fecha_carga)
    select codigo_pelicula,pelicula,ciudades_distintas,total_2005,total_2006,porcentaje_crecimiento,now() from staging.stg_peliculas_rentadas_ciudades;
    CALL metadata.sp_agregar_carga('peliculas_rentadas_ciudades', 'dwh', 'COMPLETADO',(select count(*) from staging.stg_peliculas_rentadas_ciudades)); 
end;

create procedure dwh.sp_cargar_categorias_unicas_pg13()
begin    
    insert into dwh.categorias_unicas_pg13(codigo_categoria,categoria,rating,fecha_carga)
    select codigo_categoria,categoria,rating,now() from staging.stg_categorias_unicas_pg13;
    CALL metadata.sp_agregar_carga('categorias_unicas_pg13', 'dwh', 'COMPLETADO',(select count(*) from staging.stg_categorias_unicas_pg13));
end;

create procedure dwh.sp_cargar_pelicula_elenco_detalle()
begin
    insert into dwh.pelicula_elenco_detalle(pelicula,codigo_pelicula,total_recaudado,promedio_renta,total_actores,codigo_primer_actor,primer_actor,codigo_segundo_actor,segundo_actor,fecha_carga)
    select pelicula,codigo_pelicula,total_recaudado,promedio_renta,total_actores,codigo_primer_actor,primer_actor,codigo_segundo_actor,segundo_actor,now() 
    from staging.stg_pelicula_elenco_detalle;
    CALL metadata.sp_agregar_carga('pelicula_elenco_detalle', 'dwh', 'COMPLETADO',(select count(*) from staging.stg_pelicula_elenco_detalle));
end;

create procedure dwh.sp_cargar_tienda_renta()
begin

    insert into dwh.tienda_renta(nombre_tienda,codigo_empleado,codigo_tienda,total_recaudado,fecha_carga)
    select nombre_tienda,codigo_empleado,codigo_tienda,total_recaudado,now() from staging.stg_tienda_renta;
    CALL metadata.sp_agregar_carga('tienda_renta', 'dwh', 'COMPLETADO',(select count(*) from staging.stg_tienda_renta));
end;

create  PROCEDURE dwh.sp_cargar_clientes_rentas_categoria()
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
    CALL metadata.sp_agregar_carga('clientes_rentas_categoria', 'dwh', 'COMPLETADO', (SELECT count(*) FROM staging.stg_clientes_rentas_categoria));
END; 

create  PROCEDURE dwh.sp_cargar_paises_ciudades()
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
    CALL metadata.sp_agregar_carga('paises_ciudades', 'dwh', 'COMPLETADO', (SELECT count(*) FROM staging.stg_paises_ciudades));
END; 


CREATE PROCEDURE metadata.sp_agregar_carga(
    IN p_tabla VARCHAR(200),
    IN p_esquema VARCHAR(200),
    IN p_estado VARCHAR(200),
    in p_total int
)
BEGIN
    INSERT INTO historico_carga(tabla, esquema, fecha_carga, estado, total)
    VALUES (p_tabla, p_esquema, NOW(), p_estado, p_total);
END