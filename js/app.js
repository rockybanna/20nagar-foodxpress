// SUPABASE CONFIG
const SUPABASE_URL = "https://uouwizrknwrqqynodplv.supabase.co";
const SUPABASE_ANON_KEY = "PASTE_YOUR_ANON_PUBLIC_KEY_HERE";

// CREATE CLIENT
const supabaseClient = window.supabase.createClient(
  SUPABASE_URL,
  SUPABASE_ANON_KEY
);


// SIGNUP
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
    document.getElementById("message").innerText =
      "Signup successful. Check email.";
  }

}


// LOGIN
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

  const { data: profile, error: roleError } = await supabaseClient
    .from("users")
    .select("role")
    .eq("id", user.id)
    .single();

  if (roleError) {
    console.log(roleError);
    document.getElementById("message").innerText = "Unable to read user role.";
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
