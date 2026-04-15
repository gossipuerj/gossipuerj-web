"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import GossipCard from "@/components/ui/GossipCard";
import styles from "./page.module.css";
import { LogOut, User as UserIcon, Shield, Eye, EyeOff } from "lucide-react";

import { MOCK_GOSSIPS, MOCK_USER } from "@/lib/mocks";

export default function ProfilePage() {
  const [user, setUser] = useState<any>(MOCK_USER);
  const [myGossips, setMyGossips] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [isUpdating, setIsUpdating] = useState(false);

  // Identity state
  const [gender, setGender] = useState(MOCK_USER.gender);
  const [orientation, setOrientation] = useState(MOCK_USER.orientation);
  const [instagram, setInstagram] = useState(MOCK_USER.instagram);
  const [avatar, setAvatar] = useState(MOCK_USER.avatar);
  const [course, setCourse] = useState(MOCK_USER.course);
  const [firstName, setFirstName] = useState(MOCK_USER.firstName);
  const [lastName, setLastName] = useState(MOCK_USER.lastName);
  const [bio, setBio] = useState(MOCK_USER.bio);
  const [showInGallery, setShowInGallery] = useState(MOCK_USER.showInGallery);

  const router = useRouter();

  useEffect(() => {
    const timer = setTimeout(() => {
      setMyGossips(MOCK_GOSSIPS.filter(g => g.author === MOCK_USER.id));
      setLoading(false);
    }, 800);
    return () => clearTimeout(timer);
  }, []);

  const handleLogout = () => {
    alert("Logout simulado (MOCK)");
    router.push("/");
  };

  const handleUpdateProfile = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsUpdating(true);
    setTimeout(() => {
      alert("Perfil atualizado!\nBio: " + bio + "\nGaleria: " + (showInGallery ? "Visível" : "Oculto"));
      setIsUpdating(false);
    }, 1000);
  };

  const handleImageChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      if (file.size > 2 * 1024 * 1024) {
        alert("A imagem é muito grande! Por favor, escolha uma imagem menor que 2MB.");
        return;
      }

      const reader = new FileReader();
      reader.onloadend = () => {
        const img = new Image();
        img.src = reader.result as string;
        img.onload = () => {
          const canvas = document.createElement("canvas");
          const MAX_WIDTH = 400;
          const MAX_HEIGHT = 400;
          let width = img.width;
          let height = img.height;

          if (width > height) {
            if (width > MAX_WIDTH) {
              height *= MAX_WIDTH / width;
              width = MAX_WIDTH;
            }
          } else {
            if (height > MAX_HEIGHT) {
              width *= MAX_HEIGHT / height;
              height = MAX_HEIGHT;
            }
          }

          canvas.width = width;
          canvas.height = height;
          const ctx = canvas.getContext("2d");
          ctx?.drawImage(img, 0, 0, width, height);
          const dataUrl = canvas.toDataURL("image/jpeg", 0.7);
          setAvatar(dataUrl);
        };
      };
      reader.readAsDataURL(file);
    }
  };

  const uerjCourses = [
    "Não informado", 
    "Administração", "Arqueologia", "Arquitetura e Urbanismo", "Artes Visuais",
    "Ciência da Computação", "Ciência da Computação – Zona Oeste", "Ciências Ambientais", 
    "Ciências Atuariais", "Ciências Biológicas", "Ciências Biológicas – São Gonçalo", 
    "Ciências Biológicas – Zona Oeste", "Ciências Contábeis", "Ciências Econômicas", 
    "Ciências Sociais", "Cinema e Audiovisual (licenciatura) – Duque de Caxias", 
    "Design", "Direito", "Educação Física", "Enfermagem", "Engenharia Ambiental e Sanitária", 
    "Engenharia Cartográfica", "Engenharia Civil", "Engenharia de Computação – Nova Friburgo", 
    "Engenharia de Energias Renováveis", "Engenharia de Materiais – Zona Oeste", 
    "Engenharia de Produção", "Engenharia de Produção – Resende", "Engenharia de Produção – Zona Oeste", 
    "Engenharia Elétrica", "Engenharia Mecânica", "Engenharia Mecânica – Nova Friburgo", 
    "Engenharia Mecânica – Resende", "Engenharia Metalúrgica – Zona Oeste", 
    "Engenharia Química", "Engenharia Química – Resende", "Estatística", "Farmácia – Zona Oeste", 
    "Filosofia", "Física", "Fisioterapia", "Geografia", "Geografia – Cabo Frio", 
    "Geografia (licenciatura) – Duque de Caxias", "Geografia (licenciatura) – São Gonçalo", 
    "Geologia", "História", "História – São Gonçalo", "História da Arte", "Jornalismo", 
    "Letras", "Letras (licenciatura) – São Gonçalo", "Matemática", 
    "Matemática (licenciatura) – Duque de Caxias", "Matemática (licenciatura) – São Gonçalo", 
    "Medicina", "Medicina – Cabo Frio", "Nutrição", "Oceanografia", "Odontologia", 
    "Pedagogia", "Pedagogia – Duque de Caxias", "Pedagogia – São Gonçalo", "Psicologia", 
    "Química", "Relações Internacionais", "Relações Públicas", "Serviço Social", 
    "Tecnologia em Análise e Desenvolvimento de Sistemas – Zona Oeste", 
    "Tecnologia em Construção Naval – Zona Oeste", "Turismo"
  ];

  if (loading && !user) return (
    <main className={styles.main}>
      <div className={styles.loading}>Carregando...</div>
    </main>
  );

  return (
    <main className={styles.main}>

      <div className={styles.container}>
        <div className={styles.profileHeader}>
          <div className={styles.avatarLarge}>
            {avatar ? <img src={avatar} alt="Avatar" className={styles.avatarImg} /> : <UserIcon size={48} />}
          </div>
          <div className={styles.headerInfo}>
            <h1>@{user?.username}</h1>
            <p>Membro da comunidade GlossipUerj</p>
          </div>
          <button onClick={handleLogout} className={styles.logoutBtn}>
            <LogOut size={20} /> Sair
          </button>
        </div>

        <div className={styles.stats}>
          <div className={styles.statCard}>
            <h3>{myGossips.length}</h3>
            <p>Fofocas Postadas</p>
          </div>
          <div className={styles.statCard}>
            <h3>{myGossips.length > 0 ? "Ativo" : "Novo"}</h3>
            <p>Status</p>
          </div>
        </div>

        <section className={styles.privacyCard}>
          <div className={styles.privacyHeader}>
            <Shield size={24} />
            <h2>Privacidade da Galeria</h2>
          </div>
          <p>Escolha se deseja que seu perfil seja listado na página de Crushes para outros alunos.</p>
          <button 
            type="button" 
            className={showInGallery ? styles.toggleOn : styles.toggleOff}
            onClick={() => setShowInGallery(!showInGallery)}
          >
            {showInGallery ? <Eye size={20} /> : <EyeOff size={20} />}
            {showInGallery ? "Perfil Visível na Galeria" : "Perfil Oculto na Galeria"}
          </button>
        </section>

        <section className={styles.settings}>
          <h2 className={styles.sectionTitle}>⚙️ Configurações de Identidade</h2>
          <form className={styles.form} onSubmit={handleUpdateProfile}>
            <div className={styles.formRow}>
              <div className={styles.formGroup}>
                <label>Nome</label>
                <input 
                  type="text" 
                  value={firstName} 
                  onChange={(e) => setFirstName(e.target.value)} 
                  placeholder="Nome"
                />
              </div>
              <div className={styles.formGroup}>
                <label>Sobrenome</label>
                <input 
                  type="text" 
                  value={lastName} 
                  onChange={(e) => setLastName(e.target.value)} 
                  placeholder="Sobrenome"
                />
              </div>
            </div>

            <div className={styles.formGroup}>
              <label>Bio / Descrição</label>
              <textarea 
                value={bio} 
                onChange={(e) => setBio(e.target.value)} 
                placeholder="Conte um pouco sobre você..."
                className={styles.textarea}
              />
            </div>

            <div className={styles.formGroup}>
              <label>Foto de Perfil</label>
              <div className={styles.avatarUpload}>
                {avatar && <img src={avatar} alt="Preview" className={styles.preview} />}
                <input type="file" accept="image/*" onChange={handleImageChange} className={styles.fileInput} />
              </div>
            </div>
            
            <div className={styles.formGroup}>
              <label>Seu Curso</label>
              <select value={course} onChange={(e) => setCourse(e.target.value)}>
                {uerjCourses.map(c => (
                  <option key={c} value={c}>{c}</option>
                ))}
              </select>
            </div>
            <div className={styles.formRow}>
              <div className={styles.formGroup}>
                <label>Gênero</label>
                <select value={gender} onChange={(e) => setGender(e.target.value)}>
                  <option value="Não informado">Não informado</option>
                  <option value="Masculino">Masculino</option>
                  <option value="Feminino">Feminino</option>
                  <option value="Não-binário">Não-binário</option>
                  <option value="Outro">Outro</option>
                </select>
              </div>
              <div className={styles.formGroup}>
                <label>Orientação Sexual</label>
                <select value={orientation} onChange={(e) => setOrientation(e.target.value)}>
                  <option value="Não informado">Não informado</option>
                  <option value="Heterossexual">Heterossexual</option>
                  <option value="Homossexual">Homossexual</option>
                  <option value="Bissexual">Bissexual</option>
                  <option value="Pansexual">Pansexual</option>
                  <option value="Asexual">Asexual</option>
                  <option value="Outra">Outra</option>
                </select>
              </div>
            </div>
            <div className={styles.formGroup}>
              <label>Instagram (@)</label>
              <input 
                type="text" 
                value={instagram} 
                onChange={(e) => setInstagram(e.target.value)} 
                placeholder="@username"
              />
            </div>
            <button type="submit" className={styles.saveProfileBtn} disabled={isUpdating}>
              {isUpdating ? "Salvando..." : "Salvar Alterações"}
            </button>
          </form>
        </section>

        <section className={styles.myPosts}>
          <h2 className={styles.sectionTitle}>Suas Publicações</h2>
          <div className={styles.grid}>
            {myGossips.map((gossip) => (
              <GossipCard 
                key={gossip._id}
                id={gossip._id}
                content={gossip.content}
                timestamp={new Date(gossip.createdAt).toLocaleTimeString()}
                category={gossip.category}
                authorId={gossip.author}
                currentUserId={user?.id}
              />
            ))}
            {myGossips.length === 0 && (
              <div className={styles.empty}>
                Você ainda não postou nenhuma fofoca. O que está esperando?
              </div>
            )}
          </div>
        </section>
      </div>
    </main>
  );
}
