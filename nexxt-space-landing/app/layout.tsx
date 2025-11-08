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
