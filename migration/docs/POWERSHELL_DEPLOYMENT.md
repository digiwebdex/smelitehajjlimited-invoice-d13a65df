# 🚀 SM Elite Hajj - Complete VPS Deployment Guide (PowerShell)

## ⚠️ IMPORTANT SECURITY WARNING
**Change your VPS root password and admin password IMMEDIATELY after deployment!**
Never share SSH credentials publicly.

---

## 📋 What You'll Need
- Your VPS IP: `187.77.144.38`
- Domain: `soft.smelitehajj.com`
- PowerShell on your Windows PC
- The GitHub repo: `https://github.com/digiwebdex/smelitehajjlimited-invoice-85e14d70`

---

## STEP 1: Connect to VPS via PowerShell

Open PowerShell as Administrator and run:

```powershell
ssh root@187.77.144.38
```

Type `yes` when asked, then enter your VPS password.

**You are now inside your VPS. All commands below run inside the VPS.**

---

## STEP 2: Update System & Install Required Software

Copy and paste these commands ONE BY ONE:

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install PostgreSQL
sudo apt install -y postgresql postgresql-contrib

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Verify installations
node --version
npm --version
psql --version

# Install PM2 (keeps your app running)
sudo npm install -g pm2

# Install Nginx (web server)
sudo apt install -y nginx

# Install Git
sudo apt install -y git
```

---

## STEP 3: Clone Your Project

```bash
# Go to home directory
cd /root

# Clone the project from GitHub
git clone https://github.com/digiwebdex/smelitehajjlimited-invoice-85e14d70.git sm-elite-hajj

# Go into the project
cd sm-elite-hajj
```

---

## STEP 4: Set Up PostgreSQL Database

Run these commands one by one:

```bash
# Switch to postgres user
sudo -u postgres psql
```

Now you're inside PostgreSQL. Run these SQL commands:

```sql
-- Create database
CREATE DATABASE sm_elite_hajj;

-- Create a dedicated user (CHANGE the password!)
CREATE USER sm_elite_user WITH ENCRYPTED PASSWORD 'YourSecurePassword123!';

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE sm_elite_hajj TO sm_elite_user;

-- Connect to the database
\c sm_elite_hajj

-- Grant schema permissions
GRANT ALL ON SCHEMA public TO sm_elite_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO sm_elite_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO sm_elite_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO sm_elite_user;

-- Exit PostgreSQL
\q
```

---

## STEP 5: Import Database Schema & Data

```bash
# Go to project directory
cd /root/sm-elite-hajj

# Import the complete database setup (tables, functions, triggers, indexes)
PGPASSWORD='YourSecurePassword123!' psql -h localhost -U sm_elite_user -d sm_elite_hajj -f migration/database/complete_setup.sql

# Import your data (invoices, companies, etc.)
PGPASSWORD='YourSecurePassword123!' psql -h localhost -U sm_elite_user -d sm_elite_hajj -f migration/database/data.sql
```

---

## STEP 6: Create Admin User Password

The data.sql has a placeholder password hash. Let's set the correct password for your admin:

```bash
# Generate bcrypt hash for your password (change Admin123@ to whatever you want)
node -e "const bcrypt = require('bcryptjs'); bcrypt.hash('Admin123@', 12).then(h => console.log(h));"
```

Wait - we need bcryptjs first. Let's do it in the backend folder:

```bash
cd /root/sm-elite-hajj/migration/backend
npm install

# Now generate the hash
node -e "const bcrypt = require('bcryptjs'); bcrypt.hash('Admin123@', 12).then(h => console.log(h));"
```

Copy the output (it looks like `$2a$12$xxxxx...`), then:

```bash
# Update the admin password in database
sudo -u postgres psql sm_elite_hajj
```

```sql
-- Replace THE_HASH_FROM_ABOVE with the actual hash you copied
UPDATE users SET password_hash = 'THE_HASH_FROM_ABOVE' WHERE email = 'smelitehajj@gmail.com';

-- Verify the user exists
SELECT id, email FROM users;
SELECT * FROM profiles;
SELECT * FROM user_roles;

\q
```

---

## STEP 7: Configure Backend API

```bash
cd /root/sm-elite-hajj/migration/backend

# Create .env file
cat > .env << 'EOF'
DB_HOST=localhost
DB_PORT=5432
DB_NAME=sm_elite_hajj
DB_USER=sm_elite_user
DB_PASSWORD=YourSecurePassword123!
JWT_SECRET=CHANGE_THIS_TO_A_LONG_RANDOM_STRING_USE_THE_COMMAND_BELOW
PORT=3001
BASE_URL=https://soft.smelitehajj.com
CORS_ORIGIN=https://soft.smelitehajj.com
EOF
```

Now generate a proper JWT secret:

```bash
# Generate random JWT secret
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

Copy the output and update the .env file:

```bash
nano .env
```

Replace `CHANGE_THIS_TO_A_LONG_RANDOM_STRING_USE_THE_COMMAND_BELOW` with the random string.

Press `Ctrl+X`, then `Y`, then `Enter` to save.

---

## STEP 8: Test Backend API

```bash
cd /root/sm-elite-hajj/migration/backend

# Test that it starts
node server.js
```

You should see: `SM Elite Hajj API server running on port 3001`

Press `Ctrl+C` to stop it.

Now start it with PM2 (keeps it running forever):

