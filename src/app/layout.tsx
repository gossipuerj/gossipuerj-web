import type { Metadata } from "next";
import "./globals.css";
import Navbar from "@/components/layout/Navbar";
import Footer from "@/components/layout/Footer";

export const metadata: Metadata = {
  title: "GlossipUerj | O Feed Mais Quente da UERJ",
  description: "Acompanhe as fofocas mais picantes e anônimas da UERJ. O que acontece no campus, fica no Glossip.",
  keywords: ["UERJ", "Fofocas", "Anônimo", "Social", "Gossip"],
  openGraph: {
    title: "GlossipUerj",
    description: "O portal anônimo da UERJ.",
    type: "website",
  }
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="pt-BR">
      <body>
        <Navbar />
        {children}
        <Footer />
      </body>
    </html>
  );
}
