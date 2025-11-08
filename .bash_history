- Serves your enhanced `verum.html` with no visual regressions
- Replaces the simulated responses with **real AI** via an `/api/chat` endpoint
- Keeps secrets in environment variables
- Is deployable to Vercel/Render/Fly or runnable locally
> Files are separated by headings like `=== filename ===`.
---
=== package.json ===
{   "name": "verum-eidolon",;   "version": "1.0.0",;   "private": true,;   "type": "module",;   "scripts": {;     "dev": "node --env-file=.env server.js",;     "start": "node --env-file=.env server.js",;     "postinstall": "node -e \"console.log('> VERUM EIDOLON ready')\"";   },;   "dependencies": {;     "cors": "^2.8.5",;     "dotenv": "^16.4.5",;     "express": "^4.19.2",;     "openai": "^4.56.0",;     "@supabase/supabase-js": "^2.45.4";   }
}
---
=== .env.example ===
# Copy to .env and fill in
OPENAI_API_KEY=sk-your-key
# Optional: tune system prompt/persona
VERUM_SYSTEM_PROMPT=You are VERUM — Founder-grade, precise, three-layer responses (Beginner, Intermediate, Expert). Connect tech + story + psychology + operations. Encourage, no fluff.
PORT=3000
---
=== server.js ===
import 'dotenv/config';
import express from 'express';
import path from 'path';
import cors from 'cors';
import { fileURLToPath } from 'url';
// import OpenAI from 'openai';
import { chat as providerChat, streamChat as providerStream, embed as providerEmbed, isMock as providerIsMock } from './providers/openai.js';
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const app = express();
app.use(cors());
app.use(express.json({ limit: '1mb' }));
app.use(express.static(path.join(__dirname, 'public')));
// OpenAI client moved to providers/openai.js with base & mock fallbacks
const client = null; // unused (kept to minimize diff) 
const BASE_SYSTEM = process.env.VERUM_SYSTEM_PROMPT ||   'You are VERUM — calm, precise, systems-level. Respond in 3 layers (Beginner, Intermediate, Expert). Connect tech + story + psychology + operations. Founder-grade clarity, zero fluff.';
app.post('/api/chat', async (req, res) => {
});
// Health check
app.get('/api/health', (_req, res) => res.json({ ok: true }));
const port = Number(process.env.PORT || 3000);
app.listen(port, () => {
});
---
=== public/eidolon.html ===
<html lang="en">
<head>
</head>
<body>
</body>
</html>
---
=== README.md ===
# VERUM EIDOLON — Keys-On Build
## Quickstart
```bash
cp .env.example .env  # add keys
npm i
npm run start
# open http://localhost:3000/eidolon.html
```
node -v
npm -v
git --version
npx create-next-app@latest nexxt-space-landing
Success! Created nexxt-space-landing at /data/data/com.termux/files/home/nexxt-space-landing
cd nexxt-space-landing
ls
nano app/page.tsx
npm run dev
nano package.json
cd /root/nexxt-space-landing
vercel login   # (if not already logged in)
vercel --prod
cd /root/nexxt-space-landing
vercel --prod
cd ~ && rm -rf nexxt-space-landing && mkdir -p nexxt-space-landing/app && cd nexxt-space-landing && cat > package.json << 'EOF'
{
  "name": "nexxt-space-landing",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "eslint"
  },
  "dependencies": {
    "react": "19.2.0",
    "react-dom": "19.2.0",
    "next": "16.0.1"
  },
  "devDependencies": {
    "typescript": "^5",
    "@types/node": "^20",
    "@types/react": "^19",
    "@types/react-dom": "^19",
    "@tailwindcss/postcss": "^4",
    "tailwindcss": "^4",
    "eslint": "^9",
    "eslint-config-next": "16.0.1"
  }
}
EOF

cat > next.config.mjs << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
};

export default nextConfig;
EOF

cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{"name": "next"}],
    "paths": {"@/*": ["./*"]}
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF

cat > postcss.config.mjs << 'EOF'
export default {
  plugins: {
    '@tailwindcss/postcss': {},
  },
};
EOF

