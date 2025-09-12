# Pharmacy Management API - Postman Test Requests

## Authentication Setup

For all authenticated endpoints, use **Basic Auth** with your username and password in Postman:

- Go to Authorization tab
- Select "Basic Auth"
- Enter your username and password

---

## Product API Tests

### 1. Create Product

**Method:** `POST`  
**URL:** `http://localhost:8080/api/products`  
**Headers:** `Content-Type: application/json`  
**Body (JSON):**

```json
{
    "name": "Paracetamol 500mg",
    "description": "Pain relief and fever reducer tablets",
    "price": 15.99,
    "stockQuantity": 100,
    "category": "Pain Relief",
    "rating": 4.5
}
```

### 2. Get All Products (Paginated)

**Method:** `GET`  
**URL:** `http://localhost:8080/api/products?page=0&size=10&sortBy=name&sortDirection=asc`

### 3. Get Product by ID

**Method:** `GET`  
**URL:** `http://localhost:8080/api/products/1`

### 4. Update Product

**Method:** `PUT`  
**URL:** `http://localhost:8080/api/products/1`  
**Headers:** `Content-Type: application/json`  
**Body (JSON):**

```json
{
    "name": "Paracetamol 500mg (Updated)",
    "description": "Fast-acting pain relief and fever reducer tablets",
    "price": 17.99,
    "stockQuantity": 85,
    "category": "Pain Relief",
    "rating": 4.7
}
```

### 5. Search Products by Name

**Method:** `GET`  
**URL:** `http://localhost:8080/api/products/search?name=paracetamol`

### 6. Get Products by Category

**Method:** `GET`  
**URL:** `http://localhost:8080/api/products/category/Pain Relief`

### 7. Get Products by Price Range

**Method:** `GET`  
**URL:** `http://localhost:8080/api/products/price-range?minPrice=10&maxPrice=50`

### 8. Get Low Stock Products

**Method:** `GET`  
**URL:** `http://localhost:8080/api/products/low-stock?threshold=20`

### 9. Update Stock

**Method:** `PATCH`  
**URL:** `http://localhost:8080/api/products/1/stock?quantity=75`

### 10. Check Stock Availability

**Method:** `GET`  
**URL:** `http://localhost:8080/api/products/1/stock-check?quantity=10`

### 11. Get All Categories

**Method:** `GET`  
**URL:** `http://localhost:8080/api/products/categories`

### 12. Delete Product

**Method:** `DELETE`  
**URL:** `http://localhost:8080/api/products/1`

---

## Order API Tests

### Authentication Required for All Order Endpoints

Use Basic Auth with valid user credentials.

### User Endpoints

### 1. Create Order

**Method:** `POST`  
**URL:** `http://localhost:8080/api/orders`  
**Headers:** `Content-Type: application/json`  
**Body (JSON):**

```json
{
    "items": [
        {
            "productId": 1,
            "quantity": 2
        },
        {
            "productId": 2,
            "quantity": 1
        }
    ],
    "shippingAddress": {
        "street": "123 Main St",
        "city": "Chennai",
        "state": "Tamil Nadu",
        "zipCode": "600001",
        "country": "India"
    },
    "redeemedPoints": 5.0
}
```


```json
Response

```json
{
    "orderId": 6,
    "user": {
        "userId": 1,
        "username": "",
        "firstName": "Rover",
        "lastName": "Z",
        "email": "rover@example.com"
    },
    "shippingAddress": {
        "addressId": 3,
        "street": "123 Main St",
        "city": "Chennai",
        "state": "Tamil Nadu",
        "postalCode": null,
        "country": "India"
    },
    "totalAmount": 46.97,
    "redeemedPoints": 5.0,
    "status": "PENDING",
    "items": null,
    "createdAt": "2025-09-11 21:54:50",
    "updatedAt": "2025-09-11 21:54:50"
}
```

```
### 2. Get User's Orders (Paginated)

**Method:** `GET`  
**URL:** `http://localhost:8080/api/orders/my-orders?page=0&size=10&sortBy=createdAt&sortDirection=desc`

### 3. Get Specific Order by ID

**Method:** `GET`  
**URL:** `http://localhost:8080/api/orders/1`

### 4. Cancel Order

