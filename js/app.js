const supabase = supabase.createClient(
  SUPABASE_URL,
  SUPABASE_ANON_KEY
);

console.log("Connected to Supabase:", SUPABASE_URL);
