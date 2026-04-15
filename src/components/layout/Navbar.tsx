"use client";

import styles from "./Navbar.module.css";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useState } from "react";
import { Home, Heart, Calendar, MessageSquare, User } from "lucide-react";

export default function Navbar() {
  const pathname = usePathname();
  // Simulação de estado de login - no futuro virá de um AuthContext
  const [isLoggedIn, setIsLoggedIn] = useState(true);

  const navLinks = [
    { name: "Feed", href: "/", icon: <Home size={24} /> },
    { name: "Crushes", href: "/crushes", icon: <Heart size={24} /> },
    { name: "Eventos", href: "/eventos", icon: <Calendar size={24} /> },
    { name: "Mensagens", href: "/messages", icon: <MessageSquare size={24} /> },
    { 
      name: isLoggedIn ? "Perfil" : "Login", 
      href: isLoggedIn ? "/profile" : "/login", 
      icon: <User size={24} /> 
    },
  ];

  return (
    <>
      <nav className={styles.navbar}>
        <div className={styles.container}>
          <Link href="/" className={styles.logo}>
            GLOSSIP<span>UERJ</span>
          </Link>
          <div className={styles.links}>
            {navLinks.map((link) => (
              <Link 
                key={link.href} 
                href={link.href} 
                className={pathname === link.href ? styles.active : ""}
              >
                {link.name}
              </Link>
            ))}
          </div>
        </div>
      </nav>

      {/* Mobile Bottom Navigation */}
      <nav className={styles.mobileNav}>
        {navLinks.map((link) => (
          <Link 
            key={link.href} 
            href={link.href} 
            className={pathname === link.href ? styles.mobileActive : ""}
            title={link.name}
          >
            {link.icon}
          </Link>
        ))}
      </nav>
    </>
  );
}
