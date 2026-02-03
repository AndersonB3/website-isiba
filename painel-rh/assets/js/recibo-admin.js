/**
 * ════════════════════════════════════════════════════════════════
 * SISTEMA DE RECIBOS - PAINEL RH
 * ════════════════════════════════════════════════════════════════
 * Gerencia a visualização de recibos gerados pelos colaboradores
 * ════════════════════════════════════════════════════════════════
 */

// ==================== BUSCAR TODOS OS RECIBOS ====================

/**
 * Buscar todos os recibos registrados
 */
async function buscarTodosRecibos(filtros = {}) {
    try {
        console.log('🔍 Buscando recibos...', filtros);

        let query = window.supabaseClient
            .from('view_recibos_completos')
            .select('*');

        // Aplicar filtros
        if (filtros.colaboradorId) {
            query = query.eq('colaborador_id', filtros.colaboradorId);
        }

        if (filtros.tipoDocumento) {
            query = query.eq('tipo_documento', filtros.tipoDocumento);
        }

        if (filtros.ano) {
            query = query.eq('ano', parseInt(filtros.ano));
        }

        if (filtros.mes) {
            query = query.eq('mes_referencia', filtros.mes);
        }

        // Ordenar
        query = query.order('criado_em', { ascending: false });

        const { data, error } = await query;

        if (error) throw error;

        console.log(`✅ ${data.length} recibos encontrados`);
        return { success: true, data };

    } catch (error) {
        console.error('❌ Erro ao buscar recibos:', error);
        return { success: false, error: error.message };
    }
}

/**
 * Buscar recibos de um colaborador específico
 */
async function buscarRecibosPorColaborador(colaboradorId) {
    try {
        const { data, error } = await window.supabaseClient
            .from('view_recibos_completos')
            .select('*')
            .eq('colaborador_id', colaboradorId)
            .order('criado_em', { ascending: false });

        if (error) throw error;

        console.log(`✅ ${data.length} recibos encontrados para colaborador ${colaboradorId}`);
        return { success: true, data };

    } catch (error) {
        console.error('❌ Erro ao buscar recibos:', error);
        return { success: false, error: error.message };
    }
}

/**
 * Buscar estatísticas de recibos
 */
async function buscarEstatisticasRecibos() {
    try {
        // Total de recibos
        const { count: totalRecibos, error: error1 } = await window.supabaseClient
            .from('recibos_documentos')
            .select('*', { count: 'exact', head: true });

        if (error1) throw error1;

        // Recibos por tipo
        const { data: porTipo, error: error2 } = await window.supabaseClient
            .from('recibos_documentos')
            .select('tipo_documento')
            .order('tipo_documento');

        if (error2) throw error2;

        // Contar por tipo
        const contadorTipos = porTipo.reduce((acc, item) => {
            acc[item.tipo_documento] = (acc[item.tipo_documento] || 0) + 1;
            return acc;
        }, {});

        // Documentos sem recibo
        const { count: semRecibo, error: error3 } = await window.supabaseClient
            .from('contracheques')
            .select('*', { count: 'exact', head: true })
            .eq('recibo_gerado', false);

        if (error3) throw error3;

        console.log('✅ Estatísticas de recibos obtidas');
        return {
            success: true,
            data: {
                total: totalRecibos || 0,
                porTipo: contadorTipos,
                semRecibo: semRecibo || 0
            }
        };

    } catch (error) {
        console.error('❌ Erro ao buscar estatísticas:', error);
        return { success: false, error: error.message };
    }
}

/**
 * Buscar documentos SEM recibo
 */
async function buscarDocumentosSemRecibo() {
    try {
        const { data, error } = await window.supabaseClient
            .from('contracheques')
            .select(`
                id,
                mes_referencia,
                ano,
                tipo_documento,
                nome_arquivo,
                enviado_em,
                recibo_gerado,
                visualizado,
                colaborador_id,
                colaboradores (
                    nome_completo,
                    cpf,
                    email
                )
            `)
            .eq('recibo_gerado', false)
            .order('enviado_em', { ascending: false });

        if (error) throw error;

        console.log(`✅ ${data.length} documentos sem recibo encontrados`);
        return { success: true, data };

    } catch (error) {
        console.error('❌ Erro ao buscar documentos sem recibo:', error);
        return { success: false, error: error.message };
    }
}

