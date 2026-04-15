"use client";

import { useState, useEffect } from "react";
import GossipCard from "@/components/ui/GossipCard";
import PostGossip from "@/components/features/PostGossip";
import styles from "./page.module.css";
import { MOCK_GOSSIPS, MOCK_USER } from "@/lib/mocks";

export default function Home() {
  const [selectedCategory, setSelectedCategory] = useState("Todos");
  const [gossips, setGossips] = useState<any[]>([]);
  const [currentUserId, setCurrentUserId] = useState<string | undefined>();
  const [loading, setLoading] = useState(true);

  const categories = ["Todos", "Fofoca", "Desabafo", "Paquera"];

  useEffect(() => {
    // Simulating loading data
    const timer = setTimeout(() => {
      setGossips(MOCK_GOSSIPS);
      setCurrentUserId(MOCK_USER.id);
      setLoading(false);
    }, 800);

    return () => clearTimeout(timer);
  }, []);

  const filteredGossips = selectedCategory === "Todos" 
    ? gossips 
    : gossips.filter(g => g.category === selectedCategory);

  return (
    <main className={styles.main}>
      
      <div className={styles.hero}>
        <div className={styles.heroContent}>
          <h1 className={styles.title}>O que está rolando na <span>UERJ</span>?</h1>
          <p className={styles.subtitle}>Fofocas anônimas, segredos e crushes do campus.</p>
        </div>
        <div className={styles.gretchenContainer}>
          <img src="/images/gretchen.png" alt="Gretchen UERJ" className={styles.gretchenImg} />
          <div className={styles.memeTag}>FURO EXCLUSIVO</div>
        </div>
      </div>

      <section className={styles.feed}>
        <div className={styles.container}>
          <PostGossip />
          
          <div className={styles.feedHeader}>
            <h2>Feed Recente</h2>
            <div className={styles.filters}>
              {categories.map((cat) => (
                <button 
                  key={cat}
                  className={styles.filterBtn + (selectedCategory === cat ? " " + styles.active : "")}
                  onClick={() => setSelectedCategory(cat)}
                >
                  {cat}
                </button>
              ))}
            </div>
          </div>

          <div className={styles.grid}>
            {loading ? (
              <p className={styles.loading}>Carregando fofocas...</p>
            ) : (
              filteredGossips.map((gossip) => (
                <GossipCard 
                  key={gossip._id}
                  id={gossip._id}
                  content={gossip.content}
                  timestamp={new Date(gossip.createdAt).toLocaleTimeString()}
                  category={gossip.category}
                  target={gossip.target}
                  image={gossip.image}
                  authorId={gossip.author}
                  currentUserId={currentUserId}
                />
              ))
            )}
            {!loading && filteredGossips.length === 0 && (
              <p className={styles.empty}>Nenhuma fofoca encontrada nesta categoria.</p>
            )}
          </div>
        </div>
      </section>
    </main>
  );
}
