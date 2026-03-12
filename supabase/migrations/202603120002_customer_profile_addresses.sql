-- Customer profile + reusable delivery addresses

alter table if exists public.customers
  add column if not exists phone text;

create table if not exists public.addresses (
  id uuid primary key default uuid_generate_v4(),
  customer_id uuid not null references public.customers(id) on delete cascade,
  label text not null,
  address_line text,
  latitude double precision not null,
  longitude double precision not null,
  is_default boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists idx_addresses_customer_id on public.addresses(customer_id);

alter table if exists public.orders
  add column if not exists delivery_address_id uuid references public.addresses(id) on delete set null;
