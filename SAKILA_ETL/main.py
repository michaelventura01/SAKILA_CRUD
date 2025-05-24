from etl_operation import Etl_Operation

class Main:
    def __init__(self):
        print('EJECUCION DE ETL: ')
        etl = Etl_Operation()
        etl.generar_carga_staging()
        etl.generar_carga_dwh()
        etl.generar_reporte_archivo()

if __name__ == '__main__':
    main_instance = Main()