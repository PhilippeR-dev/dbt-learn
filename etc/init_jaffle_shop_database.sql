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

--RAW.SNOWPLOW.EVENTS

create or replace table raw.snowplow.events (
	app_id varchar(255),
	platform varchar(255),
	etl_tstamp timestamp_ntz(9),
	collector_tstamp timestamp_ntz(9) not null,
	dvce_created_tstamp timestamp_ntz(9),
	event varchar(128),
	event_id varchar(36) not null,
	txn_id number(38,0),
	name_tracker varchar(128),
	v_tracker varchar(100),
	v_collector varchar(100) not null,
	v_etl varchar(100) not null,
	user_id varchar(255),
	user_ipaddress varchar(128),
	user_fingerprint varchar(128),
	domain_userid varchar(128),
	domain_sessionidx number(38,0),
	network_userid varchar(128),
	geo_country varchar(2),
	geo_region varchar(3),
	geo_city varchar(75),
	geo_zipcode varchar(15),
	geo_latitude float,
	geo_longitude float,
	geo_region_name varchar(100),
	ip_isp varchar(100),
	ip_organization varchar(128),
	ip_domain varchar(128),
	ip_netspeed varchar(100),
	page_url varchar(4096),
	page_title varchar(2000),
	page_referrer varchar(4096),
	page_urlscheme varchar(16),
	page_urlhost varchar(255),
	page_urlport number(38,0),
	page_urlpath varchar(3000),
	page_urlquery varchar(6000),
	page_urlfragment varchar(3000),
	refr_urlscheme varchar(16),
	refr_urlhost varchar(255),
	refr_urlport number(38,0),
	refr_urlpath varchar(6000),
	refr_urlquery varchar(6000),
	refr_urlfragment varchar(3000),
	refr_medium varchar(25),
	refr_source varchar(50),
	refr_term varchar(255),
	mkt_medium varchar(255),
	mkt_source varchar(255),
	mkt_term varchar(255),
	mkt_content varchar(500),
	mkt_campaign varchar(255),
	se_category varchar(1000),
	se_action varchar(1000),
	se_label varchar(4096),
	se_property varchar(1000),
	se_value float,
	tr_orderid varchar(255),
	tr_affiliation varchar(255),
	tr_total number(18,2),
	tr_tax number(18,2),
	tr_shipping number(18,2),
	tr_city varchar(255),
	tr_state varchar(255),
	tr_country varchar(255),
	ti_orderid varchar(255),
	ti_sku varchar(255),
	ti_name varchar(255),
	ti_category varchar(255),
	ti_price number(18,2),
	ti_quantity number(38,0),
	pp_xoffset_min number(38,0),
	pp_xoffset_max number(38,0),
	pp_yoffset_min number(38,0),
	pp_yoffset_max number(38,0),
	useragent varchar(1000),
	br_name varchar(50),
	br_family varchar(50),
	br_version varchar(50),
	br_type varchar(50),
	br_renderengine varchar(50),
	br_lang varchar(255),
	br_features_pdf boolean,
	br_features_flash boolean,
	br_features_java boolean,
	br_features_director boolean,
	br_features_quicktime boolean,
	br_features_realplayer boolean,
	br_features_windowsmedia boolean,
	br_features_gears boolean,
	br_features_silverlight boolean,
	br_cookies boolean,
	br_colordepth varchar(12),
	br_viewwidth number(38,0),
	br_viewheight number(38,0),
	os_name varchar(50),
	os_family varchar(50),
	os_manufacturer varchar(50),
	os_timezone varchar(255),
	dvce_type varchar(50),
	dvce_ismobile boolean,
	dvce_screenwidth number(38,0),
	dvce_screenheight number(38,0),
	doc_charset varchar(128),
	doc_width number(38,0),
	doc_height number(38,0),
	tr_currency varchar(3),
	tr_total_base number(18,2),
	tr_tax_base number(18,2),
	tr_shipping_base number(18,2),
	ti_currency varchar(3),
	ti_price_base number(18,2),
	base_currency varchar(3),
	geo_timezone varchar(64),
	mkt_clickid varchar(128),
	mkt_network varchar(64),
	etl_tags varchar(500),
	dvce_sent_tstamp timestamp_ntz(9),
	refr_domain_userid varchar(128),
	refr_dvce_tstamp timestamp_ntz(9),
	domain_sessionid varchar(128),
	derived_tstamp timestamp_ntz(9),
	event_vendor varchar(1000),
	event_name varchar(1000),
	event_format varchar(128),
	event_version varchar(128),
	event_fingerprint varchar(128),
	true_tstamp timestamp_ntz(9),
	load_tstamp timestamp_ntz(9),
	contexts_com_snowplowanalytics_mobile_screen_1 varchar,
	contexts_com_snowplowanalytics_snowplow_client_session_1 varchar,
	contexts_com_snowplowanalytics_snowplow_geolocation_context_1 varchar,
	contexts_com_snowplowanalytics_snowplow_mobile_context_1 varchar,
	contexts_com_snowplowanalytics_mobile_application_1 varchar,
	unstruct_event_com_snowplowanalytics_mobile_screen_view_1 varchar,
	constraint event_id_pk primary key (event_id)
);

CREATE OR REPLACE STAGE snowplow_mobile_sample_stage
url = 's3://snowplow-demo-datasets/Mobile/Mobile_sample_events.csv'
file_format = (TYPE=csv field_delimiter=',' skip_header=1, FIELD_OPTIONALLY_ENCLOSED_BY='"')
;

COPY INTO raw.snowplow.events
FROM @snowplow_mobile_sample_stage;


select * from raw.jaffle_shop.customers;
select * from raw.jaffle_shop.orders;
select * from raw.stripe.payment;
select * from analytics.dbt_prey.mock_orders;
select * from raw.snowplow.events;
