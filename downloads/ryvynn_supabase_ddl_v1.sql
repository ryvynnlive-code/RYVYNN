
-- RYVYNN Unified Ops Dashboard — Supabase DDL (Verum Alignment v1.0)
-- Generated at 2025-10-28T16:32:40.219639Z

create schema if not exists ryvynn_ops;

-- Enums
do $$ begin
    create type ryvynn_ops.status_t as enum ('Complete','Pending Review','In Progress','Hold','Fail-Safe Lock');
exception when duplicate_object then null; end $$;

do $$ begin
    create type ryvynn_ops.priority_t as enum ('P0','P1','P2','P3');
exception when duplicate_object then null; end $$;

-- Common table pattern macro (for reference):
-- id (text pk), title, owner, status, priority, tags (text[]), created_at, updated_at

create table if not exists ryvynn_ops.strategy_hub (
  id text primary key,
  title text not null,
  owner text,
  status ryvynn_ops.status_t not null,
  priority ryvynn_ops.priority_t not null,
  tags text[] default '{}',
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  objective text,
  kpis text[] default '{}',
  milestone_date date,
  notes text
);

create table if not exists ryvynn_ops.investor_vault (
  id text primary key,
  title text not null,
  owner text,
  status ryvynn_ops.status_t not null,
  priority ryvynn_ops.priority_t not null,
  tags text[] default '{}',
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  artifact_type text check (artifact_type in ('Offer Sheet','Investor Teaser','Landing Hero','Other')),
  version text,
  link text,
  reviewer text,
  next_step text
);

create table if not exists ryvynn_ops.compliance_core (
  id text primary key,
  title text not null,
  owner text,
  status ryvynn_ops.status_t not null,
  priority ryvynn_ops.priority_t not null,
  tags text[] default '{}',
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  category text check (category in ('IP','Data Privacy','Security','Legal','Brand')),
  risk_level text check (risk_level in ('Low','Medium','High','Critical')),
  recommendation text,
  decision text
);

create table if not exists ryvynn_ops.tech_execution_log (
  id text primary key,
  title text not null,
  owner text,
  status ryvynn_ops.status_t not null,
  priority ryvynn_ops.priority_t not null,
  tags text[] default '{}',
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  component text,
  env text check (env in ('dev','staging','prod')),
  commit_hash text,
  integration text,
  result text
);

create table if not exists ryvynn_ops.intelligence_feed (
  id text primary key,
  title text not null,
  owner text,
  status ryvynn_ops.status_t not null,
  priority ryvynn_ops.priority_t not null,
  tags text[] default '{}',
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  source text,
  summary text,
  confidence numeric check (confidence >= 0 and confidence <= 1)
);

create table if not exists ryvynn_ops.ethics_sentinel (
  id text primary key,
  title text not null,
  owner text,
  status ryvynn_ops.status_t not null,
  priority ryvynn_ops.priority_t not null,
  tags text[] default '{}',
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  detected_issue text,
  impact text,
  proposed_fix text
);

create table if not exists ryvynn_ops.founder_command_layer (
  id text primary key,
  title text not null,
  owner text,
  status ryvynn_ops.status_t not null,
  priority ryvynn_ops.priority_t not null,
  tags text[] default '{}',
  created_at timestamptz default now() not null,
  updated_at timestamptz default now() not null,
  directive text,
  assigned_to text,
  due_date date,
  acceptance_criteria text
);

-- RLS
alter table ryvynn_ops.strategy_hub enable row level security;
alter table ryvynn_ops.investor_vault enable row level security;
alter table ryvynn_ops.compliance_core enable row level security;
alter table ryvynn_ops.tech_execution_log enable row level security;
alter table ryvynn_ops.intelligence_feed enable row level security;
alter table ryvynn_ops.ethics_sentinel enable row level security;
alter table ryvynn_ops.founder_command_layer enable row level security;

-- Basic policies (adjust to your auth model). Example: only authenticated users can read; only 'founder' and 'verum' roles can write.
-- Replace `auth.jwt()` role checks with your chosen claim strategy.

