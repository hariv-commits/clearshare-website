# ClearShare Technologies — website + admin

Static site on Vercel (clearsharetechnologies.com), with a Supabase database behind the
forms and a login-protected admin page.

- `index.html` — public site (home, referral form, employer inquiry, share)
- `admin.html` — admin login and candidate/employer database (filters, status, notes, CSV)
- `config.js` — public config: Supabase URL + anon key, optional Web3Forms key
- `supabase/schema.sql` — database tables and row-level security
- `manifest.webmanifest`, `icon-*.png`, `favicon.png`, `qr.png`, `vercel.json`

## One-time setup

1. **Supabase project** (free): supabase.com → New project → name `clearshare`, choose a
   region in the US, set a strong database password (keep it; it is not used by the site).
2. **Schema**: Supabase → SQL Editor → paste `supabase/schema.sql` → Run.
3. **Lock down sign-ups**: Authentication → Providers → Email → turn **off**
   "Allow new users to sign up". (Admins are created by hand.)
4. **Create the admin user**: Authentication → Users → Add user → email + password,
   tick "Auto confirm". This is the login for `/admin`.
5. **Keys**: Settings → API → copy **Project URL** and the **anon public** key into
   `config.js`. (The anon key is safe to publish; RLS limits it to inserting rows.)
6. Optional **email notification** on every submission: web3forms.com → enter the
   ClearShare Gmail → paste the access key into `config.js` as `FORM_KEY`.
7. Push to `main`; Vercel deploys. Admin page: https://clearsharetechnologies.com/admin

## Security model
- Public visitors can only INSERT into `candidates` and `employer_inquiries`.
- Only signed-in (authenticated) users can SELECT/UPDATE. No DELETE from the site.
- `/admin` is `noindex`; the login is Supabase Auth email + password. Enable MFA for the
  admin account in Supabase when ready.
- Candidate data is personal data: review the Privacy Notice before launch.
