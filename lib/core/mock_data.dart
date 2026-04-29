import "models.dart";

const List<String> uerjCourses = [
  "Administração",
  "Arqueologia",
  "Arquitetura e Urbanismo",
  "Artes Visuais",
  "Ciência da Computação",
  "Ciência da Computação – Zona Oeste",
  "Ciências Ambientais",
  "Ciências Atuariais",
  "Ciências Biológicas",
  "Ciências Biológicas – São Gonçalo",
  "Ciências Biológicas – Zona Oeste",
  "Ciências Contábeis",
  "Ciências Econômicas",
  "Ciências Sociais",
  "Cinema e Audiovisual (licenciatura) – Duque de Caxias",
  "Design",
  "Direito",
  "Educação Física",
  "Enfermagem",
  "Engenharia Ambiental e Sanitária",
  "Engenharia Cartográfica",
  "Engenharia Civil",
  "Engenharia de Computação – Nova Friburgo",
  "Engenharia de Energias Renováveis",
  "Engenharia de Materiais – Zona Oeste",
  "Engenharia de Produção",
  "Engenharia de Produção – Resende",
  "Engenharia de Produção – Zona Oeste",
  "Engenharia Elétrica",
  "Engenharia Mecânica",
  "Engenharia Mecânica – Nova Friburgo",
  "Engenharia Mecânica – Resende",
  "Engenharia Metalúrgica – Zona Oeste",
  "Engenharia Química",
  "Engenharia Química – Resende",
  "Estatística",
  "Farmácia – Zona Oeste",
  "Filosofia",
  "Física",
  "Fisioterapia",
  "Geografia",
  "Geografia – Cabo Frio",
  "Geografia (licenciatura) – Duque de Caxias",
  "Geografia (licenciatura) – São Gonçalo",
  "Geologia",
  "História",
  "História – São Gonçalo",
  "História da Arte",
  "Jornalismo",
  "Letras",
  "Letras (licenciatura) – São Gonçalo",
  "Matemática",
  "Matemática (licenciatura) – Duque de Caxias",
  "Matemática (licenciatura) – São Gonçalo",
  "Medicina",
  "Medicina – Cabo Frio",
  "Nutrição",
  "Oceanografia",
  "Odontologia",
  "Pedagogia",
  "Pedagogia – Duque de Caxias",
  "Pedagogia – São Gonçalo",
  "Psicologia",
  "Química",
  "Relações Internacionais",
  "Relações Públicas",
  "Serviço Social",
  "Tecnologia em Análise e Desenvolvimento de Sistemas – Zona Oeste",
  "Tecnologia em Construção Naval – Zona Oeste",
  "Turismo",
];

const List<String> genders = [
  "Todos",
  "Masculino",
  "Feminino",
  "Não-Binário",
  "Outro",
];

const List<String> orientations = [
  "Todos",
  "Heterossexual",
  "Homossexual",
  "Bissexual",
  "Pansexual",
  "Assexual",
  "Outro",
];

const UserProfile mockUser = UserProfile(
  id: "user-123",
  username: "jorgegdoliveira",
  firstName: "Jorge",
  lastName: "Oliveira",
  course: "Sistemas de Informação",
  gender: "Masculino",
  orientation: "Heterossexual",
  instagram: "jorgegdoliveira",
  avatarUrl: "https://i.pravatar.cc/150?u=jorge",
  bio:
      "Estudante de TI na UERJ, apaixonado por tecnologia e fofocas bem contadas.",
  showInGallery: true,
);

final List<UserProfile> mockProfiles = [
  mockUser,
  const UserProfile(
    id: "2",
    username: "mari_uerj",
    firstName: "Mariana",
    lastName: "Costa",
    course: "Medicina",
    gender: "Feminino",
    orientation: "Bissexual",
    instagram: "mari_uerj",
    avatarUrl: "https://i.pravatar.cc/150?u=mari",
    bio: "Futura médica e fofoqueira de plantão.",
    showInGallery: true,
  ),
  const UserProfile(
    id: "3",
    username: "lucas_eng",
    firstName: "Lucas",
    lastName: "Pereira",
    course: "Engenharia Civil",
    gender: "Masculino",
    orientation: "Gay",
    instagram: "lucas_p",
    avatarUrl: "https://i.pravatar.cc/150?u=lucas",
    bio: "Construindo prédios e destruindo corações.",
    showInGallery: true,
  ),
  const UserProfile(
    id: "4",
    username: "ana_bio",
    firstName: "Ana Clara",
    lastName: "Souza",
    course: "Ciências Biológicas",
    gender: "Feminino",
    orientation: "Lésbica",
    instagram: "anaclara_bio",
    avatarUrl: "https://i.pravatar.cc/150?u=ana",
    bio: "Estudando a vida e procurando um amor.",
    showInGallery: true,
  ),
];

