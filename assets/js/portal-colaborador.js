/* ========================================
   PORTAL DO COLABORADOR - VERSÃO 3.6 FIX
   Suporta Contracheques e Informes de IR
   ======================================== */

console.log('🔥 Portal do Colaborador VERSÃO 3.6 - FIX UPDATE + DEBUG RLS carregado!');

document.addEventListener('DOMContentLoaded', () => {
    // Aguardar um pouco para garantir que o Supabase foi inicializado
    setTimeout(() => {
        // Verificar se Supabase foi inicializado
        if (!window.supabase || !window.supabaseClient) {
            console.error('❌ Erro: Supabase não foi inicializado!');
            console.log('window.supabase:', window.supabase);
            console.log('window.supabaseClient:', window.supabaseClient);
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
        
        // Verificar se é primeiro acesso (precisa trocar senha)
        if (colaborador.primeiro_acesso === true) {
            alert('Por segurança, você precisa trocar sua senha no primeiro acesso!');
            window.location.href = 'primeiro-acesso.html';
            return;
        }
        
        initDashboard(colaborador);
        initHeaderActions();
    }, 100); // Aguarda 100ms para garantir que scripts anteriores carregaram
});

// ========================================
// INICIALIZAÇÃO DO DASHBOARD
// ========================================
async function initDashboard(colaborador) {
    // Atualizar mensagem de boas-vindas
    document.getElementById('welcomeMessage').textContent = `Bem-vindo(a), ${colaborador.nome.split(' ')[0]}!`;

    // Buscar estatísticas
    await atualizarEstatisticas(colaborador.id);

    // Carregar documentos
    await carregarDocumentos(colaborador.id);

    // Verificar notificações de novos documentos
    await verificarNotificacoes(colaborador.id);

    // Popular filtro de anos
    popularFiltroAnos();

    // Inicializar dropdowns customizados
    initCustomSelects();

    // Evento de logout
    document.getElementById('btnLogout').addEventListener('click', () => {
        if (confirm('Deseja realmente sair?')) {
            sessionStorage.clear();
            localStorage.removeItem(`lastDocumentIds_${colaborador.id}`);
            window.location.href = 'colaborador.html';
        }
    });

    // Evento de filtro por tipo
    document.getElementById('filterTipo').addEventListener('change', (e) => {
        atualizarTituloSecao(e.target.value);
        carregarDocumentos(colaborador.id);
    });

    // Evento de filtro por ano
    document.getElementById('filterAno').addEventListener('change', () => {
        carregarDocumentos(colaborador.id);
    });
}

// ========================================
// VERIFICAR NOTIFICAÇÕES
// ========================================
async function verificarNotificacoes(colaboradorId) {
    try {
        console.log('🔔 Verificando notificações para colaborador:', colaboradorId);
        
        // Buscar documentos atuais
        const { data: documentos, error } = await window.supabaseClient
            .from('contracheques')
            .select('id, created_at, tipo_documento, ano_referencia, mes_referencia')
            .eq('colaborador_id', colaboradorId)
            .order('created_at', { ascending: false });

        if (error) {
            console.error('❌ Erro ao verificar notificações:', error);
            // Remover badge em caso de erro
            const badge = document.querySelector('.notification-badge');
            if (badge) badge.remove();
            return;
        }

        console.log('📄 Documentos encontrados:', documentos ? documentos.length : 0);

        if (!documentos || documentos.length === 0) {
            // Sem documentos, remover badge
            const badge = document.querySelector('.notification-badge');
            if (badge) badge.remove();
            return;
        }

        // Pegar IDs dos documentos já vistos
        const lastSeenKey = `lastDocumentIds_${colaboradorId}`;
        const lastSeenData = localStorage.getItem(lastSeenKey);
        
        console.log('💾 Dados salvos:', lastSeenData ? 'Sim' : 'Não (primeiro acesso)');
        
        // Se é o primeiro acesso (não tem dados salvos), marcar todos como vistos
        if (!lastSeenData) {
            const documentIds = documentos.map(doc => doc.id);
            localStorage.setItem(lastSeenKey, JSON.stringify(documentIds));
            
            // Remover badge (não há notificações no primeiro acesso)
            const badge = document.querySelector('.notification-badge');
            if (badge) badge.remove();
            
            console.log('✅ Primeiro acesso: todos os documentos marcados como vistos');
            return;
        }
        
        const lastSeenIds = JSON.parse(lastSeenData);
        console.log('📋 IDs salvos:', lastSeenIds);

        // Encontrar documentos novos (que não estão na lista de vistos)
        const novosDocumentos = documentos.filter(doc => !lastSeenIds.includes(doc.id));
        
        console.log('🆕 Documentos novos:', novosDocumentos.length);

        // Atualizar badge
        const btnNotifications = document.getElementById('btnNotifications');
        let badge = btnNotifications ? btnNotifications.querySelector('.notification-badge') : null;
        
        if (novosDocumentos.length > 0) {
            // Criar badge se não existir
            if (!badge && btnNotifications) {
                badge = document.createElement('span');
                badge.className = 'notification-badge';
                btnNotifications.appendChild(badge);
            }
            
            if (badge) {
                badge.textContent = novosDocumentos.length;
            }
            
            // Atualizar modal de notificações com documentos reais
            atualizarModalNotificacoes(novosDocumentos);
        } else {
            // Sem documentos novos, remover badge se existir
            if (badge) badge.remove();
        }

        // Salvar IDs atuais para próxima verificação (quando clicar no modal)
        // NÃO salvamos agora, só quando o usuário abrir o modal

    } catch (error) {
        console.error('Erro ao verificar notificações:', error);
    }
}

// ========================================
// ATUALIZAR MODAL DE NOTIFICAÇÕES
// ========================================
function atualizarModalNotificacoes(novosDocumentos) {
    const modalBody = document.querySelector('#modalNotifications .modal-body');
    if (!modalBody) return;

    // Limpar notificações antigas
    modalBody.innerHTML = '';

    // Adicionar notificações reais
    novosDocumentos.forEach((doc, index) => {
        const tipoLabel = doc.tipo_documento === 'contracheque' ? 'Contracheque' : 'Informe de IR';
        const icone = doc.tipo_documento === 'contracheque' ? 'fa-file-invoice' : 'fa-file-contract';
        const cor = doc.tipo_documento === 'contracheque' 
            ? 'linear-gradient(135deg, #0066cc 0%, #00a651 100%)'
            : 'linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%)';
        
        const periodo = doc.tipo_documento === 'contracheque' 
            ? `${doc.mes_referencia}/${doc.ano_referencia}`
            : doc.ano_referencia;

        const tempoPassado = calcularTempoPassado(doc.created_at);

        const notificationHTML = `
            <div class="notification-item unread">
                <div class="notification-icon" style="background: ${cor};">
                    <i class="fas ${icone}"></i>
                </div>
                <div class="notification-content">
                    <h4>Novo ${tipoLabel} disponível</h4>
                    <p>Seu ${tipoLabel.toLowerCase()} de ${periodo} já está disponível para download.</p>
                    <span class="notification-time">
                        <i class="fas fa-clock"></i>
                        ${tempoPassado}
                    </span>
                </div>
            </div>
        `;

        modalBody.innerHTML += notificationHTML;
    });

    // Se não houver documentos novos, mostrar mensagem
    if (novosDocumentos.length === 0) {
        modalBody.innerHTML = `
            <div style="text-align: center; padding: 40px 20px; color: var(--text-light);">
                <i class="fas fa-check-circle" style="font-size: 3rem; color: var(--primary-color); margin-bottom: 16px;"></i>
                <h4 style="margin: 0 0 8px 0; color: var(--text-color);">Tudo em dia!</h4>
                <p style="margin: 0;">Você não tem novas notificações no momento.</p>
            </div>
        `;
    }
}

// ========================================
// CALCULAR TEMPO PASSADO
// ========================================
function calcularTempoPassado(dataISO) {
    const agora = new Date();
    const data = new Date(dataISO);
    const diffMs = agora - data;
    const diffMin = Math.floor(diffMs / 60000);
    const diffHoras = Math.floor(diffMin / 60);
    const diffDias = Math.floor(diffHoras / 24);

    if (diffMin < 1) return 'Agora mesmo';
    if (diffMin < 60) return `Há ${diffMin} minuto${diffMin > 1 ? 's' : ''}`;
    if (diffHoras < 24) return `Há ${diffHoras} hora${diffHoras > 1 ? 's' : ''}`;
    if (diffDias === 1) return 'Ontem';
    if (diffDias < 7) return `Há ${diffDias} dias`;
    if (diffDias < 30) return `Há ${Math.floor(diffDias / 7)} semana${Math.floor(diffDias / 7) > 1 ? 's' : ''}`;
    return `Há ${Math.floor(diffDias / 30)} mês${Math.floor(diffDias / 30) > 1 ? 'es' : ''}`;
}

// ========================================
// AÇÕES DO HEADER
// ========================================
function initHeaderActions() {
    // Botão de notificações
    const btnNotification = document.getElementById('btnNotifications');
    if (btnNotification) {
        btnNotification.addEventListener('click', () => {
            openModal('modalNotifications');
            
            // Marcar documentos como vistos ao abrir o modal
            const colaboradorData = JSON.parse(sessionStorage.getItem('colaborador_data'));
            if (colaboradorData) {
                setTimeout(() => marcarDocumentosComoVistos(colaboradorData.id), 1000);
            }
        });
    }

    // Botão de ajuda
    const btnHelp = document.querySelector('.btn-icon[title="Ajuda"]');
    if (btnHelp) {
        btnHelp.addEventListener('click', () => {
            openModal('modalHelp');
        });
    }
}

// Funções para controlar modais
function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    }
}

