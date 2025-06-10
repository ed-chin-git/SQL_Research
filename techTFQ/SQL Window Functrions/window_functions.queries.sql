-- All the SQL Queries written during this video
-- https://youtu.be/Ww71knvhQ-s?si=IYSgHy0I3432CS7E
-- connect to techTFQ database
set search_path to 'public';  --set schema to public

select * from product;

--FIRST_VALUE 
--most expensive By category (corresponding to each record)
select *,
    first_value(product_name) 
    over(partition by product_category order by price desc) as most_exp_product
from product;

--LAST_VALUE 
--least expensive by category (corresponding to each record)
select *,
first_value(product_name) 
    over(partition by product_category order by price desc) 
    as most_expensive,
last_value(product_name) 
    over(partition by product_category order by price desc
        range between unbounded preceding and unbounded following) 
    as least_expensive
from product
WHERE product_category ='Phone';

--use Window functions
/* window functions allow calculations 
across a set of rows related to the current row 
without grouping them into a single output.
Common functions include 
SUM(), 
AVG(), 
ROW_NUMBER()
RANK(), 
defined using the OVER clause to specify the window of data.
*/

select *,
first_value(product_name) over w as most_expensive,
last_value(product_name) over w as least_expensive
from product
WHERE product_category ='Phone'
window w as (partition by product_category order by price desc
            range between unbounded preceding and unbounded following);

-- NTH_VALUE 
-- 2nd most expensive under each category.
select *,
first_value(product_name) over w as most_expensive,
last_value(product_name) over w as least_expensive,
nth_value(product_name, 2) over w as second_most_expensive
from product
window w as (partition by product_category order by price desc
            range between unbounded preceding and unbounded following);

-- NTILE
-- segregate expensive phones, mid range phones, &cheaper phones.
select x.product_name, 
case when x.buckets = 1 then 'Expensive Phones'
     when x.buckets = 2 then 'Mid Range Phones'
     when x.buckets = 3 then 'Cheaper Phones' END as Phone_Category
from (
    select *,
    ntile(3) over (order by price desc) as buckets
    from product
    where product_category = 'Phone') x;

-- CUME_DIST (cumulative distribution) ; 
/*  Formula = Current Row no (or Row No with value same as current row) / Total no of rows */

-- Query to fetch all products which are constituting the first 30% 
-- of the data in products table based on price.
select product_name, cume_dist_percetage
from (
    select *,
    cume_dist() over (order by price desc) as cume_distribution,
    round(cume_dist() over (order by price desc)::numeric * 100,2)||'%' as cume_dist_percetage
    from product) x
where x.cume_distribution <= 0.3;

-- PERCENT_RANK (relative rank of the current row / Percentage Ranking)
/* Formula = Current Row No - 1 / Total no of rows - 1 */

-- Query to identify how much percentage more expensive is "Galaxy Z Fold 3" when compared to all products.
select product_name, per
from (
    select *,
    percent_rank() over(order by price) ,
    round(percent_rank() over(order by price)::numeric * 100, 2) as per
    from product) x
where x.product_name='Galaxy Z Fold 3';