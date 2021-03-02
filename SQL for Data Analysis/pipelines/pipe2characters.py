#!/usr/bin/env python
"""Example of moving data from rpg_db.sqlite3 to PostgreSQL."""

import sqlite3
import psycopg2 as pg
import os
from dotenv import load_dotenv
load_dotenv()

# Get the data from sqlite3
sl_conn = sqlite3.connect('rpg_db.sqlite3')
results = sl_conn.execute('SELECT * FROM charactercreator_character;').fetchall()


# Assume user defines database parameters
# ____ Connect to an ElephantSQL __________
dbname = os.getenv("DS_DB_NAME")
user = os.getenv("DS_DB_USER")
host = os.getenv("DS_DB_HOST")
passw = os.getenv("DS_DB_PASSWORD")

pg_conn = pg.connect(dbname=dbname, user=user,
                     password=passw, host=host)


pg_curs = pg_conn.cursor()

#_  Create table  in PostgreSQL
create_character_table = """CREATE TABLE charactercreator_character (
  character_id SERIAL PRIMARY KEY,
  name varchar(30),
  level int,
  exp int,
  hp int,
  strength int,
  intelligence int,
  dexterity int,
  wisdom int
);"""
pg_curs.execute(create_character_table)


#  ___ insert all  data rows
for result in results:
    insert_result = """INSERT INTO charactercreator_character
    (name, level, exp, hp, strength, intelligence, dexterity, wisdom)
    VALUES""" + str(result[1:])
    print (insert_result)
    pg_curs.execute(insert_result)

#____  commit inserts to database  (finalize changes)
pg_conn.commit()
