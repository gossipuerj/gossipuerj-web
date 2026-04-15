"use client";

import { useState } from "react";
import styles from "./GossipCard.module.css";
import { Trash2 } from "lucide-react";

interface Comment {
  id: number | string;
  text: string;
  author: string;
  authorId?: string;
}

interface GossipCardProps {
  id: string;
  content: string;
  timestamp: string;
  category?: string;
  target?: string;
  image?: string;
  authorId?: string;
  currentUserId?: string;
}

export default function GossipCard({ 
  id, 
  content, 
  timestamp, 
  category = "Fofoca", 
  target,
  image,
  authorId, 
  currentUserId 
}: GossipCardProps) {
  const [showComments, setShowComments] = useState(false);
  const [isEditing, setIsEditing] = useState(false);
  const [editedContent, setEditedContent] = useState(content);
  const [isFollowing, setIsFollowing] = useState(false);
  const isAuthor = authorId && currentUserId && authorId === currentUserId;
  const [commentText, setCommentText] = useState("");
  const [comments, setComments] = useState<Comment[]>([
    { id: 1, text: "Gente, eu tava lá e foi exatamente assim!", author: "Anônimo" },
    { id: 2, text: "Alguém sabe quem era o rapaz?", author: "Anônimo" }
  ]);

  const handleAddComment = (e: React.FormEvent) => {
    e.preventDefault();
    if (!commentText.trim()) return;
    
    const newComment: Comment = { 
      id: Date.now(), 
      text: commentText, 
      author: currentUserId ? "@você" : "Anônimo",
      authorId: currentUserId
    };
    
    setComments([...comments, newComment]);
    setCommentText("");
  };

  const handleDeleteComment = (commentId: number | string) => {
    if (!confirm("Excluir seu comentário?")) return;
    setComments(comments.filter(c => c.id !== commentId));
  };

  const handleDelete = async () => {
    if (!confirm("Tem certeza que deseja excluir esta fofoca?")) return;
    alert("Fofoca excluída (Simulação Mock)!");
  };

  const handleUpdate = async () => {
    setIsEditing(false);
    alert("Conteúdo atualizado (Simulação Mock)!");
  };

  // Função para transformar #hashtags em elementos clicáveis
  const renderContentWithHashtags = (text: string) => {
    const parts = text.split(/(#[a-z0-9_]+)/gi);
    return parts.map((part, index) => {
      if (part.startsWith("#")) {
        return (
          <span key={index} className={styles.hashtag}>
            {part}
          </span>
        );
      }
      return part;
    });
  };

  return (
    <div className={styles.card}>
      <div className={styles.header}>
        <div className={styles.meta}>
          <span className={styles.category}>{category}</span>
          {target && (
            <span className={styles.targetBadge}>
              Para: <strong>{target}</strong>
            </span>
          )}
        </div>
        <div className={styles.headerActions}>
          {isAuthor && (
            <>
              <button 
                className={isFollowing ? styles.notifyBtnActive : styles.notifyBtn}
                onClick={() => setIsFollowing(!isFollowing)}
                title="Acompanhar notificações"
              >
                {isFollowing ? "🔔" : "🔕"}
              </button>
              <button className={styles.editBtn} onClick={() => setIsEditing(!isEditing)}>✏️</button>
              <button className={styles.deleteBtn} onClick={handleDelete}>🗑️</button>
            </>
          )}
          <span className={styles.timestamp}>{timestamp}</span>
        </div>
      </div>
      
      {isEditing ? (
        <div className={styles.editArea}>
          <textarea 
            value={editedContent} 
            onChange={(e) => setEditedContent(e.target.value)}
            className={styles.editTextarea}
          />
          <button onClick={handleUpdate} className={styles.saveBtn}>Salvar</button>
        </div>
      ) : (
        <>
          <p className={styles.content}>{renderContentWithHashtags(editedContent)}</p>
          {image && (
            <div className={styles.imageContainer}>
              <img src={image} alt="Gossip evidence" className={styles.postImage} />
            </div>
          )}
        </>
      )}
      <div className={styles.footer}>
        <button className={styles.action}>👍 Like</button>
        <button className={styles.action}>👎 Dislike</button>
        <button 
          className={styles.action + (showComments ? " " + styles.activeAction : "")} 
          onClick={() => setShowComments(!showComments)}
        >
          💬 Comentar ({comments.length})
        </button>
      </div>

      {showComments && (
        <div className={styles.commentSection}>
          <div className={styles.commentList}>
            {comments.map((c) => (
              <div key={c.id} className={styles.commentItem}>
                <div className={styles.commentContent}>
                  <strong>{c.author}:</strong> {c.text}
                </div>
                {c.authorId === currentUserId && (
                  <button 
                    className={styles.deleteCommentBtn} 
                    onClick={() => handleDeleteComment(c.id)}
                    title="Excluir meu comentário"
                  >
                    <Trash2 size={14} />
                  </button>
                )}
              </div>
            ))}
          </div>
          <form onSubmit={handleAddComment} className={styles.commentForm}>
            <input 
              type="text" 
              placeholder="Escreva um comentário..." 
              value={commentText}
              onChange={(e) => setCommentText(e.target.value)}
              className={styles.commentInput}
            />
            <button type="submit" className={styles.commentSubmit}>Enviar</button>
          </form>
        </div>
      )}
    </div>
  );
}
