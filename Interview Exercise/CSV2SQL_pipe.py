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


def insert_csv_data(engine, csv_file, table_name):
    # ___ load the CSV into a df ____
    csv_url = csv_file
    df = pd.read_csv(csv_url)

    #  To avoid an extra SQL table column,
    #  set dataframe index to 1st column
    #  before executing .to_sql()
    df.set_index(df.columns[0], inplace=True)

    # _____ Convert to postgres DB______
    df.to_sql(table_name, if_exists='replace', con=engine, method='multi')
    return


def main():
    # ____ Connect to postgres using SQLalchemy engine  __________
    engine = db_connect()

    # ____ Port csv's to postgres ___
    file_names = ["abtest_purchases.csv",
                  "abtest_users.csv"]
    for csv_filename in file_names:
        table_name = csv_filename.replace('.csv', '')
        insert_csv_data(engine, csv_filename, table_name)
        #  _______ verify output  _________
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
