/**
 * ════════════════════════════════════════════════════════════════
 * SISTEMA DE RECIBOS DE DOCUMENTOS - PORTAL DO COLABORADOR
 * VERSÃO 3.6 - FIX: Verifica erro UPDATE + Debug RLS
 * ════════════════════════════════════════════════════════════════
 * Gerencia a geração de recibos digitais para contracheques e
 * informes de IR entregues aos colaboradores.
 * ════════════════════════════════════════════════════════════════
 */

console.log('🔥 Recibo Modal VERSÃO 3.6 - FIX UPDATE + DEBUG RLS carregado!');

// ==================== VARIÁVEIS GLOBAIS ====================
let modalRecibo = null;
let documentoAtual = null;
let colaboradorAtual = null;

// Variáveis do Canvas de Assinatura
let canvas = null;
let ctx = null;
let isDrawing = false;
let assinaturaVazia = true;
let lastX = 0;
let lastY = 0;

// ==================== INICIALIZAÇÃO ====================

/**
 * Inicializa o sistema de recibos
 */
function inicializarSistemaRecibos() {
    console.log('📝 Inicializando sistema de recibos...');
    criarModalRecibo();
    
    // Buscar dados do colaborador do sessionStorage
    const dadosColaborador = sessionStorage.getItem('colaborador_data');
    if (dadosColaborador) {
        colaboradorAtual = JSON.parse(dadosColaborador);
        console.log('✅ Colaborador identificado:', colaboradorAtual);
        console.log('🔍 ID do colaborador:', colaboradorAtual.id);
        console.log('🔍 Nome do colaborador:', colaboradorAtual.nome);
    } else {
        console.error('❌ Dados do colaborador NÃO encontrados no sessionStorage!');
    }
}

// ==================== MODAL HTML ====================

/**
 * Cria o modal de recibo no DOM
 */
function criarModalRecibo() {
    // Remover modal existente (se houver)
    const modalExistente = document.getElementById('modalRecibo');
    if (modalExistente) {
        modalExistente.remove();
    }

    // Criar modal
    const modalHTML = `
        <div id="modalRecibo" class="modal-recibo" style="display: none;">
            <div class="modal-recibo-overlay"></div>
            <div class="modal-recibo-content">
                <!-- Header -->
                <div class="modal-recibo-header">
                    <h2><i class="fa-solid fa-file-signature"></i> Recibo de Documento</h2>
                    <button class="modal-close-btn" onclick="fecharModalRecibo()">
                        <i class="fa-solid fa-times"></i>
                    </button>
                </div>

                <!-- Body -->
                <div class="modal-recibo-body">
                    <!-- Informações do Documento -->
                    <div class="recibo-info-card">
                        <h3><i class="fa-solid fa-file-pdf"></i> Documento</h3>
                        <div class="recibo-info-grid">
                            <div class="recibo-info-item">
                                <label>Tipo:</label>
                                <span id="reciboTipoDoc">-</span>
                            </div>
                            <div class="recibo-info-item">
                                <label>Período:</label>
                                <span id="reciboPeriodo">-</span>
                            </div>
                            <div class="recibo-info-item">
                                <label>Arquivo:</label>
                                <span id="reciboArquivo">-</span>
                            </div>
                            <div class="recibo-info-item">
                                <label>Enviado em:</label>
                                <span id="reciboDataEnvio">-</span>
                            </div>
                        </div>
                    </div>

                    <!-- Declaração -->
                    <div class="recibo-declaracao">
                        <div class="recibo-declaracao-box">
                            <i class="fa-solid fa-shield-check"></i>
                            <p>
                                Declaro que <strong>recebi</strong> e tenho <strong>ciência</strong> 
                                do documento acima referenciado, disponibilizado através do 
                                Portal do Colaborador da ISIBA Social.
                            </p>
                        </div>
                    </div>

                    <!-- Assinatura Digital -->
                    <div class="recibo-assinatura-section">
                        <h3><i class="fa-solid fa-signature"></i> Assinatura Digital</h3>
                        <p class="recibo-help-text">Assine no quadro abaixo com o mouse ou dedo:</p>
                        
                        <!-- Canvas de Assinatura -->
                        <div class="canvas-container">
                            <canvas id="canvasAssinatura" width="600" height="200"></canvas>
                            <div class="canvas-overlay" id="canvasOverlay">
                                <i class="fa-solid fa-pen-nib"></i>
                                <p>Clique ou toque para começar a assinar</p>
                            </div>
                        </div>
                        
                        <div class="canvas-actions">
                            <button type="button" class="btn-canvas-clear" onclick="limparAssinatura()">
                                <i class="fa-solid fa-eraser"></i>
                                Limpar Assinatura
                            </button>
                            <small class="canvas-hint">
                                <i class="fa-solid fa-info-circle"></i>
                                A assinatura é obrigatória para desbloquear o documento
                            </small>
                        </div>

                        <!-- Nome Completo -->
                        <div class="form-group" style="margin-top: 20px;">
                            <label for="reciboAssinatura" class="form-label">
                                <i class="fa-solid fa-user"></i>
                                Confirme seu Nome Completo
                            </label>
                            <input 
                                type="text" 
                                id="reciboAssinatura" 
                                class="recibo-input"
                                placeholder="Digite seu nome completo"
                                required
                            >
                            <small class="recibo-input-hint">
                                <i class="fa-solid fa-info-circle"></i>
                                Digite exatamente como cadastrado no sistema
                            </small>
                        </div>

                        <div class="form-group">
                            <label class="recibo-checkbox">
                                <input type="checkbox" id="reciboAceite" required>
                                <span>Li e concordo com a declaração de recebimento acima</span>
                            </label>
                        </div>
                    </div>

                    <!-- Botões -->
                    <div class="recibo-actions">
                        <button class="btn-recibo-cancel" onclick="fecharModalRecibo()">
                            <i class="fa-solid fa-times"></i>
                            Cancelar
                        </button>
                        <button class="btn-recibo-confirm" onclick="confirmarRecibo()">
                            <i class="fa-solid fa-check"></i>
                            Confirmar Recebimento
                        </button>
                    </div>

                    <!-- Status de envio -->
                    <div id="reciboStatus" class="recibo-status" style="display: none;"></div>
                </div>
            </div>
        </div>
    `;

    document.body.insertAdjacentHTML('beforeend', modalHTML);
    modalRecibo = document.getElementById('modalRecibo');
    
    // Inicializar canvas de assinatura
    inicializarCanvas();
    
    console.log('✅ Modal de recibo criado');
}

