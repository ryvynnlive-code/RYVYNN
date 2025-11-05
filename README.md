# (1) Make sure you're inside your repo folder
cd ~/ryvynn

# (2) Create the full README.md file
cat > README.md
# (3) Commit and push the new README
git add README.md
git commit -m "docs: add official RYVYNN README"
git push
# (3) Commit and push the new README
git add README.md
git commit -m "docs: add official RYVYNN README"
git push
# RYVYNN — “Breakthrough From Darkness” (v8.0)

A cinematic, privacy-first, AI-guided onboarding experience that sits in front of the core RYVYNN app. This layer tells the story: “from our darkest hours to our brightest days,” then hands the user into the main RYVYNN flow.

This build reuses the RYVYNN stack (Next.js + Supabase + Stripe) so you don’t have to reinvent auth, storage, or payments. It is a presentational-first app with optional authenticated handoff.

---

## 1. Purpose

- Create an immersive, raven-themed arrival page for RYVYNN.
- Show the transformation sequence (dark → glow → lotus/raven sigil).
- Let the user click **Enter the Light** to continue into the main RYVYNN app.
- Keep all privacy and zero-trust rules from the 7.1.0 canonical build.
- Remain deployable to Vercel under the same org/account.

---

## 2. Stack

| Layer     | Tech                  | Notes                             |
|-----------|-----------------------|-----------------------------------|
| Framework | Next.js 15 (app dir)  | Modern routing, server components |
| UI        | TailwindCSS           | Dark/cyber-sacred theme           |
| Motion    | Framer Motion         | Hero + reveal animations          |
| Backend   | Supabase (same proj)  | Reuse auth + profiles             |
| Billing   | Stripe                | Optional: upsell into RYVYNN Plus |
| Hosting   | Vercel                | Same account as ryvynn.live       |

---

## 3. Features

1. **Cinematic Hero**  
   - Fullscreen dark background  
   - Raven/sacred geometry overlay  
   - Slow fade-in text: “Breakthrough from Darkness”

2. **Guided Transition Block**  
   - 3 steps: “Darkness → Recognition → Rise”  
   - Each can call a small AI endpoint to generate a 1–2 sentence affirmation.

3. **Handoff to RYVYNN**  
   - Button: `Enter RYVYNN` → route to `https://ryvynn.live` or your main app route  
   - If user is logged into Supabase already, pass session token to main app

4. **Optional Monetization Hook**  
   - Secondary CTA: “Unlock Full Companion (RYVYNN Plus)”  
   - Calls your existing Stripe price ID from the main app

5. **Privacy**  
   - No PII collected on this page  
   - Any optional “I am struggling with…” input is encrypted client-side before POST

---

## 4. Setup

### 4.1 Clone

```bash
git clone https://github.com/ryvynnlive-code/RYVYNN.git
cd RYVYNN
npm install
