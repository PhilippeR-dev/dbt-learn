select
    order_id
from SNOWDBT_TUTO.dbt_prey.fct_orders
where order_id is not null and order_id !='00000' and order_id !='11111' 
group by order_id
having count(*) > 1