-- FoodXpress core schema for customer-first rollout

create extension if not exists "uuid-ossp";

create table if not exists public.users (
  id uuid primary key,
  role text not null check (role in ('customer','restaurant','delivery_partner','payment_verifier','admin')),
  created_at timestamptz not null default now()
);

create table if not exists public.customers (
  id uuid primary key references public.users(id) on delete cascade,
  full_name text,
  latitude double precision,
  longitude double precision,
  created_at timestamptz not null default now()
);

create table if not exists public.restaurants (
  id uuid primary key default uuid_generate_v4(),
  name text not null,
  cuisine text,
  description text,
  rating numeric(2,1) default 0,
  is_open boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.menu_items (
  id uuid primary key default uuid_generate_v4(),
  restaurant_id uuid not null references public.restaurants(id) on delete cascade,
  name text not null,
  description text,
  price numeric(10,2) not null check (price >= 0),
  is_available boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.orders (
  id uuid primary key default uuid_generate_v4(),
  customer_id uuid not null references public.customers(id) on delete cascade,
  restaurant_id uuid not null references public.restaurants(id) on delete restrict,
  status text not null default 'pending_payment' check (status in ('pending_payment','payment_submitted','confirmed','preparing','ready_for_pickup','out_for_delivery','delivered','cancelled')),
  total_amount numeric(10,2) not null check (total_amount >= 0),
  payment_proof_url text,
  delivery_latitude double precision,
  delivery_longitude double precision,
  created_at timestamptz not null default now()
);

create table if not exists public.order_items (
  id bigserial primary key,
  order_id uuid not null references public.orders(id) on delete cascade,
  menu_item_id uuid not null references public.menu_items(id) on delete restrict,
  quantity integer not null check (quantity > 0),
  unit_price numeric(10,2) not null check (unit_price >= 0)
);

create index if not exists idx_menu_items_restaurant_id on public.menu_items(restaurant_id);
create index if not exists idx_orders_customer_id on public.orders(customer_id);
create index if not exists idx_orders_restaurant_id on public.orders(restaurant_id);
