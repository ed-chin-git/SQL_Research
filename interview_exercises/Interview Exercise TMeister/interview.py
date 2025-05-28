## 
#  conda activate environ1 
##
import psycopg2
import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv
load_dotenv()

def db_connect():
    # __ Connect to postgres-DB(SQLalchemy.create_engine) ____
    dbname = os.getenv("DS_DB_NAME")
    user = os.getenv("DS_DB_USER")
    host = os.getenv("DS_DB_HOST")
    passw = os.getenv("DS_DB_PASSWORD")
    pgres_str = 'postgresql+psycopg2://'+user+':'+passw+'@'+host+'/'+dbname
    pgres_engine = create_engine(pgres_str)
    return pgres_engine


def main():
    # ____ Connect to postgres using SQLalchemy engine  __________
    engine = db_connect()

    #  _______ verify output  _________
    table_name = "abtest_purchases"
    query = 'SELECT * FROM public.' + table_name + ' LIMIT 10 ;'
    print('--- public.', table_name, ' table from ', os.getenv("DS_DB_HOST"), '---')
    for row in engine.execute(query).fetchall():
        print(row)

    # ___ end main ___
    return

#  Launched from the command line
if __name__ == '__main__':
    print('\n'*100)  # force teminal to clear screen
    main()
