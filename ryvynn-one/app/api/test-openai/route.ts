import OpenAI from "openai";
import { NextResponse } from "next/server";

export async function GET() {
  const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
  try {
    const models = await openai.models.list();
    return NextResponse.json({ ok: true, modelCount: models.data.length });
  } catch (error: any) {
    return NextResponse.json({ ok: false, error: error.message });
  }
}
