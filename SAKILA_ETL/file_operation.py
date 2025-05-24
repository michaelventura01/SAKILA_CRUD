from config import Config
import os
from datetime import datetime

class File_Operation:
    def generar_archivo(self,dataframe,vista):
        _fecha = str(datetime.now())
        config = Config.get_config()['ruta']
        ruta_completa = os.path.join(config['reportes_generados'], f'{vista.replace('vw_','')}.csv')
        dataframe.to_csv(ruta_completa,index=False)
        print(f'\t |> Archivo de reporte {vista.replace('vw_','')} en fichero {ruta_completa} | {_fecha}')