export const MOCK_USER = {
  id: "user-123",
  username: "jorgegdoliveira",
  firstName: "Jorge",
  lastName: "Oliveira",
  course: "Sistemas de Informação",
  gender: "Masculino",
  orientation: "Heterossexual",
  instagram: "jorgegdoliveira",
  avatar: "https://i.pravatar.cc/150?u=jorge",
  bio: "Estudante de TI na UERJ, apaixonado por tecnologia e fofocas bem contadas.",
  showInGallery: true
};

export const MOCK_PROFILES = [
  MOCK_USER,
  {
    _id: "2",
    username: "mari_uerj",
    firstName: "Mariana",
    lastName: "Costa",
    course: "Medicina",
    gender: "Feminino",
    orientation: "Bissexual",
    instagram: "mari_uerj",
    avatar: "https://i.pravatar.cc/150?u=mari",
    bio: "Futura médica e fofoqueira de plantão.",
    showInGallery: true
  },
  {
    _id: "3",
    username: "lucas_eng",
    firstName: "Lucas",
    lastName: "Pereira",
    course: "Engenharia Civil",
    gender: "Masculino",
    orientation: "Gay",
    instagram: "lucas_p",
    avatar: "https://i.pravatar.cc/150?u=lucas",
    bio: "Construindo prédios e destruindo corações.",
    showInGallery: true
  },
  {
    _id: "4",
    username: "ana_bio",
    firstName: "Ana Clara",
    lastName: "Souza",
    course: "Ciências Biológicas",
    gender: "Feminino",
    orientation: "Lésbica",
    instagram: "anaclara_bio",
    avatar: "https://i.pravatar.cc/150?u=ana",
    bio: "Estudando a vida e procurando um amor.",
    showInGallery: true
  }
];

export const MOCK_GOSSIPS = [
  {
    _id: "g1",
    content: "Alguém vium o menino da camisa amarela no 5º andar? Que gato! #paquera #uerj #maracana",
    category: "Paquera",
    target: "@menino_amarelo",
    createdAt: new Date().toISOString(),
    author: "user-123",
    image: "https://images.unsplash.com/photo-1523050854058-8df90110c9f1?q=80&w=800"
  },
  {
    _id: "g2",
    content: "O bandejão hoje estava nota 10, parabéns para a equipe! #bandejao #uerjfome #delicia",
    category: "Fofoca",
    target: "Bandejão",
    createdAt: new Date(Date.now() - 3600000).toISOString(),
    author: "mari-456",
    image: "https://images.unsplash.com/photo-1567521464027-f127ff144326?q=80&w=800"
  },
  {
    _id: "g3",
    content: "Não aguento mais essa prova de Cálculo 2, socorro! #calculo2 #engenharia #uerjdesespero",
    category: "Desabafo",
    target: "Cálculo 2",
    createdAt: new Date(Date.now() - 7200000).toISOString(),
    author: "lucas-789"
  }
];