**Method:** `PUT`  
**URL:** `http://localhost:8080/api/orders/1/cancel`

### 5. Get User's Order History

**Method:** `GET`  
**URL:** `http://localhost:8080/api/orders/history`

### 6. Get User's Pending Orders

**Method:** `GET`  
**URL:** `http://localhost:8080/api/orders/pending`

### 7. Get Current User Info

**Method:** `GET`  
**URL:** `http://localhost:8080/api/orders/user-info`

---

### Admin Endpoints (Require ADMIN role)

### 8. Get All Orders (Admin)

**Method:** `GET`  
**URL:** `http://localhost:8080/api/orders/admin/all?page=0&size=20&sortBy=createdAt&sortDirection=desc`

### 9. Update Order Status (Admin)

**Method:** `PUT`  
**URL:** `http://localhost:8080/api/orders/1/status`  
**Headers:** `Content-Type: application/json`  
**Body (JSON):**

```json
{
    "status": "CONFIRMED"
}
```

### 10. Get Orders by Status (Admin)

**Method:** `GET`  
**URL:** `http://localhost:8080/api/orders/admin/status/PENDING`

### 11. Get Orders by Date Range (Admin)

**Method:** `GET`  
**URL:** `http://localhost:8080/api/orders/admin/date-range?startDate=2024-01-01&endDate=2024-12-31`

### 12. Get Total Sales (Admin)

**Method:** `GET`  
**URL:** `http://localhost:8080/api/orders/admin/total-sales`

### 13. Get Order Count by Status (Admin)

**Method:** `GET`  
**URL:** `http://localhost:8080/api/orders/admin/count/DELIVERED`

### 14. Get Recent Orders (Admin)

**Method:** `GET`  
**URL:** `http://localhost:8080/api/orders/admin/recent?limit=5`

---

## Sample Test Data for Multiple Products

### Create Vitamin C Tablets

```json
{
    "name": "Vitamin C 1000mg",
    "description": "Immune system support tablets",
    "price": 25.50,
    "stockQuantity": 150,
    "category": "Vitamins",
    "rating": 4.3
}
```

### Create Cough Syrup

```json
{
    "name": "Honey Cough Syrup",
    "description": "Natural cough suppressant with honey",
    "price": 12.75,
    "stockQuantity": 75,
    "category": "Cold & Flu",
    "rating": 4.1
}
```

### Create Antacid Tablets

```json
{
    "name": "Antacid Chewable",
    "description": "Fast relief from heartburn and acid indigestion",
    "price": 8.99,
    "stockQuantity": 200,
    "category": "Digestive Health",
    "rating": 4.0
}
```

---

## Testing Workflow

### 1. Setup Test Data

1. Create 3-4 products using the POST requests above
2. Note down the product IDs from responses

### 2. Test User Flow

1. Create an order with multiple items
2. Check your orders using my-orders endpoint
3. Try to cancel a pending order
4. View order history

### 3. Test Admin Flow (if you have admin role)

1. View all orders
2. Update order status from PENDING → CONFIRMED → SHIPPED → DELIVERED
3. Check sales statistics
4. View orders by status

### 4. Error Testing

- Try accessing admin endpoints without admin role
- Try ordering more quantity than available stock
- Try accessing someone else's order
- Try invalid order status transitions

---

## Expected Responses

### Successful Order Creation

```json
{
    "orderId": 1,
    "user": {
        "userId": 1,
        "username": "customer1"
    },
    "totalAmount": 47.48,
    "redeemedPoints": 5.0,
    "status": "PENDING",
    "items": [
        {
            "orderItemId": 1,
            "product": {
                "productId": 1,
                "name": "Paracetamol 500mg"
            },
            "quantity": 2,
            "price": 15.99
        }
    ],
    "createdAt": "2024-01-15T10:30:00",
    "updatedAt": "2024-01-15T10:30:00"
}
```

### Error Response Example

```json
{
    "error": "Insufficient stock for product: Paracetamol 500mg",
    "status": 400
}
```

---

## Environment Variables for Postman

Create these variables in your Postman environment:

- `baseUrl`: `http://localhost:8080`
- `username`: `your_username`
- `password`: `your_password`

Then use `{{baseUrl}}` in your URLs and configure Basic Auth to use `{{username}}` and `{{password}}`.