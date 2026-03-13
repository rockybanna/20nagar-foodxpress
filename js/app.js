// ---------- AUTH FUNCTIONS ----------

// SIGNUP
async function signup(){

const email = document.getElementById("email").value.trim();
const password = document.getElementById("password").value.trim();
const msg = document.getElementById("message");

if(!email || !password){
msg.innerText="Enter email and password";
return;
}

const { error } = await supabaseClient.auth.signUp({
email,
password
});

if(error){
msg.innerText = error.message;
return;
}

msg.innerText = "Signup successful. Check email.";

}

// LOGIN
async function login(){

const email = document.getElementById("email").value.trim();
const password = document.getElementById("password").value.trim();
const msg = document.getElementById("message");

if(!email || !password){
msg.innerText="Enter email and password";
return;
}

const { data, error } =
await supabaseClient.auth.signInWithPassword({
email,
password
});

if(error){
msg.innerText = error.message;
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

if(roleError || !profile){
msg.innerText="User role not configured.";
return;
}

const role = profile.role;

// redirect by role
switch(role){

case "customer":
window.location.href="./customer/";
break;

case "restaurant":
window.location.href="./restaurant/";
break;

case "delivery_partner":
window.location.href="./delivery/";
break;

case "payment_verifier":
window.location.href="./verifier/";
break;

case "admin":
window.location.href="./admin/";
break;

default:
msg.innerText="Unknown role assigned.";

}

}
