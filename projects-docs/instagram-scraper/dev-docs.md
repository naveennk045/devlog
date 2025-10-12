# Instagram Scraper Web Application - User Documentation

## Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Installation & Setup](#installation--setup)
4. [API Documentation](#api-documentation)
5. [Frontend Usage Guide](#frontend-usage-guide)
6. [Configuration](#configuration)
7. [Deployment](#deployment)
8. [Monitoring & Troubleshooting](#monitoring--troubleshooting)
9. [Code Examples](#code-examples)
10. [Best Practices](#best-practices)
11. [Security Considerations](#security-considerations)

## Overview

The Instagram Scraper Web Application is a comprehensive tool designed to extract data from Instagram profiles, followers, followings, and posts/reels using multiple logged-in Instagram accounts. The system handles high-volume data extraction (up to 30,000–40,000 items) while maintaining queue management, concurrency limits, and CSV export functionality.

### Key Features

- **Multi-Account Management**: Rotate between multiple Instagram accounts to distribute load
- **Queue System**: Background processing with real-time progress tracking
- **Data Export**: Automatic CSV generation with downloadable files
- **Anti-Detection**: Advanced measures to avoid Instagram's anti-bot systems
- **Scalable Architecture**: Docker-based deployment with horizontal scaling support
- **Real-time Monitoring**: Live dashboard with Flower integration

## Architecture

The system follows a microservices architecture with the following components:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   FastAPI       │    │   Celery        │
│   (React.js)    │◄───┤   Backend       │◄───┤   Workers       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                        │
                       ┌─────────────────┐    ┌─────────────────┐
                       │   PostgreSQL    │    │   Redis         │
                       │   Database      │    │   Queue         │
                       └─────────────────┘    └─────────────────┘
                                │
                       ┌─────────────────┐
                       │   Selenium      │
                       │   Scrapers      │
                       └─────────────────┘
```

### Technology Stack

- **Backend**: Python 3.10, FastAPI, SQLAlchemy
- **Frontend**: React.js, HTML5, CSS3, JavaScript
- **Queue System**: Celery with Redis broker
- **Database**: PostgreSQL
- **Web Scraping**: Selenium with undetected-chromedriver
- **Containerization**: Docker & Docker Compose
- **Proxy Server**: Nginx
- **Monitoring**: Flower (Celery monitoring)

## Installation & Setup

### Prerequisites

- Docker & Docker Compose installed
- Python 3.10+ (for development)
- Node.js 16+ (for frontend development)
- At least 4GB RAM and 10GB disk space

### Quick Start with Docker

1. **Clone the repository** (or create project structure)
```bash
mkdir instagram-scraper && cd instagram-scraper
```

2. **Create project files** (see Code Examples section)

3. **Set up environment variables**
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. **Deploy with Docker Compose**
```bash
chmod +x deploy.sh
./deploy.sh
```

5. **Access the application**
- Web Interface: `http://localhost`
- API Documentation: `http://localhost/docs`
- Monitoring (Flower): `http://localhost:5555`

### Manual Development Setup

1. **Backend Setup**
```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Set up database
alembic upgrade head

# Start FastAPI server
uvicorn main:app --reload
```

2. **Frontend Setup**
```bash
cd frontend
npm install
npm start
```

3. **Start Celery Workers**
```bash
# Terminal 1: Start worker
celery -A celery_app worker --loglevel=info

# Terminal 2: Start beat scheduler
celery -A celery_app beat --loglevel=info

# Terminal 3: Start Flower monitoring
celery -A celery_app flower --port=5555
```

## API Documentation

### Authentication
The system is designed for internal use only. No external authentication is required, but API access should be restricted via IP whitelist.

### Core Endpoints

#### Account Management

**POST /api/login-account**
```json
{
  "username": "instagram_username",
  "password": "instagram_password"
}
```
Response:
```json
{
  "message": "Account added successfully",
  "account_id": "uuid-string"
}
```

**GET /api/accounts**
```json
{
  "accounts": [
    {
      "id": "uuid-string",
      "username": "instagram_username",
      "status": "active|inactive|blocked",
      "last_used": "2024-01-15T10:30:00Z",
      "login_time": "2024-01-15T09:00:00Z"
    }
  ]
}
```

#### Scraping Jobs

**POST /api/scrape/followers**
```json
{
  "profile_url": "https://www.instagram.com/username/",
  "scrape_type": "followers|following"
}
```

**POST /api/scrape/posts**
```json
{
  "post_urls": [
    "https://www.instagram.com/p/post_id_1/",
    "https://www.instagram.com/p/post_id_2/"
  ]
}
```

#### Job Management

**GET /api/jobs** - List all jobs
**GET /api/job/{job_id}** - Get specific job status
**GET /api/job/{job_id}/download** - Download CSV results

### Response Status Codes

- `200`: Success
- `400`: Bad Request (invalid input)
- `404`: Job/Resource not found
- `429`: Rate limit exceeded
- `500`: Internal server error

## Frontend Usage Guide

### Dashboard Overview

The main dashboard provides four key sections:

1. **Statistics Bar**: Shows active accounts, queued jobs, and running jobs
2. **Account Manager**: Add, view, and manage Instagram accounts
3. **Scraping Panel**: Configure and submit scraping jobs
4. **Queue Status**: Monitor active and completed jobs

### Adding Instagram Accounts

1. Click **"Add Account"** in the Account Manager panel
2. Enter Instagram username and password
3. Click **"Add Account"** - the system will validate credentials
4. Account status will update to show login success/failure

### Starting a Scraping Job

#### For Followers/Following:
1. Select **"Followers/Following"** tab
2. Enter target Instagram profile URL
3. Choose scrape type (followers or following)
4. Click **"Start Scraping"**

#### For Posts/Reels:
1. Select **"Posts/Reels"** tab
2. Either:
   - Enter post URLs (one per line) in text area
   - Upload a CSV file with URLs
3. Click **"Start Scraping"**

### Monitoring Progress

- **Active Queue**: Shows currently running and queued jobs
- **Progress Bars**: Real-time progress for active jobs
- **Status Updates**: Live status messages (e.g., "Scraping 350/2000 followers...")

### Downloading Results

1. Wait for job to complete (status shows ✅)
2. Click **"Download CSV"** button in completed jobs section
3. File downloads automatically with naming format: `scrapeType_jobId_datetime.csv`

## Configuration

### Environment Variables

```bash
# Database
DATABASE_URL=postgresql://user:password@host:port/database
REDIS_URL=redis://host:port/db

# Security
ENCRYPTION_KEY=your-32-byte-encryption-key-here
SECRET_KEY=your-secret-key-for-sessions

# Application
DEBUG=false
LOG_LEVEL=INFO
MAX_CONCURRENT_JOBS=3

# Instagram
DEFAULT_MAX_FOLLOWERS=1000
DEFAULT_MAX_POSTS=500
SCRAPE_DELAY_MIN=2
SCRAPE_DELAY_MAX=5
```

### Proxy Configuration

For high-volume scraping, configure proxy rotation:

```python
# In your scraper configuration
PROXY_LIST = [
    "http://proxy1:port",
    "http://proxy2:port",
    "http://proxy3:port"
]

PROXY_ROTATION = True
```

### Rate Limiting

Configure scraping speed to avoid detection:

```python
# In scraper settings
REQUESTS_PER_MINUTE = 30
ACCOUNTS_ROTATION_DELAY = 300  # 5 minutes
MAX_RETRY_ATTEMPTS = 3
BACKOFF_FACTOR = 2
```

## Deployment

### Production Deployment

1. **Server Requirements**
   - 4+ CPU cores
   - 8GB+ RAM
   - 50GB+ SSD storage
   - Ubuntu 20.04+ or CentOS 8+

2. **Security Setup**
```bash
# Firewall configuration
ufw allow 80
ufw allow 443
ufw deny 8000  # Block direct API access
ufw deny 5555  # Block direct Flower access
ufw enable
```

3. **SSL Configuration**
```nginx
server {
    listen 443 ssl http2;
    server_name your-domain.com;
    
    ssl_certificate /path/to/certificate.crt;
    ssl_certificate_key /path/to/private.key;
    
    # Rest of configuration...
}
```

4. **Database Backup**
```bash
# Setup automated backups
crontab -e
# Add: 0 2 * * * pg_dump instagram_scraper > /backups/db_$(date +\%Y\%m\%d).sql
```

### Scaling Considerations

**Horizontal Scaling:**
- Deploy multiple Celery workers across different servers
- Use shared Redis instance for queue coordination
- Implement load balancing for API requests

**Vertical Scaling:**
- Increase worker concurrency based on available CPU/RAM
- Optimize database queries with proper indexing
- Use connection pooling for database access

## Monitoring & Troubleshooting

### Flower Monitoring Dashboard

Access Flower at `http://localhost:5555` to monitor:
- Active workers and tasks
- Task success/failure rates
- Queue lengths and processing times
- Worker resource utilization

### Log Analysis

**Application Logs:**
```bash
docker-compose logs -f app
docker-compose logs -f celery_worker
```

**Common Issues:**

1. **Instagram Account Blocked**
   - Check account status in dashboard
   - Reduce scraping frequency
   - Rotate to different accounts

2. **High Memory Usage**
   - Monitor Chrome processes
   - Restart workers periodically
   - Implement memory limits in Docker

3. **Queue Backlog**
   - Scale up worker instances
   - Optimize scraping speed settings
   - Check for failed tasks blocking queue

### Health Checks

Implement automated health monitoring:

```python
@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "database": check_database_connection(),
        "redis": check_redis_connection(),
        "workers": get_active_worker_count()
    }
```

## Code Examples

### FastAPI Backend Structure

```python
from fastapi import FastAPI, HTTPException, BackgroundTasks
from fastapi.responses import JSONResponse, FileResponse
from pydantic import BaseModel
from typing import List, Optional
import uuid
from datetime import datetime
import os

app = FastAPI(title="Instagram Scraper API", version="1.0.0")

# Data models
class AccountModel(BaseModel):
    username: str
    password: str
    
class ScrapeFollowersRequest(BaseModel):
    profile_url: str
    scrape_type: str  # "followers" or "following"
    
class ScrapePostsRequest(BaseModel):
    post_urls: List[str]
    
class JobResponse(BaseModel):
    job_id: str
    status: str
    created_at: datetime
    queue_position: int = None

# Sample endpoints
@app.post("/api/login-account")
async def add_account(account: AccountModel):
    # Add Instagram account logic here
    return {"message": "Account added successfully", "account_id": str(uuid.uuid4())}

@app.get("/api/accounts")
async def get_accounts():
    # Return list of accounts with status
    return {"accounts": []}

@app.post("/api/scrape/followers")
async def scrape_followers(request: ScrapeFollowersRequest):
    job_id = str(uuid.uuid4())
    # Add to queue logic here
    return JobResponse(
        job_id=job_id,
        status="queued",
        created_at=datetime.now(),
        queue_position=1
    )

@app.get("/api/job/{job_id}/download")
async def download_csv(job_id: str):
    file_path = f"/downloads/{job_id}.csv"
    if os.path.exists(file_path):
        return FileResponse(file_path, media_type='text/csv', filename=f"{job_id}.csv")
    raise HTTPException(status_code=404, detail="File not found")
```

### Selenium Scraper Implementation

```python
import undetected_chromedriver as uc
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import random
import csv
from datetime import datetime
import logging

class InstagramScraper:
    def __init__(self, use_proxy=False, proxy_list=None):
        self.driver = None
        self.use_proxy = use_proxy
        self.proxy_list = proxy_list or []
        self.logged_in_accounts = {}
        
    def setup_driver(self, headless=True):
        '''Setup undetected chromedriver with anti-detection measures'''
        options = uc.ChromeOptions()
        
        if headless:
            options.add_argument('--headless')
            
        # Anti-detection options
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-dev-shm-usage')
        options.add_argument('--disable-blink-features=AutomationControlled')
        options.add_experimental_option("excludeSwitches", ["enable-automation"])
        options.add_experimental_option('useAutomationExtension', False)
        
        # Random user agent
        user_agents = [
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36',
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36'
        ]
        options.add_argument(f'--user-agent={random.choice(user_agents)}')
        
        self.driver = uc.Chrome(options=options)
        self.driver.execute_script("Object.defineProperty(navigator, 'webdriver', {get: () => undefined})")
        
        return self.driver
    
    def login(self, username, password):
        '''Login to Instagram account'''
        try:
            self.driver.get("https://www.instagram.com/accounts/login/")
            time.sleep(random.uniform(3, 5))
            
            # Wait for and fill username
            username_input = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.NAME, "username"))
            )
            for char in username:
                username_input.send_keys(char)
                time.sleep(random.uniform(0.05, 0.15))
            
            # Fill password
            password_input = self.driver.find_element(By.NAME, "password")
            for char in password:
                password_input.send_keys(char)
                time.sleep(random.uniform(0.05, 0.15))
            
            # Submit login
            login_button = self.driver.find_element(By.XPATH, "//button[@type='submit']")
            login_button.click()
            time.sleep(random.uniform(5, 8))
            
            # Check login success
            if "instagram.com/accounts/login/" not in self.driver.current_url:
                self.logged_in_accounts[username] = {'status': 'active', 'login_time': datetime.now()}
                return True
            return False
                
        except Exception as e:
            logging.error(f"Login error for {username}: {str(e)}")
            return False
    
    def scrape_followers(self, profile_url, max_followers=1000):
        '''Scrape followers list from a profile'''
        try:
            self.driver.get(profile_url)
            time.sleep(random.uniform(3, 5))
            
            # Click followers link
            followers_link = WebDriverWait(self.driver, 10).until(
                EC.element_to_be_clickable((By.XPATH, "//a[contains(@href, '/followers/')]"))
            )
            followers_link.click()
            time.sleep(random.uniform(3, 5))
            
            followers_data = []
            loaded_followers = 0
            
            while loaded_followers < max_followers:
                # Scroll to load more
                self.driver.execute_script(
                    "arguments[0].scrollTop = arguments[0].scrollHeight",
                    self.driver.find_element(By.XPATH, "//div[@role='dialog']//div[2]")
                )
                time.sleep(random.uniform(2, 4))
                
                # Extract follower data
                follower_elements = self.driver.find_elements(
                    By.XPATH, "//div[@role='dialog']//a[contains(@href, '/')]"
                )
                
                for element in follower_elements[loaded_followers:]:
                    try:
                        username = element.get_attribute('href').split('/')[-2]
                        full_name_element = element.find_element(By.XPATH, ".//span")
                        full_name = full_name_element.text if full_name_element else ""
                        
                        followers_data.append({
                            'username': username,
                            'full_name': full_name,
                            'profile_url': element.get_attribute('href'),
                            'scraped_at': datetime.now().isoformat()
                        })
                        
                        loaded_followers += 1
                        if loaded_followers >= max_followers:
                            break
                    except Exception as e:
                        logging.warning(f"Error processing follower: {str(e)}")
                        continue
                
                if len(follower_elements) == loaded_followers:
                    break
            
            return followers_data
            
        except Exception as e:
            logging.error(f"Error scraping followers: {str(e)}")
            return []
```

### Docker Deployment Configuration

```dockerfile
# Dockerfile
FROM python:3.10-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget gnupg unzip curl \
    && rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Install ChromeDriver
RUN CHROME_DRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) \
    && wget -O /tmp/chromedriver.zip "http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip" \
    && unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/ \
    && rm /tmp/chromedriver.zip \
    && chmod +x /usr/local/bin/chromedriver

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create necessary directories
RUN mkdir -p downloads logs

# Set environment variables
ENV PYTHONPATH=/app
ENV DISPLAY=:99

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  redis:
    image: redis:7-alpine
    restart: unless-stopped
    volumes:
      - redis_data:/data

  postgres:
    image: postgres:15
    restart: unless-stopped
    environment:
      POSTGRES_DB: instagram_scraper
      POSTGRES_USER: scraper_user
      POSTGRES_PASSWORD: scraper_password
    volumes:
      - postgres_data:/var/lib/postgresql/data

  app:
    build: .
    restart: unless-stopped
    ports:
      - "8000:8000"
    environment:
      - REDIS_URL=redis://redis:6379/0
      - DATABASE_URL=postgresql://scraper_user:scraper_password@postgres:5432/instagram_scraper
    volumes:
      - ./downloads:/app/downloads
    depends_on:
      - redis
      - postgres

  celery_worker:
    build: .
    restart: unless-stopped
    environment:
      - REDIS_URL=redis://redis:6379/0
      - DATABASE_URL=postgresql://scraper_user:scraper_password@postgres:5432/instagram_scraper
    volumes:
      - ./downloads:/app/downloads
      - /dev/shm:/dev/shm
    depends_on:
      - redis
      - postgres
    command: celery -A celery_app worker --loglevel=info --concurrency=2

  flower:
    build: .
    restart: unless-stopped
    ports:
      - "5555:5555"
    environment:
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - redis
    command: celery -A celery_app flower --port=5555

volumes:
  redis_data:
  postgres_data:
```

## Best Practices

### Anti-Detection Strategies

1. **Account Rotation**: Use multiple accounts and rotate usage
2. **Random Delays**: Implement variable delays between actions
3. **Human-like Behavior**: Scroll naturally, vary click patterns
4. **Proxy Rotation**: Use residential proxies for better IP reputation
5. **User Agent Rotation**: Vary browser signatures
6. **Session Management**: Maintain persistent login sessions

### Performance Optimization

1. **Concurrent Workers**: Scale based on system resources
2. **Database Indexing**: Index frequently queried columns
3. **Caching**: Use Redis for frequently accessed data
4. **Resource Monitoring**: Track CPU, memory, and disk usage
5. **Queue Management**: Implement priority queues for urgent jobs

### Error Handling

1. **Retry Logic**: Implement exponential backoff for failures
2. **Circuit Breakers**: Stop processing when service is down
3. **Dead Letter Queues**: Handle permanently failed jobs
4. **Alerting**: Set up notifications for critical errors
5. **Graceful Degradation**: Continue operation with reduced functionality

## Security Considerations

### Data Protection

1. **Encryption at Rest**: Encrypt stored credentials and sensitive data
2. **Encryption in Transit**: Use HTTPS/TLS for all communications
3. **Access Control**: Implement IP whitelisting for API access
4. **Audit Logging**: Log all access and operations
5. **Data Retention**: Implement policies for data cleanup

### Network Security

1. **Firewall Rules**: Block unnecessary ports and services
2. **VPN Access**: Require VPN for administrative access
3. **Rate Limiting**: Implement API rate limiting
4. **Input Validation**: Sanitize all user inputs
5. **CORS Configuration**: Restrict cross-origin requests

### Operational Security

1. **Regular Updates**: Keep all dependencies updated
2. **Security Scanning**: Regular vulnerability assessments
3. **Backup Strategy**: Implement automated backups
4. **Incident Response**: Prepare for security incidents
5. **Access Reviews**: Regular audit of user permissions

---

## Support & Maintenance

For issues and questions:
1. Check the monitoring dashboard for system status
2. Review application logs for error details
3. Consult the API documentation for endpoint specifications
4. Monitor Instagram's terms of service for policy changes

Remember to always comply with Instagram's terms of service and applicable laws regarding data scraping and privacy.