// ==================== CANVAS DE ASSINATURA ====================

/**
 * Inicializa o canvas de assinatura
 */
function inicializarCanvas() {
    canvas = document.getElementById('canvasAssinatura');
    if (!canvas) return;
    
    ctx = canvas.getContext('2d');
    const overlay = document.getElementById('canvasOverlay');
    
    // ✅ FIX: Configurar estilo do canvas com cor FORTE
    ctx.strokeStyle = '#000000'; // Preto forte
    ctx.lineWidth = 3; // Linha mais grossa (era 2)
    ctx.lineCap = 'round';
    ctx.lineJoin = 'round';
    ctx.globalCompositeOperation = 'source-over'; // Garante opacidade total
    
    console.log('✅ Canvas configurado: cor preta, linha grossa 3px');
    
    // Eventos de Mouse (Desktop)
    canvas.addEventListener('mousedown', iniciarDesenho);
    canvas.addEventListener('mousemove', desenhar);
    canvas.addEventListener('mouseup', pararDesenho);
    canvas.addEventListener('mouseleave', pararDesenho);
    
    // Eventos de Touch (Mobile/Tablet)
    canvas.addEventListener('touchstart', iniciarDesenhoTouch);
    canvas.addEventListener('touchmove', desenharTouch);
    canvas.addEventListener('touchend', pararDesenho);
    
    // Remover overlay ao começar a desenhar
    canvas.addEventListener('mousedown', () => overlay.style.display = 'none', { once: true });
    canvas.addEventListener('touchstart', () => overlay.style.display = 'none', { once: true });
}

/**
 * Inicia o desenho (mouse)
 */
function iniciarDesenho(e) {
    isDrawing = true;
    const rect = canvas.getBoundingClientRect();
    lastX = e.clientX - rect.left;
    lastY = e.clientY - rect.top;
}

/**
 * Inicia o desenho (touch)
 */
function iniciarDesenhoTouch(e) {
    e.preventDefault();
    isDrawing = true;
    const rect = canvas.getBoundingClientRect();
    const touch = e.touches[0];
    lastX = touch.clientX - rect.left;
    lastY = touch.clientY - rect.top;
}

/**
 * Desenha no canvas (mouse)
 */
