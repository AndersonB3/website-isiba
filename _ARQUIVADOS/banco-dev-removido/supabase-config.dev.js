/*=============== SUPABASE CONFIGURATION - DESENVOLVIMENTO ===============*/

// 🔧 ESTE É O ARQUIVO DE DESENVOLVIMENTO (LOCALHOST)
// Este arquivo está no .gitignore e NÃO será enviado ao GitHub

// 👉 COLE AQUI AS CREDENCIAIS DO SEU PROJETO DE DESENVOLVIMENTO
// Acesse: https://supabase.com/dashboard
// Vá em: Settings → API

// 🔧 CREDENCIAIS DO BANCO DE DESENVOLVIMENTO
const SUPABASE_URL = 'https://ikwnemhqqkpjurdpauim.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlrd25lbWhxcWtwanVyZHBhdWltIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAzMTI5NzAsImV4cCI6MjA4NTg4ODk3MH0.aoHRXBHGqfAkIzXf69Mw7vinUoGNqvKM6mJRgsBASOw';

// Verificar se as credenciais foram configuradas
if (SUPABASE_URL.includes('SEU_PROJETO') || SUPABASE_ANON_KEY.includes('SUA_CHAVE')) {
    console.error('❌ ERRO: Configure as credenciais de DESENVOLVIMENTO!');
    alert('⚠️ Configure: painel-rh/assets/js/supabase-config.dev.js');
}

// Configurações adicionais do sistema
window.CONFIG = {
    bucket: 'contracheques',
    adminUser: 'admin.rh',
    ambiente: 'DESENVOLVIMENTO',
    debug: true
};

// Inicializar cliente Supabase de DESENVOLVIMENTO
window.supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

console.log('🔧 AMBIENTE: DESENVOLVIMENTO (Localhost)');
console.log('✅ Supabase configurado com sucesso!');
console.log('🗄️ Banco:', SUPABASE_URL);
console.log('⚠️ LEMBRE-SE: Este é o banco de TESTES/DESENVOLVIMENTO');
