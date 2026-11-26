-- SR Select Pedidos: configuración de Supabase.
-- Pegar completo en Supabase > SQL Editor > New query > Run.

-- 1. Tabla única para pedidos, gastos, compras, ventas y fotos de la sección navideña.
create table if not exists public.docs (
  col        text   not null,                      -- colección: pedidos, gastos, nav_compras, nav_ventas, nav_gastos, nav_fotos
  id         text   not null default gen_random_uuid()::text,
  data       jsonb  not null default '{}'::jsonb,
  creado     bigint,
  updated_at timestamptz not null default now(),
  primary key (col, id)
);
create index if not exists docs_col_creado on public.docs (col, creado desc);

-- 2. Solo usuarios con sesión iniciada pueden leer y escribir.
alter table public.docs enable row level security;
drop policy if exists "usuarios con sesion" on public.docs;
create policy "usuarios con sesion" on public.docs
  for all to authenticated using (true) with check (true);

-- 3. Cambios en vivo (si tienes la app abierta en dos equipos, se actualiza sola).
alter table public.docs replica identity full;
do $$ begin
  alter publication supabase_realtime add table public.docs;
exception when duplicate_object then null; end $$;

-- 4. Almacenamiento privado para las fotos.
insert into storage.buckets (id, name, public) values ('fotos', 'fotos', false)
on conflict (id) do nothing;
drop policy if exists "fotos leer" on storage.objects;
drop policy if exists "fotos subir" on storage.objects;
drop policy if exists "fotos borrar" on storage.objects;
create policy "fotos leer"   on storage.objects for select to authenticated using (bucket_id = 'fotos');
create policy "fotos subir"  on storage.objects for insert to authenticated with check (bucket_id = 'fotos');
create policy "fotos borrar" on storage.objects for delete to authenticated using (bucket_id = 'fotos');
