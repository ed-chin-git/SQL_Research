import psycopg2
import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv
load_dotenv()

# list of csv files to load
file_list = ['artist',
             'canvas_size',
             'image_link',
             'museum_hours',
             'museum',
             'product_size',
             'subject',
             'work']

#  ____________  CONNECT TO DATABASE ___________________
def db_connect():
    # __ Connect to postgres (SQLalchemy.create_engine) ____
    dbname = os.getenv("local_DB_NAME")
    schema = os.getenv("local_DB_SCHEMA")
    user   = os.getenv("local_DB_USER")
    host   = os.getenv("local_DB_HOST")
    passw  = os.getenv("local_DB_PASSWORD")
    pgres_str = 'postgresql://'+user+':'+passw+'@'+host+'/'+dbname
    pgres_engine = create_engine(pgres_str)
    return pgres_engine

def csv_to_sql(engine, csv_filename):
    # ___ load the CSV into a df ____
    print(f'Loading {csv_filename} ...............')
    df = pd.read_csv(f'{csv_filename}.csv')
    ## df_sample = df.sample(200) if large file
    
    #  To avoid creating an extra SQL table column,
    #  set df index to 1st column before executing df.to_sql()
    df.set_index(df.columns[0], inplace=True)    

    print(df.head())
    # _____ Convert to SQL Table _____
    print(f'Loading {csv_filename} ...............')
    df.to_sql(csv_filename,
              if_exists='replace',
              con=engine,
              schema=os.getenv('local_DB_SCHEMA'),
              chunksize=10000,
              method='multi')
    print('Conversion COMPLETED...')
    return

def main():
    # ____ Connect to DB __________
    engine =  db_connect()

    # ____ and Port csv to postgres ___
    for file_name in file_list:
            csv_to_sql(engine, file_name)

    #  _______ verify output  _________
    db_schema = os.getenv("local_DB_SCHEMA")
    for file_name in file_list:
        query = (f"SELECT * FROM {db_schema}.{file_name} LIMIT 10;")
        print(f'--- {db_schema}.{file_name} table from {os.getenv("local_DB_HOST")} ---')
        for row in engine.execute(query).fetchall():
            print(row)

    # ___ end main ___________
    return

#  Launched from the command line
if __name__ == '__main__':
    main()
