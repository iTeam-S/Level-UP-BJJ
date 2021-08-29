from os import environ as env

def database(**kwargs):
     return {
          'host' : 'localhost',
          'user' : env.get('ITEAMS_DB_USER'),
          'password': env.get('ITEAMS_DB_PASSWORD'),
          'database': 'BJJ'
     }
