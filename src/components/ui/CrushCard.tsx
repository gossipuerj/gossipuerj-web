"use client";

import styles from "./CrushCard.module.css";

interface CrushCardProps {
  description: string;
  location: string;
  target?: string;
  instagram?: string;
  timestamp: string;
  hearts: number;
}

export default function CrushCard({ description, location, target, instagram, timestamp, hearts }: CrushCardProps) {
  return (
    <div className={styles.card}>
      <div className={styles.topRow}>
        <span className={styles.location}>📍 {location}</span>
        {instagram && <span className={styles.instagram}>@{instagram}</span>}
        <span className={styles.timestamp}>{timestamp}</span>
      </div>
      {target && <h3 className={styles.target}>Para: {target}</h3>}
      <p className={description.length > 100 ? styles.descriptionLong : styles.description}>
        "{description}"
      </p>
      <div className={styles.footer}>
        <div className={styles.stats}>
          <button className={styles.heartBtn}>
            ❤️ <span>{hearts}</span>
          </button>
        </div>
        <button className={styles.dmBtn}>Demonstrar Interesse</button>
      </div>
    </div>
  );
}
