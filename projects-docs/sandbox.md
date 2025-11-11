### Basic model design by NK

#### User :

- user_id[primary-key]
- first_name
- last_name
- email[unique-key || primary-key || we can say as alternate key]
- phone_number
- password_hash
- address_id [ foreign-key]
- user_type  enum[freelancer, Client]
- created_at
- is_logged_in
- is_active



#### Address :
- address_id
- door_no
- city
- state
- country
- pin-code

#### Public Profile for freelancer

- profile_id [primary-key]
- user_id
- bio
- projects[we need to design it later as separate table for project]
- ratings
- reviews_id [ I do not have idea on designing this, but may be we can separate this as table reviews, make table reviewer, project_id,client_id , so we can have table for both side client can review the freelancer and freelancer can review the client]
- public profile URL like portfolio, LinkedIn, GitHub etc..
- hourly rate
- skills [ we need to design it later as separate table for project]
- history






###  Updated model
User
-----
user_id          PK
first_name
last_name
email            UNIQUE
phone_number     UNIQUE
password_hash
address_id       FK -> Address.address_id
user_type        ENUM('freelancer', 'client', 'admin')  -- include admin for system ops
created_at       TIMESTAMP DEFAULT NOW()
updated_at       TIMESTAMP DEFAULT NOW() ON UPDATE NOW()
is_logged_in     BOOLEAN DEFAULT FALSE
is_active        BOOLEAN DEFAULT TRUE
last_login       TIMESTAMP

Address
--------
address_id       PK
door_no
street
city
state
country
pin_code
created_at       TIMESTAMP DEFAULT NOW()




Here’s your corrected and properly structured version of the flow 👇

---

### 🔄 Corrected Flow Description

1. **Frontend Request:**  
    The frontend sends a request to a protected API endpoint.  
    This request includes an **Authorization header** with a **Bearer token**, like this:
    
    ```
    Authorization: Bearer <access_token>
    ```
    
2. **Backend Route Handling:**  
    When the request reaches the backend (FastAPI), the route handler has a dependency defined using:
    
    ```python
    Depends(oauth2_scheme)
    ```
    
    or
    
    ```python
    Depends(get_current_user)
    ```
    
3. **Dependency Injection:**  
    FastAPI automatically calls the dependency function (e.g., `get_current_user`) before executing the main route logic.  
    This function handles the **token extraction and validation**.
    
4. **Token Validation (OAuth2 Flow):**  
    Inside the dependency function, the Bearer token is:
    
    - Decoded and verified using the secret key and algorithm.
        
    - The payload (usually user ID or email) is extracted.
        
    - The database is queried to check if the user exists and is active.
        
5. **Authorization Outcome:**
    
    - ✅ **If valid:** The user object is returned, allowing the main route function to continue.
        
    - ❌ **If invalid or user doesn’t exist:** A `401 Unauthorized` exception is raised.
        

---

### ✅ Example (FastAPI)

```python
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

def get_current_user(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: str = payload.get("sub")
        if user_id is None:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED)
        # Fetch user from DB
        user = get_user_from_db(user_id)
        if user is None:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED)
        return user
    except JWTError:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED)
```

---

### 🧩 Summary Flow

**Frontend → Backend → Dependency Injection → Token Validation → User Fetch → Authorization Decision**

---

Would you like me to show the same flow with a **diagram (sequence-style)** for better visualization?
