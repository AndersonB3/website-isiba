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
 *    - Project URL (supabaseUrl)
 *    - Project API keys > anon public (supabaseKey)
 */

window.CONFIG = {
    // URL do seu projeto Supabase
    // Exemplo: 'https://abc123xyz.supabase.co'
    supabaseUrl: 'https://SEU-PROJETO-ID.supabase.co',
    
    // Chave pública (anon/public) do Supabase
    // Exemplo: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
    supabaseKey: 'SUA-CHAVE-PUBLICA-ANONIMA-AQUI',
    
    // Nome do bucket de storage (não alterar)
    bucket: 'contracheques',
    
    // Usuário admin padrão (para logs)
    adminUser: 'admin.rh'
};

// Inicializar cliente do Supabase
if (typeof supabase !== 'undefined') {
    window.supabaseClient = supabase.createClient(
        window.CONFIG.supabaseUrl,
        window.CONFIG.supabaseKey
    );
    console.log('✅ Supabase configurado com sucesso!');
} else {
    console.error('❌ Biblioteca do Supabase não carregada!');
    console.error('Verifique se o script do Supabase está incluído no HTML antes deste arquivo.');
}
