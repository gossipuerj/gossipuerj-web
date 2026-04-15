export interface UniversityEvent {
  id: string;
  title: string;
  category: "Acadêmico" | "Social" | "Cultura" | "Esporte";
  location: string;
  time: string;
  description: string;
}

export const MOCK_EVENTS: Record<string, UniversityEvent[]> = {
  "2026-04-10": [
    {
      id: "1",
      title: "Choppada de Direito",
      category: "Social",
      location: "Concha Acústica",
      time: "18:00",
      description: "A melhor choppada da UERJ está de volta! Open bar e DJs convidados."
    }
  ],
  "2026-04-12": [
    {
      id: "2",
      title: "Seminário de IA na Educação",
      category: "Acadêmico",
      location: "Auditório 11",
      time: "10:00",
      description: "Palestra com especialistas sobre o futuro da IA nas universidades."
    }
  ],
  "2026-04-15": [
    {
      id: "3",
      title: "InterUERJ - Futsal",
      category: "Esporte",
      location: "Ginásio",
      time: "14:00",
      description: "Engenharia vs Medicina. Venha torcer pelo seu curso!"
    }
  ],
  "2026-04-20": [
    {
      id: "4",
      title: "Cine UERJ: O Auto da Compadecida 2",
      category: "Cultura",
      location: "Teatro Odylo Costa Filho",
      time: "19:00",
      description: "Sessão gratuita para alunos e funcionários."
    }
  ]
};
