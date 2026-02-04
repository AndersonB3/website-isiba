/**
 * Configuração do Supabase - ARQUIVO DE EXEMPLO
 * 
 * ⚠️ IMPORTANTE:
 * 1. Copie este arquivo para "supabase-config.js" (mesmo diretório)
 * 2. Preencha com suas credenciais reais do Supabase
 * 3. NUNCA faça commit do arquivo "supabase-config.js" no Git
 * 
 * Como obter as credenciais:
 * 1. Acesse: https://supabase.com/dashboard
 * 2. Selecione seu projeto
 * 3. Vá em Settings > API
 * 4. Copie:
 *    - Project URL
 *    - Project API keys > anon public
 */

const SUPABASE_URL = 'https://SEU-PROJETO-ID.supabase.co';
const SUPABASE_ANON_KEY = 'SUA-CHAVE-PUBLICA-ANONIMA-AQUI';

// Verificar se as credenciais foram configuradas
if (SUPABASE_ANON_KEY.includes('SUA-CHAVE') || SUPABASE_URL.includes('SEU-PROJETO')) {
    console.error('❌ ERRO: Configure as credenciais corretas no arquivo supabase-config.js');
    console.log('📍 Acesse: https://supabase.com/dashboard');
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
