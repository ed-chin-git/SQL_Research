DROP TABLE IF EXISTS abtest_purchases CASCADE;
DROP TABLE IF EXISTS abtest_users CASCADE;

CREATE TABLE abtest_purchases
(
   user_id       integer,
   purchase_id   bigint
);

CREATE TABLE abtest_users
(
   user_id       integer,
   user_name     varchar(13)
);

COMMIT;

COPY abtest_purchases FROM 'abtest_purchases.csv' DELIMITER ',' CSV HEADER;

COPY abtest_users FROM 'abtest_users.csv' DELIMITER ',' CSV HEADER;
