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

  if(error){
    document.getElementById("message").innerText = error.message;
  } else {
    document.getElementById("message").innerText = "Signup successful. Check email.";
  }

}

async function login(){

  const email = document.getElementById("email").value;
  const password = document.getElementById("password").value;

  const { data, error } = await supabaseClient.auth.signInWithPassword({
    email: email,
    password: password
  });

  if(error){
    document.getElementById("message").innerText = error.message;
  } else {
    document.getElementById("message").innerText = "Login successful";
  }

}
