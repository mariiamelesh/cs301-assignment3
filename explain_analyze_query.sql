explain analyze 
select c.customer_id, c.full_name, count(distinct o.order_id) as total_orders, sum(oi.quantity) as total_items_bought, count(distinct oi.product_id) as unique_products_ordered
from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
group by c.customer_id, c.full_name
order by total_items_bought desc;