const supabaseClient = window.supabase.createClient(
  SUPABASE_URL,
  SUPABASE_ANON_KEY
);

/* =========================
   SIGNUP
========================= */

async function signup() {

  const email = document.getElementById("email").value;
  const password = document.getElementById("password").value;

  const { data, error } = await supabaseClient.auth.signUp({
    email: email,
    password: password
  });

  if (error) {
    document.getElementById("message").innerText = error.message;
    return;
  }

  document.getElementById("message").innerText =
    "Signup successful. Please confirm email before login.";

}


/* =========================
   LOGIN
========================= */

async function login() {

  const email = document.getElementById("email").value;
  const password = document.getElementById("password").value;

  const { data, error } = await supabaseClient.auth.signInWithPassword({
    email: email,
    password: password
  });

  if (error) {
    document.getElementById("message").innerText = error.message;
    return;
  }

  document.getElementById("message").innerText = "Login successful";

  const user = data.user;

  /* get user role */

  const { data: profile, error: roleError } = await supabaseClient
    .from("users")
    .select("role")
    .eq("id", user.id)
    .single();

  if (roleError) {
    console.error(roleError);
    document.getElementById("message").innerText =
      "Unable to read user role.";
    return;
  }

  const role = profile.role;

  console.log("User role:", role);

  /* ROLE REDIRECTS */

  if (role === "customer") {
    window.location.href = "./customer/";
    return;
  }

  if (role === "restaurant") {
    window.location.href = "./restaurant/";
    return;
  }

  if (role === "delivery_partner") {
    window.location.href = "./delivery/";
    return;
  }

  if (role === "payment_verifier") {
    window.location.href = "./verifier/";
    return;
  }

  if (role === "admin") {
    window.location.href = "./admin/";
    return;
  }

  /* fallback */

  document.getElementById("message").innerText =
    "User role not configured.";

}
