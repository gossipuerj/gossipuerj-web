"use client";

import { useState } from "react";
import styles from "./PostGossip.module.css";

export default function PostGossip() {
  const [content, setContent] = useState("");
  const [target, setTarget] = useState("");
  const [category, setCategory] = useState("Fofoca");

  const categories = ["Fofoca", "Desabafo", "Paquera"];

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!content.trim()) return;

    try {
      const response = await fetch("/api/gossips", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ content, category, target }),
      });

      if (response.ok) {
        alert("Publicação enviada anonimamente!");
        setContent("");
        setTarget("");
      } else {
        alert("Erro ao enviar. Verifique sua conexão.");
      }
    } catch (error) {
      alert("Erro no servidor.");
    }
  };

  return (
    <div className={styles.container}>
      <form onSubmit={handleSubmit} className={styles.form}>
        <input 
          type="text"
          className={styles.targetInput}
          placeholder="Para quem é? (Ex: @username, @curso, Alguém do Bandejão...)"
          value={target}
          onChange={(e) => setTarget(e.target.value)}
        />
        <textarea
          className={styles.textarea}
          placeholder="O que está acontecendo no campus?"
          value={content}
          onChange={(e) => setContent(e.target.value)}
          maxLength={280}
        />
        <div className={styles.bottom}>
          <select 
            className={styles.select}
            value={category}
            onChange={(e) => setCategory(e.target.value)}
          >
            {categories.map(cat => (
              <option key={cat} value={cat}>{cat}</option>
            ))}
          </select>
          <span className={styles.charCount}>{content.length}/280</span>
          <button type="submit" className={styles.submitBtn} disabled={!content.trim()}>
            Publicar Anonimamente
          </button>
        </div>
      </form>
    </div>
  );
}
