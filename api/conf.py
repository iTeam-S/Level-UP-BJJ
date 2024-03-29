from os import environ as env
from dotenv import load_dotenv

load_dotenv()

TOKEN_PAYEMENT = env.get('TOKEN_PAYEMENT')

def database(**kwargs):
     return {
          'host' : "127.0.0.1",
          'user' : env.get('ITEAMS_DB_USER'),
          'password': env.get('ITEAMS_DB_PASSWORD'),
          'database': 'BJJ',
	     'charset': 'utf8mb4'
     }