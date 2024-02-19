create database raw;
create database analytics;
create schema raw.jaffle_shop;
create schema raw.stripe;
create schema raw.snowplow;
create schema raw.dbt_prey;
create schema analytics.dbt_prey;


create table raw.jaffle_shop.customers 
( id integer,
  first_name varchar,
  last_name varchar
);


copy into raw.jaffle_shop.customers (id, first_name, last_name)
from 's3://dbt-tutorial-public/jaffle_shop_customers.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
    ); 


create table raw.jaffle_shop.orders
( id integer,
  user_id integer,
  order_date date,
  status varchar,
  _etl_loaded_at timestamp default current_timestamp
);

copy into raw.jaffle_shop.orders (id, user_id, order_date, status)
from 's3://dbt-tutorial-public/jaffle_shop_orders.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
    );


create table raw.stripe.payment 
( id integer,
  orderid integer,
  paymentmethod varchar,
  status varchar,
  amount integer,
  created date,
  _batched_at timestamp default current_timestamp
);


copy into raw.stripe.payment (id, orderid, paymentmethod, status, amount, created)
from 's3://dbt-tutorial-public/stripe_payments.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
    );

create or replace table analytics.dbt_prey.mock_orders as
select od.id as order_id,
       od.user_id,
       od.order_date,
       od.status,
       od._etl_loaded_at as updated_at 
from raw.jaffle_shop.orders od
;


ANALYTICS.DBT_PREY.MOCK_ORDERS

select * from raw.jaffle_shop.customers;
select * from raw.jaffle_shop.orders;
select * from raw.stripe.payment;
select * from analytics.dbt_prey.mock_orders;