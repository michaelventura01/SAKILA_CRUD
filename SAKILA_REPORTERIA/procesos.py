import subprocess
from config import Config
class Procesos:
    def ejecutar_etl():
        try:
            config = Config.get_config()['ejecucion']            
            subprocess.run(["python", config['etl']], check=True)
            return True
        except Exception as e:
            return False