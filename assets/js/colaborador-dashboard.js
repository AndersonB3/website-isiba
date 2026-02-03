/* ========================================
   PORTAL DO COLABORADOR - DASHBOARD
   VERSÃO: 2.0 - SISTEMA DE BLOQUEIO COM CADEADO
   ATUALIZADO: 03/02/2026 - 14:30
   ======================================== */

console.log('🔥 VERSÃO NOVA CARREGADA - 2.0 - BLOQUEIO ATIVO');

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
    
    // DEBUG COMPLETO: Ver TODOS os dados do primeiro documento
    if (contracheques.length > 0) {
        console.log('🔍 DEBUG COMPLETO - Primeiro documento:');
        console.log(JSON.stringify(contracheques[0], null, 2));
        console.log('🔍 Valor de recibo_gerado:', contracheques[0].recibo_gerado);
        console.log('🔍 Tipo:', typeof contracheques[0].recibo_gerado);
        console.log('🔍 É NULL?', contracheques[0].recibo_gerado === null);
        console.log('🔍 É undefined?', contracheques[0].recibo_gerado === undefined);
        console.log('🔍 É false?', contracheques[0].recibo_gerado === false);
        console.log('🔍 É true?', contracheques[0].recibo_gerado === true);
    }

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
    container.innerHTML = contracheques.map(contracheque => {
        // DEBUG: Verificar valor de recibo_gerado
        console.log('📋 Documento:', {
            id: contracheque.id,
            mes: contracheque.mes_referencia,
            ano: contracheque.ano,
            recibo_gerado: contracheque.recibo_gerado,
            tipo: typeof contracheque.recibo_gerado
        });
        
        // Se recibo_gerado for NULL ou undefined, considerar como false (bloqueado)
        const bloqueado = contracheque.recibo_gerado !== true;
        const badgeClass = bloqueado ? 'badge-bloqueado' : 'badge-liberado';
        const badgeIcon = bloqueado ? 'fa-lock' : 'fa-check-circle';
        const badgeText = bloqueado ? 'Bloqueado' : 'Liberado';
        const btnDisabled = bloqueado ? 'disabled' : '';
        const btnClass = bloqueado ? 'btn-download-blocked' : 'btn-download';
        const btnIcon = bloqueado ? 'fa-lock' : 'fa-download';
        const btnText = bloqueado ? 'Assinar Recibo para Desbloquear' : 'Baixar PDF';
        const cardClass = bloqueado ? 'contracheque-card bloqueado' : 'contracheque-card';
        
        console.log('🔍 Status:', { bloqueado, badgeText, btnClass });
        
        return `
        <div class="${cardClass}" data-documento-id="${contracheque.id}">
            ${bloqueado ? '<div class="overlay-bloqueio"><i class="fas fa-lock"></i></div>' : ''}
            <div class="contracheque-header">
                <div class="contracheque-icon ${bloqueado ? 'icon-bloqueado' : ''}">
                    <i class="fa-solid ${bloqueado ? 'fa-lock' : 'fa-file-pdf'}"></i>
                </div>
                <div class="contracheque-title">
                    <h3>${contracheque.mes_referencia} ${contracheque.ano}</h3>
                    <p>${contracheque.tipo_documento === 'contracheque' ? 'Contracheque' : 'Informe IR'}</p>
                    <span class="badge ${badgeClass}">
                        <i class="fas ${badgeIcon}"></i>
                        ${badgeText}
                    </span>
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
                    class="${btnClass}" 
                    onclick="${bloqueado ? `abrirModalRecibo('${contracheque.id}', '${contracheque.tipo_documento}', '${contracheque.mes_referencia}', ${contracheque.ano}, '${contracheque.nome_arquivo}', '${contracheque.arquivo_url}')` : `baixarContracheque('${contracheque.arquivo_url}', '${contracheque.nome_arquivo}')`}"
                    ${btnDisabled}
                >
                    <i class="fa-solid ${btnIcon}"></i>
                    ${btnText}
                </button>
            </div>
        </div>
    `;
    }).join('');
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

        if (!result.url) {
            throw new Error('URL de download não retornada');
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
        console.error('❌ Erro ao baixar contracheque:', error);
        alert('Erro ao baixar o contracheque: ' + error.message);
        btn.disabled = false;
        btn.innerHTML = originalHtml;
    }
}

// ========================================
// ABRIR MODAL DE RECIBO
// ========================================
async function abrirModalRecibo(documentoId, tipoDocumento, mesReferencia, ano, nomeArquivo, arquivoUrl) {
    const colaboradorData = JSON.parse(sessionStorage.getItem('colaborador_data'));
    
    // Verificar se o modal já foi criado, se não, criar
    if (typeof verificarEAbrirRecibo === 'function') {
        await verificarEAbrirRecibo(documentoId, colaboradorData.id, tipoDocumento, mesReferencia, ano, nomeArquivo, arquivoUrl);
    } else {
        console.error('❌ Função verificarEAbrirRecibo não foi carregada!');
        alert('Erro ao abrir modal de recibo. Recarregue a página.');
    }
}

// ========================================
// CALLBACK APÓS ASSINAR RECIBO
// ========================================
window.onReciboConfirmado = async function(documentoId, arquivoUrl, nomeArquivo) {
    console.log('✅ Recibo confirmado! Desbloqueando documento...');
    
    // Atualizar a visualização - recarregar os documentos
    const colaboradorData = JSON.parse(sessionStorage.getItem('colaborador_data'));
    await carregarContracheques(colaboradorData.id);
    
    // Baixar automaticamente o documento
    await baixarContracheque(arquivoUrl, nomeArquivo);
    
    // Mostrar mensagem de sucesso
    showSuccessMessage('Recibo assinado com sucesso! O documento foi desbloqueado e está sendo baixado.');
};

// ========================================
// MENSAGEM DE SUCESSO
// ========================================
function showSuccessMessage(message) {
    // Criar elemento de notificação
    const notification = document.createElement('div');
    notification.className = 'success-notification';
    notification.innerHTML = `
        <i class="fas fa-check-circle"></i>
        <span>${message}</span>
    `;
    document.body.appendChild(notification);
    
    // Remover após 4 segundos
    setTimeout(() => {
        notification.style.opacity = '0';
        setTimeout(() => notification.remove(), 300);
    }, 4000);
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
