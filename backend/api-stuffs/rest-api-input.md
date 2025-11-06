In a typical Restful API, there are **four primary ways** a client can send input to your server.

---

### 1. Path Parameters (Route Parameters)2

This is input that is part of the URL path itself, typically used to identify a **specific resource**.3 It's not optional; it's required to find the endpoint.4

- **Example:** `GET /users/123/orders/45`
    
- **Input:** The server receives `123` as the user ID and `45` as the order ID.
    

---

### 2. Query Parameters (Query String)

This is input sent as key-value pairs at the end of the URL, starting with a `?`.5 This method is ideal for **filtering, sorting, or pagination** of a collection.6

- **Example:** `GET /posts?category=tech&sort=desc&page=2`
    
- **Input:**
    
    - `category`: "tech"
        
    - `sort`: "desc"
        
    - `page`: "2"
        

---

### 3. Request Body (Payload)

This is the data sent _inside_ the HTTP request itself, not in the URL.7 It's used when you need to send complex or large amounts of data, such as **creating or updating a resource**.8

- **Used with verbs like:** `POST`, `PUT`, and `PATCH`.
    
- **Format:** Most modern APIs use **JSON** for the body.
    
- **Example:** When making a `POST /users` request, the client sends a body:
    
    JSON
    
    ```
    {
      "username": "jane_doe",
      "email": "jane@example.com",
      "age": 30
    }
    ```
    
- **Input:** The entire JSON object containing the new user's details.
    

---

### 4. HTTP Headers

Headers provide metadata _about_ the request.9 While not typically used for the _main_ data of your business logic, they are a critical form of input for **authentication, caching, and content negotiation**.

- **Example 1 (Authentication):** `Authorization: Bearer <your_jwt_token_here>`
    
- **Example 2 (Content Type):** `Content-Type: application/json` (This is the client _telling_ the server, "The body I am sending you is in JSON format.")
    
- **Example 3 (Language):** `Accept-Language: en-US`
    

---

### Summary of Methods

|**Method**|**Where is the data?**|**Primary Use Case**|**Example**|
|---|---|---|---|
|**Path Parameter**|In the URL path|Identifying a specific resource|`/users/123`|
|**Query Parameter**|End of URL (after `?`)|Filtering, sorting, paging|`/users?role=admin`|
|**Request Body**|"Inside" the request|Creating or updating data|`POST /users` (with JSON)|
|**Request Header**|Metadata of the request|Authentication, content type|`Authorization: ...`|

Would you like to see how a single framework, like FastAPI or Spring Boot, handles all four of these input types for one endpoint?