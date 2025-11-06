
### What is CORS?

CORS stands for **Cross-Origin Resource Sharing**.1

In simple terms, **CORS is a security mechanism that allows a web page from one domain (or "origin") to request resources from another domain.2**

By default, web browsers block these cross-domain requests for security reasons.3 CORS is the standard way to _safely_ tell the browser, "It's okay, this other domain is allowed to access my resources."4

---

### The Problem: The "Same-Origin Policy"

To understand why CORS exists, you first need to know about the **Same-Origin Policy** (SOP).5

- The SOP is a strict security rule built into every modern web browser.
    
- It states that a web page can only request data from the **same origin** it was loaded from.6
    
- An "origin" is the combination of the protocol (like `https`://), the domain (like `my-website.com`), and the port (like `:80`).7
    

**Example of the problem:**

Imagine your JavaScript code running on your website, `https://www.my-cool-site.com`. This code tries to fetch data from an API server at `https://api.weather-service.com`.

Without CORS, the browser would block this request and show an error in the console, because `www.my-cool-site.com` and `api.weather-service.com` are **different origins**.8

This security rule is crucial. Without it, any malicious website you visit (`evil.com`) could use your browser to make requests to your online bank (`my-bank.com`), potentially stealing your data, since your browser _is_ logged into your bank.9 The SOP prevents this.10

### The Solution: How CORS Works

CORS "relaxes" the Same-Origin Policy in a controlled way.11 It works by adding special **HTTP headers** to the communication between the browser and the server.12

Think of it as a security checkpoint:

1. **The Browser Asks for Permission:** When your site (`my-cool-site.com`) tries to fetch data from `api.weather-service.com`, the browser automatically adds a new header to the request, called `Origin`.13
    
    - `Origin: https://www.my-cool-site.com`
        
2. **The Server Grants Permission:** The API server (`api.weather-service.com`) receives this request.14 It looks at the `Origin` header and decides if it trusts that domain.15
    
    - If it does trust your site, it sends its response back with a special header:16
        
        Access-Control-Allow-Origin: https://www.my-cool-site.com
        
    - (Or, it could allow _any_ site by using a wildcard: `Access-Control-Allow-Origin: *`)
        
3. **The Browser Checks the "Pass":** Your browser receives the response.17 It checks if the `Access-Control-Allow-Origin` header is present and if it matches your site's origin.18
    
    - **If it matches:** The browser allows your JavaScript code to access the data.19
        
    - **If it doesn't match (or is missing):** The browser _still_ blocks the request and shows the famous CORS error.20
        

> **Key Takeaway:** CORS is not an error on your frontend code. It's a **server-side security configuration**. To fix a CORS error, you must configure the _server_ (the API) to send the correct `Access-Control-Allow-Origin` headers.21

---

### A Quick Look at "Preflight" Requests

For more complex requests (like `PUT`, `DELETE`, or those with custom headers like `Authorization`), the browser adds an extra safety step called a **preflight request**.22

1. Before sending the _actual_ request (e.g., the `DELETE` request), the browser first sends a "preflight" request using the `OPTIONS` method to the server.23
    
2. This `OPTIONS` request basically asks, "Hey, is it okay if I send a `DELETE` request from this origin with an `Authorization` header?"24
    
3. The server then replies with headers like `Access-Control-Allow-Methods: GET, POST, DELETE` and `Access-Control-Allow-Headers: Authorization`.25
    
4. If the server's reply approves the method and headers, the browser then sends the _actual_ `DELETE` request.26 If not, it blocks it.27
    