// ==================== RENDERIZAÇÃO ====================

/**
 * Renderizar tabela de recibos
 */
function renderizarTabelaRecibos(recibos, containerId = 'tabelaRecibos') {
    const container = document.getElementById(containerId);
    
    if (!container) {
        console.error('❌ Container não encontrado:', containerId);
        return;
    }

    if (!recibos || recibos.length === 0) {
        container.innerHTML = `
            <div class="empty-state">
                <i class="fa-solid fa-inbox"></i>
                <p>Nenhum recibo registrado ainda</p>
            </div>
        `;
        return;
    }

    const html = `
        <div class="table-responsive">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Colaborador</th>
                        <th>CPF</th>
                        <th>Documento</th>
                        <th>Período</th>
                        <th>Data Recebimento</th>
                        <th>IP</th>
                        <th>Ações</th>
                    </tr>
                </thead>
                <tbody>
                    ${recibos.map(recibo => `
                        <tr>
                            <td>
                                <strong>${recibo.nome_completo}</strong>
                                ${recibo.email ? `<br><small>${recibo.email}</small>` : ''}
                            </td>
                            <td>${formatarCPF(recibo.cpf)}</td>
                            <td>
                                <span class="badge badge-${recibo.tipo_documento === 'informe_ir' ? 'warning' : 'primary'}">
                                    ${recibo.tipo_documento === 'informe_ir' ? 'Informe IR' : 'Contracheque'}
                                </span>
                            </td>
                            <td>
                                ${recibo.tipo_documento === 'informe_ir' 
                                    ? `Ano ${recibo.ano}` 
                                    : `${recibo.mes_referencia} ${recibo.ano}`
                                }
                            </td>
                            <td>${formatarDataHora(recibo.data_recebimento)}</td>
                            <td><small>${recibo.ip_address || '-'}</small></td>
                            <td>
                                <button 
                                    class="btn-icon btn-info" 
                                    onclick="visualizarDetalheRecibo('${recibo.recibo_id}')"
                                    title="Ver detalhes"
                                >
                                    <i class="fa-solid fa-eye"></i>
                                </button>
                            </td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        </div>
    `;

    container.innerHTML = html;
}

/**
 * Renderizar cards de estatísticas
 */
function renderizarEstatisticasRecibos(stats, containerId = 'statsRecibos') {
    const container = document.getElementById(containerId);
    
    if (!container) {
        console.error('❌ Container não encontrado:', containerId);
        return;
    }

    const html = `
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon bg-primary">
                    <i class="fa-solid fa-file-signature"></i>
                </div>
                <div class="stat-info">
                    <h3>${stats.total}</h3>
                    <p>Total de Recibos</p>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon bg-success">
                    <i class="fa-solid fa-file-pdf"></i>
                </div>
                <div class="stat-info">
                    <h3>${stats.porTipo.contracheque || 0}</h3>
                    <p>Contracheques</p>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon bg-warning">
                    <i class="fa-solid fa-file-invoice"></i>
                </div>
                <div class="stat-info">
                    <h3>${stats.porTipo.informe_ir || 0}</h3>
                    <p>Informes de IR</p>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon bg-danger">
                    <i class="fa-solid fa-exclamation-triangle"></i>
                </div>
                <div class="stat-info">
                    <h3>${stats.semRecibo}</h3>
                    <p>Sem Recibo</p>
                </div>
            </div>
        </div>
    `;

    container.innerHTML = html;
}

/**
 * Visualizar detalhes completos de um recibo
 */
async function visualizarDetalheRecibo(reciboId) {
    try {
        console.log('🔍 Buscando detalhes do recibo:', reciboId);

        const { data, error } = await window.supabaseClient
            .from('view_recibos_completos')
            .select('*')
            .eq('recibo_id', reciboId)
            .single();

        if (error) throw error;

        // Criar modal com detalhes
        mostrarModalDetalheRecibo(data);

    } catch (error) {
        console.error('❌ Erro ao buscar detalhes do recibo:', error);
        alert('Erro ao carregar detalhes do recibo');
    }
}

/**
 * Mostrar modal com detalhes do recibo
 */
function mostrarModalDetalheRecibo(recibo) {
    // 🐛 DEBUG: Verificar o que chegou
    console.log('🔍 DEBUG MODAL - Dados recebidos:', recibo);
    console.log('🔍 assinatura_canvas:', recibo.assinatura_canvas ? 'TEM ✅' : 'NÃO TEM ❌');
    console.log('🔍 assinatura_digital:', recibo.assinatura_digital ? 'TEM ✅' : 'NÃO TEM ❌');
    
    const modalHTML = `
        <div id="modalDetalheRecibo" class="modal-overlay" onclick="fecharModalDetalhe(event)">
            <div class="modal-content-large" onclick="event.stopPropagation()">
                <div class="modal-header">
                    <h2><i class="fa-solid fa-file-contract"></i> Detalhes do Recibo Digital</h2>
                    <button class="btn-close" onclick="fecharModalDetalhe()">
                        <i class="fa-solid fa-times"></i>
                    </button>
                </div>

                <div class="modal-body" id="conteudo-impressao">
                    <!-- Papel Timbrado - Cabeçalho -->
                    <div class="papel-timbrado-header">
                        <img src="assets/img/logomarca alternativa.png" alt="ISIBA" class="logo-timbrado">
                        <div class="timbrado-info">
                            <h1>COMPROVANTE DE RECEBIMENTO DE DOCUMENTO</h1>
                            <p class="protocolo-destaque">Protocolo: ${recibo.recibo_id.substring(0, 8).toUpperCase()}</p>
                        </div>
                    </div>

                    <!-- Conteúdo Compacto -->
                    <div class="recibo-content">
                        <!-- Linha 1: Colaborador e Documento lado a lado -->
                        <div class="row-compact">
                            <div class="col-compact">
                                <h3>👤 COLABORADOR</h3>
                                <p><b>Nome:</b> ${recibo.nome_completo}</p>
                                <p><b>CPF:</b> ${formatarCPF(recibo.cpf)}</p>
                                <p><b>E-mail:</b> ${recibo.email || '-'}</p>
                            </div>
                            <div class="col-compact">
                                <h3>📄 DOCUMENTO</h3>
                                <p><b>Tipo:</b> ${recibo.tipo_documento === 'informe_ir' ? 'Informe de Rendimentos' : 'Contracheque'}</p>
                                <p><b>Período:</b> ${recibo.tipo_documento === 'informe_ir' ? `Ano ${recibo.ano}` : `${recibo.mes_referencia}/${recibo.ano}`}</p>
                                <p><b>Enviado:</b> ${formatarDataHora(recibo.enviado_em)}</p>
                            </div>
                        </div>

                        <!-- Linha 2: Confirmação de Recebimento -->
                        <div class="section-compact">
                            <h3>✍️ CONFIRMAÇÃO DE RECEBIMENTO</h3>
                            <p><b>Declarante:</b> ${recibo.assinatura_texto} | <b>Data:</b> ${formatarDataHora(recibo.data_recebimento)} | <b>Aceite:</b> ${recibo.declaracao_aceite ? '✅ Confirmado' : '❌ Não'}</p>
                            
                            ${recibo.assinatura_canvas ? `
                                <div class="assinatura-box-compact">
                                    <img src="${recibo.assinatura_canvas}" alt="Assinatura" class="assinatura-img-compact">
                                    <small>Assinatura capturada digitalmente • Lei 14.063/2020</small>
                                </div>
                            ` : '<p class="no-sign">⚠️ Assinatura digital não disponível</p>'}
                        </div>

                        <!-- Linha 3: Informações Técnicas (só impressão) -->
                        <div class="tech-info">
                            <p><b>IP:</b> ${recibo.ip_address || '-'} | <b>Registro:</b> ${formatarDataHora(recibo.criado_em)}</p>
                        </div>
                    </div>

                    <!-- Papel Timbrado - Rodapé -->
                    <div class="papel-timbrado-footer">
                        <p class="declaracao-legal">
                            <b>DECLARAÇÃO:</b> Declaro que recebi o documento acima descrito por meio digital e que a assinatura corresponde à minha identificação. 
                            Este recibo possui validade jurídica conforme legislação vigente (Lei 14.063/2020).
                        </p>
                        <p class="autenticidade">
                            Documento gerado eletronicamente • Protocolo: ${recibo.recibo_id.substring(0, 8).toUpperCase()} • ${formatarDataHora(new Date())}
                        </p>
                    </div>
                </div>

                <div class="modal-footer no-print">
                    <button class="btn btn-secondary" onclick="fecharModalDetalhe()">
                        <i class="fa-solid fa-times"></i> Fechar
                    </button>
                    <button class="btn btn-print" onclick="imprimirRecibo()">
                        <i class="fa-solid fa-print"></i> Imprimir Documento
                    </button>
                </div>
            </div>
        </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);
}

