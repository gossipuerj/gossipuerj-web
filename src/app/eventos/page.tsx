"use client";

import { useState, useEffect } from "react";
import styles from "./page.module.css";
import { MOCK_EVENTS, UniversityEvent } from "@/lib/events";
import { ChevronLeft, ChevronRight, Calendar as CalendarIcon, MapPin, Clock, Plus, X } from "lucide-react";

export default function EventsPage() {
  const [currentDate, setCurrentDate] = useState(new Date(2026, 3, 1)); // Abril de 2026
  const [selectedDate, setSelectedDate] = useState<string | null>("2026-04-10");
  const [events, setEvents] = useState<Record<string, UniversityEvent[]>>(MOCK_EVENTS);
  const [showAddModal, setShowAddModal] = useState(false);

  // Form states
  const [newTitle, setNewTitle] = useState("");
  const [newCategory, setNewCategory] = useState<any>("Social");
  const [newLocation, setNewLocation] = useState("");
  const [newTime, setNewTime] = useState("");
  const [newDesc, setNewDesc] = useState("");

  const monthNames = [
    "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
    "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
  ];

  const daysInMonth = (year: number, month: number) => new Date(year, month + 1, 0).getDate();
  const firstDayOfMonth = (year: number, month: number) => new Date(year, month, 1).getDay();

  const handlePrevMonth = () => {
    setCurrentDate(new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1));
  };

  const handleNextMonth = () => {
    setCurrentDate(new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1));
  };

  const handleAddEvent = (e: React.FormEvent) => {
    e.preventDefault();
    if (!selectedDate || !newTitle) return;

    const newEvent: UniversityEvent = {
      id: Date.now().toString(),
      title: newTitle,
      category: newCategory,
      location: newLocation,
      time: newTime,
      description: newDesc
    };

    const updatedEvents = { ...events };
    if (!updatedEvents[selectedDate]) updatedEvents[selectedDate] = [];
    updatedEvents[selectedDate] = [...updatedEvents[selectedDate], newEvent];

    setEvents(updatedEvents);
    setShowAddModal(false);
    
    // Reset form
    setNewTitle("");
    setNewLocation("");
    setNewTime("");
    setNewDesc("");
  };

  const year = currentDate.getFullYear();
  const month = currentDate.getMonth();
  const totalDays = daysInMonth(year, month);
  const startDay = firstDayOfMonth(year, month);

  const days = [];
  for (let i = 0; i < startDay; i++) {
    days.push(<div key={`empty-${i}`} className={styles.emptyDay} />);
  }

  for (let day = 1; day <= totalDays; day++) {
    const dateStr = `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
    const hasEvents = events[dateStr] && events[dateStr].length > 0;
    const isSelected = selectedDate === dateStr;

    days.push(
      <div 
        key={day} 
        className={`${styles.day} ${isSelected ? styles.selectedDay : ""} ${hasEvents ? styles.hasEvents : ""}`}
        onClick={() => setSelectedDate(dateStr)}
      >
        <span className={styles.dayNumber}>{day}</span>
        {hasEvents && <div className={styles.eventIndicator} />}
      </div>
    );
  }

  const selectedEvents = selectedDate ? events[selectedDate] || [] : [];

  return (
    <main className={styles.main}>

      <div className={styles.container}>
        <section className={styles.hero}>
          <h1>Calendário de <span>Eventos</span></h1>
          <p>Fique por dentro de tudo o que acontece na UERJ.</p>
        </section>

        <div className={styles.content}>
          <div className={styles.calendarSection}>
            <div className={styles.calendarHeader}>
              <button onClick={handlePrevMonth} className={styles.navBtn}><ChevronLeft /></button>
              <h2>{monthNames[month]} {year}</h2>
              <button onClick={handleNextMonth} className={styles.navBtn}><ChevronRight /></button>
            </div>
            
            <div className={styles.weekdayRow}>
              {["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"].map(d => (
                <div key={d} className={styles.weekday}>{d}</div>
              ))}
            </div>

            <div className={styles.calendarGrid}>
              {days}
            </div>
          </div>

          <div className={styles.detailsSection}>
            <div className={styles.detailsHeader}>
              <div className={styles.headerInfo}>
                <CalendarIcon size={20} className={styles.accent} />
                <h3>Eventos do dia {selectedDate?.split('-').reverse().join('/')}</h3>
              </div>
              <button 
                className={styles.addBtn} 
                onClick={() => setShowAddModal(true)}
                title="Novo Evento"
              >
                <Plus size={20} />
              </button>
            </div>

            <div className={styles.eventList}>
              {selectedEvents.length > 0 ? (
                selectedEvents.map((event) => (
                  <div key={event.id} className={styles.eventCard}>
                    <div className={styles.categoryBadge} data-category={event.category}>
                      {event.category}
                    </div>
                    <h4>{event.title}</h4>
                    <p className={styles.desc}>{event.description}</p>
                    <div className={styles.meta}>
                      <div className={styles.metaItem}>
                        <MapPin size={14} /> <span>{event.location}</span>
                      </div>
                      <div className={styles.metaItem}>
                        <Clock size={14} /> <span>{event.time}</span>
                      </div>
                    </div>
                  </div>
                ))
              ) : (
                <div className={styles.noEvents}>
                  <p>Nenhum evento programado para este dia.</p>
                  <span>Aproveite para estudar no 11º andar! 📚</span>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>

      {showAddModal && (
        <div className={styles.modalOverlay}>
          <div className={styles.modal}>
            <div className={styles.modalHeader}>
              <h3>Cadastrar Novo Evento</h3>
              <button onClick={() => setShowAddModal(false)}><X /></button>
            </div>
            <p className={styles.modalDate}>Data: {selectedDate?.split('-').reverse().join('/')}</p>
            
            <form onSubmit={handleAddEvent} className={styles.form}>
              <div className={styles.formGroup}>
                <label>Título do Evento</label>
                <input required type="text" value={newTitle} onChange={e => setNewTitle(e.target.value)} placeholder="Ex: Choppada de Engenharia" />
              </div>
              
              <div className={styles.formRow}>
                <div className={styles.formGroup}>
                  <label>Categoria</label>
                  <select value={newCategory} onChange={e => setNewCategory(e.target.value)}>
                    <option value="Social">Social</option>
                    <option value="Acadêmico">Acadêmico</option>
                    <option value="Esporte">Esporte</option>
                    <option value="Cultura">Cultura</option>
                  </select>
                </div>
                <div className={styles.formGroup}>
                  <label>Horário</label>
                  <input required type="text" value={newTime} onChange={e => setNewTime(e.target.value)} placeholder="Ex: 18:00" />
                </div>
              </div>

              <div className={styles.formGroup}>
                <label>Localização</label>
                <input required type="text" value={newLocation} onChange={e => setNewLocation(e.target.value)} placeholder="Ex: Campus Maracanã - 5º Andar" />
              </div>

              <div className={styles.formGroup}>
                <label>Descrição</label>
                <textarea value={newDesc} onChange={e => setNewDesc(e.target.value)} placeholder="Conte mais sobre o evento..." />
              </div>

              <button type="submit" className={styles.submitBtn}>Salvar Evento</button>
            </form>
          </div>
        </div>
      )}
    </main>
  );
}
