import psycopg2
import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv
load_dotenv()

# set input and output locations
csv_filename = 'flights.csv'
new_table_name = 'flight_delays'

#  ____________  CONNECT TO DATABASE ___________________
def db_connect(): 
    # __ Connect to AWS-RDS(postgres) (SQLalchemy.create_engine) ____
    dbname = os.getenv("local_DB_NAME")
    user   = os.getenv("local_DB_USER")
    host   = os.getenv("local_DB_HOST")
    passw  = os.getenv("local_DB_PASSWORD")
    pgres_str = 'postgresql://'+user+':'+passw+'@'+host+'/'+dbname
    pgres_engine = create_engine(pgres_str)
    return pgres_engine

def csv_to_sql(engine):
    # ___ load the CSV into a df ____
    print('Loading CSV file...............')
    df_large = pd.read_csv(csv_filename)
    df = df_large.sample(200)
    
    #  To avoid an extra SQL table column,
    #  set dataframe index to 1st column
    #  before executing .to_sql()
    df.set_index(df.columns[0], inplace=True)    
    print(df.head())
    # _____ Convert to SQL Table _____
    print('Conversion to SQL in progress. PLEASE WAIT ...............')
    df.to_sql(new_table_name,
              if_exists='replace',
              con=engine,
              chunksize=10000,
              method='multi')
    print('Conversion COMPLETED...')
    return

def main():
    # ____ Connect to DB using SQLalchemy engine  __________
    # ____ and Port csv to SQL DB ___
    engine =  db_connect()
    csv_to_sql(engine)

    #  _______ verify output  _________
    query = "SELECT * FROM public.{} LIMIT 10 ;".format(new_table_name)
    print('--- public.{} table from {} ---'.format(new_table_name ,os.getenv("local_DB_HOST")))
    for row in engine.execute(query).fetchall():
        print(row)

    # ___ end main ___________
    return

#  Launched from the command line
if __name__ == '__main__':
    main()
