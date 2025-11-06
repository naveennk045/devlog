Here is the complete, end-to-end flow for your entire kiosk system, incorporating all our design decisions.

This system is fast, secure, and reliable because it correctly separates responsibilities:

- **KDS:** The single source of truth for _what_ you sell.
    
- **Redis:** A high-speed _copy_ of the menu for fast browsing and checkout.
    
- **PostgreSQL:** The permanent _record_ of what you've sold.
    
- **FastAPI:** The central brain that enforces all business rules.
    
- **React:** The user-friendly face that only displays data.
    

---

## 🚀 Phase 1: System Startup & Displaying the Menu

This phase is all about getting the menu to the customer as fast as possible.

1. **Kiosk Starts (React):** The kiosk browser opens your React application.
    
2. **Fetch Catalog (React):** The app immediately sends a `GET /api/v1/catalog` request to your FastAPI backend to get the menu.
    
3. **Check Cache (FastAPI):** Your backend receives the request and first checks **Redis** for a key named `"catalog"`.
    
4. **Cache Hit (Fast Path):**
    
    - If the `"catalog"` key exists, **Redis** instantly returns the full menu JSON.
        
    - Your backend sends this JSON directly to the React app.
        
5. **Cache Miss (Slow Path):**
    
    - If the `"catalog"` key is not in **Redis** (e.g., the system just started or the cache was cleared), the backend proceeds.
        
    - It makes an authenticated API call to the existing **KDS API** to fetch the full, up-to-date catalog (items, prices, categories, taxes).
        
    - The **KDS** returns the data.
        
    - Your backend **saves this data to the "catalog" key in Redis** (with an expiration time, e.g., 1 hour) so the next request is a "Cache Hit."
        
    - Your backend sends this JSON to the React app.
        
6. **Display Menu (React):** The React app receives the menu JSON and renders the interactive menu for the customer.
    

---

## 🛒 Phase 2: Customer Places an Order (Checkout)

This is the most critical phase for security. The backend, _not_ the frontend, must determine the price.

1. **Customer Browsing (React):** The customer adds items to their cart (e.g., 2x Masala Dosa, 1x Idli). This cart is managed in the React app's local state.
    
2. **Press Checkout (React):** The customer is ready and presses "Checkout." The app sends a `POST /api/v1/orders` request to your backend.
    
3. **Request Body (React -> FastAPI):** The body _only_ contains item IDs and quantities. It **does not** send any prices.
    
    JSON
    
    ```
    {
      "items": [
        { "item_id": "kds_dosa_m", "quantity": 2 },
        { "item_id": "kds_idli_s", "quantity": 1 }
      ]
    }
    ```
    
4. Calculate Total (FastAPI): Your backend receives this request and:
    
    a. Fetches the current catalog from Redis.
    
    b. Looks up the price and tax_rate for "kds_dosa_m" and "kds_idli_s" from the cached data.
    
    c. Securely calculates the final, authoritative total_amount (e.g., (2 * 80.00) + (1 * 50.00) + tax = 231.00).
    
5. Save Pending Order (FastAPI):
    
    a. The backend creates a new record in the PostgreSQL Orders table with a unique order_id (e.g., "ORD-123"), the total_amount: 231.00, and a status: "PENDING".
    
    b. It creates records in the PostgreSQL Order_Items table, linking them to "ORD-123" and storing the item_name and price_at_sale (e.g., "Masala Dosa", 80.00). This is your permanent financial record.
    
6. **Confirm to Frontend (FastAPI -> React):** The backend returns the official order details.
    
    JSON
    
    ```
    {
      "order_id": "ORD-123",
      "total_amount": 231.00
    }
    ```
    
7. **Display Confirmation (React):** The React app displays the final price: "Total: 231.00. Please confirm to pay."
    

---

## 💳 Phase 3: Payment with PhonePe

This phase handles the live payment transaction.

1. **Press Pay Now (React):** The customer confirms the total and presses "Pay Now."
    
