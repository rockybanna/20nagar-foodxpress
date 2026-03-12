# Supabase backend setup (FoodXpress)

This project now includes a starter Supabase backend structure for pushing schema changes.

## Included files
- `config.toml` — local Supabase CLI configuration.
- `migrations/202603120001_initial_schema.sql` — initial customer-first schema.

## Push backend to Supabase
1. Install Supabase CLI.
2. Login:
   ```bash
   supabase login
   ```
3. Link your project:
   ```bash
   supabase link --project-ref <your-project-ref>
   ```
4. Push migrations:
   ```bash
   supabase db push
   ```

## Notes
- The frontend currently uses the Supabase URL and anon key in `js/config.js`.
- For production, move keys to environment-managed configuration.
