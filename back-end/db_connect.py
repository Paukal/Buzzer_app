'''
Lets Go App
Paulius Tomas Kalvers
DB connection logic
'''

#!/usr/bin/python
import psycopg2
from db_config import config

def connect():
    """ Connect to the PostgreSQL database server """
    conn = None
    try:
        # read connection parameters
        params = config()

        # connect to the PostgreSQL server
        conn = psycopg2.connect(**params)

        # create a cursor
        cur = conn.cursor()

        cur.execute('SET client_encoding TO \'UTF8\';')

	# close the communication with the PostgreSQL
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            print('Database connected.')
            return conn