2. **Initiate Payment (React):** The app sends a `POST /api/v1/payment/initiate` request, including the `order_id`.
    
3. Get QR Code (FastAPI):
    
    a. Your backend looks up "ORD-123" in PostgreSQL to get the total_amount (231.00).
    
    b. It makes an API call to the PhonePe API, sending the total_amount, the order_id (as merchantTransactionId), and a callback_url. This URL points to your backend (e.g., https://api.myrestaurant.com/api/v1/payment/webhook).
    
    c. PhonePe's API returns a QR code string.
    
4. **Display QR (FastAPI -> React):** The backend sends this `qr_string` back to the frontend.
    
5. Start Polling (React):
    
    a. The React app displays the QR code on the screen.
    
    b. It immediately starts polling your backend every 3-5 seconds at a new endpoint: GET /api/v1/orders/ORD-123/status.
    
    c. This endpoint simply checks the status in the PostgreSQL Orders table and returns it (e.g., {"status": "PENDING"}).
    
6. **Customer Pays:** The customer scans the QR code and authorizes the payment on their phone.
    

---

## ✅ Phase 4: Confirmation, KDS, and Printing

This final phase happens in two parallel parts: a backend webhook (invisible) and a frontend poll (visible).

### Part A: Backend Webhook (Server-to-Server)

1. **Payment Confirmed (PhonePe):** PhonePe's servers process the payment.
    
2. **Send Webhook (PhonePe -> FastAPI):** PhonePe _immediately_ sends a `POST` request to your `callback_url` (`.../api/v1/payment/webhook`). This request contains proof of payment.
    
3. Confirm Order (FastAPI): Your backend:
    
    a. Verifies the signature of the webhook to ensure it's truly from PhonePe.
    
    b. If valid and successful, it updates the order in PostgreSQL: UPDATE Orders SET status = 'CONFIRMED' WHERE order_id = 'ORD-123'.
    
    c. This is the key: Now that payment is confirmed, the backend immediately calls the KDS API and posts the confirmed order (items, quantities) to the kitchen.
    
    d. Returns a 200 OK response to PhonePe to acknowledge the webhook.
    

### Part B: Frontend Polling

1. **Still Polling (React):** The React app continues to poll `GET .../status`.
    
    - Request 1: `{"status": "PENDING"}`
        
    - Request 2: `{"status": "PENDING"}`
        
    - _(Part A happens in the background. The database is updated.)_
        
    - Request 3: `{"status": "CONFIRMED"}`
        
2. Show Success (React):
    
    a. As soon as the React app sees the "CONFIRMED" status, it stops polling.
    
    b. It hides the QR code and displays the "Payment Successful! Your order is being prepared." screen.
    
3. **Printing (React):** The app now enables the "Print Receipt" button. When pressed, it uses the browser's print functionality to print the final KOT and bill based on the order data.
    

---

## 🔄 Phase 5: Menu Updates (Cache Management)

This is the background "script" that keeps your menu in sync.

1. **Change Made (KDS):** A manager changes the price of "Masala Dosa" from 80.00 to 85.00 in the **KDS** admin panel.
    
2. **KDS Webhook (Best Solution):** The **KDS** is configured to _immediately_ send a `POST` request (a webhook) to a special endpoint on your backend (e.g., `POST /api/v1/catalog/refresh`).
    
3. **Clear Cache (FastAPI):** Your backend receives this webhook and its only job is to **delete the `"catalog"` key from Redis.**
    
4. **Next Customer:** The next customer who opens the app triggers **Phase 1, Step 5 (Cache Miss)**. Your backend fetches the _new_ catalog (with the 85.00 price) from the **KDS**, saves it to **Redis**, and serves it.
    

The system is now fully updated automatically, ensuring your prices are always correct.


Request Model for Order **POST**
- item_sku_id [ List ]
- quantity
- total_amount_include_tax
- total_amount_exclude_tax

Response Model for Order
- order_id
- total_amount_include_tax
- total_amount_exclude_tax

Request Model for  Payment **POST**
- order_id
- amount

Response Model for the payment 
- order_id
- qr_string




Request Model for Order **POST**
- item_sku_id [ List ]
- quantity
- total_amount_include_tax
- total_amount_exclude_tax
{
  "categories": [
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd4",
      "name": "Bengaluru Dose",
      "subCategories": []
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd8",
      "name": "Coffee",
      "subCategories": []
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd3",
      "name": "Davanagere Dose",
      "subCategories": []
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd5",
      "name": "Idli",
      "subCategories": []
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd7",
      "name": "Rice",
      "subCategories": []
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd6",
      "name": "Wada/Snacks",
      "subCategories": []
    }
  ],
  "charges": [
    {
      "applicableModes": [
        "Delivery",
        "Pickup",
        "Others"
      ],
      "applyAt": "Order",
      "chargeId": "68f0e00a592b7cf3428c5f0e",
      "chargeRate": 20,
      "chargeType": "Absolute",
      "isIncludesTax": false,
      "name": "PC",
      "taxTypeIds": []
    }
  ],
  "discounts": [],
  "itemTags": [
    {
      "itemTagId": "6868c0ab6065bace3cd952b7",
      "name": "Vegetarian"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952b8",
      "name": "Non-vegetarian"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952b9",
      "name": "Chef Recommended"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952ba",
      "name": "Spicy"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952bb",
      "name": "Egg"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952bc",
      "name": "Wheat Free"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952bd",
      "name": "Glutten Free"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952be",
      "name": "Vegan"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952bf",
      "name": "Beverage"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952c0",
      "name": "Seasonal"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952c1",
      "name": "Grilled"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952c2",
      "name": "Fried"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952c3",
      "name": "Platter"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952c4",
      "name": "Age Restriction"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952c5",
      "name": "Meal"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952c6",
      "name": "Cake"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952c7",
      "name": "Swiggy POP"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952c8",
      "name": "Zomato Treat"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952c9",
      "name": "Zomato QVM Desserts"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952ca",
      "name": "Zomato QVM Breakfast"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952cb",
      "name": "Zomato QVM Lunch"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952cc",
      "name": "Zomato QVM Dinner"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952cd",
      "name": "Zomato QVM North Indian"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952ce",
      "name": "Zomato QVM Chinese"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952cf",
      "name": "Zomato QVM Snacks"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952d0",
      "name": "Zomato QVM South Indian"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952d1",
      "name": "Zomato QVM Pizza"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952d2",
      "name": "Zomato QVM Burger"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952d3",
      "name": "Zomato QVM Biryani"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952d4",
      "name": "Zomato QVM Fast food"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952d5",
      "name": "Custom Photo Cake"
    },
    {
      "itemTagId": "6868c0ab6065bace3cd952d6",
      "name": "Zomato QVM Party Order"
    },
    {
      "itemTagId": "68e92186a7ca6b3bc3051f4a",
      "name": "Ve"
    }
  ],
  "items": [
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd3",
      "chargeIds": [],
      "denyDiscount": false,
      "imageURL": "https://static.apps.ristaapps.com/b/d8bd00cc-8cab-4e7e-8b92-1d08d972d2b9/images/68d674bcbc10223a0c5d6e7e/original.jpg",
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccba2",
      "itemName": "Davanagere Benne Sada Dose",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 110,
      "scheduleIds": [],
      "skuCode": "1",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd3",
      "chargeIds": [],
      "denyDiscount": false,
      "imageURL": "https://static.apps.ristaapps.com/b/d8bd00cc-8cab-4e7e-8b92-1d08d972d2b9/images/68d674bcbc10223a0c5d6e80/original.jpg",
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccba4",
      "itemName": "Davanagere Benne Masala Dose",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 140,
      "scheduleIds": [],
      "skuCode": "2",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd3",
      "chargeIds": [],
      "denyDiscount": false,
      "imageURL": "https://static.apps.ristaapps.com/b/d8bd00cc-8cab-4e7e-8b92-1d08d972d2b9/images/68d674bcd8983162d82a377a/original.jpg",
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccba6",
      "itemName": "Davanagere Benne Open Dose",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 160,
      "scheduleIds": [],
      "skuCode": "3",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd3",
      "chargeIds": [],
      "denyDiscount": false,
      "imageURL": "https://static.apps.ristaapps.com/b/d8bd00cc-8cab-4e7e-8b92-1d08d972d2b9/images/68d674bcbc10223a0c5d6e86/original.jpg",
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccba8",
      "itemName": "Davanagere Khali Dose",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 120,
      "scheduleIds": [],
      "skuCode": "4",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd4",
      "chargeIds": [],
      "denyDiscount": false,
      "imageURL": "https://static.apps.ristaapps.com/b/d8bd00cc-8cab-4e7e-8b92-1d08d972d2b9/images/68d674bcbc10223a0c5d6e7e/original.jpg",
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbaa",
      "itemName": "Bangaluru Benne Plain Dose",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 130,
      "scheduleIds": [],
      "skuCode": "5",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd4",
      "chargeIds": [],
      "denyDiscount": false,
      "imageURL": "https://static.apps.ristaapps.com/b/d8bd00cc-8cab-4e7e-8b92-1d08d972d2b9/images/68d674bcbc10223a0c5d6e80/original.jpg",
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbac",
      "itemName": "Bangaluru Benne Masala Dose",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 140,
      "scheduleIds": [],
      "skuCode": "6",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd4",
      "chargeIds": [],
      "denyDiscount": false,
      "imageURL": "https://static.apps.ristaapps.com/b/d8bd00cc-8cab-4e7e-8b92-1d08d972d2b9/images/68d674bcbc10223a0c5d6e7f/original.jpg",
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbae",
      "itemName": "Bangaluru Benne Pudi Masala Dose",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 160,
      "scheduleIds": [],
      "skuCode": "7",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd4",
      "chargeIds": [],
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbb0",
      "itemName": "Bangaluru Ghee Plain Dose",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 130,
      "scheduleIds": [],
      "skuCode": "8",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd5",
      "chargeIds": [],
      "denyDiscount": false,
      "imageURL": "https://static.apps.ristaapps.com/b/d8bd00cc-8cab-4e7e-8b92-1d08d972d2b9/images/68d674bcbc10223a0c5d6e83/original.jpg",
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbb2",
      "itemName": "Idli Chutney",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 70,
      "scheduleIds": [],
      "skuCode": "9",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd5",
      "chargeIds": [],
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbb4",
      "itemName": "Ghee Pudi Idli",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 90,
      "scheduleIds": [],
      "skuCode": "10",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd5",
      "chargeIds": [],
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbb6",
      "itemName": "Thatte Idli",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "optionSetIds": [],
      "price": 80,
      "scheduleIds": [],
      "skuCode": "11",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd5",
      "chargeIds": [],
      "denyDiscount": false,
      "imageURL": "https://static.apps.ristaapps.com/b/d8bd00cc-8cab-4e7e-8b92-1d08d972d2b9/images/68d674bcbc10223a0c5d6e84/original.jpg",
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbb8",
      "itemName": "Ghee Pudi Thatte Idli",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 100,
      "scheduleIds": [],
      "skuCode": "12",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd6",
      "chargeIds": [],
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbba",
      "itemName": "Medu Wada",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "optionSetIds": [],
      "price": 90,
      "scheduleIds": [],
      "skuCode": "13",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd6",
      "chargeIds": [],
      "denyDiscount": false,
      "imageURL": "https://static.apps.ristaapps.com/b/d8bd00cc-8cab-4e7e-8b92-1d08d972d2b9/images/68d674bcbc10223a0c5d6e81/original.jpg",
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbbc",
      "itemName": "Dal Vada",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "optionSetIds": [],
      "price": 90,
      "scheduleIds": [],
      "skuCode": "14",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd7",
      "chargeIds": [],
      "imageURL": "https://static.apps.ristaapps.com/b/d8bd00cc-8cab-4e7e-8b92-1d08d972d2b9/images/68d674bcd8983162d82a377c/original.jpg",
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbc2",
      "itemName": "Kesari Bath",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 90,
      "scheduleIds": [],
      "skuCode": "17",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd7",
      "chargeIds": [],
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbc4",
      "itemName": "Khara Bath",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "optionSetIds": [],
      "price": 90,
      "scheduleIds": [],
      "skuCode": "18",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd7",
      "chargeIds": [],
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbc6",
      "itemName": "Chow Chow Bath",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "optionSetIds": [],
      "price": 150,
      "scheduleIds": [],
      "skuCode": "19",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd7",
      "chargeIds": [],
      "imageURL": "https://static.apps.ristaapps.com/b/d8bd00cc-8cab-4e7e-8b92-1d08d972d2b9/images/68d674bcd8983162d82a377d/original.jpg",
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbc8",
      "itemName": "Temple Puliyogare Bath",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 130,
      "scheduleIds": [],
      "skuCode": "20",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd7",
      "chargeIds": [],
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbca",
      "itemName": "Bisi Bele Bath",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "optionSetIds": [],
      "price": 120,
      "scheduleIds": [],
      "skuCode": "21",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd7",
      "chargeIds": [],
      "denyDiscount": false,
      "imageURL": "https://static.apps.ristaapps.com/b/d8bd00cc-8cab-4e7e-8b92-1d08d972d2b9/images/68d674bcbc10223a0c5d6e85/original.jpg",
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbcc",
      "itemName": "Shavige Bath",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "optionSetIds": [],
      "price": 130,
      "scheduleIds": [],
      "skuCode": "22",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd7",
      "chargeIds": [],
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbce",
      "itemName": "Chitranna",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "optionSetIds": [],
      "price": 130,
      "scheduleIds": [],
      "skuCode": "23",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd8",
      "chargeIds": [],
      "denyDiscount": false,
      "imageURL": "https://static.apps.ristaapps.com/b/d8bd00cc-8cab-4e7e-8b92-1d08d972d2b9/images/68d674bcbc10223a0c5d6e87/original.jpg",
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbe3",
      "itemName": "Hot Filter Coffee",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 80,
      "scheduleIds": [],
      "skuCode": "27",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd8",
      "chargeIds": [],
      "denyDiscount": false,
      "imageURL": "https://static.apps.ristaapps.com/b/d8bd00cc-8cab-4e7e-8b92-1d08d972d2b9/images/68d674bcbc10223a0c5d6e82/original.jpg",
      "isPriceIncludesTax": false,
      "itemId": "6868ca5d4fda6eabd33ccbe5",
      "itemName": "Cold Filter Coffee",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "optionSetIds": [],
      "price": 90,
      "scheduleIds": [],
      "skuCode": "28",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd4",
      "chargeIds": [],
      "denyDiscount": false,
      "isPriceIncludesTax": false,
      "itemId": "68e918ac9fc4860b02bc4fa6",
      "itemName": "Bangaluru Benne Pudi Plain Dose",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 150,
      "scheduleIds": [],
      "skuCode": "73",
      "status": "Active",
      "taxTypeIds": [],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd7",
      "chargeIds": [],
      "denyDiscount": false,
      "isPriceIncludesTax": false,
      "itemId": "68e91c9c63e041c6c8d8d525",
      "itemName": "Vangi Bath",
      "itemNature": "Service",
      "measuringUnit": "ea",
      "price": 130,
      "scheduleIds": [],
      "skuCode": "74",
      "status": "Active",
      "taxTypeIds": [],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd5",
      "chargeIds": [],
      "denyDiscount": false,
      "isPriceIncludesTax": false,
      "itemId": "68e91d9bebc3d720d09f78c2",
      "itemName": "Idli Wada",
      "itemNature": "Service",
      "measuringUnit": "ea",
      "price": 130,
      "scheduleIds": [],
      "skuCode": "75",
      "status": "Active",
      "taxTypeIds": [],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd5",
      "chargeIds": [],
      "denyDiscount": false,
      "isPriceIncludesTax": false,
      "itemId": "68e91dcccfd2397cc233acc8",
      "itemName": "Benne Idli",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 100,
      "scheduleIds": [],
      "skuCode": "76",
      "status": "Active",
      "taxTypeIds": [
        "6868c05ede387c9d22a94396",
        "6868c05ede387c9d22a94397"
      ],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd5",
      "chargeIds": [],
      "denyDiscount": false,
      "isPriceIncludesTax": false,
      "itemId": "68e91dfbfc9154f756362298",
      "itemName": "Benne Thatte Idli",
      "itemNature": "Service",
      "measuringUnit": "ea",
      "price": 100,
      "scheduleIds": [],
      "skuCode": "77",
      "status": "Active",
      "taxTypeIds": [],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd4",
      "chargeIds": [],
      "denyDiscount": false,
      "isPriceIncludesTax": false,
      "itemId": "68e91e35a7ca6b3bc3051cc1",
      "itemName": "Bangaluru Ghee Pudi Masala Dose",
      "itemNature": "Service",
      "measuringUnit": "ea",
      "price": 160,
      "scheduleIds": [],
      "skuCode": "78",
      "status": "Active",
      "taxTypeIds": [],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd4",
      "chargeIds": [],
      "denyDiscount": false,
      "isPriceIncludesTax": false,
      "itemId": "68e91e72a7ca6b3bc3051cff",
      "itemName": "Bangaluru Ghee Pudi Plain Dose",
      "itemNature": "Service",
      "measuringUnit": "ea",
      "price": 150,
      "scheduleIds": [],
      "skuCode": "79",
      "status": "Active",
      "taxTypeIds": [],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd4",
      "chargeIds": [],
      "denyDiscount": false,
      "isPriceIncludesTax": false,
      "itemId": "68e91ec5ae03128daf17ea8c",
      "itemName": "Bangaluru Ghee Masala Dose",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 140,
      "scheduleIds": [],
      "skuCode": "80",
      "status": "Active",
      "taxTypeIds": [],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd4",
      "chargeIds": [],
      "denyDiscount": false,
      "isPriceIncludesTax": false,
      "itemId": "68f607f4a398b8c5953392bc",
      "itemName": "TEST ",
      "itemNature": "Service",
      "measuringUnit": "ea",
      "price": 1,
      "scheduleIds": [],
      "skuCode": "98",
      "status": "Active",
      "taxTypeIds": [],
      "type": "Simple"
    },
    {
      "categoryId": "6868ca5dc29c8ed4d3c98dd7",
      "chargeIds": [],
      "denyDiscount": false,
      "isPriceIncludesTax": false,
      "itemId": "68fc7c442bca533a6589dd83",
      "itemName": "Kashi Halwa",
      "itemNature": "Service",
      "itemTagIds": [
        "6868c0ab6065bace3cd952b7"
      ],
      "measuringUnit": "ea",
      "price": 150,
      "scheduleIds": [],
      "skuCode": "111",
      "status": "Active",
      "taxTypeIds": [],
      "type": "Simple"
    }
  ],
  "memberships": [],
  "optionSets": [],
  "schedules": [],
  "taxTypes": [
    {
      "name": "CGST",
      "percentage": 2.5,
      "taxTypeId": "6868c05ede387c9d22a94396"
    },
    {
      "name": "SGST",
      "percentage": 2.5,
      "taxTypeId": "6868c05ede387c9d22a94397"
    },
    {
      "name": "CGST6",
      "percentage": 6,
      "taxTypeId": "6868c05ede387c9d22a94398"
    },
    {
      "name": "SGST6",
      "percentage": 6,
      "taxTypeId": "6868c05ede387c9d22a94399"
    },
    {
      "name": "CGST9",
      "percentage": 9,
      "taxTypeId": "6868c05ede387c9d22a9439a"
    },
    {
      "name": "SGST9",
      "percentage": 9,
      "taxTypeId": "6868c05ede387c9d22a9439b"
    },
    {
      "name": "CGST14",
      "percentage": 14,
      "taxTypeId": "6868c05ede387c9d22a9439c"
    },
    {
      "name": "SGST14",
      "percentage": 14,
      "taxTypeId": "6868c05ede387c9d22a9439d"
    },
    {
      "name": "VAT",
      "percentage": 5,
      "taxTypeId": "6868c05ede387c9d22a9439e"
    }
  ]
}