function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.remove('active');
        document.body.style.overflow = '';
    }
}

function markAllAsRead() {
    const notifications = document.querySelectorAll('.notification-item.unread');
    notifications.forEach(notif => {
        notif.classList.remove('unread');
    });
    
    // Salvar todos os documentos como vistos
    const colaboradorData = JSON.parse(sessionStorage.getItem('colaborador_data'));
    if (colaboradorData) {
        marcarDocumentosComoVistos(colaboradorData.id);
    }
    
    setTimeout(() => {
        closeModal('modalNotifications');
    }, 500);
}

// Marcar documentos como vistos
async function marcarDocumentosComoVistos(colaboradorId) {
    try {
        // Buscar todos os documentos atuais
        const { data: documentos, error } = await window.supabaseClient
            .from('contracheques')
            .select('id')
            .eq('colaborador_id', colaboradorId);

        if (!error && documentos) {
            const documentIds = documentos.map(doc => doc.id);
            const lastSeenKey = `lastDocumentIds_${colaboradorId}`;
            localStorage.setItem(lastSeenKey, JSON.stringify(documentIds));
            
            // Remover badge
            const badge = document.querySelector('.notification-badge');
            if (badge) {
                badge.style.animation = 'fadeOut 0.3s ease forwards';
                setTimeout(() => badge.remove(), 300);
            }
        }
    } catch (error) {
        console.error('Erro ao marcar como lidos:', error);
    }
}

