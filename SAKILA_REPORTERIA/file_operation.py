from config import Config
import os
import pandas as pd

class File_Operation:

    def obtener_archivos(self):
        config = Config.get_config()['ruta']
        directorio = os.listdir(config['reportes_generados'])
        archivos = [f for f in directorio if f.endswith(".csv")]
        return archivos

    def abrir_archivo(self,archivo):
        config = Config.get_config()['ruta']
        ruta_completa = os.path.join(config['reportes_generados'], archivo)
        reporte = pd.read_csv(ruta_completa)
        return reporte