cat > tailwind.config.ts << 'EOF'
import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        gold: {
          DEFAULT: '#FFD700',
          50: '#FFF9E5',
          100: '#FFF3CC',
          200: '#FFE799',
          300: '#FFDB66',
          400: '#FFCF33',
          500: '#FFD700',
          600: '#CCAC00',
          700: '#998100',
          800: '#665600',
          900: '#332B00',
        },
      },
    },
  },
  plugins: [],
};

export default config;
EOF

cat > app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

* {
  box-sizing: border-box;
  padding: 0;
  margin: 0;
}

html,
body {
  max-width: 100vw;
  overflow-x: hidden;
}

body {
  color: rgb(255, 255, 255);
  background: rgb(0, 0, 0);
}
EOF

cat > app/layout.tsx << 'EOF'
import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "RYVYNN",
  description: "From our darkest hours to our brightest days",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="antialiased">{children}</body>
    </html>
  );
}
EOF

cat > app/page.tsx << 'EOF'
export default function Home() {
  return (
    <main className="min-h-screen bg-black text-white">
      <section className="flex flex-col items-center justify-center min-h-screen px-6 py-20">
        <div className="max-w-4xl mx-auto text-center space-y-8">
          <h1 className="text-6xl md:text-8xl font-bold tracking-tight bg-gradient-to-r from-white via-gold-400 to-gold-600 bg-clip-text text-transparent">
            RYVYNN
          </h1>
          <p className="text-xl md:text-2xl text-gray-400 font-light">
            From our darkest hours to our brightest days.
          </p>
          <button className="mt-8 px-8 py-4 bg-gradient-to-r from-gold-600 to-gold-500 hover:from-gold-500 hover:to-gold-400 text-black font-semibold rounded-lg transition-all duration-300 transform hover:scale-105 shadow-lg shadow-gold-900/50">
            Enter the Sanctuary
          </button>
        </div>
      </section>
      <section className="px-6 py-20 bg-gradient-to-b from-black to-slate-950">
        <div className="max-w-6xl mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="bg-slate-900/50 backdrop-blur border border-slate-800 rounded-xl p-8 hover:border-gold-600/50 transition-all duration-300">
              <div className="w-12 h-12 bg-gold-600/10 rounded-lg flex items-center justify-center mb-6">
                <svg className="w-6 h-6 text-gold-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                </svg>
              </div>
              <h3 className="text-2xl font-semibold mb-4">Anonymous Confession</h3>
              <p className="text-gray-400 leading-relaxed">Share your truth without fear. Complete anonymity, zero judgment.</p>
            </div>
            <div className="bg-slate-900/50 backdrop-blur border border-slate-800 rounded-xl p-8 hover:border-gold-600/50 transition-all duration-300">
              <div className="w-12 h-12 bg-gold-600/10 rounded-lg flex items-center justify-center mb-6">
                <svg className="w-6 h-6 text-gold-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
              </div>
              <h3 className="text-2xl font-semibold mb-4">Daily Truth</h3>
              <p className="text-gray-400 leading-relaxed">Journal your journey. AI wisdom meets human experience.</p>
            </div>
            <div className="bg-slate-900/50 backdrop-blur border border-slate-800 rounded-xl p-8 hover:border-gold-600/50 transition-all duration-300">
              <div className="w-12 h-12 bg-gold-600/10 rounded-lg flex items-center justify-center mb-6">
                <svg className="w-6 h-6 text-gold-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z" />
                </svg>
              </div>
              <h3 className="text-2xl font-semibold mb-4">Soul Tokens</h3>
              <p className="text-gray-400 leading-relaxed">Earn rewards for growth. Your progress has value.</p>
            </div>
          </div>
        </div>
      </section>
      <footer className="py-12 px-6 border-t border-slate-900">
        <div className="max-w-6xl mx-auto text-center text-sm text-gray-500">
          AONIXX • Privacy-First • 2025
        </div>
      </footer>
    </main>
  );
}
EOF

