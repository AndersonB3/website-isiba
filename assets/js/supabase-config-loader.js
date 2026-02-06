/*=============== SUPABASE CONFIG LOADER - DETECÇÃO AUTOMÁTICA DE AMBIENTE ===============*/

// 🎯 Este script detecta automaticamente se você está em:
// - DESENVOLVIMENTO: localhost, 127.0.0.1, file://
// - PRODUÇÃO: andersonb3.github.io (GitHub Pages)

(function() {
    'use strict';
    
    // Detectar ambiente atual
    const hostname = window.location.hostname;
    const isLocal = hostname === 'localhost' || 
                    hostname === '127.0.0.1' || 
                    hostname === '' || 
                    window.location.protocol === 'file:';
    
    const isGitHubPages = hostname.includes('github.io');
    
    let ambiente = 'DESCONHECIDO';
    let configFile = 'supabase-config.js'; // Padrão: produção
    
    // Determinar qual arquivo de configuração carregar
    if (isLocal) {
        ambiente = 'DESENVOLVIMENTO';
        configFile = 'supabase-config.dev.js';
        console.log('%c🔧 AMBIENTE DETECTADO: DESENVOLVIMENTO', 'background: #ff6b35; color: white; padding: 4px 8px; border-radius: 4px; font-weight: bold;');
        console.log('%c📍 Hostname:', hostname || 'file://', 'color: #666;');
    } else if (isGitHubPages) {
        ambiente = 'PRODUÇÃO';
        configFile = 'supabase-config.js';
        console.log('%c🌐 AMBIENTE DETECTADO: PRODUÇÃO (GitHub Pages)', 'background: #00a651; color: white; padding: 4px 8px; border-radius: 4px; font-weight: bold;');
        console.log('%c📍 Hostname:', hostname, 'color: #666;');
    } else {
        ambiente = 'PRODUÇÃO';
        configFile = 'supabase-config.js';
        console.log('%c🌐 AMBIENTE DETECTADO: PRODUÇÃO (Outro)', 'background: #0066cc; color: white; padding: 4px 8px; border-radius: 4px; font-weight: bold;');
        console.log('%c📍 Hostname:', hostname, 'color: #666;');
    }
    
    // Armazenar informação do ambiente globalmente
    window.ENVIRONMENT = {
        type: ambiente,
        isLocal: isLocal,
        isProduction: !isLocal,
        hostname: hostname
    };
    
    // Carregar o arquivo de configuração correto de forma SÍNCRONA
    console.log(`%c📦 Carregando: ${configFile}`, 'color: #666; font-style: italic;');
    
    // Criar script de forma síncrona usando XMLHttpRequest
    const xhr = new XMLHttpRequest();
    xhr.open('GET', `assets/js/${configFile}`, false); // false = síncrono
    xhr.send();
    
    if (xhr.status === 200) {
        // Executar o código JavaScript
        eval(xhr.responseText);
        console.log('%c✅ Configuração carregada com sucesso!', 'color: #00a651; font-weight: bold;');
    } else {
        console.error(`%c❌ ERRO ao carregar ${configFile}`, 'color: #ff0000; font-weight: bold;');
        alert(`⚠️ ERRO: Não foi possível carregar ${configFile}\n\nStatus: ${xhr.status}`);
    }
    
})();