/**
 * Fechar modal de detalhes
 */
function fecharModalDetalhe(event) {
    if (event && event.target.className !== 'modal-overlay') return;
    
    const modal = document.getElementById('modalDetalheRecibo');
    if (modal) {
        modal.remove();
    }
}

// ==================== FUNÇÕES AUXILIARES ====================

/**
 * Formatar CPF
 */
function formatarCPF(cpf) {
    if (!cpf) return '-';
    return cpf.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4');
}

/**
 * Formatar data e hora
 */
function formatarDataHora(dataISO) {
    if (!dataISO) return '-';
    const data = new Date(dataISO);
    return data.toLocaleString('pt-BR', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

/**
 * Baixar assinatura digital como PNG
 */
function baixarAssinaturaDigital(nomeColaborador, assinaturaBase64) {
    try {
        // Criar link de download
        const link = document.createElement('a');
        link.href = assinaturaBase64;
        link.download = `Assinatura_${nomeColaborador.replace(/\s+/g, '_')}_${new Date().getTime()}.png`;
        
        // Disparar download
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        
        console.log('✅ Assinatura digital baixada com sucesso');
    } catch (error) {
        console.error('❌ Erro ao baixar assinatura:', error);
        alert('Erro ao baixar assinatura digital');
    }
}

/**
 * Imprimir recibo formatado
 */
function imprimirRecibo() {
    try {
        console.log('🖨️ Iniciando impressão do recibo...');
        
        // Ocultar botões e overlay antes de imprimir
        const footer = document.querySelector('.modal-footer');
        const btnClose = document.querySelector('.btn-close');
        const overlay = document.getElementById('modalDetalheRecibo');
        
        if (footer) footer.style.display = 'none';
        if (btnClose) btnClose.style.display = 'none';
        if (overlay) overlay.style.background = 'white';
        
        // Aguardar renderização
        setTimeout(() => {
            // Executar impressão
            window.print();
            
            // Restaurar visualização após impressão
            setTimeout(() => {
                if (footer) footer.style.display = 'flex';
                if (btnClose) btnClose.style.display = 'flex';
                if (overlay) overlay.style.background = 'rgba(0, 0, 0, 0.6)';
            }, 500);
            
            console.log('✅ Impressão iniciada com sucesso');
        }, 300);
        
    } catch (error) {
        console.error('❌ Erro ao imprimir:', error);
        alert('Erro ao imprimir documento. Tente novamente.');
    }
}

console.log('✅ recibo-admin.js VERSÃO 3.5 - LOGO ALTERNATIVA + PÁGINA ÚNICA carregado');