function desenhar(e) {
    if (!isDrawing) return;
    
    const rect = canvas.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    
    ctx.beginPath();
    ctx.moveTo(lastX, lastY);
    ctx.lineTo(x, y);
    ctx.stroke();
    
    lastX = x;
    lastY = y;
    assinaturaVazia = false;
}

/**
 * Desenha no canvas (touch)
 */
function desenharTouch(e) {
    if (!isDrawing) return;
    e.preventDefault();
    
    const rect = canvas.getBoundingClientRect();
    const touch = e.touches[0];
    const x = touch.clientX - rect.left;
    const y = touch.clientY - rect.top;
    
    ctx.beginPath();
    ctx.moveTo(lastX, lastY);
    ctx.lineTo(x, y);
    ctx.stroke();
    
    lastX = x;
    lastY = y;
    assinaturaVazia = false;
}

/**
 * Para o desenho
 */
function pararDesenho() {
    isDrawing = false;
}

/**
 * Limpa a assinatura
 */
function limparAssinatura() {
    if (!canvas || !ctx) return;
    
    console.log('🧹 Limpando assinatura...');
    
    // Limpar o canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    assinaturaVazia = true;
    
    // Resetar o estado de desenho
    isDrawing = false;
    
    // ✅ FIX: Reconfigurar estilo após limpar (cor FORTE)
    ctx.strokeStyle = '#000000'; // Preto forte
    ctx.lineWidth = 3;
    ctx.lineCap = 'round';
    ctx.lineJoin = 'round';
    ctx.globalCompositeOperation = 'source-over';
    
    console.log('✅ Canvas limpo e reconfigurado com cor preta forte');
}

/**
 * Converte canvas para base64
 */
function obterAssinaturaBase64() {
    if (!canvas) return null;
    return canvas.toDataURL('image/png');
}

// ==================== VERIFICAÇÃO E ABERTURA ====================

/**
 * Verifica se o documento já tem recibo e abre modal se necessário
 * @param {Object} documento - Dados do documento (contracheque/informe)
 * @param {Function} callbackSucesso - Função a executar após gerar recibo
 */
async function verificarEAbrirRecibo(documento, callbackSucesso) {
    try {
        console.log('🔍 Verificando se documento precisa de recibo...', documento.id);
        
        // ===== VERIFICAR SE COLABORADOR ESTÁ CARREGADO =====
        if (!colaboradorAtual || !colaboradorAtual.id) {
            console.error('❌ Colaborador não identificado! Recarregando dados...');
            
            // Tentar recarregar dados do sessionStorage
            const dadosColaborador = sessionStorage.getItem('colaborador_data');
            if (dadosColaborador) {
                colaboradorAtual = JSON.parse(dadosColaborador);
                console.log('✅ Colaborador recarregado:', colaboradorAtual.nome_completo);
            } else {
                console.error('❌ ERRO CRÍTICO: Dados do colaborador não encontrados!');
                alert('Erro: Sessão expirada. Por favor, faça login novamente.');
                window.location.href = 'colaborador.html';
                return;
            }
        }

        console.log('🔍 Colaborador ID:', colaboradorAtual.id);
        console.log('🔍 Documento ID:', documento.id);

        // ===== VERIFICAÇÃO DUPLA: Tabela recibos_documentos E campo recibo_gerado =====
        
        // 1. Verificar campo recibo_gerado do documento
        console.log('🔍 Verificando campo recibo_gerado...', documento.recibo_gerado);
        
        if (documento.recibo_gerado === false || documento.recibo_gerado === null) {
            console.log('🔒 Documento bloqueado (recibo_gerado = false), forçando assinatura...');
            // Documento está bloqueado, forçar modal de assinatura
            documentoAtual = documento;
            mostrarModalRecibo(documento, callbackSucesso);
            return;
        }

        // 2. Se recibo_gerado = true, verificar se existe recibo na tabela
        const { data: reciboExistente, error } = await window.supabaseClient
            .from('recibos_documentos')
            .select('id, data_recebimento, assinatura_canvas')
            .eq('documento_id', documento.id)
            .eq('colaborador_id', colaboradorAtual.id)
            .single();

        if (error && error.code !== 'PGRST116') {
            console.error('❌ Erro ao verificar recibo:', error);
        }

        if (reciboExistente && reciboExistente.assinatura_canvas) {
            console.log('✅ Recibo com assinatura canvas existe, liberando download...');
            // Já tem recibo com assinatura, pode baixar diretamente
            if (callbackSucesso) {
                callbackSucesso();
            }
            return;
        }

        // 3. Não tem recibo OU não tem assinatura, abrir modal
        console.log('📝 Abrindo modal para gerar recibo...');
        documentoAtual = documento;
        mostrarModalRecibo(documento, callbackSucesso);

    } catch (error) {
        console.error('❌ Erro ao verificar recibo:', error);
        // Em caso de erro, permite o download
        if (callbackSucesso) {
            callbackSucesso();
        }
    }
}

