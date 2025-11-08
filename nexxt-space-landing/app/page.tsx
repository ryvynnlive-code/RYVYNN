import WaitlistInline from "@/components/waitlist-inline";

export default function Page() {
  return (
    <main className="min-h-screen bg-black text-white">
      {/* Hero */}
      <section className="flex flex-col items-center pt-20 pb-16 px-4">
        <div className="max-w-4xl mx-auto text-center">
          <h1 className="text-6xl md:text-8xl font-bold tracking-tight">RYVYNN</h1>
          <p className="text-xl md:text-2xl text-gray-400 mt-6">
            From our darkest hours to our brightest days.
          </p>
          <button className="mt-8 px-8 py-4 bg-gradient-to-r from-red-600 to-red-500 rounded-xl font-semibold">
            Enter the Sanctuary
          </button>
        </div>
      </section>

      {/* Features */}
      <section className="px-6 py-20 bg-gradient-to-b from-black to-[#060608]">
        <div className="max-w-6xl mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="bg-slate-900/50 backdrop-blur border border-slate-800 rounded-2xl p-6">
              <h3 className="text-2xl font-semibold mb-2">Anonymous</h3>
              <p className="text-gray-400 leading-relaxed">
                No public feed, no audience, no surveillance surface.
              </p>
            </div>
            <div className="bg-slate-900/50 backdrop-blur border border-slate-800 rounded-2xl p-6">
              <h3 className="text-2xl font-semibold mb-2">Crisis-first</h3>
              <p className="text-gray-400 leading-relaxed">
                Recovery sequences when people are at their lowest.
              </p>
            </div>
            <div className="bg-slate-900/50 backdrop-blur border border-slate-800 rounded-2xl p-6">
              <h3 className="text-2xl font-semibold mb-2">Private by design</h3>
              <p className="text-gray-400 leading-relaxed">
                Built for founders, survivors, and people who can’t be seen.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="py-12 px-6 border-t border-slate-800">
        <div className="max-w-6xl mx-auto text-center">
          AONIXX • Privacy-First • 2025
        </div>
      </footer>

      {/* Waitlist */}
      <section className="text-center space-y-4 py-16 px-4">
        <h2 className="text-3xl font-bold text-white">Join the Waitlist</h2>
        <p className="text-gray-400">
          Secure early access to the RYVYNN Private Beta.
        </p>
        <WaitlistInline />
      </section>
    </main>
  );
}
