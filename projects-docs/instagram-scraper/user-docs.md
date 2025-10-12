
# Instagram Scraper - Quick Start Example

## Step-by-Step Usage Example

This document provides a complete walkthrough of using the Instagram Scraper Web Application, from setup to downloading results.

### Prerequisites Checklist

- [ ] Docker installed and running
- [ ] At least 2 Instagram accounts for scraping
- [ ] Target Instagram profiles/posts identified
- [ ] 8GB+ RAM available
- [ ] Stable internet connection

### Example Scenario
Let's scrape followers from @natgeo and posts from travel-related accounts:

**Target Data:**
- Followers from @natgeo (up to 1000)
- Posts from 3 travel blogger accounts
- Export results as CSV files

### Step 1: Initial Setup

1. **Download and extract the application:**
```bash
# Create project directory
mkdir instagram-scraper-app
cd instagram-scraper-app

# Copy all the provided files (from documentation)
# - docker-compose.yml
# - Dockerfile
# - requirements.txt
# - main.py (FastAPI app)
# - celery_app.py
# - tasks.py
# - instagram_scraper.py
```

2. **Configure environment:**
```bash
# Create .env file
cat > .env << EOF
REDIS_URL=redis://redis:6379/0
DATABASE_URL=postgresql://scraper_user:scraper_password@postgres:5432/instagram_scraper
ENCRYPTION_KEY=my-32-byte-encryption-key-123456
DEBUG=False
LOG_LEVEL=INFO
MAX_CONCURRENT_JOBS=2
EOF
```

### Step 2: Deploy the Application

```bash
# Start all services
docker-compose up -d

# Check if services are running
docker-compose ps

# Expected output:
# NAME                STATUS              PORTS
# app                 Up                  0.0.0.0:8000->8000/tcp
# celery_worker       Up                  
# flower              Up                  0.0.0.0:5555->5555/tcp
# postgres            Up                  0.0.0.0:5432->5432/tcp
# redis               Up                  0.0.0.0:6379->6379/tcp
```

### Step 3: Access the Dashboard

1. **Open your browser to:** `http://localhost:8000`
2. **You should see the Instagram Scraper Dashboard with:**
   - Statistics bar (0 active accounts, 0 queued jobs)
   - Account Manager panel (empty)
   - Scraping Options panel
   - Queue Status panel (empty)

### Step 4: Add Instagram Accounts

1. **Click "Add Account" in the Account Manager**
2. **Enter your first Instagram account:**
   - Username: `your_first_account`
   - Password: `your_password`
   - Click "Add Account"

3. **Repeat for second account:**
   - Username: `your_second_account`  
   - Password: `your_password`
   - Click "Add Account"

4. **Verify accounts are active:**
   - Both accounts should show green "active" status
   - Statistics bar should show "2 Active Accounts"

### Step 5: Start Scraping Followers

1. **Select "Followers/Following" tab**
2. **Configure the job:**
   - Profile URL: `https://www.instagram.com/natgeo/`
   - Scrape Type: `Followers`
3. **Click "Start Scraping"**
4. **Monitor progress:**
   - Job appears in "Active Queue" section
   - Status updates in real-time
   - Progress bar shows completion percentage

### Step 6: Add Multiple Post URLs

1. **Select "Posts/Reels" tab**
2. **Enter post URLs (one per line):**
```
https://www.instagram.com/p/ABC123DEF/
https://www.instagram.com/p/GHI456JKL/
https://www.instagram.com/p/MNO789PQR/
```
3. **Click "Start Scraping"**

### Step 7: Monitor Job Progress

**Active Queue shows:**
```
🔄 Scrape Followers - natgeo        [In Progress]
   Progress: 45% - Scraping 450/1000 followers...

⏳ Scrape Posts - Multiple URLs     [Queued]
   Position in queue: 1
```

### Step 8: Download Results

1. **Wait for jobs to complete** (✅ status)
2. **In "Completed Jobs" section:**
   - Click "Download CSV" for followers data
   - Click "Download CSV" for posts data

**Expected CSV files:**
- `followers_natgeo_20241012_143022.csv`
- `posts_multiple_20241012_143115.csv`

### Step 9: Analyze CSV Data

**Followers CSV contains:**
```csv
username,full_name,profile_url,scraped_at
johndoe123,John Doe,https://www.instagram.com/johndoe123/,2024-10-12T14:30:22
traveler_sarah,Sarah Wilson,https://www.instagram.com/traveler_sarah/,2024-10-12T14:30:23
photographer_mike,,https://www.instagram.com/photographer_mike/,2024-10-12T14:30:24
```

