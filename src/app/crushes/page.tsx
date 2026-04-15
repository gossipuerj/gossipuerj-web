"use client";

import { useEffect, useState } from "react";
import ProfileCard from "@/components/ui/ProfileCard";
import styles from "./page.module.css";
import Link from "next/link";
import { MOCK_PROFILES, MOCK_USER } from "@/lib/mocks";
import { UERJ_COURSES, GENDERS, ORIENTATIONS } from "@/lib/constants";
import { Search } from "lucide-react";

interface UserProfile {
  _id: string;
  username: string;
  firstName?: string;
  lastName?: string;
  instagram?: string;
  avatar?: string;
  gender?: string;
  orientation?: string;
  course?: string;
  showInGallery?: boolean;
}

export default function CrushesPage() {
  const [profiles, setProfiles] = useState<UserProfile[]>([]);
  const [isLoggedIn, setIsLoggedIn] = useState(true);
  const [currentUsername, setCurrentUsername] = useState<string | undefined>(MOCK_USER.username);
  const [loading, setLoading] = useState(true);

  // Filter States
  const [search, setSearch] = useState("");
  const [selectedCourse, setSelectedCourse] = useState("Todos");
  const [selectedGender, setSelectedGender] = useState("Todos");
  const [selectedOrientation, setSelectedOrientation] = useState("Todos");

  useEffect(() => {
    const timer = setTimeout(() => {
      setProfiles(MOCK_PROFILES as any);
      setLoading(false);
    }, 800);
    return () => clearTimeout(timer);
  }, []);

  const filteredProfiles = profiles.filter(profile => {
    // Não exibir o próprio card se estiver logado
    if (isLoggedIn && profile.username === currentUsername) {
      return false;
    }

    // Respeitar configuração de privacidade
    if (profile.showInGallery === false) {
      return false;
    }

    const matchesSearch = 
      profile.username.toLowerCase().includes(search.toLowerCase()) ||
      (profile.firstName?.toLowerCase() || "").includes(search.toLowerCase()) ||
      (profile.lastName?.toLowerCase() || "").includes(search.toLowerCase());
    
    const matchesCourse = selectedCourse === "Todos" || profile.course === selectedCourse;
    const matchesGender = selectedGender === "Todos" || profile.gender === selectedGender;
    const matchesOrientation = selectedOrientation === "Todos" || profile.orientation === selectedOrientation;

    return matchesSearch && matchesCourse && matchesGender && matchesOrientation;
  });

  return (
    <main className={styles.main}>

      <section className={styles.hero}>
        <h1 className={styles.title}>Galeria de <span>Crushes</span></h1>
        <p className={styles.subtitle}>Encontre outros alunos da UERJ e demonstre seu interesse.</p>
      </section>

      <div className={styles.container}>
        {!isLoggedIn && (
          <div className={styles.authReminder}>
            <p>Você precisa estar logado com seu <strong>@ do Instagram</strong> para dar like nos perfis.</p>
            <Link href="/login" className={styles.loginBtn}>Entrar / Registrar</Link>
          </div>
        )}

        <div className={styles.filterSection}>
          <div className={styles.searchWrapper}>
            <Search className={styles.searchIcon} size={20} />
            <input 
              type="text" 
              placeholder="Procurar por nome ou @..." 
              className={styles.searchInput}
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
          </div>

          <div className={styles.advancedFilters}>
            <div className={styles.filterGroup}>
              <label>Curso:</label>
              <select 
                value={selectedCourse} 
                onChange={(e) => setSelectedCourse(e.target.value)}
                className={styles.select}
              >
                <option value="Todos">Todos os Cursos</option>
                {UERJ_COURSES.map(c => <option key={c} value={c}>{c}</option>)}
              </select>
            </div>

            <div className={styles.filterGroup}>
              <label>Gênero:</label>
              <select 
                value={selectedGender} 
                onChange={(e) => setSelectedGender(e.target.value)}
                className={styles.select}
              >
                {GENDERS.map(g => <option key={g} value={g}>{g}</option>)}
              </select>
            </div>

            <div className={styles.filterGroup}>
              <label>Orientação:</label>
              <select 
                value={selectedOrientation} 
                onChange={(e) => setSelectedOrientation(e.target.value)}
                className={styles.select}
              >
                {ORIENTATIONS.map(o => <option key={o} value={o}>{o}</option>)}
              </select>
            </div>
          </div>
        </div>

        <div className={styles.feedHeader}>
          <h2>
            {filteredProfiles.length} {filteredProfiles.length === 1 ? "Perfil Encontrado" : "Perfis Encontrados"}
          </h2>
        </div>

        {loading ? (
          <div className={styles.loading}>Carregando perfis...</div>
        ) : (
          <div className={styles.grid}>
            {filteredProfiles.map((profile) => (
              <ProfileCard 
                key={profile._id} 
                username={profile.username}
                firstName={profile.firstName}
                lastName={profile.lastName}
                instagram={profile.instagram}
                avatar={profile.avatar}
                gender={profile.gender}
                orientation={profile.orientation}
                course={profile.course}
                isLoggedIn={isLoggedIn}
                currentUsername={currentUsername}
              />
            ))}
            {filteredProfiles.length === 0 && (
              <div className={styles.empty}>
                Nenhum perfil corresponde aos seus filtros. Tente outra busca!
              </div>
            )}
          </div>
        )}
      </div>

    </main>
  );
}