import httpx
import redis.asyncio as redis
import json
import logging
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.concurrency import run_in_threadpool

from app.core.config import settings
from app.core.dependencies import get_http_client, get_redis_client
from app.core.rista_utils import generate_jwt_token

logger = logging.getLogger(__name__)

router = APIRouter()


@router.get("/")
async def get_catalog(
        channel: str,
        http_client: httpx.AsyncClient = Depends(get_http_client),
        redis_client: redis.Redis = Depends(get_redis_client)
):
    cache_key = f"{channel}_catalog_data"

    # 1. Check cache first
    try:
        if cached_data := await redis_client.get(cache_key):
            logger.info(f"Returning catalog for channel '{channel}' from cache.")
            return json.loads(cached_data)
    except Exception as e:
        logger.error(f"Cache read error for channel '{channel}': {e}", exc_info=True)

    # 2. Generate token in a threadpool
    try:
        token = await run_in_threadpool(generate_jwt_token)
    except Exception as e:
        logger.error(f"Failed to generate JWT: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Could not process authentication."
        )

    headers = {
        "x-api-key": settings.PI_KEY,
        "x-api-token": token,
        "content-type": 'application/json'
    }
    params = {
        "branch": settings.BRANCH_CODE,
        "channel": channel
    }

    try:
        url = f"{settings.RISTA_BASE_URL}/catalog"
        logger.info(f"Fetching fresh catalog for channel '{channel}' from Rista API...")
        response = await http_client.get(url, headers=headers, params=params)
        response.raise_for_status()

        catalog_data = response.json()

        if catalog_data is None:
            logger.error(f"Rista API returned null data for channel '{channel}'.")
            raise HTTPException(
                status_code=status.HTTP_502_BAD_GATEWAY,
                detail="Invalid response structure from upstream API: received null data."
            )

        # 4. Store the catalog data in cache
        try:
            await redis_client.set(
                cache_key,
                json.dumps(catalog_data),
                ex=3600  # 1 hour expiration
            )
            logger.info(f"Successfully cached catalog for channel '{channel}'.")
        except Exception as e:
            logger.warning(f"Cache write error for channel '{channel}': {e}", exc_info=True)

        return catalog_data

    except httpx.HTTPStatusError as e:
        logger.error(
            f"Rista API returned status {e.response.status_code} for channel '{channel}'. Response: {e.response.text}",
            exc_info=True
        )
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail="Error from upstream catalog API."
        )
    except httpx.RequestError as e:
        logger.error(f"Cannot connect to Rista API for channel '{channel}': {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail="Cannot connect to upstream catalog API."
        )

Response Model for Order
- order_id
- total_amount_include_tax
- total_amount_exclude_tax
Request Model for Order **POST**
- item_sku_id [ List ]
- quantity
- total_amount_include_tax
- total_amount_exclude_tax

Response Model for Order
- order_id
- total_amount_include_tax
- total_amount_exclude_tax


now we need to create some endpoints for create the order in the postrgres

now from the frontend gives the request to backend with items skucode 
then we need to cross the check the items by fetching all the detaislfrom redis then we need to send the response i have attached the abpove format