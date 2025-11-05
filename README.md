# 📌 Pay-Per-Use API Access Smart Contract

## 📖 What is this?

This smart contract enables **developers to monetize their APIs** directly on-chain.

- Developers can register their API details and set prices for **per-call access** or **time-based subscriptions**.
- Consumers can purchase access by paying ETH.
- The contract tracks **usage counters** and **expiry times** to enforce fair access.
- Developers can withdraw funds anytime. 

This brings **Web3-native payments** into the **API economy**, eliminating middlemen and ensuring transparent access tracking.
  
---           
     
## ❓ Why build this?  
 
Today, most APIs rely on centralized payment processors (Stripe, Razorpay, etc.) and closed dashboards. These have several issues:

1. **High fees** → Intermediaries take a cut.
2. **Limited transparency** → Consumers cannot verify fair usage.
3. **Global friction** → APIs serving worldwide users need multiple payment integrations.
4. **Trust issue** → Developers and consumers must trust a central entity.

👉 By moving access control **on-chain**:

- **Developers** get direct, trustless payments.
- **Consumers** get verifiable entitlements (calls/time).
- **Transparency** improves since usage & payments are publicly auditable.
- **Borderless access** → anyone with crypto can pay & use APIs.

This is a step toward a **Decentralized API Marketplace**.

---

## ⚡ Features

- **Developer Registration** → Register API with pricing.
- **Consumer Access** → Pay for either per-call access or subscriptions.
- **On-Chain Usage Counter** → Track remaining calls or expiry.
- **Access Verification** → Middleware/off-chain gateway can query `hasAccess()`.
- **Withdrawal** → Developers withdraw funds anytime.

---

## 🏗️ Smart Contract Overview

- Language: Solidity ^0.8.20
- Framework: Hardhat (recommended for local testing)
- Functions:
  - `registerAPI()` → Developer registers API.
  - `buyCalls()` → Consumer buys a fixed number of calls.
  - `buySubscription()` → Consumer buys time-based access.
  - `hasAccess()` → Check if user has valid access.
  - `useCall()` → Decrease call balance after usage.
  - `withdraw()` → Developer withdraws funds.

---