// Fechar modal ao clicar fora
document.addEventListener('click', (e) => {
    if (e.target.classList.contains('modal-overlay')) {
        e.target.classList.remove('active');
        document.body.style.overflow = '';
    }
});

// Fechar modal com ESC
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        document.querySelectorAll('.modal-overlay.active').forEach(modal => {
            modal.classList.remove('active');
            document.body.style.overflow = '';
        });
    }
});

// Adicionar animação de fadeOut ao CSS inline
const style = document.createElement('style');
style.textContent = `
    @keyframes fadeOut {
        from { opacity: 1; transform: scale(1); }
        to { opacity: 0; transform: scale(0); }
    }
`;
document.head.appendChild(style);

// ========================================
// CUSTOM SELECT DROPDOWNS
// ========================================
function initCustomSelects() {
    const customSelects = document.querySelectorAll('.custom-select');
    
    customSelects.forEach(select => {
        const trigger = select.querySelector('.custom-select-trigger');
        const options = select.querySelectorAll('.custom-option');
        const hiddenInput = select.closest('.custom-select-wrapper').querySelector('input[type="hidden"]');
        
        // Toggle dropdown ao clicar
        select.addEventListener('click', (e) => {
            e.stopPropagation();
            
            // Fechar outros dropdowns
            document.querySelectorAll('.custom-select').forEach(s => {
                if (s !== select) {
                    s.classList.remove('open');
                }
            });
            
            // Toggle este dropdown
            select.classList.toggle('open');
        });
        
        // Selecionar opção
        options.forEach(option => {
            option.addEventListener('click', (e) => {
                e.stopPropagation();
                
                // Remover active de todas as opções
                options.forEach(opt => opt.classList.remove('active'));
                
                // Adicionar active na opção clicada
                option.classList.add('active');
                
                // Atualizar o trigger
                const icon = option.querySelector('i').outerHTML;
                const text = option.querySelector('span').textContent;
                trigger.innerHTML = icon + ' ' + text;
                
                // Atualizar input hidden
                hiddenInput.value = option.dataset.value;
                
                // Fechar dropdown
                select.classList.remove('open');
                
                // Atualizar título da seção e carregar documentos
                atualizarTituloSecao();
                const colaboradorData = JSON.parse(sessionStorage.getItem('colaborador_data'));
                carregarDocumentos(colaboradorData.id);
            });
        });
    });
    
    // Fechar dropdowns ao clicar fora
    document.addEventListener('click', () => {
        document.querySelectorAll('.custom-select').forEach(select => {
            select.classList.remove('open');
        });
    });
}

