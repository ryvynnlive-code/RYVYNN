"use client";

import { useState } from "react";

export default function WaitlistInline() {
  const [email, setEmail] = useState("");
  const [sent, setSent] = useState(false);
  const [error, setError] = useState("");

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setError("");
    const res = await fetch("/api/waitlist", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email }),
    });
    if (res.ok) setSent(true);
    else setError("Invalid email or server error");
  }

  return (
    <div className="max-w-md mx-auto mt-12">
      {sent ? (
        <div className="bg-[#0f0f13] border border-[#1b1b1f] rounded-xl p-6 text-center text-gray-200">
          You’re on the waitlist. We’ll reach out soon.
        </div>
      ) : (
        <form
          onSubmit={submit}
          className="flex flex-col sm:flex-row items-center gap-3 bg-[#0f0f13] border border-[#1b1b1f] rounded-xl p-4"
        >
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="enter your email"
            required
            className="flex-1 bg-[#0a0a0a] border border-[#1b1b1f] rounded-lg px-3 py-2 text-sm focus:outline-none focus:border-[#e11d2e]"
          />
          <button
            type="submit"
            className="bg-[#e11d2e] text-white font-medium rounded-lg px-5 py-2 hover:bg-[#c81a2a] transition-colors"
          >
            Join
          </button>
        </form>
      )}
      {error && <p className="text-xs text-red-400 mt-2 text-center">{error}</p>}
    </div>
  );
}
