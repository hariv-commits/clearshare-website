-- ClearShare database schema (Supabase / Postgres)
-- Run once in Supabase → SQL Editor. Safe to re-run.

create extension if not exists pgcrypto;

-- ---------- candidates ----------
create table if not exists public.candidates (
  id                 uuid primary key default gen_random_uuid(),
  created_at         timestamptz not null default now(),
  first_name         text not null,
  last_name          text not null,
  preferred_name     text,
  email              text not null,
  phone              text,
  location           text,
  desired_roles      text,
  technologies       text[] not null default '{}',   -- e.g. {Kubernetes,Go,AWS}
  skills_detail      text,                            -- free text with years per skill
  years_experience   numeric,
  work_arrangement   text,                            -- Remote / Hybrid / On-site / Flexible
  available_from     date,
  engagement_types   text[] not null default '{}',
  target_comp        text,
  current_bill_rate  numeric,                         -- $/hr, optional
  current_share_pct  numeric,                         -- %, optional
  visa_status        text,                            -- H-1B, F-1 OPT/STEM, Green card, Citizen, Other, Prefer not to say
  privacy_ack        boolean not null default false,
  privacy_version    text,
  email_optin        boolean not null default false,
  sms_optin          boolean not null default false,
  status             text not null default 'new',     -- new / contacted / introduced / placed / closed
  notes              text,
  source             text not null default 'website'
);
create index if not exists candidates_created_at_idx on public.candidates (created_at desc);
create index if not exists candidates_technologies_idx on public.candidates using gin (technologies);
create index if not exists candidates_status_idx on public.candidates (status);

alter table public.candidates enable row level security;

drop policy if exists "public can submit" on public.candidates;
create policy "public can submit" on public.candidates
  for insert to anon with check (true);

drop policy if exists "admins can read" on public.candidates;
create policy "admins can read" on public.candidates
  for select to authenticated using (true);

drop policy if exists "admins can update" on public.candidates;
create policy "admins can update" on public.candidates
  for update to authenticated using (true) with check (true);

-- ---------- employer inquiries ----------
create table if not exists public.employer_inquiries (
  id              uuid primary key default gen_random_uuid(),
  created_at      timestamptz not null default now(),
  company         text not null,
  contact_name    text not null,
  work_email      text not null,
  preferred_contact text,
  role            text,
  location        text,
  urgency         text,
  hiring_need     text,
  status          text not null default 'new',
  notes           text
);
alter table public.employer_inquiries enable row level security;

drop policy if exists "public can submit" on public.employer_inquiries;
create policy "public can submit" on public.employer_inquiries
  for insert to anon with check (true);

drop policy if exists "admins can read" on public.employer_inquiries;
create policy "admins can read" on public.employer_inquiries
  for select to authenticated using (true);

drop policy if exists "admins can update" on public.employer_inquiries;
create policy "admins can update" on public.employer_inquiries
  for update to authenticated using (true) with check (true);

-- Admin accounts are created by hand in Supabase → Authentication → Users.
-- Turn OFF "Allow new users to sign up" in Authentication → Providers → Email,
-- so only accounts you create can log in.
