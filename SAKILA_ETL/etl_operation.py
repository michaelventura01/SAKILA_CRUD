from config import Config
from database_operation import Database_Operation
from file_operation import File_Operation
from datetime import datetime

class Etl_Operation:
    def generar_carga_staging(self):
        _fecha = str(datetime.now())
        _config = Config.get_config()['reporte']
        _database = Database_Operation()
        print(f' - Inicio de ejecucion de staging | {_fecha}')
        
        for clave, vista in _config.items():
            _reporte = _database.obtener_vista(vista)
            _total_registros = len(_reporte)
            _database.cargar_reporte_stg_dwh(_reporte,vista)
            _database.registro_carga_dwh('staging',vista,_total_registros)
            _database.cargar_reporte_stg_sakila(_reporte,vista)
            _database.registro_carga_sakila('staging',vista,_total_registros)
    
    def generar_carga_dwh(self):
        _fecha = str(datetime.now())
        _config = Config.get_config()['procedimiento']
        _database = Database_Operation()
        print(f' - Inicio de ejecucion de dwh | {_fecha}')

        for clave, procedimiento in _config.items():
            # _database.ejecutar_carga_sakila(procedimiento)
            _database.ejecutar_carga_dwh(procedimiento)

    def generar_reporte_archivo(self):
        _fecha = str(datetime.now())
        _config = Config.get_config()['reporte']
        _database = Database_Operation()
        _archivo = File_Operation()
        print(f' - Inicio de ejecucion de generacion de archivos | {_fecha}')

        for clave, vista in _config.items():
            _reporte = _database.obtener_vista(vista)
            _archivo.generar_archivo(_reporte,vista)