// ========================================
// ATUALIZAR TÍTULO DA SEÇÃO
// ========================================
function atualizarTituloSecao() {
    const sectionTitle = document.getElementById('sectionTitle');
    const sectionIcon = document.getElementById('sectionIcon');
    const tipoFiltro = document.getElementById('filterTipo').value;
    
    switch(tipoFiltro) {
        case 'contracheque':
            sectionTitle.textContent = 'Meus Contracheques';
            sectionIcon.className = 'fa-solid fa-file-invoice';
            break;
        case 'informe_ir':
            sectionTitle.textContent = 'Meu IRRF';
            sectionIcon.className = 'fa-solid fa-file-contract';
            break;
        default:
            sectionTitle.textContent = 'Meus Documentos';
            sectionIcon.className = 'fa-solid fa-file-lines';
    }
}

// ========================================
// ESTATÍSTICAS
// ========================================
async function atualizarEstatisticas(colaboradorId) {
    const result = await obterMinhasEstatisticasCompletas(colaboradorId);
    
    if (result.success) {
        const stats = result.data;
        
        document.getElementById('totalContracheques').textContent = stats.totalContracheques;
        document.getElementById('totalInformes').textContent = stats.totalInformes;
        
        if (stats.ultimoDocumento) {
            const tipo = stats.ultimoDocumento.tipo_documento === 'informe_ir' ? 'Informe IR' : 'Contracheque';
            const periodo = stats.ultimoDocumento.mes_referencia === 'Anual' 
                ? stats.ultimoDocumento.ano 
                : `${stats.ultimoDocumento.mes_referencia}/${stats.ultimoDocumento.ano}`;
            document.getElementById('ultimoDocumento').textContent = `${tipo} ${periodo}`;
        } else {
            document.getElementById('ultimoDocumento').textContent = 'Nenhum';
        }
    }
}

