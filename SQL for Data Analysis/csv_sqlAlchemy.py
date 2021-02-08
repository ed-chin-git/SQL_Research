import psycopg2
import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv
load_dotenv()

#  ____________  CONNECT TO DATABASE ___________________
def db_connect(): 
    # __ Connect to AWS-RDS(postgres) (SQLalchemy.create_engine) ____
    dbname = os.getenv("local_DB_NAME")
    user   = os.getenv("local_DB_USER")
    host   = os.getenv("local_DB_HOST")
    passw  = os.getenv("local_DB_PASSWORD")
    pgres_str = 'postgresql+psycopg2://'+user+':'+passw+'@'+host+'/'+dbname
    pgres_engine = create_engine(pgres_str)
    return pgres_engine

def csv_to_sql(engine):
    # ___ load the CSV into a df ____
    csv_url = "flights.csv"
    print('Loading CSV file...............')
    df = pd.read_csv(csv_url)

    #  To avoid an extra SQL table column,
    #  set dataframe index to 1st column
    #  before executing .to_sql()
    df.set_index(df.columns[0], inplace=True)    
    print(df.head())
    # _____ Convert to SQL Table _____
    print('Conversion to SQLg in progress. PLEASE WAIT ...............')
    df.to_sql('flight_delays',
              if_exists='replace',
              con=engine,
              chunksize=10000,
              method='multi')
    print('Conversion COMPLETED...')
    return

def main():
    # ____ Connect to DB using SQLalchemy engine  __________
    engine = db_connect()

    # ____ Port csv to SQL DB ___
    csv_to_sql(engine)

    #  _______ verify output  _________
    query = """
    SELECT *
    FROM public.flight_delays
    LIMIT 10 ;
    """
    print('--- public.flight_delays table from ', os.getenv("DS_DB_HOST"), '---')
    for row in engine.execute(query).fetchall():
        print(row)

    # ___ end main ___________
    return

#  Launched from the command line
if __name__ == '__main__':
    main()
