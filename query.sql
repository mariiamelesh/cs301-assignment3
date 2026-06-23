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