-- READ for authenticated
do $$ begin
  create policy "read_all_auth"
  on ryvynn_ops.strategy_hub for select
  to authenticated using (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "read_all_auth_iv"
  on ryvynn_ops.investor_vault for select
  to authenticated using (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "read_all_auth_cc"
  on ryvynn_ops.compliance_core for select
  to authenticated using (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "read_all_auth_tl"
  on ryvynn_ops.tech_execution_log for select
  to authenticated using (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "read_all_auth_if"
  on ryvynn_ops.intelligence_feed for select
  to authenticated using (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "read_all_auth_es"
  on ryvynn_ops.ethics_sentinel for select
  to authenticated using (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "read_all_auth_cmd"
  on ryvynn_ops.founder_command_layer for select
  to authenticated using (true);
exception when duplicate_object then null; end $$;

-- WRITE only for founder/verum roles
-- Assumes JWT has 'role' claim. Adjust to your auth provider.
create or replace function ryvynn_ops.has_write_role() returns boolean language sql as $$
  select coalesce(current_setting('request.jwt.claims', true)::jsonb->>'role','') in ('founder','verum');
$$;

do $$ begin
  create policy "write_founder_verum"
  on ryvynn_ops.strategy_hub for insert to authenticated
  with check (ryvynn_ops.has_write_role());
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "update_founder_verum"
  on ryvynn_ops.strategy_hub for update to authenticated
  using (ryvynn_ops.has_write_role()) with check (ryvynn_ops.has_write_role());
exception when duplicate_object then null; end $$;

-- Repeat for other tables
do $$ begin
  create policy "write_founder_verum_iv"
  on ryvynn_ops.investor_vault for insert to authenticated
  with check (ryvynn_ops.has_write_role());
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "update_founder_verum_iv"
  on ryvynn_ops.investor_vault for update to authenticated
  using (ryvynn_ops.has_write_role()) with check (ryvynn_ops.has_write_role());
exception when duplicate_object then null; end $$;

do $$ begin
  create policy "write_founder_verum_cc"
  on ryvynn_ops.compliance_core for insert to authenticated
  with check (ryvynn_ops.has_write_role());
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "update_founder_verum_cc"
  on ryvynn_ops.compliance_core for update to authenticated
  using (ryvynn_ops.has_write_role()) with check (ryvynn_ops.has_write_role());
exception when duplicate_object then null; end $$;

do $$ begin
  create policy "write_founder_verum_tl"
  on ryvynn_ops.tech_execution_log for insert to authenticated
  with check (ryvynn_ops.has_write_role());
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "update_founder_verum_tl"
  on ryvynn_ops.tech_execution_log for update to authenticated
  using (ryvynn_ops.has_write_role()) with check (ryvynn_ops.has_write_role());
exception when duplicate_object then null; end $$;

do $$ begin
  create policy "write_founder_verum_if"
  on ryvynn_ops.intelligence_feed for insert to authenticated
  with check (ryvynn_ops.has_write_role());
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "update_founder_verum_if"
  on ryvynn_ops.intelligence_feed for update to authenticated
  using (ryvynn_ops.has_write_role()) with check (ryvynn_ops.has_write_role());
exception when duplicate_object then null; end $$;

do $$ begin
  create policy "write_founder_verum_es"
  on ryvynn_ops.ethics_sentinel for insert to authenticated
  with check (ryvynn_ops.has_write_role());
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "update_founder_verum_es"
  on ryvynn_ops.ethics_sentinel for update to authenticated
  using (ryvynn_ops.has_write_role()) with check (ryvynn_ops.has_write_role());
exception when duplicate_object then null; end $$;

do $$ begin
  create policy "write_founder_verum_cmd"
  on ryvynn_ops.founder_command_layer for insert to authenticated
  with check (ryvynn_ops.has_write_role());
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "update_founder_verum_cmd"
  on ryvynn_ops.founder_command_layer for update to authenticated
  using (ryvynn_ops.has_write_role()) with check (ryvynn_ops.has_write_role());
exception when duplicate_object then null; end $$;
