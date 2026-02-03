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
    const modalHTML = `
        <div id="modalDetalheRecibo" class="modal-overlay" onclick="fecharModalDetalhe(event)">
            <div class="modal-content-large" onclick="event.stopPropagation()">
                <div class="modal-header">
                    <h2><i class="fa-solid fa-file-contract"></i> Detalhes do Recibo Digital</h2>
                    <button class="btn-close" onclick="fecharModalDetalhe()">
                        <i class="fa-solid fa-times"></i>
                    </button>
                </div>

                <div class="modal-body">
                    <div class="detail-grid">
                        <div class="detail-section">
                            <h3><i class="fa-solid fa-user"></i> Colaborador</h3>
                            <p><strong>Nome:</strong> ${recibo.nome_completo}</p>
                            <p><strong>CPF:</strong> ${formatarCPF(recibo.cpf)}</p>
                            <p><strong>E-mail:</strong> ${recibo.email || '-'}</p>
                        </div>

                        <div class="detail-section">
                            <h3><i class="fa-solid fa-file-pdf"></i> Documento</h3>
                            <p><strong>Tipo:</strong> ${recibo.tipo_documento === 'informe_ir' ? 'Informe de IR' : 'Contracheque'}</p>
                            <p><strong>Período:</strong> ${recibo.tipo_documento === 'informe_ir' ? `Ano ${recibo.ano}` : `${recibo.mes_referencia} ${recibo.ano}`}</p>
                            <p><strong>Arquivo:</strong> ${recibo.nome_arquivo}</p>
                            <p><strong>Enviado em:</strong> ${formatarDataHora(recibo.enviado_em)}</p>
                            <p><strong>Enviado por:</strong> ${recibo.enviado_por}</p>
                        </div>

                        <div class="detail-section">
                            <h3><i class="fa-solid fa-signature"></i> Assinatura</h3>
                            <p><strong>Nome Completo:</strong> ${recibo.assinatura_texto}</p>
                            <p><strong>Data de Recebimento:</strong> ${formatarDataHora(recibo.data_recebimento)}</p>
                            <p><strong>Data de Visualização:</strong> ${formatarDataHora(recibo.data_visualizacao)}</p>
                            <p><strong>Aceite:</strong> ${recibo.declaracao_aceite ? '✅ Sim' : '❌ Não'}</p>
                            
                            ${recibo.assinatura_digital ? `
                                <div class="assinatura-digital-container">
                                    <label><strong><i class="fa-solid fa-pen-nib"></i> Assinatura Digital:</strong></label>
                                    <div class="assinatura-digital-box">
                                        <img src="${recibo.assinatura_digital}" alt="Assinatura Digital" class="assinatura-digital-img">
                                    </div>
                                    <small style="color: #666; font-size: 0.85rem;">
                                        <i class="fa-solid fa-shield-check"></i> Assinatura capturada digitalmente em ${formatarDataHora(recibo.data_recebimento)}
                                    </small>
                                </div>
                            ` : '<p style="color: #999; font-style: italic;"><i class="fa-solid fa-info-circle"></i> Assinatura digital não disponível (recibo antigo)</p>'}
                        </div>

                        <div class="detail-section">
                            <h3><i class="fa-solid fa-info-circle"></i> Informações Técnicas</h3>
                            <p><strong>IP Address:</strong> ${recibo.ip_address || '-'}</p>
                            <p><strong>Registrado em:</strong> ${formatarDataHora(recibo.criado_em)}</p>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button class="btn btn-secondary" onclick="fecharModalDetalhe()">
                        <i class="fa-solid fa-times"></i> Fechar
                    </button>
                    ${recibo.assinatura_digital ? `
                        <button class="btn btn-primary" onclick="baixarAssinaturaDigital('${recibo.nome_completo}', '${recibo.assinatura_digital}')">
                            <i class="fa-solid fa-download"></i> Baixar Assinatura
                        </button>
                    ` : ''}
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

console.log('✅ recibo-admin.js VERSÃO 3.0 - SUPORTE ASSINATURA DIGITAL carregado');
