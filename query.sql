create or replace function calculate_order_total(p_order_id int)
returns numeric 
as $$
begin
    return (
		select coalesce(sum(quantity*price), 0)
		from order_items
		where order_id = p_order_id
		group by order_id
		);
end;
$$ language plpgsql;

create or replace procedure create_order(p_customer_id int)
as $$
begin
    if not exists (select 1 from customers where customer_id = p_customer_id) then
    raise exception 'customer doesnt exist';
	end if;
	insert into orders (customer_id) values (p_customer_id);
end;
$$ language plpgsql;
