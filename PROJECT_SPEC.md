# 20nagar FoodXpress Platform

## System Overview
Food delivery platform with 5 roles:

- Customer
- Restaurant
- Delivery Partner
- Payment Verifier
- Admin

Backend: Supabase  
Frontend: GitHub Pages PWA

---

## Order Flow

Customer places order  
↓
Uploads payment proof  
↓
Verifier approves payment  
↓
Restaurant receives order  
↓
Restaurant accepts and sets preparation time  
↓
Delivery partner assigned  
↓
Delivery partner picks up order  
↓
Delivery completed  

---

## Delivery Rules

1 delivery partner = 1 active delivery

System capacity =

online_delivery_partners × 2

Example:

2 DPs → 4 orders allowed  
2 active deliveries  
2 waiting orders

Maximum delivery distance = 25 km

---

## Delivery Fee Rules

Distance ≤ 8 km

max(30 , distance × 15)

Distance > 8 km

distance × 1.2  
max(120 , distance × 13)

---

## Discount Rule

First ₹199 → no discount

Remaining amount → 5%

Limit:

delivery_fee − 1

---

## Order Limits

Minimum order = ₹99  
Maximum order = ₹1800

Max carts per user = 3  
Each cart = single restaurant

---

## Image Limits

Item image → 40KB  
Restaurant logo → 100KB  
Company logo → 200KB  
Refund QR → 250KB

Format = JPG

---

## Storage Buckets

item_images (public)  
restaurant_logos (public)  
company_assets (public)

payment_proofs (private)  
payout_proofs (private)  
refund_qr_codes (private)

---

## Database

14 tables

users  
customers  
restaurants  
delivery_partners  
addresses  
categories  
menu_items  
addons  
orders  
order_items  
payments  
delivery_logs  
restaurant_settlements  
dp_settlements

---

## Authentication

Email login only

Email verification required  
Password reset enabled

---

## Data Retention

Orders stored for 90 days  
Then automatically deleted
