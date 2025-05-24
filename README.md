# PROYECTO DE CRUD DE BASE DE DATOS SAKILA
### OBJETIVO 
#### Se busca utilizar las practicas para lectura de datos desde unos origenes, manipularlos y luego cargarlos utilizando python

### Detalles
#### Este proyecto cuenta con dos bloques:
- <b>ETL</b>: carga de datos del origen
- <b>REPORTERIA</b>: manipulacion de la informacion generada por el etl y ejecucion del mismo

#### Secuencia de instalacion
```
  pip install SAKILA_CRUD/SAKILA_ETL/requirements.txt
  pip install SAKILA_CRUD/SAKILA_REPORTERIA/requirements.txt
```

#### Se requiere tener dos bases de datos para su uso
- <b>mysql</b>: script/script_sakila_mysql.sql
- <b>postgree</b>: script/script_sakila_dwh_postgree.sql


### Fichero
```
SAKILA_CRUD
│   prac01-Consigna de Queries de practica 01.txt
│   SampleSakila.png
│   
├───REPORTES_GENERADOS
│       categorias_unicas_pg13.csv
│       clientes_rentas_categoria.csv
│       cliente_direccion.csv
│       paises_ciudades.csv
│       pais_ciudad_eri.csv
│       peliculas_rentadas_ciudades.csv
│       peliculas_rima_paises.csv
│       pelicula_categoria.csv
│       pelicula_elenco_detalle.csv
│       tienda_renta.csv
│       
├───SAKILA_ETL
│   │   config.ini
│   │   config.py
│   │   database_operation.py
│   │   etl_operation.py
│   │   file_operation.py
│   │   main.py
│   │   requirements.txt
│   │
│   └───__pycache__
│           config.cpython-312.pyc
│           database_operation.cpython-312.pyc
│           etl_operation.cpython-312.pyc
│           file_operation.cpython-312.pyc
│
├───SAKILA_REPORTERIA
│   │   config.ini
│   │   config.py
│   │   database_operation.py
│   │   file_operation.py
│   │   main.py
│   │   procesos.py
│   │   requirements.txt
│   │   user_interface.py
│   │
│   └───__pycache__
│           config.cpython-312.pyc
│           database_operation.cpython-312.pyc
│           file_operation.cpython-312.pyc
│           procesos.cpython-312.pyc
│           user_interface.cpython-312.pyc
│
└───SCRIPTS
        qty01.sql
        qty02.sql
        qty03.sql
        qty04.sql
        qty05.sql
        qty06.sql
        qty07.sql
        qty08.sql
        qty09.sql
        qty10.sql
        script_sakila_dwh_postgree.sql
        script_sakila_mysql.sql
```

### EJECUCION DE ETL
![image](https://github.com/user-attachments/assets/bdd20de3-f71c-487e-95d3-c7d10536501f)

### EJECUCION DE PEPORTERIA
![image](https://github.com/user-attachments/assets/0390fc40-5bfd-4cc1-a507-db8c42eb8cc8)

