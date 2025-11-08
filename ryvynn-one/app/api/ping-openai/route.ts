import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({
    ok: !!process.env.OPENAI_API_KEY,
    env: process.env.VERCEL_ENV,
  });
}
