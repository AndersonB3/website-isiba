/*=============== SUPABASE CONFIGURATION - PRODUÇÃO ===============*/

// 🔴 ESTE É O ARQUIVO DE PRODUÇÃO (GITHUB PAGES)
// Para desenvolvimento local, as credenciais são carregadas de: supabase-config.dev.js

const SUPABASE_URL = 'https://kklhcmrnraroletwbbid.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtrbGhjbXJucmFyb2xldHdiYmlkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjkxMjM2NDEsImV4cCI6MjA4NDY5OTY0MX0.dk1aXu6WiNN_Yn-PU-ST2nHOTca0PjDDZgYKauiUP0Y';

// Configurações adicionais do sistema
window.CONFIG = {
    bucket: 'contracheques',
    adminUser: 'admin.rh',
    ambiente: 'PRODUÇÃO',
    debug: false
};

// Inicializar cliente Supabase de PRODUÇÃO
window.supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

console.log('🌐 AMBIENTE: PRODUÇÃO (GitHub Pages)');
console.log('✅ Supabase configurado com sucesso!');
console.log('🗄️ Banco:', SUPABASE_URL);
