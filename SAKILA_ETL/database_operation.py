import psycopg2
import mysql.connector
from sqlalchemy import create_engine
from config import Config
import pandas as pd
from datetime import datetime

class Database_Operation:

    def __get_sakila_string(self):
        config = Config.get_config()['sakila']
        connection_string = f"mysql+mysqlconnector://{config['username']}:{config['password']}@{config['server']}/{config['catalogo']}"
        return connection_string
    
    def __get_dwh_string(self):
        config = Config.get_config()['sakila_etl']
        connection_string = f"postgresql://{config['username']}:{config['password']}@{config['server']}/{config['catalogo']}"
        return connection_string

    def obtener_vista(self,vista):
        engine = create_engine(self.__get_sakila_string())
        dataframe =pd.read_sql_table(vista, con=engine)
        return dataframe
    
    def cargar_reporte_stg_dwh(self,reporte,vista):
        engine = create_engine(self.__get_dwh_string())
        reporte.to_sql(f'{vista.replace('vw_','stg_')}', engine, schema='staging', if_exists='replace', index=False)
    
    def cargar_reporte_stg_sakila(self,reporte,vista):
        engine = create_engine(self.__get_sakila_string())
        reporte.to_sql(f'{vista.replace('vw_','stg_')}', engine, schema='staging', if_exists='replace', index=False)

    def registro_carga_sakila(self, esquema, vista, registros):
        _fecha = str(datetime.now())
        config = Config.get_config()['sakila']
        config_metadata = Config.get_config()['metadata']
        conexion = mysql.connector.connect(
            host=config['server'],
            port=int(config['puerto']),
            user=config['username'],
            password=config['password'],
            database=config_metadata['esquema']
        )
        cursor = conexion.cursor()

        try:
            nombre_tabla = vista.replace("vw_", "stg_" if esquema == "staging" else "")
            cursor.execute(f"CALL {config_metadata['esquema']}.{config_metadata['registrar']}(%s, %s, %s, %s)", (nombre_tabla, esquema, 'COMPLETADO', int(registros)))
            conexion.commit()
            print(f"\t |> Reporte {vista.replace('vw_', '')} CARGADO en {esquema} en sakila con {registros} registros | {_fecha}")
        except Exception as e:
            print(f"\t |> Reporte {vista.replace('vw_', '')} cargado en {esquema} No fue CARGADO en sakila | {_fecha}", e)
            conexion.rollback()
        finally:
            cursor.close()
            conexion.close()
    
    def registro_carga_dwh(self, esquema, vista,registros):
        _fecha = str(datetime.now())
        config_metadata = Config.get_config()['metadata']
        conexion = psycopg2.connect(self.__get_dwh_string())
        cursor = conexion.cursor()
        try:
            cursor.execute(f"CALL {config_metadata['esquema']}.{config_metadata['registrar']}(%s, %s, %s,%s)", (f'{vista.replace('vw_','stg_' if esquema == 'staging'  else '')}', esquema, 'COMPLETADO',int(registros)))
            conexion.commit()  # Importante: confirmar los cambios
            print(f"\t |> Reporte {vista.replace('vw_','')} CARGADO en {esquema} en sakila_dwh con {registros} registros | {_fecha}")
        except Exception as e:
            print(f"\t |> Reporte {vista.replace('vw_','')} cargado en {esquema} No fue CARGADO en sakila_dwh | {_fecha}", e)
            conexion.rollback()
        finally:
            cursor.close()
            conexion.close()
        
    def ejecutar_carga_dwh(self,procedimiento):
        _fecha = str(datetime.now())
        conexion = psycopg2.connect(self.__get_dwh_string())
        cursor = conexion.cursor()
        try:
            cursor.execute(f"CALL dwh.{procedimiento}()")
            conexion.commit()  # Importante: confirmar los cambios
            print(f"\t |> Tabla {procedimiento.replace('sp_cargar_','')} CARGADA en sakila_dwh CON EXITO | {_fecha}")
        except Exception as e:
            print(F"\t |> Tabla {procedimiento.replace('sp_cargar_','')} NO FUE CARGADA en sakila_dwh | {_fecha}", e)
            conexion.rollback()
        finally:
            cursor.close()
            conexion.close()
    
    def ejecutar_carga_sakila(self,procedimiento):
        _fecha = str(datetime.now())
        config = Config.get_config()['sakila']
        conexion = mysql.connector.connect(
            host=config['server'],
            port=int(config['puerto']),
            user=config['username'],
            password=config['password'],
            database='dwh'
        )
        cursor = conexion.cursor()

        try:
            cursor.callproc(procedimiento)
            conexion.commit()
            print(f"\t |> Tabla {procedimiento.replace('sp_cargar_','')} CARGADA CON EXITO | {_fecha}")
        except Exception as e:
            print(F"\t |> Tabla {procedimiento.replace('sp_cargar_','')} NO FUE CARGADA | {_fecha}", e)
            conexion.rollback()
        finally:
            cursor.close()
            conexion.close()
