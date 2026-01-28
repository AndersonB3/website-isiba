/**
 * Servidor do Painel Administrativo RH
 * ISIBA Social
 * 
 * Porta: 3001 (diferente do site principal)
 */

const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = 3001;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname)));

// Rota principal - Painel Admin
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'admin-rh.html'));
});

// Rota de health check
app.get('/health', (req, res) => {
    res.json({ 
        status: 'OK', 
        service: 'Painel RH - ISIBA Social',
        port: PORT,
        timestamp: new Date().toISOString()
    });
});

// Iniciar servidor
app.listen(PORT, () => {
    console.log('═══════════════════════════════════════════');
    console.log('🚀 PAINEL ADMINISTRATIVO RH - ISIBA SOCIAL');
    console.log('═══════════════════════════════════════════');
    console.log(`✅ Servidor rodando na porta: ${PORT}`);
    console.log(`🌐 Acesse: http://localhost:${PORT}`);
    console.log(`📊 Health Check: http://localhost:${PORT}/health`);
    console.log('═══════════════════════════════════════════');
    console.log('⚙️  Credenciais padrão:');
    console.log('   Usuário: admin');
    console.log('   Senha: admin');
    console.log('═══════════════════════════════════════════');
    console.log('🔒 Segurança: Porta separada do site público');
    console.log('💾 Banco: Supabase Cloud');
    console.log('═══════════════════════════════════════════\n');
});

// Tratamento de erros
process.on('uncaughtException', (error) => {
    console.error('❌ Erro não tratado:', error);
});

process.on('SIGINT', () => {
    console.log('\n\n⏹️  Servidor encerrado pelo usuário');
    process.exit(0);
});
