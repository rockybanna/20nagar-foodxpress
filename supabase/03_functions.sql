-- FoodXpress backend foundation: reusable functions
-- Run after 01_tables.sql.

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create or replace function public.is_admin()
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.users u
    where u.id = auth.uid()
      and u.role = 'admin'
  );
$$;

create or replace function public.current_user_role()
returns public.user_role
language sql
stable
as $$
  select u.role
  from public.users u
  where u.id = auth.uid();
$$;

create or replace function public.validate_order_items_restaurant()
returns trigger
language plpgsql
as $$
declare
  v_order_restaurant_id uuid;
  v_item_restaurant_id uuid;
begin
  select o.restaurant_id into v_order_restaurant_id
  from public.orders o
  where o.id = new.order_id;

  select ri.restaurant_id into v_item_restaurant_id
  from public.restaurant_items ri
  where ri.id = new.item_id;

  if v_order_restaurant_id is null or v_item_restaurant_id is null then
    raise exception 'Order or item not found';
  end if;

  if v_order_restaurant_id <> v_item_restaurant_id then
    raise exception 'All items in an order must belong to the same restaurant';
  end if;

  return new;
end;
$$;

create or replace function public.enforce_dp_assignment_limits()
returns trigger
language plpgsql
as $$
declare
  v_active_count integer;
  v_waiting_count integer;
begin
  if new.dp_id is null then
    return new;
  end if;

  -- Active delivery load: max 2 orders per delivery partner.
  select count(*)
  into v_active_count
  from public.orders o
  where o.dp_id = new.dp_id
    and o.id <> new.id
    and o.status in ('dp_assigned', 'picked_up', 'out_for_delivery');

  if v_active_count >= 2 then
    raise exception 'Delivery partner already has the maximum 2 active orders';
  end if;

  -- Waiting queue: max 3 waiting assignments per active delivery partner.
  select count(*)
  into v_waiting_count
  from public.orders o
  where o.dp_id = new.dp_id
    and o.id <> new.id
    and o.status = 'dp_assigned';

  if new.status = 'dp_assigned' and v_waiting_count >= 3 then
    raise exception 'Delivery partner already has the maximum 3 waiting orders';
  end if;

  return new;
end;
$$;

create or replace function public.set_dp_ring_window()
returns trigger
language plpgsql
as $$
begin
  if new.status = 'dp_assigned' and (old.status is distinct from new.status) then
    new.dp_ring_started_at = now();
  end if;

  return new;
end;
$$;
