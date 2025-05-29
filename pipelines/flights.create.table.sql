DROP TABLE IF EXISTS flights CASCADE;
DROP TABLE IF EXISTS flight_test CASCADE;
CREATE TABLE flights 
(
   year               integer,
   month              integer,
   dayofmonth         integer,
   dayofweek          integer,
   deptime            numeric,
   crsdeptime         integer,
   arrtime            numeric,
   crsarrtime         integer,
   uniquecarrier      varchar(8),
   flightnum          integer,
   tailnum            varchar(8),
   actualelapsedtime  numeric,
   crselapsedtime     numeric,
   airtime            numeric,
   arrdelay           numeric,
   depdelay           numeric,
   origin             varchar(8),
   dest               varchar(8),
   distance           integer,
   taxiin             integer,
   taxiout            integer,
   cancelled          integer,
   cancellationcode   varchar(8),
   diverted           bigint,
   carrierdelay       bigint,
   weatherdelay       bigint,
   nasdelay           bigint,
   securitydelay      bigint,
   lateaircraftdelay  bigint
);

COMMIT;
