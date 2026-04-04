#!/bin/bash
# ============================================
# SM Elite Hajj - Database Security Setup
# Run ONCE on VPS to create dedicated DB user
# ============================================

set -e

DB_PORT=5440
DB_NAME="sm_elite_hajj"
DB_USER="sm_elite_user"
DB_PASS="SmEliteHajj2026Pass"

echo "Setting up dedicated database user..."

sudo -u postgres psql -p $DB_PORT << EOF
-- Create dedicated user (if not exists)
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${DB_USER}') THEN
    CREATE ROLE ${DB_USER} WITH LOGIN PASSWORD '${DB_PASS}';
  ELSE
    ALTER ROLE ${DB_USER} WITH PASSWORD '${DB_PASS}';
  END IF;
END
\$\$;

-- Grant access ONLY to sm_elite_hajj database
GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO ${DB_USER};

-- Connect to the database and grant schema access
\c ${DB_NAME}
GRANT USAGE ON SCHEMA public TO ${DB_USER};
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${DB_USER};
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ${DB_USER};
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO ${DB_USER};

-- Future tables auto-grant
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL ON TABLES TO ${DB_USER};
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL ON SEQUENCES TO ${DB_USER};

EOF

echo ""
echo "============================================"
echo "  Database user '${DB_USER}' is ready"
echo "  Database: ${DB_NAME} on port ${DB_PORT}"
echo "  This user can ONLY access ${DB_NAME}"
echo "============================================"
