-- FoodXpress backend foundation: row-level security policies
-- Run after 01_tables.sql and 03_functions.sql.

alter table public.users enable row level security;
alter table public.customers enable row level security;
alter table public.restaurants enable row level security;
alter table public.restaurant_categories enable row level security;
alter table public.restaurant_items enable row level security;
alter table public.delivery_partners enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
alter table public.dp_wallet enable row level security;
alter table public.transactions enable row level security;

-- USERS
create policy "users_select_self_or_admin" on public.users
for select
using (id = auth.uid() or public.is_admin());

create policy "users_update_self_or_admin" on public.users
for update
using (id = auth.uid() or public.is_admin())
with check (id = auth.uid() or public.is_admin());

create policy "users_insert_admin_only" on public.users
for insert
with check (public.is_admin());

-- CUSTOMERS
create policy "customers_select_self_or_admin" on public.customers
for select
using (user_id = auth.uid() or public.is_admin());

create policy "customers_mutate_self_or_admin" on public.customers
for all
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

-- RESTAURANTS
create policy "restaurants_public_read" on public.restaurants
for select
using (true);

create policy "restaurants_admin_full_access" on public.restaurants
for all
using (public.is_admin())
with check (public.is_admin());

create policy "restaurants_owner_update" on public.restaurants
for update
using (owner_user_id = auth.uid())
with check (owner_user_id = auth.uid());

-- RESTAURANT CATEGORIES
create policy "restaurant_categories_public_read" on public.restaurant_categories
for select
using (true);

create policy "restaurant_categories_admin_manage" on public.restaurant_categories
for all
using (public.is_admin())
with check (public.is_admin());

create policy "restaurant_categories_owner_manage" on public.restaurant_categories
for all
using (
  exists (
    select 1
    from public.restaurants r
    where r.id = restaurant_categories.restaurant_id
      and r.owner_user_id = auth.uid()
  )
)
with check (
  exists (
    select 1
    from public.restaurants r
    where r.id = restaurant_categories.restaurant_id
      and r.owner_user_id = auth.uid()
  )
);

-- RESTAURANT ITEMS
create policy "restaurant_items_public_read" on public.restaurant_items
for select
using (true);

create policy "restaurant_items_admin_manage" on public.restaurant_items
for all
using (public.is_admin())
with check (public.is_admin());

create policy "restaurant_items_owner_manage" on public.restaurant_items
for all
using (
  exists (
    select 1
    from public.restaurants r
    where r.id = restaurant_items.restaurant_id
      and r.owner_user_id = auth.uid()
  )
)
with check (
  exists (
    select 1
    from public.restaurants r
    where r.id = restaurant_items.restaurant_id
      and r.owner_user_id = auth.uid()
  )
);

-- DELIVERY PARTNERS
create policy "delivery_partners_select_self_or_admin" on public.delivery_partners
for select
using (user_id = auth.uid() or public.is_admin());

create policy "delivery_partners_mutate_self_or_admin" on public.delivery_partners
for all
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

-- ORDERS
create policy "orders_admin_full_access" on public.orders
for all
using (public.is_admin())
with check (public.is_admin());

create policy "orders_customer_access" on public.orders
for all
using (customer_id = auth.uid())
with check (customer_id = auth.uid());

create policy "orders_restaurant_access" on public.orders
for select
using (
  exists (
    select 1
    from public.restaurants r
    where r.id = orders.restaurant_id
      and r.owner_user_id = auth.uid()
  )
);

create policy "orders_restaurant_update_status" on public.orders
for update
using (
  exists (
    select 1
    from public.restaurants r
    where r.id = orders.restaurant_id
      and r.owner_user_id = auth.uid()
  )
)
with check (
  exists (
    select 1
    from public.restaurants r
    where r.id = orders.restaurant_id
      and r.owner_user_id = auth.uid()
  )
);

create policy "orders_dp_access" on public.orders
for select
using (dp_id = auth.uid());

create policy "orders_dp_update" on public.orders
for update
using (dp_id = auth.uid())
with check (dp_id = auth.uid());

-- ORDER ITEMS
create policy "order_items_admin_full_access" on public.order_items
for all
using (public.is_admin())
with check (public.is_admin());

create policy "order_items_order_participants_read" on public.order_items
for select
using (
  exists (
    select 1
    from public.orders o
    left join public.restaurants r on r.id = o.restaurant_id
    where o.id = order_items.order_id
      and (
        o.customer_id = auth.uid()
        or o.dp_id = auth.uid()
        or r.owner_user_id = auth.uid()
      )
  )
);

create policy "order_items_customer_insert" on public.order_items
for insert
with check (
  exists (
    select 1
    from public.orders o
    where o.id = order_items.order_id
      and o.customer_id = auth.uid()
  )
);

-- DP WALLET
create policy "dp_wallet_select_self_or_admin" on public.dp_wallet
for select
using (dp_id = auth.uid() or public.is_admin());

create policy "dp_wallet_admin_manage" on public.dp_wallet
for all
using (public.is_admin())
with check (public.is_admin());

-- TRANSACTIONS
create policy "transactions_select_participants_or_admin" on public.transactions
for select
using (
  public.is_admin()
  or dp_id = auth.uid()
  or exists (
    select 1
    from public.orders o
    where o.id = transactions.order_id
      and o.customer_id = auth.uid()
  )
);

create policy "transactions_admin_insert" on public.transactions
for insert
with check (public.is_admin());
