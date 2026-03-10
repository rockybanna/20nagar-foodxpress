# 20nagar FoodXpress – Project Context (AI System Instructions)

## Project Overview

20nagar FoodXpress is a multi-role food delivery platform built using:

Frontend:

* GitHub Pages (static HTML/CSS/JS)

Backend:

* Supabase (PostgreSQL + Auth + REST API)

The system has **5 user roles**:

1. Customer
2. Restaurant
3. Delivery Partner
4. Payment Verifier
5. Admin

The project is currently deployed at:

https://rockybanna.github.io/20nagar-foodxpress/

Repository:

rockybanna/20nagar-foodxpress

This file defines the **FULL frozen architecture and business logic**.

AI agents (Codex / assistants) must follow this file strictly and **must not redesign the system**.

---

# SYSTEM ARCHITECTURE

Frontend
Static web app served by GitHub Pages.

Structure:

/index.html (login)
/customer/
/restaurant/
/delivery/
/admin/
/verifier/
/js/
/css/

Backend
Supabase provides:

Authentication
Database
REST API

Database tables: **14 total**

users
customers
restaurants
delivery_partners
categories
menu_items
addons
orders
order_items
payments
delivery_logs
dp_settlements
restaurant_settlements
addresses

---

# AUTHENTICATION RULES

Supabase Auth is used.

Signup:
Email + Password

On signup:
Trigger creates record in **users table**

users table schema:

id (uuid)
email
role

Default role = customer

Admin later changes roles manually if needed.

Login flow:

User logs in
→ system reads role from users table
→ redirects:

customer → /customer
restaurant → /restaurant
delivery_partner → /delivery
payment_verifier → /verifier
admin → /admin

---

# CUSTOMER APP LOGIC

Customer can:

1 Browse restaurants
2 View menu
3 Place order

Restaurant listing rule:

restaurants.is_online = true

Menu listing rule:

menu_items.restaurant_id = selected restaurant

Menu item structure:

id
restaurant_id
category_id
name
description
price

Order creation flow:

Customer presses Order

System creates:

orders record

fields:

customer_id
total_amount
status = pending

Then creates:

order_items record

fields:

order_id
menu_item_id
quantity
price

---

# ORDER STATUS FLOW

pending
accepted
preparing
ready_for_pickup
picked_up
delivered
cancelled

---

# RESTAURANT APP LOGIC

Restaurant can:

View incoming orders
Accept order
Reject order
Mark order ready

Flow:

pending → accepted → preparing → ready_for_pickup

---

# DELIVERY PARTNER LOGIC

Delivery partner sees:

Orders ready for pickup

Assignment rule:

Nearest available delivery partner

Delivery partner status:

online
offline

Order flow:

ready_for_pickup → picked_up → delivered

Delivery partner earnings:

8–10 Rs per KM

---

# PAYMENT LOGIC

Payment methods:

COD
Wallet

COD rule:

Wallet not deducted.

Wallet rule:

Wallet balance deducted.

Payment verification done by:

Payment Verifier role.

---

# ADMIN PANEL

Admin manages:

Restaurants
Menu items
Delivery partners
Orders
Settlements

Admin can:

Set restaurant online/offline
Set delivery charges
Edit distances
View reports

---

# DELIVERY CHARGES

Delivery charges based on distance.

Customer charge:

12–15 Rs per KM

Delivery partner pay:

8–10 Rs per KM

Distance stored manually in database.

---

# ORDER LIMIT RULES

Max order value:

₹5000

Minimum order value:

₹149

---

# DELIVERY PARTNER RULES

Max active orders:

2

Max waiting orders:

3

If more than 3 waiting:

Customer must wait.

---

# NOTIFICATION LOGIC

Delivery partner receives order request.

Ringing cycle:

2 minutes ring

If not accepted:
Retry 5 times.

If still not accepted:

System auto assigns order.

---

# COD HANDLING

COD payments stored.

Admin manually marks settlement.

---

# CURRENT PROJECT STATUS

Completed:

✔ Supabase connected
✔ GitHub Pages deployed
✔ Login system working
✔ Role based redirect working
✔ Restaurant listing working
✔ Menu loading working
✔ Order creation working

Next features to build:

Restaurant order dashboard
Delivery partner assignment
Order status tracking
Wallet system
Settlement system
Reports

---

# DEVELOPMENT RULES

AI assistants must:

Never change architecture
Never change table structure without approval
Never redesign role logic
Only extend features within current architecture

Always keep system simple.

---

# PRIMARY OBJECTIVE

Build a reliable food delivery platform for a local city network.

Focus on:

Stability
Clear logic
Simple UI
Reliable order flow