echo "✅ Done! Now run: npm install && vercel --prod"
npm install && vercel --prod
vercel --prod
cd /data/data/com.termux/files/home/nexxt-space-landing  # or your project folder
mkdir -p app/manifesto
mkdir -p app/investors
mkdir -p app/waitlist
mkdir -p components
// app/layout.tsx
import './globals.css';
import { Inter } from 'next/font/google';
import type { Metadata } from 'next';
import NavShell from '@/components/nav-shell';
const inter = Inter({
});
export const metadata: Metadata = {
};
export default function RootLayout({
}: {
}) {
}
nano components/nav-shell.tsx
npm run lint
npm run build
cd /data/data/com.termux/files/home/nexxt-space-landing
ls app
npm run build
# 1. Clear any partial cache
rm -rf .next
# 2. Force SWC (disable turbopack)
NEXT_SKIP_TURBOPACK=1 npm run build
# 3. (Optional) If it still fails, rebuild node_modules clean
rm -rf node_modules package-lock.json
npm install
NEXT_SKIP_TURBOPACK=1 npm run build
cd /data/data/com.termux/files/home/nexxt-space-landing
rm -rf .next
NEXT_SKIP_TURBOPACK=1 npm run build
cd /data/data/com.termux/files/home/nexxt-space-landing
# 1) try build without turbopack
npx next build --no-turbo
nano package.json
npm run build
{   "name": "nexxt-space-landing",;   "version": "0.1.0",;   "private": true,;   "scripts": {;     "dev": "next dev",;     "build": "next build --no-turbo",;     "start": "next start",;     "lint": "next lint";   },;   "dependencies": {;     "react": "19.2.0",;     "react-dom": "19.2.0",;     "next": "16.0.1";   },;   "devDependencies": {;     "typescript": "^5",;     "@types/node": "^20",;     "@types/react": "^19",;     "@types/react-dom": "^19",;     "tailwindcss": "^4",;     "@tailwindcss/postcss": "^4",;     "eslint": "^9",;     "eslint-config-next": "16.0.1";   }
}
cd ~/nexxt-space-landing && mkdir -p types app/api/waitlist && cat > types/waitlist.ts << 'A'
export interface WaitlistPayload{email:string;name?:string;referralCode?:string}export interface WaitlistResponse{success:boolean;message:string}
A

cat > app/api/waitlist/route.ts << 'B'
import{NextRequest,NextResponse}from'next/server';import type{WaitlistPayload,WaitlistResponse}from'@/types/waitlist';export async function POST(r:NextRequest){try{const b:WaitlistPayload=await r.json();if(!b.email)return NextResponse.json({success:false,message:'Email is required'}as WaitlistResponse,{status:400});if(!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(b.email))return NextResponse.json({success:false,message:'Invalid email format'}as WaitlistResponse,{status:400});console.log('Waitlist:',{email:b.email,name:b.name,referralCode:b.referralCode,timestamp:new Date().toISOString()});return NextResponse.json({success:true,message:'Successfully joined the waitlist'}as WaitlistResponse,{status:200})}catch(e){console.error('Waitlist error:',e);return NextResponse.json({success:false,message:'An error occurred. Please try again.'}as WaitlistResponse,{status:500})}}
B

vercel --prod --yes
cd ~/nexxt-space-landing && mkdir -p types app/api/waitlist && cat > types/waitlist.ts << 'A'
export interface WaitlistPayload{email:string;name?:string;referralCode?:string}export interface WaitlistResponse{success:boolean;message:string}
A

cat > app/api/waitlist/route.ts << 'B'
import{NextRequest,NextResponse}from'next/server';import type{WaitlistPayload,WaitlistResponse}from'@/types/waitlist';export async function POST(r:NextRequest){try{const b:WaitlistPayload=await r.json();if(!b.email)return NextResponse.json({success:false,message:'Email is required'}as WaitlistResponse,{status:400});if(!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(b.email))return NextResponse.json({success:false,message:'Invalid email format'}as WaitlistResponse,{status:400});console.log('Waitlist:',{email:b.email,name:b.name,referralCode:b.referralCode,timestamp:new Date().toISOString()});return NextResponse.json({success:true,message:'Successfully joined the waitlist'}as WaitlistResponse,{status:200})}catch(e){console.error('Waitlist error:',e);return NextResponse.json({success:false,message:'An error occurred. Please try again.'}as WaitlistResponse,{status:500})}}
B

