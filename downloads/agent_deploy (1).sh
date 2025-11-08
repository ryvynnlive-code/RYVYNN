#!/usr/bin/env bash
# Agent deployment script for RYVYNN MVT launch
#
# This script automates the high‑level steps needed to get the RYVYNN Minimal
# Viable Trust (MVT) environment up and running. It expects certain
# environment variables to be set in the shell before execution. The script
# is idempotent: if resources already exist, it will skip creating them and
# continue without error.

# ============================================================================
# Configuration
#
# Before running this script you must export the following environment
# variables in your terminal:
#
#   NEXT_PUBLIC_SUPABASE_URL      – Your Supabase project’s URL
#   NEXT_PUBLIC_SUPABASE_ANON_KEY – The Supabase anon key used by the client
#   SUPABASE_SERVICE_ROLE_KEY      – The Supabase service role key for server
#   STRIPE_SECRET_KEY              – Your Stripe secret key
#   DMS_SECRET_KEY                 – Shared secret for admin/DMS API calls
#   NEXT_PUBLIC_BASE_URL           – (Optional) Override production URL
#
# The script does not automatically create the STRIPE_WEBHOOK_SECRET. After
# deploying to Vercel you must add a Stripe Webhook endpoint for
# `/api/webhooks/stripe` in the Stripe Dashboard. Stripe will generate a
# signing secret (`whsec_...`); copy that into the Vercel Environment
# Variables page as STRIPE_WEBHOOK_SECRET and redeploy your project.

set -euo pipefail

echo "[1/7] Verify environment variables are set"
required=(NEXT_PUBLIC_SUPABASE_URL NEXT_PUBLIC_SUPABASE_ANON_KEY SUPABASE_SERVICE_ROLE_KEY STRIPE_SECRET_KEY DMS_SECRET_KEY)
missing=false
for var in "${required[@]}"; do
  if [ -z "${!var:-}" ]; then
    echo "Error: Required variable $var is not set."
    missing=true
  fi
done
if [ "$missing" = true ]; then
  echo "One or more required environment variables are missing. Please export them before running." >&2
  exit 1
fi

# Choose package manager: prefer pnpm if available
if command -v pnpm >/dev/null 2>&1; then
  PM=pnpm
else
  PM=npm
fi

echo "[2/7] Installing dependencies with $PM"
$PM install

echo "[3/7] Building Next.js app"
$PM run build

echo "[4/7] Supabase migrations"
cat <<'SQL_INFO'
-------------------------------------------------------------------------------
NOTE: The Supabase schema must be created manually from the SQL provided in
your deployment documentation. Open the Supabase web console, navigate to
SQL Editor, and paste the SQL for the `public_trust`, `audit_log`, and
`mvt_tasks` tables, as well as any views and policies. Running the SQL is
idempotent and safe to execute multiple times.
-------------------------------------------------------------------------------
SQL_INFO

echo "[5/7] Deploying to Vercel"
# Create or update environment variables on Vercel. The vercel CLI will
# interactively ask which environment (development/preview/production) you
# want to store variables in. To automate this step, set the variables using
# the Vercel web dashboard or use `vercel env add <name> <environment>` commands
# ahead of time. The script continues regardless of whether these commands
# succeed.
echo "Setting environment variables on Vercel (you may be prompted to select the environment)..."
for env_var in NEXT_PUBLIC_SUPABASE_URL NEXT_PUBLIC_SUPABASE_ANON_KEY SUPABASE_SERVICE_ROLE_KEY STRIPE_SECRET_KEY DMS_SECRET_KEY; do
  # Remove existing variable if present (ignore errors)
  vercel env rm "$env_var" --yes >/dev/null 2>&1 || true
  # Add variable for production environment
  if [ -n "${!env_var}" ]; then
    echo "${!env_var}" | vercel env add "$env_var" production || true
  fi
done

# Deploy. The --prod flag targets production automatically.
URL=$(vercel --prod --confirm | tail -n1 | awk '{print $NF}')
echo "Production deployment completed: $URL"

# Save to environment if not already set
export NEXT_PUBLIC_BASE_URL="${NEXT_PUBLIC_BASE_URL:-$URL}"

echo "[6/7] Publish initial mandate snapshot"
# Prepare JSON payload for mandate publishing
MANDATE_VERSION=$(date +%F)
PAYLOAD=$(cat <<EOF
{
  "mandate_version": "${MANDATE_VERSION}",
  "metrics": {
    "mvt_status": "live",
    "audit_reserve_balance": 0
  }
}
EOF
)

curl -sS -X POST "$NEXT_PUBLIC_BASE_URL/api/admin/publish-mandate" \
  -H "Content-Type: application/json" \
  -H "x-admin-token: $DMS_SECRET_KEY" \
  -d "$PAYLOAD" || true

echo "[7/7] Done. Verify the trust dashboard at $NEXT_PUBLIC_BASE_URL/trust"

# Reminder for manual steps
cat <<'EOF'
-------------------------------------------------------------------------------
Remaining manual tasks:

1. In Stripe, create a Product (e.g., “RYVYNN Elite Architect”) with a $49/month
   price and note its price ID.
2. Add a webhook endpoint in Stripe for your production URL:
      https://<your-domain>/api/webhooks/stripe
   Copy the generated signing secret (starts with `whsec_`) and set it as
   STRIPE_WEBHOOK_SECRET in your Vercel project’s environment variables.
   Then redeploy.
3. Seed your Supabase tables using the provided SQL if you have not already.
4. Update the metrics.audit_reserve_balance field in public_trust whenever
   transfers to the Audit Reserve occur:

     curl -X POST "$NEXT_PUBLIC_BASE_URL/api/admin/publish-mandate" \
       -H "Content-Type: application/json" \
       -H "x-admin-token: $DMS_SECRET_KEY" \
       -d '{"mandate_version": "<new-date>", "metrics": {"audit_reserve_balance": 2500}}'

5. Attach your paywall to the Stripe price ID in your Next.js app so that
   subscriptions are processed correctly.

-------------------------------------------------------------------------------
EOF