

## **1. Project Overview**

| Field              | Details                                                  |
| ------------------ | -------------------------------------------------------- |
| **Project Name**   | Restaurant Inventory Management with Advanced analytics  |
| **Goal / Purpose** | Building a product that will help the options traders to |
| **Current Status** | Started                                                  |
| **Architecture**   | [[high-level-design.canvas\|high-level-design]]          |


---
### About project

I want to build a real-time trading signal system focused on options buying only (CE/PE) for Indian markets.

Requirements:

Live market data integration from TrueData API (or similar NSE/BSE/MCX feed)

Auto-scan all instruments (NSE, BSE, MCX) and generate Buy/Sell signals with Entry, Stoploss, and Targets

Focus only on Options Buying (Index Options, Stock Options, MCX Options)

Instant WhatsApp alerts (via WhatsApp Business API / Twilio / Gupshup)

Backend should be in Python (scalable for future upgrades)

Should support indices (Nifty, BankNifty, Finnifty), top F&O stocks, and MCX commodities (Gold, Silver, Crude, NG, etc.)

Basic dashboard (optional) to view live signals and trade history

Future upgrade possibility: integration with AngelOne / Dhan SmartAPI for auto-execution

Deliverables:

Working bot with live option signals

Whats-App alert system

Source code + setup guide

---

##  **2. Task Tracker**

- [ ] Web socket phase 
	- Should find the way to process the data from the web-socket, because it will impact on the latency
	



---

## **4. Notes & Ideas**
1. [[sample-docs-data-analysis]]
2. 



---

## **5. Resources & References**

| Resource | Type | Link | Why it’s useful |
| -------- | ---- | ---- | --------------- |
|          |      |      |                 |

