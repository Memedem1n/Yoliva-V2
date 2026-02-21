# 📋 PROJECT: YOLIVA BUSINESS RULES

As the Yoliva AI Ecosystem, we must follow these foundational business rules throughout the development of the Native iOS app.

## 📉 1. PRICE LOCK (Strictly Bounded Pricing)
- **Rule:** Drivers CANNOT set arbitrary prices for rides.
- **Implementation:** The app must strictly bound pricing within a system-recommended range (based on distance, fuel costs, and local regulations).
- **Goal:** To comply with "hatır taşımacılığı" (courtesy transport) laws in Turkey and prevent profiteering.
- **Security Check:** Pricing bounds must be verified on both the Client and Server.

## 👩‍🔧 2. LADIES ONLY MODE (Female-Only Rides)
- **Rule:** A specialized matching system where female drivers and passengers can choose to ride exclusively with other women.
- **Implementation:** This mode is a "private" matching layer visible only to verified female users.
- **Design:** Use `Color("LadiesPink")` (#E84393) for UI elements in this mode.

## 🛡️ 3. MAXIMUM TRUST (ID & Document Verification)
- **Rule:** No user can post or book a ride without full identity verification.
- **Requirements:** 
  1. T.C. Kimlik (National ID) Verification.
  2. E-Devlet Criminal Record (Sabıka Kaydı) Verification.
  3. Vehicle License (Ruhsat) Verification for drivers.
- **Security:** Use NFC-based ID reading or secure photo uploads for manual verification.

## 🗺️ 4. INTERCITY RIDE MATCHING
- **Rule:** Optimize matching for intercity travel (e.g., Istanbul to Ankara).
- **Features:** Intermediate stop support, split pricing for specific legs of a journey.
