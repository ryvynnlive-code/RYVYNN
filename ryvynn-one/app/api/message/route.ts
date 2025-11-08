import OpenAI from "openai";
import { NextResponse } from "next/server";

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

export async function GET(req: Request) {
  const { searchParams } = new URL(req.url);
  const q = searchParams.get("q") || "Say hi in one short sentence.";
  try {
    const res = await openai.chat.completions.create({
      model: "gpt-4.1-mini",
      messages: [{ role: "user", content: q }],
    });
    return NextResponse.json({ ok: true, reply: res.choices[0].message?.content });
  } catch (e: any) {
    return NextResponse.json({ ok: false, error: e.message }, { status: 500 });
  }
}

export async function POST(req: Request) {
  const { message, system } = await req.json().catch(() => ({}));
  if (!message) return NextResponse.json({ ok: false, error: "message is required" }, { status: 400 });

  try {
    const messages: any[] = [];
    if (system) messages.push({ role: "system", content: system });
    messages.push({ role: "user", content: message });

    const res = await openai.chat.completions.create({
      model: "gpt-4.1-mini",
      messages,
    });
    return NextResponse.json({ ok: true, reply: res.choices[0].message?.content });
  } catch (e: any) {
    return NextResponse.json({ ok: false, error: e.message }, { status: 500 });
  }
}
