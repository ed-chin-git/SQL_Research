-- get the flights csv file here:  wget 46.101.230.157/sql_tutorial/2007.csv.bz2 
-- warning: it has NA's in integer fields and must be cleaned using flights.clean.csv.py

-- CSV file must be in the same directory as the pgres DB files 
--  if Binded to windows directory -->  C:/databases/pgres/pgdat    or as defined in the container

COPY flights FROM 'flights-2007-Clean.csv' DELIMITER ',' CSV HEADER;