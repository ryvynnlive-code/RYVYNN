import { NextResponse } from "next/server";

export async function POST(req: Request) {
  try {
    const { message } = await req.json();
    const systemPrompt = `
You are RYVYNN, an AI reflection guide built to help people rise from their darkest places.
You speak with grounded compassion, poetic clarity, and human warmth.
Never act as a therapist—be a mirror of wisdom and calm, inviting awareness, forgiveness, and renewal.
`;

    const payload = {
      model: "gpt-4o-mini",
      messages: [
        { role: "system", content: systemPrompt },
        { role: "user", content: message }
      ]
    };

    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${process.env.OPENAI_API_KEY}`
      },
      body: JSON.stringify(payload)
    });

    const data = await response.json();
    const reply = data.choices?.[0]?.message?.content ?? "No reply generated.";
    return NextResponse.json({ reply });
  } catch (err: any) {
    return NextResponse.json({ error: err.message }, { status: 500 });
  }
}