// ========================================
// CARREGAR DOCUMENTOS (CONTRACHEQUES + INFORMES)
// ========================================
async function carregarDocumentos(colaboradorId) {
    const container = document.getElementById('contrachequesList');
    const filterAno = document.getElementById('filterAno').value;
    const filterTipo = document.getElementById('filterTipo').value;
    
    // Loading state
    container.innerHTML = `
        <div class="loading-state">
            <i class="fas fa-spinner fa-spin"></i>
            <p>Carregando documentos...</p>
        </div>
    `;

    // Buscar documentos
    const result = await buscarMeusDocumentos(colaboradorId);

    if (!result.success) {
        container.innerHTML = `
            <div class="empty-state">
                <i class="fa-solid fa-exclamation-circle"></i>
                <p>Erro ao carregar documentos</p>
            </div>
        `;
        return;
    }

    let documentos = result.data;
    
    // DEBUG COMPLETO: Ver TODOS os dados do primeiro documento
    if (documentos.length > 0) {
        console.log('🔍 DEBUG COMPLETO - Primeiro documento:');
        console.log(JSON.stringify(documentos[0], null, 2));
        console.log('🔍 Valor de recibo_gerado:', documentos[0].recibo_gerado);
        console.log('🔍 Tipo:', typeof documentos[0].recibo_gerado);
        console.log('🔍 É NULL?', documentos[0].recibo_gerado === null);
        console.log('🔍 É undefined?', documentos[0].recibo_gerado === undefined);
        console.log('🔍 É false?', documentos[0].recibo_gerado === false);
        console.log('🔍 É true?', documentos[0].recibo_gerado === true);
    }

    // Aplicar filtro de tipo
    if (filterTipo) {
        documentos = documentos.filter(d => d.tipo_documento === filterTipo);
    }

    // Aplicar filtro de ano
    if (filterAno) {
        documentos = documentos.filter(d => d.ano.toString() === filterAno);
    }

    // Verificar se há documentos
    if (documentos.length === 0) {
        const tipoTexto = filterTipo === 'contracheque' ? 'contracheques' : 
                         filterTipo === 'informe_ir' ? 'informes de IR' : 'documentos';
        container.innerHTML = `
            <div class="empty-state">
                <i class="fa-solid fa-inbox"></i>
                <p>${filterAno || filterTipo ? `Nenhum ${tipoTexto} encontrado` : 'Você ainda não possui documentos disponíveis'}</p>
            </div>
        `;
        return;
    }

    // Renderizar documentos
    container.innerHTML = documentos.map(doc => {
        // Sistema de bloqueio
        const bloqueado = doc.recibo_gerado !== true;
        console.log('📋 Documento:', { id: doc.id, mes: doc.mes_referencia, bloqueado, recibo_gerado: doc.recibo_gerado });
        
        const badgeClass = bloqueado ? 'badge-bloqueado' : 'badge-liberado';
        const badgeIcon = bloqueado ? 'fa-lock' : 'fa-check-circle';
        const badgeText = bloqueado ? 'Bloqueado' : 'Liberado';
        const btnClass = bloqueado ? 'btn-download-blocked' : 'btn-download';
        const btnIcon = bloqueado ? 'fa-lock' : 'fa-download';
        const btnText = bloqueado ? 'Assinar Recibo para Desbloquear' : 'Baixar PDF';
        const cardClass = bloqueado ? 'contracheque-card bloqueado' : 'contracheque-card';
        
        const isInforme = doc.tipo_documento === 'informe_ir';
        const icon = bloqueado ? 'fa-lock' : (isInforme ? 'fa-file-invoice' : 'fa-file-pdf');
        const iconColor = bloqueado ? '#ff6b6b' : (isInforme ? '#00a651' : '#0066cc');
        const titulo = isInforme ? `Informe de IR ${doc.ano}` : `${doc.mes_referencia} ${doc.ano}`;
        const subtitulo = isInforme ? 'Informe de Rendimentos' : 'Contracheque';
        
        return `
        <div class="${cardClass}" data-documento-id="${doc.id}">
            ${bloqueado ? '<div class="overlay-bloqueio"><i class="fas fa-lock"></i></div>' : ''}
            <div class="contracheque-header">
                <div class="contracheque-icon ${bloqueado ? 'icon-bloqueado' : ''}" style="background-color: ${iconColor}20;">
                    <i class="fa-solid ${icon}" style="color: ${iconColor};"></i>
                </div>
                <div class="contracheque-title">
                    <h3>${titulo}</h3>
                    <p>${subtitulo}</p>
                    <span class="badge ${badgeClass}">
                        <i class="fas ${badgeIcon}"></i>
                        ${badgeText}
                    </span>
                </div>
            </div>
            
            <div class="contracheque-info">
                <div class="info-row">
                    <i class="fa-solid fa-calendar"></i>
                    <span>Enviado em ${formatarData(doc.enviado_em)}</span>
                </div>
                <div class="info-row">
                    <i class="fa-solid fa-file"></i>
                    <span>${formatarTamanho(doc.tamanho_arquivo)}</span>
                </div>
                <div class="info-row">
                    <i class="fa-solid fa-user"></i>
                    <span>Enviado por ${doc.enviado_por}</span>
                </div>
            </div>
            
            <div class="contracheque-actions">
                <button 
                    class="${btnClass}" 
                    data-doc-id="${doc.id}"
                    data-bloqueado="${bloqueado}"
                    data-tipo="${doc.tipo_documento}"
                    data-mes="${doc.mes_referencia || ''}"
                    data-ano="${doc.ano}"
                    data-arquivo="${doc.nome_arquivo}"
                    data-url="${doc.arquivo_url}"
                >
                    <i class="fa-solid ${btnIcon}"></i>
                    ${btnText}
                </button>
            </div>
        </div>
    `}).join('');
    
    // Adicionar event listeners aos botões
    const botoes = container.querySelectorAll('.btn-download, .btn-download-blocked');
    botoes.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            const bloqueado = this.dataset.bloqueado === 'true';
            
            console.log('🖱️ BOTÃO CLICADO:', {
                bloqueado: bloqueado,
                id: this.dataset.docId,
                tipo: this.dataset.tipo,
                mes: this.dataset.mes,
                ano: this.dataset.ano
            });
            
            if (bloqueado) {
                console.log('🔒 Abrindo modal de recibo...');
                abrirModalRecibo(
                    this.dataset.docId,
                    this.dataset.tipo,
                    this.dataset.mes,
                    this.dataset.ano,
                    this.dataset.arquivo,
                    this.dataset.url
                );
            } else {
                console.log('📥 Baixando documento...');
                baixarDocumento(this.dataset.url, this.dataset.arquivo);
            }
        });
    });
}

