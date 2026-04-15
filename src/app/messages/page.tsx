"use client";

import styles from "./page.module.css";
import Link from "next/link";
import { useState, useEffect, useRef } from "react";
import { ArrowLeft, Send, Paperclip, MoreVertical, Smile } from "lucide-react";

interface Conversation {
  id: number;
  user: string;
  lastMessage: string;
  time: string;
  unread: boolean;
}

interface Message {
  id: number;
  text: string;
  time: string;
  sender: "me" | "them";
}

export default function MessagesPage() {
  const [loading, setLoading] = useState(true);
  const [selectedChat, setSelectedChat] = useState<Conversation | null>(null);
  const [newMessage, setNewMessage] = useState("");
  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Mock conversations
  const conversations: Conversation[] = [
    { id: 1, user: "ana_uerj", lastMessage: "Obrigada por demonstrar interesse! 😉", time: "10 min", unread: true },
    { id: 2, user: "luca_souza", lastMessage: "Vi você no Direito também?", time: "2 horas", unread: false },
    { id: 3, user: "marcos_eng", lastMessage: "O Cálculo 3 tá osso...", time: "1 dia", unread: false }
  ];

  // Mock messages for each chat
  const [chatHistory, setChatHistory] = useState<Record<number, Message[]>>({
    1: [
      { id: 101, text: "Oi Ana! Gostei muito do seu perfil.", time: "10:30", sender: "me" },
      { id: 102, text: "Oi! Tudo bem? Obrigada por demonstrar interesse! 😉", time: "10:35", sender: "them" }
    ],
    2: [
      { id: 201, text: "E aí Luca, beleza?", time: "Ontem", sender: "me" },
      { id: 202, text: "Beleza cara! Vi você no Direito também?", time: "Ontem", sender: "them" }
    ],
    3: [
      { id: 301, text: "Salve Marcos! E a prova de ontem?", time: "Segunda", sender: "me" },
      { id: 302, text: "O Cálculo 3 tá osso...", time: "Segunda", sender: "them" }
    ]
  });

  useEffect(() => {
    const timer = setTimeout(() => setLoading(false), 500);
    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [selectedChat, chatHistory]);

  const handleSendMessage = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newMessage.trim() || !selectedChat) return;

    const msg: Message = {
      id: Date.now(),
      text: newMessage,
      time: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
      sender: "me"
    };

    setChatHistory({
      ...chatHistory,
      [selectedChat.id]: [...(chatHistory[selectedChat.id] || []), msg]
    });
    setNewMessage("");
  };

  if (loading) return (
    <main className={styles.main}>
      <div className={styles.loading}>Carregando mensagens...</div>
    </main>
  );

  return (
    <main className={styles.main}>
      
      <div className={styles.container}>
        {!selectedChat ? (
          <div className={styles.listContainer}>
            <div className={styles.header}>
              <h1>Suas Conversas</h1>
              <p>Diga algo para seus crushes e amigos da UERJ.</p>
            </div>

            <div className={styles.chatList}>
              {conversations.map((conv) => (
                <div 
                  key={conv.id} 
                  className={conv.unread ? styles.chatItemUnread : styles.chatItem}
                  onClick={() => setSelectedChat(conv)}
                >
                  <div className={styles.avatar}>
                    {conv.user[0].toUpperCase()}
                  </div>
                  <div className={styles.info}>
                    <div className={styles.top}>
                      <span className={styles.username}>@{conv.user}</span>
                      <span className={styles.time}>{conv.time}</span>
                    </div>
                    <p className={styles.lastMessage}>{conv.lastMessage}</p>
                  </div>
                  {conv.unread && <div className={styles.unreadDot} />}
                </div>
              ))}
            </div>

            {conversations.length === 0 && (
              <div className={styles.empty}>
                <p>Você ainda não tem conversas. Comece demonstrando interesse em alguém!</p>
                <Link href="/crushes" className={styles.findCrush}>Ver Crushes</Link>
              </div>
            )}
          </div>
        ) : (
          <div className={styles.chatWindow}>
            <div className={styles.chatHeader}>
              <button className={styles.backBtn} onClick={() => setSelectedChat(null)}>
                <ArrowLeft size={24} />
              </button>
              <div className={styles.chatAvatar}>
                {selectedChat.user[0].toUpperCase()}
              </div>
              <div className={styles.chatUserInfo}>
                <span className={styles.chatUsername}>@{selectedChat.user}</span>
                <span className={styles.chatStatus}>online</span>
              </div>
              <div className={styles.chatActions}>
                <MoreVertical size={20} />
              </div>
            </div>

            <div className={styles.chatBody}>
              {chatHistory[selectedChat.id]?.map((msg) => (
                <div key={msg.id} className={msg.sender === "me" ? styles.msgMe : styles.msgThem}>
                  <div className={styles.bubble}>
                    <p>{msg.text}</p>
                    <span className={styles.bubbleTime}>{msg.time}</span>
                  </div>
                </div>
              ))}
              <div ref={messagesEndRef} />
            </div>

            <form className={styles.chatFooter} onSubmit={handleSendMessage}>
              <button type="button" className={styles.chatIconBtn}><Smile size={24} /></button>
              <button type="button" className={styles.chatIconBtn}><Paperclip size={22} /></button>
              <input 
                type="text" 
                placeholder="Mensagem" 
                className={styles.chatInput}
                value={newMessage}
                onChange={(e) => setNewMessage(e.target.value)}
              />
              <button type="submit" className={styles.sendBtn} disabled={!newMessage.trim()}>
                <Send size={24} />
              </button>
            </form>
          </div>
        )}
      </div>
    </main>
  );
}
