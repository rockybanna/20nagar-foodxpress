// ---------- AUTH FUNCTIONS ---------- // 
signup
async function signup(){

  const email = document.getElementById("email").value.trim();
  const password = document.getElementById("password").value.trim();

  if(!email || !password){
    document.getElementById("message").innerText="Enter email and password";
    return;
  }

  const { error } = await supabaseClient.auth.signUp({
    email,
    password
  });

  if(error){
    document.getElementById("message").innerText = error.message;
    return;
  }

  document.getElementById("message").innerText =
  "Signup successful. Check email.";

}


// login
async function login(){

  const email = document.getElementById("email").value.trim();
  const password = document.getElementById("password").value.trim();

  if(!email || !password){
    document.getElementById("message").innerText="Enter email and password";
    return;
  }

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

  // read role
  const { data: profile, error: roleError } =
  await supabaseClient
  .from("users")
  .select("role")
  .eq("id", user.id)
  .single();

  if(roleError){
    document.getElementById("message").innerText =
    "User role not configured.";
    return;
  }

  const role = profile.role;

  // redirect by role
  if(role==="customer"){
    window.location.href="./customer/";
  }

  else if(role==="restaurant"){
    window.location.href="./restaurant/";
  }

  else if(role==="delivery_partner"){
    window.location.href="./delivery/";
  }

  else if(role==="payment_verifier"){
    window.location.href="./verifier/";
  }

  else if(role==="admin"){
    window.location.href="./admin/";
  }

  else{
    document.getElementById("message").innerText=
    "Unknown role assigned.";
  }

}
