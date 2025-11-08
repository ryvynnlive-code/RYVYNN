import React from "react";
export default function FlameHero() {
  return (
    <header className="w-full min-h-screen flex flex-col items-center justify-center bg-ryvynn-gradient text-center text-white">
      <div className="w-40 h-40 mb-6">
        <svg viewBox="0 0 240 240" xmlns="http://www.w3.org/2000/svg" className="w-full h-full">
          <defs>
            <linearGradient id="g" x1="0" x2="0" y1="0" y2="1">
              <stop offset="0%" stopColor="#00F0D8"/>
              <stop offset="55%" stopColor="#0088FF"/>
              <stop offset="100%" stopColor="#3A00A4"/>
            </linearGradient>
          </defs>
          <circle cx="120" cy="120" r="100" fill="none" stroke="url(#g)" strokeWidth="6" opacity="0.2"/>
          <path d="M120,28 C180,60 200,130 150,200 C100,270 40,240 20,180 C0,120 80,80 120,28 Z" fill="url(#g)"/>
        </svg>
      </div>
      <h1 className="text-5xl font-bold tracking-widest text-cyan-300">RYVYNN</h1>
      <p className="text-gray-300 mt-3">rising from our darkest places</p>
    </header>
  );
}