vercel --prod --yes
cd ~/nexxt-space-landing && cat > package.json << 'EOF'
{
  "name": "nexxt-space-landing",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "eslint"
  },
  "dependencies": {
    "react": "19.2.0",
    "react-dom": "19.2.0",
    "next": "16.0.1"
  },
  "devDependencies": {
    "typescript": "^5",
    "@types/node": "^20",
    "@types/react": "^19",
    "@types/react-dom": "^19",
    "@tailwindcss/postcss": "^4",
    "tailwindcss": "^4",
    "eslint": "^9",
    "eslint-config-next": "16.0.1"
  }
}
EOF

vercel --prod --yes
cd ~/nexxt-space-landing && cat > package.json << 'EOF'
{
  "name": "nexxt-space-landing",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "eslint"
  },
  "dependencies": {
    "react": "19.2.0",
    "react-dom": "19.2.0",
    "next": "16.0.1"
  },
  "devDependencies": {
    "typescript": "^5",
    "@types/node": "^20",
    "@types/react": "^19",
    "@types/react-dom": "^19",
    "@tailwindcss/postcss": "^4",
    "tailwindcss": "^4",
    "eslint": "^9",
    "eslint-config-next": "16.0.1"
  }
}
EOF

vercel --prod --yes
cd ~/nexxt-space-landing && rm -rf components && vercel --prod --yes
cd ~/nexxt-space-landing
ls
mkdir -p components
nano components/waitlist-inline.tsx
nano app/page.tsx
npm run build
npx vercel --prod
<footer className="py-12 px-6 border-t border-slate-800">
</footer>
<section className="text-center space-y-4 py-16">
</section>
</main>
);
}
export default Page;   // ← add this if missing
rm -rf .next
NEXT_SKIP_TURBOPACK=1 npm run build
npx vercel --prod
nano app/page.tsx
rm -rf .next
NEXT_SKIP_TURBOPACK=1 npm run build
npx vercel --prod
# 1. make a folder for the app
mkdir ryvynn-app && cd ryvynn-app
# 2. init next app (if you don’t already have the repo pulled)
npx create-next-app@latest . --ts
# 3. add env file placeholders
cat > .env.local << 'EOF'
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
NEXT_PUBLIC_SITE_URL=https://app.ryvynn.live
EOF

# 4. test locally
npm install
npm run dev
# 1. switch to plain esbuild
export NEXT_JS_FORCE_ESBUILD=true
# 2. start server
npm run dev -- --port 3000
grep -Ri "ryvynn" .
grep -Ri "shawn" .
cd ~/ryvynn
grep -Ri "ryvynn" .
grep -Ri "shawn" .
[200~cd ~/ryvynn~
cd ~/ryvynn
cl ~/ryvynn
vercel logout
vercel login
# use the SAME email as the Vercel that owns ryvynn.live
vercel link
vercel --prod
vercel status
# 1. see all projects in this account
vercel projects ls
# 2. link THIS folder to the landing-page project
vercel link --project nexxt-space-landing
# 3. deploy it live
vercel --prod
cl 
ryvynn
prod ryvynn
cl proj ryvynn
node -v
vercel whoami
cd ~/ryvynn
npm run dev
vercel --prod
cd ~/ryvynn
npm run dev
vercel --prod
xcd ~/ryvynn
ls
cd ~/ryvynn/ryvynn-app
vercel --prod
cd ~/ryvynn/ryvynn-app
vercel --prod
cd ~
find . -type f -name "package.json" | grep ryvynn
cd <that-folder>
vercel --prod
npx vercel link
# in project root
vercel logout
vercel login
vercel link --confirm
vercel env pull .env.local
vercel --prod --confirm
# 1) see what folders you have
ls
npm install
vercel link --yes
vercel --prod --yes
