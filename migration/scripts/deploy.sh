#!/bin/bash
# ============================================
# SM Elite Hajj Invoice - Secure Deploy Script
# LOCKED: port 3003, db port 5440, db sm_elite_hajj
# ============================================

set -e

PROJECT_DIR="/var/www/smelitehajj"
BACKEND_DIR="${PROJECT_DIR}/migration/backend"
PM2_APP_NAME="smelitehajj-api"
LOCKED_PORT=3003
LOCKED_DB_PORT=5440
LOCKED_DB_NAME="sm_elite_hajj"

echo "============================================"
echo "  SM Elite Hajj Invoice - Secure Deployment"
echo "============================================"

# 1. Verify port is not taken by another project
PORT_USER=$(lsof -ti:${LOCKED_PORT} 2>/dev/null || true)
if [ -n "$PORT_USER" ]; then
    PORT_PROCESS=$(ps -p $PORT_USER -o comm= 2>/dev/null || echo "unknown")
    PM2_NAME=$(pm2 jlist 2>/dev/null | python3 -c "
import sys, json
try:
    apps = json.load(sys.stdin)
    for a in apps:
        if a.get('pid') == $PORT_USER:
            print(a.get('name',''))
            break
except: pass
" 2>/dev/null || true)
    
    if [ "$PM2_NAME" != "$PM2_APP_NAME" ] && [ -n "$PM2_NAME" ]; then
        echo "ERROR: Port ${LOCKED_PORT} is used by another project: ${PM2_NAME}"
        echo "This port is RESERVED for ${PM2_APP_NAME}."
        echo "Please use a different port for the other project."
        exit 1
    fi
fi

# 2. Pull latest code
cd "$PROJECT_DIR"
echo "Pulling latest code..."
git fetch origin
git reset --hard origin/main

# 3. Build frontend
echo "Building frontend..."
npm install --production=false
npm run build

# 4. Setup backend
echo "Setting up backend..."
cd "$BACKEND_DIR"
npm install --production

# 5. Verify .env has correct locked values
if [ -f .env ]; then
    CURRENT_PORT=$(grep -E "^PORT=" .env | cut -d= -f2)
    CURRENT_DB_PORT=$(grep -E "^DB_PORT=" .env | cut -d= -f2)
    CURRENT_DB_NAME=$(grep -E "^DB_NAME=" .env | cut -d= -f2)
    
    if [ "$CURRENT_PORT" != "$LOCKED_PORT" ]; then
        echo "WARNING: .env PORT ($CURRENT_PORT) != locked port ($LOCKED_PORT). Fixing..."
        sed -i "s/^PORT=.*/PORT=${LOCKED_PORT}/" .env
    fi
    if [ "$CURRENT_DB_PORT" != "$LOCKED_DB_PORT" ]; then
        echo "WARNING: .env DB_PORT ($CURRENT_DB_PORT) != locked port ($LOCKED_DB_PORT). Fixing..."
        sed -i "s/^DB_PORT=.*/DB_PORT=${LOCKED_DB_PORT}/" .env
    fi
    if [ "$CURRENT_DB_NAME" != "$LOCKED_DB_NAME" ]; then
        echo "WARNING: .env DB_NAME ($CURRENT_DB_NAME) != locked name ($LOCKED_DB_NAME). Fixing..."
        sed -i "s/^DB_NAME=.*/DB_NAME=${LOCKED_DB_NAME}/" .env
    fi
fi

# 6. Restart API with locked env
echo "Restarting API..."
pm2 delete "$PM2_APP_NAME" 2>/dev/null || true
pm2 start ecosystem.config.js
pm2 save

# 7. Verify
sleep 3
HEALTH=$(curl -sf http://localhost:${LOCKED_PORT}/api/health 2>/dev/null || echo "FAILED")
if echo "$HEALTH" | grep -q "ok"; then
    echo ""
    echo "============================================"
    echo "  DEPLOYMENT SUCCESSFUL"
    echo "  API: http://localhost:${LOCKED_PORT}"
    echo "  DB:  ${LOCKED_DB_NAME} on port ${LOCKED_DB_PORT}"
    echo "  Frontend: ${PROJECT_DIR}/dist"
    echo "============================================"
else
    echo ""
    echo "WARNING: Health check failed!"
    echo "Response: $HEALTH"
    echo "Check: pm2 logs $PM2_APP_NAME --lines 20"
    exit 1
fi
