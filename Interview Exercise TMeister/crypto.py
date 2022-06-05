
import pandas as pd
import os
import sqlite3
import os
from dotenv import load_dotenv
import psycopg2
from psycopg2.extras import execute_values	
import json				

# CONNECT TO CURRENT DB TO RUN QUERIES
DB_FILEPATH = os.path.join(os.path.dirname(__file__), "crypto.sqlite3")
conn = sqlite3.connect(DB_FILEPATH)
conn.row_factory = sqlite3.Row
curs = conn.cursor()

query_q1 = "SELECT count(Symbol) FROM crypto"
results1 = curs.execute(query_q1).fetchone()[0]
print("The answer is: ", results1)


# # INSERT SOME DATA

# insert_query = """
# INSERT INTO test_table (name, data) VALUES 
# (
# 	'A rowwwww', 
# 	'null'
# ),
# (
# 	'Another row, with JSON',
# 	'{"a":1, "b": ["dog", "cat", 42], "c":true}'::JSONB
# );"""

# # adds one row this way
# my_dict = { "a": 1, "b": ["dog", "cat", 42], "c": 'true' }
	
# insertion_query = "INSERT INTO test_table (name, data) VALUES (%s, %s)"
# cursor.execute(insertion_query,
#     ('A rowwwww', 'null')
# )
# cursor.execute(insertion_query,
#     ('Another row, with JSONNNNN', json.dumps(my_dict))
# )


# insertion_query = "CREATE TABLE IF NOT EXISTS practice(id integer, name varchar(44), abbreviation varchar(10), date date)"
# cursor.execute(insertion_query)

# insertion_query1 = "INSERT INTO practice VALUES(1, 'Bitcoin', 'BTC', 4/18/2020)"
# cursor.execute((insertion_query1))
#execute_values(cursor, insertion_query, results1)



# EXECUTE Multiple items
# way to add multiple items
# my_dict = { "a": 1, "b": ["dog", "cat", 42], "c": 'true' }

# insertion_query = "INSERT INTO test_table (name, data) VALUES %s"
# execute_values(cursor, insertion_query, [
#     ('A rowwwww', 'null'),
#     ('Another row, with JSONNNNN', json.dumps(my_dict)),
#     ('Third row', "3")
# ])


# insertion_query = "INSERT INTO practice VALUES(3, 'Ethereum', 'ETH', '4/25/2020')"
# curs.execute((insertion_query))

insertion_query6 = "INSERT INTO practice (id, name, abbreviation, date) VALUES %s"
execute_values(curs, "INSERT INTO practice (id, name, abbreviation, date) VALUES %s", [
    (3, 'Etherium', 'ETH', '4/25/2020')
    ])


# commit the data
conn.commit()
curs.close()
conn.close()