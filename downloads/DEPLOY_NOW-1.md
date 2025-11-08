# 🚀 RYVYNN.LIVE - DEPLOY NOW

## ⚡ ONE COMMAND TO GO LIVE

```bash
/mnt/user-data/outputs/FINAL_DEPLOY.sh
```

## 🔑 YOU NEED (Get these first - 5 minutes):

1. **Anthropic API Key** - https://console.anthropic.com/settings/keys
   - Click "Create Key"
   - Copy the key (starts with `sk-ant-`)
   
2. **Supabase** (optional for now, can use mock data)
   - https://supabase.com - create project
   - Get URL + anon key

## 📋 EXACT STEPS:

### 1. Get API Key
```bash
# Go to: https://console.anthropic.com/settings/keys
# Create new key
# Copy it
```

### 2. Run Deploy Script
```bash
/mnt/user-data/outputs/FINAL_DEPLOY.sh
```

When it asks, paste your ANTHROPIC_API_KEY into .env.local

### 3. Deploy to Vercel
```bash
cd /mnt/user-data/outputs/ryvynn-production-final
vercel --prod
```

### 4. Add Domain in Vercel Dashboard
- Go to your project → Settings → Domains
- Add: ryvynn.live
- DNS is already configured (you said it's set)

## ✅ DONE

Site will be live at https://ryvynn.live in 2-3 minutes.

## 📧 THEN IMMEDIATELY:

Send investor emails using:
`/mnt/user-data/outputs/RYVYNN_Investor_Email_Templates.txt`

Attach:
- `/mnt/user-data/outputs/RYVYNN_Investor_Offer_Sheet.pdf`
- `/mnt/user-data/outputs/RYVYNN_Investor_Teaser_3Slide.pdf`

**THAT'S IT. GO LIVE. CLOSE YOUR ROUND.** 🔥
