```javascript
// Supabase configuration
const SUPABASE_URL = "https://uouwizrknwrqqynodplv.supabase.co";
const SUPABASE_ANON_KEY =
"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVvdXdpenJrbndycXF5bm9kcGx2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMwNDk1MjksImV4cCI6MjA4ODYyNTUyOX0.oxDZqaT1bMed6uuirN2ZoDCambPYLhOHp2PlhX8gaco";

const supabaseClient = window.supabase.createClient(
  SUPABASE_URL,
  SUPABASE_ANON_KEY
);

// ---------- AUTH ----------

async function signup(){
  const email = document.getElementById("email").value;
  const password = document.getElementById("password").value;

  const { error } = await supabaseClient.auth.signUp({
    email,
    password
  });

  document.getElementById("message").innerText =
    error ? error.message : "Signup successful. Check email.";
}

async function login(){

  const email = document.getElementById("email").value;
  const password = document.getElementById("password").value;

  const { data, error } =
  await supabaseClient.auth.signInWithPassword({
    email,
    password
  });

  if(error){
    document.getElementById("message").innerText = error.message;
    return;
  }

  const user = data.user;

  const { data: profile, error: roleError } =
  await supabaseClient
  .from("users")
  .select("role")
  .eq("id", user.id)
  .single();

  if(roleError){
    document.getElementById("message").innerText =
    "Unable to read role.";
    return;
  }

  const role = profile.role;

  if(role === "customer") window.location.href="./customer/";
  if(role === "restaurant") window.location.href="./restaurant/";
  if(role === "delivery_partner") window.location.href="./delivery/";
  if(role === "payment_verifier") window.location.href="./verifier/";
  if(role === "admin") window.location.href="./admin/";
}
```
