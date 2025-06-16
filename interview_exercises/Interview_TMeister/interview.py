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
    dbname = os.getenv("Local_DB_NAME")
    dbname = 'school'  
    user = os.getenv("Local_DB_USER")
    host = os.getenv("Local_DB_HOST")
    passw = os.getenv("Local_DB_PASSWORD")
    conn_str = 'postgresql+psycopg2://'+user+':'+passw+'@'+host+'/'+dbname
    conn = create_engine(conn_str)
    return conn

def runQuery(tablename, db_conn, query):
    print('--- public.', tablename, 'table from', os.getenv("Local_DB_HOST"), '---')
    for row in db_conn.execute(query).fetchall():
        print(row)
    return

def main():
    # ____ Connect to postgres db __________
    db_conn = db_connect()

    #  _______ execute queries  _________
    table_name = "abtest_purchases"
    query = f"SELECT * FROM public.{table_name} LIMIT 50 ;"
    runQuery(table_name, db_conn, query)

    table_name = "abtest_users"
    query = f"SELECT * FROM public.{table_name} LIMIT 50 ;"
    runQuery(table_name, db_conn, query)

    # ___ end main ___
    return

#  Launched from the command line
if __name__ == '__main__':
    print('\n'*100)  # force teminal to clear screen
    main()
