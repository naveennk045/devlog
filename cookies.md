### tree commands

` tree -I "*.log|*.pyc|*.tmp|*__pycache__|sandbox|.venv|.idea|.git" -a`

----

#  **1. Build Your Containers**

### **Build everything**

```bash
docker compose build
```

### **Force rebuild (no cache)**

```bash
docker compose build --no-cache
```

---

#  **2. Start Containers**

### **Start everything in background**

```bash
docker compose up -d
```

### **Start + show logs live (best for debugging)**

```bash
docker compose up
```

This is the one you want when starting the project and seeing logs in same shell.

---

#  **3. Stop Containers**

### **Stop all**

```bash
docker compose down
```

### **Stop and remove volumes too (fresh DB)**

⚠ This wipes Postgres & Redis data.

```bash
docker compose down -v
```

---

#  **4. View Logs**

### **All services (live stream)**

```bash
docker compose logs -f
```

### **All services + last 100 lines + live**

```bash
docker compose logs --tail=100 -f
```

### **Specific container logs**

```bash
docker logs -f ktr-kiosk-backend-backend-1
docker logs -f ktr-kiosk-backend-postgres-1
docker logs -f ktr-kiosk-backend-redis-1
```

---

#  **5. Shell Into a Container**

Backend:

```bash
docker exec -it ktr-kiosk-backend-backend-1 bash
```

Postgres:

```bash
docker exec -it ktr-kiosk-backend-postgres-1 sh
```

Redis:

```bash
docker exec -it ktr-kiosk-backend-redis-1 sh
```

---

#  **6. Clean Up System**

### **Remove stopped containers**

```bash
docker container prune
```

### **Remove unused images**

```bash
docker image prune
```

### **Full clean (be careful!)**

```bash
docker system prune -a
```

---

#  **7. Check Containers, Images, Networks**

### **List running containers**

```bash
docker ps
```

### **List all containers**

```bash
docker ps -a
```

### **List images**

```bash
docker images
```

### **List Docker networks**

```bash
docker network ls
```

---

#  **8. Rebuild & Restart Quickly (Most Used)**

The NK special one-liner 🔥:

```bash
docker compose down -v && docker compose build --no-cache && docker compose up
```

Starts everything + full logs in one shell.

---

# 🎁 **9. Check Your App Inside Container**

### Test API from inside backend

```bash
docker exec -it ktr-kiosk-backend-backend-1 curl http://127.0.0.1:8000
```

### Check Redis connectivity

```bash
docker exec -it ktr-kiosk-backend-backend-1 nc -zv redis 6379
```

### Check Postgres connectivity

```bash
docker exec -it ktr-kiosk-backend-backend-1 nc -zv postgres 5432
```

---

# 🧙 **10. Magic Dev Script (optional)**

If you want one script to run EVERYTHING:

Create a file `dev.sh`:

```bash
#!/bin/bash
docker compose down -v
docker compose build --no-cache
docker compose up
```

Then run:

```bash
bash dev.sh
```

---


``