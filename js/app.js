const supabaseClient = window.supabase.createClient(
  SUPABASE_URL,
  SUPABASE_ANON_KEY
);

async function signup() {
  const email = document.getElementById("email").value;
  const password = document.getElementById("password").value;

  const { data, error } = await supabaseClient.auth.signUp({
    email: email,
    password: password
  });

  if (error) {
    document.getElementById("message").innerText = error.message;
  } else {
    document.getElementById("message").innerText = "Signup successful. Check email.";
  }
}

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

  // get role from users table
  const { data: profile, error: roleError } = await supabaseClient
    .from("users")
    .select("role")
    .eq("id", user.id)
    .single();

  if (roleError) {
    console.log(roleError);
    return;
  }

  const role = profile.role;

  if (role === "customer") {
    window.location.href = "./customer/";
  }

  if (role === "restaurant") {
    window.location.href = "./restaurant/";
  }

  if (role === "delivery_partner") {
    window.location.href = "./delivery/";
  }

  if (role === "payment_verifier") {
    window.location.href = "./verifier/";
  }

  if (role === "admin") {
    window.location.href = "./admin/";
  }
}
