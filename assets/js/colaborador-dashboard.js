/* ========================================
   PORTAL DO COLABORADOR - DASHBOARD
   ======================================== */

document.addEventListener('DOMContentLoaded', () => {
    // Verificar se Supabase foi inicializado
    if (!window.supabaseClient) {
        console.error('❌ Erro: Supabase não foi inicializado!');
        alert('Erro ao conectar com o banco de dados. Verifique a configuração.');
        window.location.href = 'colaborador.html';
        return;
    }

    // Verificar se está logado
    const colaboradorData = sessionStorage.getItem('colaborador_data');
    if (!colaboradorData) {
        alert('Você precisa fazer login primeiro!');
        window.location.href = 'colaborador.html';
        return;
    }

    const colaborador = JSON.parse(colaboradorData);
    initDashboard(colaborador);
});

// ========================================
// INICIALIZAÇÃO DO DASHBOARD
// ========================================
async function initDashboard(colaborador) {
    // Atualizar mensagem de boas-vindas
    document.getElementById('welcomeMessage').textContent = `Bem-vindo(a), ${colaborador.nome.split(' ')[0]}!`;

    // Buscar estatísticas
    await atualizarEstatisticas(colaborador.id);

    // Carregar contracheques
    await carregarContracheques(colaborador.id);

    // Popular filtro de anos
    popularFiltroAnos();

    // Evento de logout
    document.getElementById('btnLogout').addEventListener('click', () => {
        if (confirm('Deseja realmente sair?')) {
            sessionStorage.clear();
            window.location.href = 'colaborador.html';
        }
    });

    // Evento de filtro por ano
    document.getElementById('filterAno').addEventListener('change', () => {
        carregarContracheques(colaborador.id);
    });
}

// ========================================
// ESTATÍSTICAS
// ========================================
async function atualizarEstatisticas(colaboradorId) {
    const result = await obterMinhasEstatisticas(colaboradorId);
    
    if (result.success) {
        const stats = result.data;
        
        document.getElementById('totalContracheques').textContent = stats.total;
        
        if (stats.ultimoMes && stats.ultimoAno) {
            document.getElementById('ultimoContracheque').textContent = 
                `${stats.ultimoMes}/${stats.ultimoAno}`;
        } else {
            document.getElementById('ultimoContracheque').textContent = 'Nenhum';
        }
    }
}

// ========================================
// CARREGAR CONTRACHEQUES
// ========================================
async function carregarContracheques(colaboradorId) {
    const container = document.getElementById('contrachequesList');
    const filterAno = document.getElementById('filterAno').value;
    
    // Loading state
    container.innerHTML = `
        <div class="loading-state">
            <i class="fas fa-spinner fa-spin"></i>
            <p>Carregando contracheques...</p>
        </div>
    `;

    // Buscar contracheques
    const result = await buscarMeusContracheques(colaboradorId);

    if (!result.success) {
        container.innerHTML = `
            <div class="empty-state">
                <i class="fa-solid fa-exclamation-circle"></i>
                <p>Erro ao carregar contracheques</p>
            </div>
        `;
        return;
    }

    let contracheques = result.data;

    // Aplicar filtro de ano
    if (filterAno) {
        contracheques = contracheques.filter(c => c.ano.toString() === filterAno);
    }

    // Verificar se há contracheques
    if (contracheques.length === 0) {
        container.innerHTML = `
            <div class="empty-state">
                <i class="fa-solid fa-inbox"></i>
                <p>${filterAno ? 'Nenhum contracheque encontrado para este ano' : 'Você ainda não possui contracheques disponíveis'}</p>
            </div>
        `;
        return;
    }

    // Renderizar contracheques
    container.innerHTML = contracheques.map(contracheque => `
        <div class="contracheque-card">
            <div class="contracheque-header">
                <div class="contracheque-icon">
                    <i class="fa-solid fa-file-pdf"></i>
                </div>
                <div class="contracheque-title">
                    <h3>${contracheque.mes_referencia} ${contracheque.ano}</h3>
                    <p>Contracheque</p>
                </div>
            </div>
            
            <div class="contracheque-info">
                <div class="info-row">
                    <i class="fa-solid fa-calendar"></i>
                    <span>Enviado em ${formatarData(contracheque.enviado_em)}</span>
                </div>
                <div class="info-row">
                    <i class="fa-solid fa-file"></i>
                    <span>${formatarTamanho(contracheque.tamanho_arquivo)}</span>
                </div>
                <div class="info-row">
                    <i class="fa-solid fa-user"></i>
                    <span>Enviado por ${contracheque.enviado_por}</span>
                </div>
            </div>
            
            <div class="contracheque-actions">
                <button 
                    class="btn-download" 
                    onclick="baixarContracheque('${contracheque.arquivo_url}', '${contracheque.nome_arquivo}')"
                >
                    <i class="fa-solid fa-download"></i>
                    Baixar PDF
                </button>
            </div>
        </div>
    `).join('');
}

// ========================================
// DOWNLOAD DE CONTRACHEQUE
// ========================================
async function baixarContracheque(arquivoUrl, nomeArquivo) {
    const btn = event.target.closest('.btn-download');
    const originalHtml = btn.innerHTML;
    
    // Loading state
    btn.disabled = true;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Baixando...';

    try {
        // Gerar URL assinada
        const result = await downloadMeuContracheque(arquivoUrl);

        if (!result.success) {
            throw new Error(result.error || 'Erro ao gerar link de download');
        }

        // Abrir em nova aba
        window.open(result.url, '_blank');
        
        // Feedback de sucesso
        btn.innerHTML = '<i class="fa-solid fa-check"></i> Baixado!';
        setTimeout(() => {
            btn.disabled = false;
            btn.innerHTML = originalHtml;
        }, 2000);

    } catch (error) {
        console.error('Erro ao baixar:', error);
        alert('Erro ao baixar o contracheque. Tente novamente.');
        btn.disabled = false;
        btn.innerHTML = originalHtml;
    }
}

// ========================================
// POPULAR FILTRO DE ANOS
// ========================================
function popularFiltroAnos() {
    const filterAno = document.getElementById('filterAno');
    const anoAtual = new Date().getFullYear();
    
    // Adicionar últimos 5 anos
    for (let i = 0; i < 5; i++) {
        const ano = anoAtual - i;
        const option = document.createElement('option');
        option.value = ano;
        option.textContent = ano;
        filterAno.appendChild(option);
    }
}

console.log('✅ Dashboard do Colaborador carregado!');
