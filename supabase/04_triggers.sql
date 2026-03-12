-- FoodXpress backend foundation: trigger bindings
-- Run after 03_functions.sql.

drop trigger if exists trg_users_set_updated_at on public.users;
create trigger trg_users_set_updated_at
before update on public.users
for each row execute function public.set_updated_at();

drop trigger if exists trg_customers_set_updated_at on public.customers;
create trigger trg_customers_set_updated_at
before update on public.customers
for each row execute function public.set_updated_at();

drop trigger if exists trg_restaurants_set_updated_at on public.restaurants;
create trigger trg_restaurants_set_updated_at
before update on public.restaurants
for each row execute function public.set_updated_at();

drop trigger if exists trg_restaurant_categories_set_updated_at on public.restaurant_categories;
create trigger trg_restaurant_categories_set_updated_at
before update on public.restaurant_categories
for each row execute function public.set_updated_at();

drop trigger if exists trg_restaurant_items_set_updated_at on public.restaurant_items;
create trigger trg_restaurant_items_set_updated_at
before update on public.restaurant_items
for each row execute function public.set_updated_at();

drop trigger if exists trg_delivery_partners_set_updated_at on public.delivery_partners;
create trigger trg_delivery_partners_set_updated_at
before update on public.delivery_partners
for each row execute function public.set_updated_at();

drop trigger if exists trg_orders_set_updated_at on public.orders;
create trigger trg_orders_set_updated_at
before update on public.orders
for each row execute function public.set_updated_at();

drop trigger if exists trg_dp_wallet_set_updated_at on public.dp_wallet;
create trigger trg_dp_wallet_set_updated_at
before update on public.dp_wallet
for each row execute function public.set_updated_at();

drop trigger if exists trg_order_items_validate_restaurant on public.order_items;
create trigger trg_order_items_validate_restaurant
before insert or update on public.order_items
for each row execute function public.validate_order_items_restaurant();

drop trigger if exists trg_orders_enforce_dp_limits on public.orders;
create trigger trg_orders_enforce_dp_limits
before insert or update of dp_id, status on public.orders
for each row execute function public.enforce_dp_assignment_limits();

drop trigger if exists trg_orders_set_dp_ring_window on public.orders;
create trigger trg_orders_set_dp_ring_window
before update of status on public.orders
for each row execute function public.set_dp_ring_window();
