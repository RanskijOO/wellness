# Supabase Setup

## Required Components

- Supabase project
- Auth enabled for email/password
- Database access for migration and seed

## Steps

1. Create a new Supabase project.
2. Link the repo with the Supabase CLI.
3. Run the migration:

```bash
supabase db push
```

4. Seed content:

```bash
supabase db reset --linked
```

5. Copy the project URL and anon key into `assets/env/app.env`.

## Tables Created

- `users`
- `user_profiles`
- `goals`
- `user_goals`
- `product_categories`
- `product_tags`
- `product_tag_links`
- `products`
- `plans`
- `plan_days`
- `user_plan_assignments`
- `daily_logs`
- `reminders`
- `outbound_clicks`
- `consents`
- `app_config`

## Notes

- The app currently uses local-first persistence and gracefully falls back when Supabase is not configured.
- Product categories and products are seeded with `*_uk` and `*_en` fields so English content can be added without a schema rewrite.
- In production, review every RLS policy and add environment-specific monitoring and backups.