```bash
pm2 start server.js --name sm-elite-api
pm2 save
pm2 startup
```

Test the API:

```bash
curl http://localhost:3001/api/health
```

You should see: `{"status":"ok","database":"connected"}`

---

## STEP 9: Build Frontend

**⚠️ IMPORTANT: Before building, you need to modify the frontend code to use your API instead of Supabase. See STEP 9B below.**

For now, let's prepare:

```bash
cd /root/sm-elite-hajj

# Install frontend dependencies
npm install

# Build frontend
npm run build

# The built files are in the 'dist' folder
ls dist/
```

---

## STEP 9B: Frontend Code Changes (CRITICAL)

The frontend currently uses Supabase SDK. You need to replace it with API calls to your backend.

**This is the most complex part.** You have two options:

### Option A: Ask me (Lovable) to rewrite the frontend hooks
Come back to Lovable and ask me to:
> "Rewrite all frontend hooks (useInvoices, useCompanies, useAdmin, useBranding, useTheme, AuthContext) to use fetch() calls to my backend API at https://soft.smelitehajj.com/api instead of Supabase SDK"

### Option B: Manual approach
You'd need to edit these files to replace `supabase.from(...)` calls with `fetch('/api/...')` calls:
- `src/contexts/AuthContext.tsx`
- `src/hooks/useInvoices.ts`
- `src/hooks/useCompanies.ts`
- `src/hooks/useAdmin.ts`
- `src/hooks/useTheme.ts`
- `src/hooks/useBranding.ts`
- `src/pages/PublicInvoiceView.tsx`
- `src/pages/ResetPassword.tsx`

**I strongly recommend Option A** - come back and ask me to do this for you.

---

## STEP 10: Configure Nginx

```bash
# Create Nginx config for your site
sudo nano /etc/nginx/sites-available/soft.smelitehajj.com
```

Paste this content:

```nginx
server {
    listen 80;
    server_name soft.smelitehajj.com;

    # Frontend - serve the built React app
    location / {
        root /root/sm-elite-hajj/dist;
        try_files $uri $uri/ /index.html;
    }

    # Backend API proxy
    location /api/ {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        client_max_body_size 10M;
    }

    # Uploaded files
    location /uploads/ {
        proxy_pass http://localhost:3001;
        proxy_set_header Host $host;
    }
}
```

Save with `Ctrl+X`, `Y`, `Enter`.

```bash
# Enable the site
sudo ln -sf /etc/nginx/sites-available/soft.smelitehajj.com /etc/nginx/sites-enabled/

# Test Nginx config
sudo nginx -t

# If it says "ok", reload Nginx
sudo systemctl reload nginx
```

---

## STEP 11: Set Up SSL (HTTPS)

```bash
# Install Certbot
sudo apt install -y certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d soft.smelitehajj.com
```

Follow the prompts:
1. Enter your email
2. Agree to terms (Y)
3. Choose whether to share email (your choice)
4. Choose to redirect HTTP to HTTPS (option 2)

---

## STEP 12: Point Your Domain

Go to your domain registrar and add:

| Type | Name | Value |
|------|------|-------|
| A    | soft | 187.77.144.38 |

Wait for DNS propagation (can take up to 24 hours).

---

## STEP 13: Verify Everything Works

```bash
# Check PM2 is running
pm2 status

# Check Nginx is running
sudo systemctl status nginx

# Check database
PGPASSWORD='YourSecurePassword123!' psql -h localhost -U sm_elite_user -d sm_elite_hajj -c "SELECT COUNT(*) FROM invoices;"

# Test API
curl https://soft.smelitehajj.com/api/health

# Check logs if something is wrong
pm2 logs sm-elite-api
sudo tail -50 /var/log/nginx/error.log
```

---

## 🔧 Common Troubleshooting

### "Connection refused" on port 3001
```bash
pm2 restart sm-elite-api
pm2 logs sm-elite-api
```

### "502 Bad Gateway"
```bash
# Check if API is running
pm2 status
# Restart it
pm2 restart sm-elite-api
```

### Database connection error
```bash
# Check PostgreSQL is running
sudo systemctl status postgresql
# Restart it
sudo systemctl restart postgresql
```

### Need to update code
```bash
cd /root/sm-elite-hajj
git pull
npm install
npm run build
pm2 restart sm-elite-api
```

---

## 📋 Quick Reference Commands

| Action | Command |
|--------|---------|
| Connect to VPS | `ssh root@187.77.144.38` |
| View API logs | `pm2 logs sm-elite-api` |
| Restart API | `pm2 restart sm-elite-api` |
| Restart Nginx | `sudo systemctl restart nginx` |
| Restart PostgreSQL | `sudo systemctl restart postgresql` |
| Connect to database | `PGPASSWORD='YourSecurePassword123!' psql -h localhost -U sm_elite_user -d sm_elite_hajj` |
| Rebuild frontend | `cd /root/sm-elite-hajj && npm run build` |
| View all PM2 apps | `pm2 status` |
| View Nginx error logs | `sudo tail -50 /var/log/nginx/error.log` |

---

## ⚠️ REMEMBER

1. **Change all passwords** after setup
2. **The frontend needs code changes** (Step 9B) before it will work with the new backend
3. **Come back to Lovable** and ask me to rewrite the frontend to use your API
4. All new data you add through the website will be saved in your VPS PostgreSQL database
