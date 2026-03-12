-- FoodXpress backend foundation: performance indexes
-- Run after 01_tables.sql.

create index if not exists idx_users_role on public.users(role);

create index if not exists idx_restaurants_is_open on public.restaurants(is_open);
create index if not exists idx_restaurants_location on public.restaurants(lat, lng);

create index if not exists idx_restaurant_categories_restaurant_id on public.restaurant_categories(restaurant_id);

create index if not exists idx_restaurant_items_restaurant_id on public.restaurant_items(restaurant_id);
create index if not exists idx_restaurant_items_category_id on public.restaurant_items(category_id);
create index if not exists idx_restaurant_items_available on public.restaurant_items(restaurant_id, is_available);

create index if not exists idx_delivery_partners_online on public.delivery_partners(is_online);
create index if not exists idx_delivery_partners_location on public.delivery_partners(current_lat, current_lng);

create index if not exists idx_orders_customer_id on public.orders(customer_id);
create index if not exists idx_orders_restaurant_id on public.orders(restaurant_id);
create index if not exists idx_orders_dp_id on public.orders(dp_id);
create index if not exists idx_orders_status on public.orders(status);
create index if not exists idx_orders_created_at on public.orders(created_at desc);
create index if not exists idx_orders_dp_active on public.orders(dp_id, status)
  where status in ('dp_assigned', 'picked_up', 'out_for_delivery');

create index if not exists idx_order_items_order_id on public.order_items(order_id);
create index if not exists idx_order_items_item_id on public.order_items(item_id);

create index if not exists idx_transactions_order_id on public.transactions(order_id);
create index if not exists idx_transactions_dp_id on public.transactions(dp_id);
create index if not exists idx_transactions_created_at on public.transactions(created_at desc);