// ========================================
// DOWNLOAD DE DOCUMENTO
// ========================================
async function baixarDocumento(arquivoUrl, nomeArquivo) {
    // Verificar se foi chamado por um evento de clique ou programaticamente
    const btn = event?.target?.closest('.btn-download');
    let originalHtml;
    
    // Se foi clicado em um botão, mostrar loading
    if (btn) {
        originalHtml = btn.innerHTML;
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Baixando...';
    }

    try {
        console.log('📥 Iniciando download:', { arquivoUrl, nomeArquivo });
        
        // Gerar URL assinada
        const result = await downloadMeuContracheque(arquivoUrl);

        if (!result.success) {
            throw new Error(result.error || 'Erro ao gerar link de download');
        }

        if (!result.url) {
            throw new Error('URL de download não retornada');
        }

        console.log('✅ URL gerada, abrindo download...');
        
        // Abrir em nova aba
        window.open(result.url, '_blank');
        
        // Feedback de sucesso (apenas se houver botão)
        if (btn) {
            btn.innerHTML = '<i class="fa-solid fa-check"></i> Baixado!';
            setTimeout(() => {
                btn.disabled = false;
                btn.innerHTML = originalHtml;
            }, 2000);
        }

    } catch (error) {
        console.error('❌ Erro ao baixar documento:', error);
        alert('Erro ao baixar o documento: ' + error.message);
        
        // Restaurar botão apenas se existir
        if (btn) {
            btn.disabled = false;
            btn.innerHTML = originalHtml;
        }
    }
}

