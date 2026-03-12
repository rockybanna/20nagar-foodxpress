// ---------- SUPABASE CONFIG ----------

const SUPABASE_URL = "https://uouwizrknwrqqynodplv.supabase.co";

const SUPABASE_ANON_KEY =
"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVvdXdpenJrbndycXF5bm9kcGx2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMwNDk1MjksImV4cCI6MjA4ODYyNTUyOX0.oxDZqaT1bMed6uuirN2ZoDCambPYLhOHp2PlhX8gaco";

// create client once for entire app
const supabaseClient = window.supabase.createClient(
  SUPABASE_URL,
  SUPABASE_ANON_KEY
);
```
