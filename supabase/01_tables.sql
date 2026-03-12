-- FoodXpress backend foundation: core tables and constraints
-- Run this file first in Supabase SQL Editor.

create extension if not exists pgcrypto;

create type public.user_role as enum ('customer', 'restaurant', 'delivery_partner', 'admin');
create type public.order_status as enum (
  'placed',
  'restaurant_accepted',
  'preparing',
  'ready_for_pickup',
  'dp_assigned',
  'picked_up',
  'out_for_delivery',
  'delivered',
  'cancelled'
);
create type public.payment_method as enum ('cod', 'wallet');
create type public.transaction_type as enum ('credit', 'debit', 'settlement', 'refund');

create table if not exists public.users (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  phone text not null unique,
  role public.user_role not null,
  password_hash text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.customers (
  user_id uuid primary key references public.users(id) on delete cascade,
  address text not null,
  lat double precision,
  lng double precision,
  delivery_charge numeric(10,2) not null default 0 check (delivery_charge >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.restaurants (
  id uuid primary key default gen_random_uuid(),
  owner_user_id uuid unique references public.users(id) on delete set null,
  name text not null,
  lat double precision,
  lng double precision,
  is_open boolean not null default false,
  preparation_time_min smallint not null default 10 check (preparation_time_min between 10 and 45),
  preparation_time_max smallint not null default 30 check (preparation_time_max between 10 and 45),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint restaurants_preparation_time_range_chk check (preparation_time_min <= preparation_time_max)
);

create table if not exists public.restaurant_categories (
  id uuid primary key default gen_random_uuid(),
  restaurant_id uuid not null references public.restaurants(id) on delete cascade,
  name text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (restaurant_id, name)
);

create table if not exists public.restaurant_items (
  id uuid primary key default gen_random_uuid(),
  restaurant_id uuid not null references public.restaurants(id) on delete cascade,
  category_id uuid not null references public.restaurant_categories(id) on delete cascade,
  name text not null,
  price numeric(10,2) not null check (price >= 0),
  image_url text,
  is_available boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.delivery_partners (
  user_id uuid primary key references public.users(id) on delete cascade,
  is_online boolean not null default false,
  current_lat double precision,
  current_lng double precision,
  performance_score numeric(4,2) not null default 0 check (performance_score between 0 and 5),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.customers(user_id) on delete restrict,
  restaurant_id uuid not null references public.restaurants(id) on delete restrict,
  dp_id uuid references public.delivery_partners(user_id) on delete set null,
  status public.order_status not null default 'placed',
  order_amount numeric(10,2) not null check (order_amount between 149 and 5000),
  delivery_fee numeric(10,2) not null default 0 check (delivery_fee >= 0),
  payment_method public.payment_method not null,
  prep_time_minutes smallint check (prep_time_minutes between 10 and 45),
  dp_ring_started_at timestamptz,
  dp_ring_attempts smallint not null default 0 check (dp_ring_attempts between 0 and 5),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  item_id uuid not null references public.restaurant_items(id) on delete restrict,
  quantity integer not null check (quantity > 0),
  price numeric(10,2) not null check (price >= 0),
  created_at timestamptz not null default now(),
  unique (order_id, item_id)
);

create table if not exists public.dp_wallet (
  dp_id uuid primary key references public.delivery_partners(user_id) on delete cascade,
  balance numeric(12,2) not null default 0,
  updated_at timestamptz not null default now()
);

create table if not exists public.transactions (
  id uuid primary key default gen_random_uuid(),
  order_id uuid references public.orders(id) on delete set null,
  dp_id uuid references public.delivery_partners(user_id) on delete set null,
  type public.transaction_type not null,
  amount numeric(12,2) not null check (amount > 0),
  created_at timestamptz not null default now()
);
