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
    dbname = 'tmeister'  
    user = os.getenv("Local_DB_USER")
    host = os.getenv("Local_DB_HOST")
    passw = os.getenv("Local_DB_PASSWORD")
    pgres_str = 'postgresql+psycopg2://'+user+':'+passw+'@'+host+'/'+dbname
    pgres_engine = create_engine(pgres_str)
    return pgres_engine

def insert_csv_data(DBengine, csv_file, table_name):
    # ___ load the CSV into a df ____
    csv_url = csv_file
    df = pd.read_csv(csv_url)

    #  To avoid an extra SQL table column,
    #  set dataframe index to 1st column
    #  before executing .to_sql()
    df.set_index(df.columns[0], inplace=True)

    # _____ Convert to postgres DB______
    df.to_sql(table_name, if_exists='replace', con=DBengine, method='multi')
    return

def main():
    # ____ Connect and create db engine  __________
    DB_engine = db_connect()
    # _
    # ___ Port csv's to postgres ___
    csv_list = ["abtest_purchases.csv",
                  "abtest_users.csv"]
    for csv_filename in csv_list:
        table_name = csv_filename.replace('.csv', '')
        insert_csv_data(DB_engine, csv_filename, table_name)
        #  _______ verify output  _________
        query = 'SELECT * FROM public.' + table_name + ' LIMIT 10 ;'
        print('--- public.', table_name, ' table from ', os.getenv("DS_DB_HOST"), '---')
        for row in DB_engine.execute(query).fetchall():
            print(row)
    # ___ end main ___
    return

#  Launched from the command line
if __name__ == '__main__':
    print('\n'*100)  # force teminal to clear screen
    main()