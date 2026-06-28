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

create or replace procedure add_product_to_order(
    p_order_id int,
    p_product_id int,
    p_quantity int
    )
as $$
declare 
	price int;
begin
	if p_quantity <= 0 then
	raise exception 'cant add zero or negative number of products';
	end if;

	if (select stock_quantity from products where product_id = p_product_id) < p_quantity then
	raise exception 'not enough product';
	end if;

	select price 
	into price
	from products 
	where product_id = p_product_id;

	update products
	set stock_quantity = stock_quantity-p_quantity
	where product_id = p_product_id;

	insert into order_items (order_id, product_id, quantity, price)
    values (p_order_id, p_product_id, p_quantity, price);
end;
$$ language plpgsql;

create or replace function update_total()
returns trigger as $$
declare
    temp_order_id int;
    new_total int;
begin
    temp_order_id := coalesce(new.order_id, new.order_id);
    new_total := calculate_order_total(temp_order_id);

    update orders
    set total_amount = new_total
    where order_id = temp_order_id;

   	return new;
end;
$$ language plpgsql;

create trigger update_total
after insert or update or delete 
on orders
for each row
execute function update_total();

create or replace function log_order_creation()
returns trigger
as $$
begin
    insert into order_log (order_id, customer_id, action)
    values (
        new.order_id, 
        new.customer_id, 
        'created order'
    );
    return new;
end;
$$ language plpgsql;

create trigger order_log
after insert
on orders
for each row
execute function log_order_creation();