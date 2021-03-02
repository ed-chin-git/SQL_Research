import psycopg2 as pgres
import pandas as pd
import os
from dotenv import load_dotenv
load_dotenv()

csv_url = "titanic.csv"
new_table_name = 'titanic'
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


def main():
    # ____ Connect to DB Server __________
    dbname = os.getenv("local_DB_NAME")
    user = os.getenv("local_DB_USER")
    host = os.getenv("local_DB_HOST")
    passw = os.getenv("local_DB_PASSWORD")
    pgres_str = 'dbname=' + dbname + ' user=' + user +' host=' + host + ' password=' + passw
    pg_conn = pgres.connect(pgres_str)

    # ____ create cursor ___
    pg_cur = pg_conn.cursor()

    # _  Re-Create table  in PostgreSQL
    pg_cur.execute(create_table)
    pg_conn.commit()  # commit the CREATE
 
    # ____ Port csv to Postgres ___
    df = pd.read_csv(csv_url)
    df_len = len(df)
    single_quote = "'"
    double_quote = '"'
    SQLinsert1 = 'INSERT INTO titanic (Survived, pclass, name, sex, age, SSAboard, PCAboard, fare) VALUES'

    for index, row in df.iterrows(): 
        # Changes O'Dwyer to O"Dwyer to correct bug in INSERT string
        na_me = row.Name.replace(single_quote, double_quote)
        row_data = (row.Survived,
                    row.Pclass,
                    na_me,
                    row.Sex,
                    int(row.Age),
                    row.SSAboard,
                    row.PCAboard,
                    row.Fare)
        SQLinsert = SQLinsert1 + str(row_data)
        print('\r', end='')    
        print('Inserting Row:{}   {:2.0f} percent complete'.format(index, (index/df_len)*100), end='')
        pg_cur.execute(SQLinsert)
        pg_conn.commit()  # commit INSERT

    # _______ verify output  _________
    query = "SELECT * FROM public.titanic LIMIT 15;"
    print('\n--- public.titanic table ---')
    pg_cur.execute(query)
    for row in pg_cur.fetchall():
        print(row[3],row[4],row[8] )

    # ___ end main ___________
    pg_cur.close()   # close cursor
    pg_conn.close()  # close connection
    return

# Launched from the command line
if __name__ == '__main__':
    main()
