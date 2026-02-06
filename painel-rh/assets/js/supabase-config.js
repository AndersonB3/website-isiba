/*=============== SUPABASE CONFIGURATION ===============*/

// ⚠️ ATENÇÃO: A chave que você colocou está INCORRETA!
// Você precisa da chave "anon" ou "public", NÃO da "publishable"
// 
// Siga estes passos:
// 1. Acesse: https://supabase.com/dashboard/project/kklhcmrnraroletwbbid
// 2. Vá em: Settings > API
// 3. Copie a chave "anon" que começa com: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
// 4. Cole aqui embaixo na variável SUPABASE_ANON_KEY

const SUPABASE_URL = 'https://kklhcmrnraroletwbbid.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtrbGhjbXJucmFyb2xldHdiYmlkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjkxMjM2NDEsImV4cCI6MjA4NDY5OTY0MX0.dk1aXu6WiNN_Yn-PU-ST2nHOTca0PjDDZgYKauiUP0Y';

// Verificar se as credenciais foram configuradas
if (SUPABASE_ANON_KEY.includes('COLE_AQUI')) {
    console.error('❌ ERRO: Configure a chave ANON correta no arquivo supabase-config.js');
    console.log('📍 Acesse: https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/settings/api');
}

// Configurações adicionais do sistema
window.CONFIG = {
    bucket: 'contracheques',
    adminUser: 'admin.rh'
};

// Função para inicializar o Supabase quando a biblioteca estiver pronta
function inicializarSupabase() {
    if (window.supabase && window.supabase.createClient) {
        window.supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
        console.log('✅ Supabase configurado com sucesso!');
        console.log('✅ window.supabaseClient criado:', !!window.supabaseClient);
        return true;
    }
    return false;
}

// Tentar inicializar imediatamente
if (!inicializarSupabase()) {
    // Se não conseguir, aguardar a biblioteca carregar
    let tentativas = 0;
    const intervalo = setInterval(() => {
        if (inicializarSupabase() || tentativas++ > 50) {
            clearInterval(intervalo);
            if (tentativas > 50) {
                console.error('❌ ERRO: Biblioteca Supabase não carregou!');
            }
        }
    }, 100);
}
