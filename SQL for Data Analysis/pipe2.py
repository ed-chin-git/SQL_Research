import psycopg2 as pgres
import pandas as pd
import os
from dotenv import load_dotenv
load_dotenv()

# ___ Connect to ElephantSQL db _________
def conx_elephant(conx_str):
    # instantiate and return connection obj
    cnx = pgres.connect(conx_str)
    return cnx


def main():
    # ____ Connect to an ElephantSQL __________
    dbname = os.getenv("DS_DB_NAME")
    user = os.getenv("DS_DB_USER")
    host = os.getenv("DS_DB_HOST")
    passw = os.getenv("DS_DB_PASSWORD")
    pgres_str = 'dbname=' + dbname + ' user=' + user +' host=' + host + ' password=' + passw
    pg_conn = conx_elephant(pgres_str)

    # ____ create cursor ___
    pg_cur = pg_conn.cursor()

    # _  Create table  in PostgreSQL
    create_table = """CREATE TABLE titanic (
    passenger_id SERIAL PRIMARY KEY,
    survived int,
    pclass int,
    name varchar(90),
    sex varchar(8),
    age int,
    SSAboard int,
    PCAboard int,
    fare numeric
    );"""
    pg_cur.execute(create_table)
    pg_conn.commit()  # commit the CREATE
 
    # ____ Port titanic.csv to Postgres ___
    csv_url = "titanic.csv"
    df = pd.read_csv(csv_url)
    single_quote = "'"
    double_quote = '"'
    for i in range(len(df)):
        # Changes O'Dwyer to O"Dwyer to correct bug in INSERT string
        na_me = str(df['Name'].iloc[i]).replace(single_quote, double_quote)  
        SQLinsert = 'INSERT INTO titanic (Survived, pclass, name, sex, age, SSAboard, PCAboard, fare) VALUES('
        SQLinsert = SQLinsert + str(df['Survived'].iloc[i]) + ',' \
                              + str(df['Pclass'].iloc[i]) + ",'" \
                              + na_me + "','" \
                              + df['Sex'].iloc[i] + "'," \
                              + str(df['Age'].iloc[i]) + ',' \
                              + str(df['SSAboard'].iloc[i]) + ',' \
                              + str(df['PCAboard'].iloc[i]) + ',' \
                              + str(df['Fare'].iloc[i])+');'
        print(SQLinsert)
        pg_cur.execute(SQLinsert)
    pg_conn.commit() # commit all the INSERTs

    # _______ verify output  _________
    query = "SELECT * FROM public.titanic LIMIT 15;"
    print('--- public.titanic table ---')
    pg_cur.execute(query)
    for row in pg_cur.fetchall():
        print(row)

    # ___ end main ___________
    pg_cur.close()   # close cursor
    pg_conn.close()  # close connection
    return

# Launched from the command line
if __name__ == '__main__':
    main()