/**
 * Mostra o modal de recibo (função interna)
 */
function mostrarModalRecibo(documento, callbackSucesso) {
    // Preencher informações do documento
    const tipoDoc = documento.tipo_documento === 'informe_ir' 
        ? 'Informe de Rendimentos' 
        : 'Contracheque';
    
    const periodo = documento.tipo_documento === 'informe_ir'
        ? `Ano ${documento.ano}`
        : `${documento.mes_referencia} ${documento.ano}`;

    document.getElementById('reciboTipoDoc').textContent = tipoDoc;
    document.getElementById('reciboPeriodo').textContent = periodo;
    document.getElementById('reciboArquivo').textContent = documento.nome_arquivo || 'Documento.pdf';
    document.getElementById('reciboDataEnvio').textContent = formatarDataHora(documento.enviado_em);

    // ✅ FIX: Campo de nome VAZIO para o colaborador digitar
    document.getElementById('reciboAssinatura').value = '';

    // Limpar checkbox
    document.getElementById('reciboAceite').checked = false;

    // ✅ FIX: Limpar canvas ao abrir o modal
    limparAssinatura();

    // Armazenar callback
    modalRecibo.dataset.callbackSucesso = callbackSucesso ? 'true' : 'false';

    // Mostrar modal
    modalRecibo.style.display = 'flex';
    document.body.style.overflow = 'hidden';

    // Foco no input de assinatura
    setTimeout(() => {
        document.getElementById('reciboAssinatura').focus();
    }, 300);
}

/**
 * Fecha o modal de recibo
 */
function fecharModalRecibo() {
    if (!modalRecibo) return;

    modalRecibo.style.display = 'none';
    document.body.style.overflow = 'auto';
    
    // Limpar campos
    document.getElementById('reciboAssinatura').value = '';
    document.getElementById('reciboAceite').checked = false;
    document.getElementById('reciboStatus').style.display = 'none';
    
    // Limpar assinatura digital
    limparAssinatura();
}

// ==================== CONFIRMAÇÃO ====================

/**
 * Confirma o recibo e salva no banco
 */