**Posts CSV contains:**
```csv
post_url,caption,likes,comments_count,scraped_at
https://www.instagram.com/p/ABC123DEF/,"Amazing sunset in Bali! 🌅",15420,234,2024-10-12T14:31:15
https://www.instagram.com/p/GHI456JKL/,"Street food adventure in Thailand",8901,156,2024-10-12T14:31:45
```

### Step 10: Monitor System Health

1. **Check Flower dashboard:** `http://localhost:5555`
   - View worker status
   - Monitor task completion rates
   - Check for any failed tasks

2. **Check application logs:**
```bash
# View API logs
docker-compose logs -f app

# View worker logs  
docker-compose logs -f celery_worker
```

## Advanced Usage Examples

### Bulk Processing with CSV Upload

1. **Create a CSV file with post URLs:**
```csv
url
https://www.instagram.com/p/POST1/
https://www.instagram.com/p/POST2/
https://www.instagram.com/p/POST3/
```

2. **Upload via Posts/Reels tab:**
   - Click "Choose File" 
   - Select your CSV
   - URLs automatically populate

### Scheduling Large Jobs

For scraping 10,000+ followers:

1. **Add 4-5 Instagram accounts** for rotation
2. **Adjust settings** (if needed):
   - Lower concurrency to avoid detection
   - Increase delays between requests
3. **Submit job and expect 2-3 hours completion**

### Monitoring Multiple Jobs

The dashboard can handle multiple concurrent jobs:
- Followers scraping from Account A
- Posts scraping using Account B  
- Following list from Account C

## Troubleshooting Common Issues

### Account Gets Blocked
```
⚠️ Error: Login failed for account @username
```
**Solution:**
1. Check account status in Account Manager
2. Try logging in manually to Instagram
3. Wait 24 hours before retrying
4. Use different IP/proxy if available

### Slow Scraping Speed
```
Job taking longer than expected...
```
**Solution:**
1. Check system resources: `docker stats`
2. Verify internet connection speed
3. Ensure target profile is public
4. Try with smaller batch sizes

### Out of Memory Errors
```
Chrome process killed (out of memory)
```
**Solution:**
1. Restart services: `docker-compose restart`
2. Reduce concurrent jobs: `MAX_CONCURRENT_JOBS=1`
3. Increase system RAM or use smaller batches

### Queue Not Processing
```
Jobs stuck in "Queued" status
```
**Solution:**
1. Check Celery workers: `docker-compose logs celery_worker`
2. Restart workers: `docker-compose restart celery_worker`
3. Check Redis connection: `docker-compose logs redis`

## Production Tips

### For High-Volume Scraping (10k+ items):

1. **Use multiple worker instances:**
```bash
docker-compose up --scale celery_worker=3
```

2. **Implement proxy rotation:**
   - Use residential proxy service
   - Configure proxy list in scraper
   - Rotate proxies every 100 requests

3. **Account management:**
   - Use 5-10 aged Instagram accounts
   - Rotate accounts every 30 minutes
   - Monitor account health daily

4. **Resource monitoring:**
   - Set up alerts for high CPU/memory usage
   - Monitor disk space for CSV files
   - Implement automated cleanup of old files

### Data Quality Best Practices:

1. **Verify scraped data:**
   - Check CSV files for completeness
   - Validate URLs and usernames
   - Remove duplicate entries

2. **Handle rate limits gracefully:**
   - Implement exponential backoff
   - Use multiple IP addresses
   - Respect Instagram's terms of service

3. **Backup important data:**
   - Regular database backups
   - Archive completed CSV files
   - Maintain configuration backups

## API Integration Example

You can also use the API directly:

```python
import requests
import time

# Add account
response = requests.post('http://localhost:8000/api/login-account', 
                        json={'username': 'your_account', 'password': 'your_password'})
print(response.json())

# Start followers scrape
response = requests.post('http://localhost:8000/api/scrape/followers',
                        json={'profile_url': 'https://www.instagram.com/natgeo/', 
                              'scrape_type': 'followers'})
job_data = response.json()
job_id = job_data['job_id']

# Monitor progress
while True:
    response = requests.get(f'http://localhost:8000/api/job/{job_id}')
    status = response.json()
    print(f"Status: {status['status']}, Progress: {status.get('progress', 0)}%")

    if status['status'] in ['completed', 'failed']:
        break
    time.sleep(10)

# Download results
if status['status'] == 'completed':
    response = requests.get(f'http://localhost:8000/api/job/{job_id}/download')
    with open(f'{job_id}.csv', 'wb') as f:
        f.write(response.content)
    print(f"Downloaded results to {job_id}.csv")
```

This completes the practical usage example. The system is now ready for production use with proper monitoring and maintenance procedures in place.