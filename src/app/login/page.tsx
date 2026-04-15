"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import styles from "./page.module.css";
import Link from "next/link";

export default function LoginPage() {
  const [isLogin, setIsLogin] = useState(true);
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const router = useRouter();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");

    const endpoint = isLogin ? "/api/auth/login" : "/api/auth/register";
    try {
      const res = await fetch(endpoint, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ username, password }),
      });

      const data = await res.json();
      if (res.ok) {
        if (isLogin) {
          router.push("/crushes");
          router.refresh();
        } else {
          setIsLogin(true);
          alert("Conta criada! Agora faça o login.");
        }
      } else {
        setError(data.error || "Ocorreu um erro");
      }
    } catch (err) {
      setError("Erro na conexão");
    }
  };

  return (
    <main className={styles.main}>
      <div className={styles.card}>
        <h1 className={styles.logo}>GLOSSIP<span>UERJ</span></h1>
        <h2 className={styles.title}>{isLogin ? "Bem-vindo de volta" : "Criar sua conta"}</h2>
        <p className={styles.subtitle}>
          {isLogin ? "Acesse para demonstrar interesse nos crushes." : "Use seu @ do Instagram como usuário."}
        </p>

        <form onSubmit={handleSubmit} className={styles.form}>
          <div className={styles.inputGroup}>
            <label>@ do Instagram</label>
            <input 
              type="text" 
              placeholder="@seu_insta" 
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              required
            />
          </div>
          <div className={styles.inputGroup}>
            <label>Senha</label>
            <input 
              type="password" 
              placeholder="••••••••" 
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>

          {error && <p className={styles.error}>{error}</p>}

          <button type="submit" className={styles.submitBtn}>
            {isLogin ? "Entrar" : "Registrar"}
          </button>
        </form>

        <p className={styles.switch}>
          {isLogin ? "Não tem conta?" : "Já tem conta?"}
          <button onClick={() => setIsLogin(!isLogin)} className={styles.switchBtn}>
            {isLogin ? "Crie agora" : "Faça login"}
          </button>
        </p>

        <Link href="/" className={styles.backHome}>Voltar ao Feed</Link>
      </div>
    </main>
  );
}
