create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$;

create table if not exists public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  email text unique,
  created_at timestamptz not null default timezone('utc', now())
);

create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (id, email)
  values (new.id, new.email)
  on conflict (id) do update set email = excluded.email;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_auth_user();

create table if not exists public.user_profiles (
  id uuid primary key references public.users(id) on delete cascade,
  email text,
  display_name text not null,
  activity_level text not null check (activity_level in ('calm', 'balanced', 'active')),
  hydration_baseline_ml integer not null default 1800,
  hydration_target_ml integer not null default 2200,
  sleep_baseline_hours numeric(4,1) not null default 7.0,
  sleep_target_hours numeric(4,1) not null default 7.5,
  program_length_days integer not null check (program_length_days in (7, 14, 21)),
  starting_weight_kg numeric(6,2),
  personal_note text not null default '',
  locale_code text not null default 'uk',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create trigger trg_user_profiles_updated_at
before update on public.user_profiles
for each row execute procedure public.set_updated_at();

create table if not exists public.goals (
  goal_key text primary key,
  title_uk text not null,
  title_en text,
  description_uk text not null,
  description_en text,
  icon_key text not null,
  sort_order integer not null default 0
);

create table if not exists public.user_goals (
  user_id uuid not null references public.users(id) on delete cascade,
  goal_key text not null references public.goals(goal_key) on delete restrict,
  created_at timestamptz not null default timezone('utc', now()),
  primary key (user_id, goal_key)
);

create table if not exists public.product_categories (
  id text primary key,
  title_uk text not null,
  title_en text,
  subtitle_uk text not null,
  subtitle_en text,
  icon_key text not null,
  sort_order integer not null default 0
);

create table if not exists public.product_tags (
  id bigserial primary key,
  slug text unique not null,
  label_uk text not null
);

create table if not exists public.products (
  id text primary key,
  category_id text not null references public.product_categories(id) on delete restrict,
  title_uk text not null,
  title_en text,
  short_description_uk text not null,
  short_description_en text,
  usage_notes_uk text not null,
  usage_notes_en text,
  caution_notes_uk text not null,
  caution_notes_en text,
  image_token text not null,
  external_product_url text not null,
  highlight_uk text not null,
  highlight_en text,
  is_featured boolean not null default false,
  wellness_tags text[] not null default '{}',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create trigger trg_products_updated_at
before update on public.products
for each row execute procedure public.set_updated_at();

create table if not exists public.product_tag_links (
  product_id text not null references public.products(id) on delete cascade,
  tag_id bigint not null references public.product_tags(id) on delete cascade,
  primary key (product_id, tag_id)
);

create table if not exists public.plans (
  plan_code text primary key,
  title_uk text not null,
  description_uk text not null,
  duration_days integer not null check (duration_days in (7, 14, 21)),
  goal_keys text[] not null default '{}',
  is_active boolean not null default true
);

create table if not exists public.plan_days (
  id uuid primary key default gen_random_uuid(),
  plan_code text not null references public.plans(plan_code) on delete cascade,
  day_number integer not null,
  title_uk text not null,
  hydration_task_uk text not null,
  wellness_action_uk text not null,
  journal_prompt_uk text not null,
  checklist_labels_uk jsonb not null default '[]'::jsonb,
  suggested_product_ids text[] not null default '{}',
  unique (plan_code, day_number)
);

create table if not exists public.user_plan_assignments (
  user_id uuid primary key references public.users(id) on delete cascade,
  plan_code text not null,
  title text not null,
  description text not null,
  duration_days integer not null,
  goal_keys text[] not null default '{}',
  start_date timestamptz not null,
  adherence_score numeric(6,4) not null default 0,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create trigger trg_user_plan_assignments_updated_at
before update on public.user_plan_assignments
for each row execute procedure public.set_updated_at();

create table if not exists public.daily_logs (
  user_id uuid not null references public.users(id) on delete cascade,
  log_date timestamptz not null,
  water_ml integer not null default 0,
  sleep_hours numeric(4,1) not null default 0,
  weight_kg numeric(6,2),
  mood_score integer not null default 3 check (mood_score between 1 and 5),
  notes text not null default '',
  completed_checklist_ids text[] not null default '{}',
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  primary key (user_id, log_date)
);

create trigger trg_daily_logs_updated_at
before update on public.daily_logs
for each row execute procedure public.set_updated_at();

create table if not exists public.reminders (
  user_id uuid not null references public.users(id) on delete cascade,
  reminder_key text not null,
  type text not null,
  title text not null,
  description text not null,
  hour integer not null check (hour between 0 and 23),
  minute integer not null check (minute between 0 and 59),
  is_enabled boolean not null default false,
  updated_at timestamptz not null default timezone('utc', now()),
  primary key (user_id, reminder_key)
);

create trigger trg_reminders_updated_at
before update on public.reminders
for each row execute procedure public.set_updated_at();

create table if not exists public.outbound_clicks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id) on delete cascade,
  product_id text references public.products(id) on delete set null,
  destination_url text not null,
  source text not null,
  created_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.consents (
  user_id uuid not null references public.users(id) on delete cascade,
  consent_type text not null check (consent_type in ('disclaimer', 'privacy_policy', 'terms_of_use')),
  consent_version text not null,
  accepted_at timestamptz not null,
  source text not null,
  created_at timestamptz not null default timezone('utc', now()),
  primary key (user_id, consent_type, consent_version)
);

create table if not exists public.app_config (
  key text primary key,
  value jsonb not null,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create trigger trg_app_config_updated_at
before update on public.app_config
for each row execute procedure public.set_updated_at();

create index if not exists idx_products_category_id on public.products(category_id);
create index if not exists idx_products_wellness_tags on public.products using gin (wellness_tags);
create index if not exists idx_daily_logs_user_id on public.daily_logs(user_id);
create index if not exists idx_outbound_clicks_user_id on public.outbound_clicks(user_id);

alter table public.users enable row level security;
alter table public.user_profiles enable row level security;
alter table public.goals enable row level security;
alter table public.user_goals enable row level security;
alter table public.product_categories enable row level security;
alter table public.product_tags enable row level security;
alter table public.product_tag_links enable row level security;
alter table public.products enable row level security;
alter table public.plans enable row level security;
alter table public.plan_days enable row level security;
alter table public.user_plan_assignments enable row level security;
alter table public.daily_logs enable row level security;
alter table public.reminders enable row level security;
alter table public.outbound_clicks enable row level security;
alter table public.consents enable row level security;
alter table public.app_config enable row level security;

create policy "users_can_view_own_user_record"
on public.users for select
using (auth.uid() = id);

create policy "users_can_view_own_profile"
on public.user_profiles for select
using (auth.uid() = id);

create policy "users_can_upsert_own_profile"
on public.user_profiles for all
using (auth.uid() = id)
with check (auth.uid() = id);

create policy "public_can_read_goals"
on public.goals for select
using (true);

create policy "authenticated_can_manage_own_user_goals"
on public.user_goals for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "public_can_read_product_categories"
on public.product_categories for select
using (true);

create policy "public_can_read_product_tags"
on public.product_tags for select
using (true);

create policy "public_can_read_product_tag_links"
on public.product_tag_links for select
using (true);

create policy "public_can_read_products"
on public.products for select
using (true);

create policy "public_can_read_plans"
on public.plans for select
using (true);

create policy "public_can_read_plan_days"
on public.plan_days for select
using (true);

create policy "authenticated_can_manage_own_plan_assignment"
on public.user_plan_assignments for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "authenticated_can_manage_own_daily_logs"
on public.daily_logs for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "authenticated_can_manage_own_reminders"
on public.reminders for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "authenticated_can_manage_own_outbound_clicks"
on public.outbound_clicks for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "authenticated_can_manage_own_consents"
on public.consents for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "authenticated_can_view_own_consents"
on public.consents for select
using (auth.uid() = user_id);

create policy "public_can_read_app_config"
on public.app_config for select
using (is_active = true);
