import { MOCK_GOSSIPS, MOCK_PROFILES, MOCK_USER } from "./mocks";

// Altere esta URL quando o servidor backend estiver pronto
export const API_BASE_URL = ""; 

const IS_MOCK = !API_BASE_URL;

export async function fetchApi(endpoint: string, options: any = {}) {
  if (IS_MOCK) {
    console.log(`[Mock API] Chamada para: ${endpoint}`);
    
    // Simulação de delay
    await new Promise(resolve => setTimeout(resolve, 500));

    if (endpoint === "/api/gossips") return { success: true, data: MOCK_GOSSIPS };
    if (endpoint === "/api/users") return { success: true, data: MOCK_PROFILES };
    if (endpoint === "/api/users/me") return { success: true, data: MOCK_USER };
    if (endpoint === "/api/auth/session") return { success: true, user: MOCK_USER };
    if (endpoint === "/api/users/me/gossips") return { success: true, data: MOCK_GOSSIPS.filter(g => g.author === MOCK_USER.id) };
    
    return { success: true, data: [] };
  }

  const res = await fetch(`${API_BASE_URL}${endpoint}`, options);
  return res.json();
}