final List<GossipPost> mockGossips = [
  GossipPost(
    id: "g1",
    content:
        "Alguém vium o menino da camisa amarela no 5º andar? Que gato! #paquera #uerj #maracana",
    category: "Paquera",
    target: "@menino_amarelo",
    timestamp: DateTime.now(),
    authorId: "user-123",
    imageUrl:
        "https://images.unsplash.com/photo-1523050854058-8df90110c9f1?q=80&w=800",
    comments: const [
      GossipComment(
        id: "c1",
        text: "Gente, eu tava lá e foi exatamente assim!",
        author: "Anônimo",
      ),
      GossipComment(
        id: "c2",
        text: "Alguém sabe quem era o rapaz?",
        author: "Anônimo",
      ),
    ],
  ),
  GossipPost(
    id: "g2",
    content:
        "O bandejão hoje estava nota 10, parabéns para a equipe! #bandejao #uerjfome #delicia",
    category: "Fofoca",
    target: "Bandejão",
    timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    authorId: "mari-456",
    imageUrl:
        "https://images.unsplash.com/photo-1567521464027-f127ff144326?q=80&w=800",
    comments: const [
      GossipComment(
        id: "c3",
        text: "Gente, eu tava lá e foi exatamente assim!",
        author: "Anônimo",
      ),
      GossipComment(
        id: "c4",
        text: "Alguém sabe quem era o rapaz?",
        author: "Anônimo",
      ),
    ],
  ),
  GossipPost(
    id: "g3",
    content:
        "Não aguento mais essa prova de Cálculo 2, socorro! #calculo2 #engenharia #uerjdesespero",
    category: "Desabafo",
    target: "Cálculo 2",
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    authorId: "lucas-789",
    comments: const [
      GossipComment(
        id: "c5",
        text: "Gente, eu tava lá e foi exatamente assim!",
        author: "Anônimo",
      ),
      GossipComment(
        id: "c6",
        text: "Alguém sabe quem era o rapaz?",
        author: "Anônimo",
      ),
    ],
  ),
];

final Map<String, List<UniversityEvent>> mockEvents = {
  "2026-04-10": const [
    UniversityEvent(
      id: "1",
      title: "Choppada de Direito",
      category: "Social",
      location: "Concha Acústica",
      time: "18:00",
      description:
          "A melhor choppada da UERJ está de volta! Open bar e DJs convidados.",
    ),
  ],
  "2026-04-12": const [
    UniversityEvent(
      id: "2",
      title: "Seminário de IA na Educação",
      category: "Acadêmico",
      location: "Auditório 11",
      time: "10:00",
      description:
          "Palestra com especialistas sobre o futuro da IA nas universidades.",
    ),
  ],
  "2026-04-15": const [
    UniversityEvent(
      id: "3",
      title: "InterUERJ - Futsal",
      category: "Esporte",
      location: "Ginásio",
      time: "14:00",
      description: "Engenharia vs Medicina. Venha torcer pelo seu curso!",
    ),
  ],
  "2026-04-20": const [
    UniversityEvent(
      id: "4",
      title: "Cine UERJ: O Auto da Compadecida 2",
      category: "Cultura",
      location: "Teatro Odylo Costa Filho",
      time: "19:00",
      description: "Sessão gratuita para alunos e funcionários.",
    ),
  ],
};

const List<ConversationSummary> seedConversations = [
  ConversationSummary(
    id: 1,
    user: "ana_uerj",
    lastMessage: "Obrigada por demonstrar interesse! 😉",
    timeLabel: "10 min",
    unread: true,
  ),
  ConversationSummary(
    id: 2,
    user: "luca_souza",
    lastMessage: "Vi você no Direito também?",
    timeLabel: "2 horas",
    unread: false,
  ),
  ConversationSummary(
    id: 3,
    user: "marcos_eng",
    lastMessage: "O Cálculo 3 tá osso...",
    timeLabel: "1 dia",
    unread: false,
  ),
];

final Map<int, List<ChatMessage>> seedChatHistory = {
  1: const [
    ChatMessage(
      id: 101,
      text: "Oi Ana! Gostei muito do seu perfil.",
      timeLabel: "10:30",
      sender: ChatSender.me,
    ),
    ChatMessage(
      id: 102,
      text: "Oi! Tudo bem? Obrigada por demonstrar interesse! 😉",
      timeLabel: "10:35",
      sender: ChatSender.them,
    ),
  ],
  2: const [
    ChatMessage(
      id: 201,
      text: "E aí Luca, beleza?",
      timeLabel: "Ontem",
      sender: ChatSender.me,
    ),
    ChatMessage(
      id: 202,
      text: "Beleza cara! Vi você no Direito também?",
      timeLabel: "Ontem",
      sender: ChatSender.them,
    ),
  ],
  3: const [
    ChatMessage(
      id: 301,
      text: "Salve Marcos! E a prova de ontem?",
      timeLabel: "Segunda",
      sender: ChatSender.me,
    ),
    ChatMessage(
      id: 302,
      text: "O Cálculo 3 tá osso...",
      timeLabel: "Segunda",
      sender: ChatSender.them,
    ),
  ],
};
