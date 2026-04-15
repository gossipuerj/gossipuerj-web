"use client";

import styles from "./ProfileCard.module.css";
import { useState } from "react";
import { Instagram, MessageCircle } from "lucide-react";
import Link from "next/link";

interface ProfileCardProps {
  username: string;
  firstName?: string;
  lastName?: string;
  instagram?: string;
  avatar?: string;
  gender?: string;
  orientation?: string;
  course?: string;
  isLoggedIn: boolean;
  currentUsername?: string;
}

export default function ProfileCard({ 
  username, 
  firstName,
  lastName,
  instagram, 
  avatar, 
  gender, 
  orientation, 
  course, 
  isLoggedIn, 
  currentUsername 
}: ProfileCardProps) {
  const [liked, setLiked] = useState(false);
  const isOwnProfile = username === currentUsername;

  const handleLike = () => {
    if (!isLoggedIn) {
      alert("Você precisa estar logado para dar like em um perfil!");
      return;
    }
    if (isOwnProfile) {
      alert("Você não pode dar like em si mesmo!");
      return;
    }
    setLiked(!liked);
  };

  const displayName = firstName || lastName 
    ? `${firstName || ""} ${lastName || ""}`.trim() 
    : `@${username}`;

  return (
    <div className={styles.card}>
      <div className={styles.avatar}>
        {avatar ? (
          <img src={avatar} alt={username} className={styles.avatarImg} />
        ) : (
          username[0]?.toUpperCase() || "@"
        )}
      </div>
      <div className={styles.info}>
        <h3 className={styles.username}>{displayName}</h3>
        {firstName || lastName ? <p className={styles.handle}>@{username}</p> : null}
        <div className={styles.details}>
          <span className={styles.detailTag}>{course || "Curso não inf."}</span>
          <span className={styles.detailTag}>{gender}</span>
          <span className={styles.detailTag}>{orientation}</span>
        </div>
      </div>
      <div className={styles.actions}>
        {instagram && (
          <a 
            href={`https://instagram.com/${instagram.replace("@", "")}`} 
            target="_blank" 
            rel="noopener noreferrer"
            className={styles.iconBtn}
            title="Ver Instagram"
          >
            <Instagram size={20} />
          </a>
        )}
        
        {!isOwnProfile && (
          <Link 
            href={`/messages?user=${username}`} 
            className={styles.iconBtn}
            title="Mandar Mensagem"
          >
            <MessageCircle size={20} />
          </Link>
        )}

        {!isOwnProfile ? (
          <button 
            className={liked ? styles.likedBtn : styles.likeBtn} 
            onClick={handleLike}
          >
            {liked ? "❤️ Interessado" : "🤍 Dar Like"}
          </button>
        ) : (
          <span className={styles.meBadge}>Você</span>
        )}
      </div>
    </div>
  );
}
