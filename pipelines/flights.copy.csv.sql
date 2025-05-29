-- CSV file must be in the same directory as the pgres DB files 
--  if Binded to windows directory -->  C:/databases/pgres/pgdat    or as defined in the container

COPY flights FROM 'flights-2007-Clean.csv' DELIMITER ',' CSV HEADER;