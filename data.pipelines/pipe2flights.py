# __________ CSV file to postgres-DB Pipeline __________
import psycopg2 as pgres
import pandas as pd
import os
from dotenv import load_dotenv
load_dotenv()

csv_url = "flights-2007.csv"
new_table_name = 'flight_delays'
new_table_columns = """(
id SERIAL PRIMARY KEY,
Year int,
Month int,
DayofMonth int,
DayOfWeek int,
DepTime numeric,
CRSDepTime	int	,
ArrTime	numeric	,
CRSArrTime	int	,
UniqueCarrier varchar(8),
FlightNum int,
TailNum	varchar(8),
ActualElapsedTime numeric,
CRSElapsedTime numeric,
AirTime numeric,
ArrDelay numeric,
DepDelay numeric,
Origin varchar(8),
Dest varchar(8),
Distance int,
TaxiIn	int,
TaxiOut	int,
Cancelled int,
CancellationCode varchar(8),
Diverted bigint,
CarrierDelay bigint,
WeatherDelay bigint,
NASDelay bigint,
SecurityDelay bigint,
LateAircraftDelay bigint
);"""

def main():
    # ____ Load csv into dataframe___
    print('Loading CSV.......')
    df = pd.read_csv(csv_url)   

    # ____ set NANs to 0 ____
    df.fillna(0, inplace=True)

    # ____ define strings
    table_columns = str(tuple(df.columns)).replace("'", "")
    SQLinsert_prefix = 'INSERT INTO {} '.format(new_table_name)
    SQLinsert_prefix = SQLinsert_prefix + table_columns + ' VALUES'

    # ____ Connect to DB Server __________
    dbname = os.getenv("local_DB_NAME")
    user = os.getenv("local_DB_USER")
    host = os.getenv("local_DB_HOST")
    passw = os.getenv("local_DB_PASSWORD")
    pgres_str = 'dbname=' + dbname + ' user=' + user +' host=' + host + ' password=' + passw
    pg_conn = pgres.connect(pgres_str)

    # ____ create cursor ___
    pg_cur = pg_conn.cursor()

    # ___ Create table  in PostgreSQL ___
    pg_cur.execute('DROP TABLE IF EXISTS {} CASCADE;'.format(new_table_name))
    pg_cur.execute('CREATE TABLE {} '.format(new_table_name) + new_table_columns)
    pg_conn.commit()  # commit the CREATE


    # print(df.columns)
    # df_len = len(df)
    # for index, row in df.iterrows():
    #     print(index, row.Month, row.DayofMonth, end='/    ')

    # ____ Port df to Postgres ___
    df_len = len(df)
    for index, row in df.iterrows():
        row_data = (
                    row.Year,
                    row.Month,
                    row.DayofMonth,
                    row.DayOfWeek,
                    row.DepTime,
                    row.CRSDepTime,
                    row.ArrTime,
                    row.CRSArrTime,
                    row.UniqueCarrier,
                    row.FlightNum,
                    row.TailNum,
                    row.ActualElapsedTime,
                    row.CRSElapsedTime,
                    row.AirTime,
                    row.ArrDelay,
                    row.DepDelay,
                    row.Origin,
                    row.Dest,
                    row.Distance,
                    row.TaxiIn,
                    row.TaxiOut,
                    row.Cancelled,
                    row.CancellationCode,
                    row.Diverted,
                    row.CarrierDelay,
                    row.WeatherDelay,
                    row.NASDelay,
                    row.SecurityDelay,
                    row.LateAircraftDelay)
        SQLinsert = SQLinsert_prefix + str(row_data)
        print('\r', end='')
        print('Inserted Row:{}   {:2.0f} percent complete'.format(index, (index/df_len)*100), end='')
        pg_cur.execute(SQLinsert)
        pg_conn.commit()  # commit INSERT

    # _______ verify output  _________
    query = "SELECT * FROM public.{} LIMIT 15;".format(new_table_name)
    print('\n--- public.{} table ---'.format(new_table_name))
    pg_cur.execute(query)
    for row in pg_cur.fetchall():
        print(row[0], row[1], row[2])

    # ___ end main ___________
    pg_cur.close()   # close cursor
    pg_conn.close()  # close connection
    return

#  Launched from the command line
if __name__ == '__main__':
    main()