async function confirmarRecibo() {
    try {
        const btnConfirmar = document.querySelector('.btn-recibo-confirm');
        const statusDiv = document.getElementById('reciboStatus');
        
        // Validações
        const assinatura = document.getElementById('reciboAssinatura').value.trim();
        const aceite = document.getElementById('reciboAceite').checked;

        // Validar assinatura digital
        if (assinaturaVazia) {
            mostrarStatus('error', '✍️ Por favor, assine no quadro acima');
            return;
        }

        if (!assinatura) {
            mostrarStatus('error', 'Por favor, digite seu nome completo');
            return;
        }

        if (!aceite) {
            mostrarStatus('error', 'Você precisa concordar com a declaração');
            return;
        }

        // Validar se o nome corresponde ao cadastrado
        if (colaboradorAtual && colaboradorAtual.nome && assinatura.toLowerCase() !== colaboradorAtual.nome.toLowerCase()) {
            mostrarStatus('error', 'O nome digitado não corresponde ao seu cadastro');
            return;
        }

        // Desabilitar botão
        btnConfirmar.disabled = true;
        btnConfirmar.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Salvando...';

        // Capturar assinatura digital como base64
        const assinaturaDigital = obterAssinaturaBase64();
        console.log('✍️ Assinatura capturada:', assinaturaDigital ? 'Sim' : 'Não');

        // Capturar informações do cliente
        const ipAddress = await obterIPAddress();
        const userAgent = navigator.userAgent;

        // Dados do recibo
        const dadosRecibo = {
            documento_id: documentoAtual.id,
            colaborador_id: colaboradorAtual.id,
            tipo_documento: documentoAtual.tipo_documento || 'contracheque',
            mes_referencia: documentoAtual.mes_referencia,
            ano: documentoAtual.ano,
            nome_arquivo: documentoAtual.nome_arquivo,
            assinatura_texto: assinatura,
            assinatura_canvas: assinaturaDigital, // ✅ CORRIGIDO: Imagem base64 da assinatura
            declaracao_aceite: aceite,
            ip_address: ipAddress,
            user_agent: userAgent,
            data_visualizacao: new Date().toISOString(),
            data_recebimento: new Date().toISOString()
        };

        console.log('💾 Salvando recibo:', dadosRecibo);

        // Salvar no banco
        const { data, error } = await window.supabaseClient
            .from('recibos_documentos')
            .insert([dadosRecibo])
            .select();

        if (error) throw error;

        console.log('✅ Recibo salvo com sucesso:', data);

        // Atualizar flag no documento + salvar assinatura digital
        console.log('📝 Atualizando documento ID:', documentoAtual.id);
        const { data: dataUpdate, error: errorUpdate } = await window.supabaseClient
            .from('contracheques')
            .update({ 
                recibo_gerado: true,
                visualizado: true,
                data_primeira_visualizacao: new Date().toISOString(),
                assinatura_digital: assinaturaDigital // ✅ Salva assinatura também no contracheque
            })
            .eq('id', documentoAtual.id)
            .select(); // ← IMPORTANTE: Retorna os dados atualizados

        if (errorUpdate) {
            console.error('❌ ERRO ao atualizar contracheque:', errorUpdate);
            throw new Error('Falha ao atualizar documento: ' + errorUpdate.message);
        }

        console.log('✅ Documento atualizado com sucesso:', dataUpdate);
        console.log('✅ recibo_gerado agora é:', dataUpdate?.[0]?.recibo_gerado);

        // Sucesso!
        mostrarStatus('success', 'Recibo registrado com sucesso!');

        setTimeout(() => {
            fecharModalRecibo();
            
            // ✅ FIX: Recarregar documentos para atualizar o status visual
            if (typeof window.carregarDocumentos === 'function' && colaboradorAtual && colaboradorAtual.id) {
                console.log('🔄 Recarregando documentos para atualizar status...');
                window.carregarDocumentos(colaboradorAtual.id);
            } else {
                // Fallback: recarregar página inteira
                console.log('🔄 Recarregando página...');
                window.location.reload();
            }
            
            // Chamar callback global para desbloquear documento
            if (typeof window.onReciboConfirmado === 'function') {
                window.onReciboConfirmado(documentoAtual.id, documentoAtual.arquivo_url, documentoAtual.nome_arquivo);
            } else {
                // Fallback: baixar documento diretamente
                baixarDocumentoAposRecibo();
            }
        }, 1500);

    } catch (error) {
        console.error('❌ Erro ao salvar recibo:', error);
        mostrarStatus('error', 'Erro ao salvar recibo: ' + error.message);
        
        // Reabilitar botão
        const btnConfirmar = document.querySelector('.btn-recibo-confirm');
        btnConfirmar.disabled = false;
        btnConfirmar.innerHTML = '<i class="fa-solid fa-check"></i> Confirmar Recebimento';
    }
}

/**
 * Baixa o documento após gerar o recibo
 */
function baixarDocumentoAposRecibo() {
    if (documentoAtual && documentoAtual.arquivo_url) {
        console.log('📥 Iniciando download do documento...');
        baixarContracheque(documentoAtual.arquivo_url, documentoAtual.nome_arquivo);
    }
}

// ==================== FUNÇÕES AUXILIARES ====================

/**
 * Mostra mensagem de status no modal
 */
function mostrarStatus(tipo, mensagem) {
    const statusDiv = document.getElementById('reciboStatus');
    statusDiv.style.display = 'block';
    statusDiv.className = `recibo-status recibo-status-${tipo}`;
    
    const icon = tipo === 'success' ? 'check-circle' : 'exclamation-circle';
    statusDiv.innerHTML = `
        <i class="fa-solid fa-${icon}"></i>
        <span>${mensagem}</span>
    `;
}

/**
 * Obtém o IP do cliente (se possível)
 */
async function obterIPAddress() {
    try {
        const response = await fetch('https://api.ipify.org?format=json');
        const data = await response.json();
        return data.ip;
    } catch (error) {
        console.warn('⚠️ Não foi possível obter IP:', error);
        return 'Não disponível';
    }
}

/**
 * Formata data e hora
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

// ==================== INICIALIZAÇÃO AUTOMÁTICA ====================

// Inicializar quando o DOM carregar
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', inicializarSistemaRecibos);
} else {
    inicializarSistemaRecibos();
}

console.log('🔥 recibo-modal.js VERSÃO 3.0 - ASSINATURA DIGITAL CANVAS carregado');