// ========================================
// POPULAR FILTRO DE ANOS
// ========================================
function popularFiltroAnos() {
    const optionsAno = document.getElementById('optionsAno');
    const anoAtual = new Date().getFullYear();
    
    // Adicionar últimos 5 anos
    for (let i = 0; i < 5; i++) {
        const ano = anoAtual - i;
        const optionDiv = document.createElement('div');
        optionDiv.className = 'custom-option';
        optionDiv.dataset.value = ano;
        optionDiv.innerHTML = `
            <i class="fas fa-calendar-day"></i>
            <span>${ano}</span>
        `;
        optionsAno.appendChild(optionDiv);
    }
    
    // Re-inicializar event listeners para as novas opções
    const customSelectAno = document.getElementById('customSelectAno');
    const triggerAno = customSelectAno.querySelector('.custom-select-trigger');
    const hiddenInputAno = document.getElementById('filterAno');
    
    optionsAno.querySelectorAll('.custom-option').forEach(option => {
        option.addEventListener('click', (e) => {
            e.stopPropagation();
            
            // Remover active de todas as opções
            optionsAno.querySelectorAll('.custom-option').forEach(opt => opt.classList.remove('active'));
            
            // Adicionar active na opção clicada
            option.classList.add('active');
            
            // Atualizar o trigger
            const icon = option.querySelector('i').outerHTML;
            const text = option.querySelector('span').textContent;
            triggerAno.innerHTML = icon + ' ' + text;
            
            // Atualizar input hidden
            hiddenInputAno.value = option.dataset.value;
            
            // Fechar dropdown
            customSelectAno.classList.remove('open');
            
            // Atualizar título da seção e carregar documentos
            atualizarTituloSecao();
            const colaboradorData = JSON.parse(sessionStorage.getItem('colaborador_data'));
            carregarDocumentos(colaboradorData.id);
        });
    });
}

// ========================================
// ABRIR MODAL DE RECIBO
// ========================================
async function abrirModalRecibo(documentoId, tipoDocumento, mesReferencia, ano, nomeArquivo, arquivoUrl) {
    console.log('🔍 abrirModalRecibo chamada com parâmetros:', {
        documentoId,
        tipoDocumento,
        mesReferencia,
        ano,
        nomeArquivo,
        arquivoUrl
    });
    
    const colaboradorData = JSON.parse(sessionStorage.getItem('colaborador_data'));
    
    // Montar objeto documento com todos os dados necessários
    const documento = {
        id: documentoId,
        tipo_documento: tipoDocumento,
        mes_referencia: mesReferencia,
        ano: ano,
        nome_arquivo: nomeArquivo,
        arquivo_url: arquivoUrl,
        colaborador_id: colaboradorData.id
    };
    
    console.log('📦 Objeto documento montado:', documento);
    
    // Verificar se o modal já foi criado, se não, criar
    if (typeof verificarEAbrirRecibo === 'function') {
        await verificarEAbrirRecibo(documento, async () => {
            // Callback de sucesso - baixar documento após assinar recibo
            await baixarDocumento(arquivoUrl, nomeArquivo);
        });
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
    await carregarDocumentos(colaboradorData.id);
    
    // Baixar automaticamente o documento
    await baixarDocumento(arquivoUrl, nomeArquivo);
    
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

console.log('🔥 Portal do Colaborador VERSÃO 2.5 - FIX DOWNLOAD AUTOMÁTICO carregado!');

