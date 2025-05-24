import configparser
from pathlib import Path

class Config:
    @staticmethod
    def get_config(config_file='config.ini'):
        config = configparser.ConfigParser()
        ruta = Path(__file__).resolve().parent / config_file
        config.read(ruta)
        return config