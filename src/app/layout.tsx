import type { Metadata } from "next";
import Script from "next/script";
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
        <noscript>
          <iframe
            src="https://www.googletagmanager.com/ns.html?id=GTM-NSGZ3GCR"
            height="0"
            width="0"
            style={{ display: "none", visibility: "hidden" }}
          />
        </noscript>
        <Navbar />
        {children}
        <Footer />
        <Script
          id="gtm"
          strategy="afterInteractive"
          dangerouslySetInnerHTML={{
            __html: `(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);})(window,document,'script','dataLayer','GTM-NSGZ3GCR');`,
          }}
        />
        {/* Google tag (gtag.js) — injected into <head> via beforeInteractive */}
        <Script
          id="gtag-src"
          strategy="beforeInteractive"
          src="https://www.googletagmanager.com/gtag/js?id=G-10RW9925RE"
        />
        <Script
          id="gtag-config"
          strategy="beforeInteractive"
          dangerouslySetInnerHTML={{
            __html: `window.dataLayer = window.dataLayer || [];function gtag(){dataLayer.push(arguments);}gtag('js', new Date());gtag('config', 'G-10RW9925RE');`,
          }}
        />
      </body>
    </html>
  );
}
