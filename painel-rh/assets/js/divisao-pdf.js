/**
 * ================================================================
 * DIVISÃO AUTOMÁTICA DE PDF COMPILADO
 * ================================================================
 * Sistema que divide um PDF compilado em contracheques individuais
 * Identifica código e nome do funcionário em cada página
 * Cria PDFs separados e vincula aos colaboradores
 * ================================================================
 */

// Importar bibliotecas necessárias
// pdf-lib para manipulação de PDF
// pdfjs-dist para leitura de texto

let pdfCompilado = null;
let pdfDoc = null;
let totalPaginas = 0;

// ============================================================
// INICIALIZAÇÃO
// ============================================================
document.addEventListener('DOMContentLoaded', () => {
    initDivisaoPDF();
});

function initDivisaoPDF() {
    const uploadZone = document.getElementById('uploadLoteZone');
    const uploadInput = document.getElementById('uploadLoteFiles');
    const btnLimpar = document.getElementById('btnLimparLote');
    const btnProcessar = document.getElementById('btnProcessarLote');

    if (!uploadZone || !uploadInput) return;

    // Remover atributo multiple para aceitar apenas 1 arquivo
    uploadInput.removeAttribute('multiple');

    // Drag and drop
    uploadZone.addEventListener('click', () => uploadInput.click());
    
    uploadZone.addEventListener('dragover', (e) => {
        e.preventDefault();
        uploadZone.style.borderColor = '#2196f3';
        uploadZone.style.background = '#e3f2fd';
    });

    uploadZone.addEventListener('dragleave', () => {
        uploadZone.style.borderColor = '#ddd';
        uploadZone.style.background = 'transparent';
    });

    uploadZone.addEventListener('drop', (e) => {
        e.preventDefault();
        uploadZone.style.borderColor = '#ddd';
        uploadZone.style.background = 'transparent';
        
        const arquivo = e.dataTransfer.files[0];
        if (arquivo && arquivo.type === 'application/pdf') {
            handleArquivoSelecionado(arquivo);
        } else {
            showNotification('Apenas arquivos PDF são aceitos!', 'error');
        }
    });

    uploadInput.addEventListener('change', (e) => {
        const arquivo = e.target.files[0];
        if (arquivo) {
            handleArquivoSelecionado(arquivo);
        }
    });

    if (btnLimpar) {
        btnLimpar.addEventListener('click', limparSelecao);
    }

    if (btnProcessar) {
        btnProcessar.addEventListener('click', processarPDFCompilado);
    }

    // Definir mês atual no select
    const mesAtual = new Date().getMonth() + 1;
    const mesSelect = document.getElementById('mesLote');
    if (mesSelect) {
        mesSelect.value = mesAtual.toString().padStart(2, '0');
    }
}

// ============================================================
// MANIPULAÇÃO DE ARQUIVO
// ============================================================
async function handleArquivoSelecionado(arquivo) {
    // Validar tamanho (máx 50MB)
    const maxSize = 50 * 1024 * 1024;
    if (arquivo.size > maxSize) {
        showNotification('Arquivo muito grande! Máximo 50MB.', 'error');
        return;
    }

    pdfCompilado = arquivo;

    try {
        // Carregar PDF para contar páginas
        const arrayBuffer = await arquivo.arrayBuffer();
        const loadingTask = pdfjsLib.getDocument({data: arrayBuffer});
        pdfDoc = await loadingTask.promise;
        totalPaginas = pdfDoc.numPages;

        mostrarInfoArquivo(arquivo, totalPaginas);
        showNotification(`PDF carregado com sucesso! ${totalPaginas} páginas detectadas.`, 'success');
    } catch (error) {
        console.error('Erro ao carregar PDF:', error);
        showNotification('Erro ao ler o PDF. Verifique se o arquivo não está corrompido.', 'error');
        pdfCompilado = null;
        pdfDoc = null;
    }
}

function mostrarInfoArquivo(arquivo, paginas) {
    const lista = document.getElementById('listaArquivosLote');
    const container = document.getElementById('arquivosLoteList');
    const configProcessar = document.getElementById('configProcessar');
    const areaProcessar = document.getElementById('areaProcessar');

    if (!lista || !container) return;

    const tamanhoMB = (arquivo.size / (1024 * 1024)).toFixed(2);

    container.innerHTML = `
        <div style="background: white; padding: 20px; border-radius: 12px; border: 2px solid #2196f3;">
            <div style="display: flex; align-items: center; gap: 16px;">
                <i class="fa-solid fa-file-pdf" style="font-size: 3rem; color: #f44336;"></i>
                <div style="flex: 1;">
                    <h4 style="margin: 0 0 8px 0; color: #333; font-size: 1.1rem;">${arquivo.name}</h4>
                    <div style="display: flex; gap: 16px; color: #666; font-size: 0.9rem;">
                        <span><i class="fa-solid fa-weight"></i> ${tamanhoMB} MB</span>
                        <span><i class="fa-solid fa-file"></i> ${paginas} páginas</span>
                    </div>
                </div>
                <div style="background: #4caf50; color: white; padding: 8px 16px; border-radius: 20px; font-weight: 600;">
                    <i class="fa-solid fa-check"></i> Pronto
                </div>
            </div>
        </div>
    `;

    lista.style.display = 'block';
    if (configProcessar) configProcessar.style.display = 'block';
    if (areaProcessar) areaProcessar.style.display = 'block';
}

function limparSelecao() {
    pdfCompilado = null;
    pdfDoc = null;
    totalPaginas = 0;

    const uploadInput = document.getElementById('uploadLoteFiles');
    if (uploadInput) uploadInput.value = '';

    const lista = document.getElementById('listaArquivosLote');
    const configProcessar = document.getElementById('configProcessar');
    const areaProcessar = document.getElementById('areaProcessar');
    const progressoLote = document.getElementById('progressoLote');
    const statsLote = document.getElementById('statsLote');
    const logLote = document.getElementById('logLote');

    if (lista) lista.style.display = 'none';
    if (configProcessar) configProcessar.style.display = 'none';
    if (areaProcessar) areaProcessar.style.display = 'none';
    if (progressoLote) progressoLote.style.display = 'none';
    if (statsLote) statsLote.style.display = 'none';
    if (logLote) logLote.style.display = 'none';
}

// ============================================================
// PROCESSAMENTO DO PDF
// ============================================================
async function processarPDFCompilado() {
    if (!pdfCompilado || !pdfDoc) {
        showNotification('Nenhum arquivo PDF selecionado!', 'error');
        return;
    }

    const tipoDocumento = document.getElementById('tipoDocumentoLote')?.value;
    const ano = document.getElementById('anoLote')?.value;
    const mes = document.getElementById('mesLote')?.value;
    const centroCusto = document.getElementById('centroCustoLote')?.value;

    if (!tipoDocumento || !ano || !mes) {
        showNotification('Preencha todos os campos de configuração!', 'error');
        return;
    }

    if (!centroCusto) {
        showNotification('Selecione o Centro de Custo antes de processar!', 'error');
        return;
    }

    // Confirmar processamento
    if (!confirm(`Processar PDF com ${totalPaginas} páginas?\n\nIsso irá dividir o PDF e criar ${totalPaginas} contracheques individuais.`)) {
        return;
    }

    const btnProcessar = document.getElementById('btnProcessarLote');
    if (btnProcessar) {
        btnProcessar.disabled = true;
        btnProcessar.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Processando...';
    }

    try {
        mostrarProgresso(true);
        resetarStats();
        limparLog();

        addLog('info', `Iniciando processamento de ${totalPaginas} páginas...`);
        addLog('info', `Tipo: ${tipoDocumento} | Período: ${mes}/${ano} | Centro: ${centroCusto}`);
        
        // DEBUG: Análise prévia - coletar nomes do PDF
        console.log('\n🔍 ========== ANÁLISE PRÉVIA DO PDF ==========');
        const nomesNoPDF = [];
        for (let i = 1; i <= Math.min(20, totalPaginas); i++) {
            try {
                const textoPage = await extrairTextoPagina(i);
                const dadosColaborador = identificarColaborador(textoPage, i);
                if (dadosColaborador.nome) {
                    nomesNoPDF.push(`Pág ${i}: Cód ${dadosColaborador.codigo} - ${dadosColaborador.nome}`);
                }
            } catch (err) {}
        }
        console.log('📄 PRIMEIROS 20 NOMES NO PDF:');
        nomesNoPDF.forEach(n => console.log('   ' + n));
        
        const { data: todosColaboradores } = await supabaseClient
            .from('colaboradores')
            .select('codigo_funcionario, nome_completo');
        console.log('\n👥 COLABORADORES NO BANCO:');
        todosColaboradores?.forEach(c => console.log(`   Cód ${c.codigo_funcionario} - ${c.nome_completo}`));
        console.log('\n🔄 INICIANDO PROCESSAMENTO E CRUZAMENTO...\n');

        let sucessos = 0;
        let avisos = 0;
        let erros = 0;

        // Processar cada página
        for (let i = 1; i <= totalPaginas; i++) {
            atualizarProgresso(i, totalPaginas, `Processando página ${i} de ${totalPaginas}...`);

            try {
                // Extrair texto da página
                const textoPage = await extrairTextoPagina(i);
                
                // Identificar código e nome
                const dadosColaborador = identificarColaborador(textoPage, i);

                if (!dadosColaborador.codigo || !dadosColaborador.nome) {
                    addLog('warning', `Página ${i}: Código ou nome não identificado`);
                    avisos++;
                    continue;
                }

                addLog('info', `Página ${i}: ${dadosColaborador.codigo} - ${dadosColaborador.nome}`);

                // Extrair página individual
                const pdfIndividual = await extrairPaginaIndividual(i);

                // Buscar colaborador no banco
                const colaborador = await buscarColaboradorNoBanco(dadosColaborador.codigo, dadosColaborador.nome, centroCusto);

                if (!colaborador) {
                    addLog('warning', `Página ${i}: Colaborador não encontrado no banco - ${dadosColaborador.codigo} ${dadosColaborador.nome}`);
                    avisos++;
                    continue;
                }

                console.log(`📤 Preparando upload da página ${i} para ${colaborador.nome_completo}...`);
                console.log(`   CPF: ${colaborador.cpf}`);
                console.log(`   Tipo: ${tipoDocumento} | Período: ${mes}/${ano}`);

                // Upload para Supabase
                const resultado = await uploadContracheque(pdfIndividual, colaborador, tipoDocumento, ano, mes, centroCusto);

                console.log(`📊 Resultado do upload (Página ${i}):`, resultado);

                if (resultado.success) {
                    addLog('success', `Página ${i}: Contracheque enviado com sucesso para ${colaborador.nome_completo}`);
                    sucessos++;
                } else {
                    addLog('error', `Página ${i}: Erro ao enviar - ${resultado.error}`);
                    erros++;
                }

            } catch (error) {
                console.error(`Erro na página ${i}:`, error);
                addLog('error', `Página ${i}: ${error.message}`);
                erros++;
            }

            // Pequeno delay para não sobrecarregar
            await sleep(100);
        }

        // Finalizar
        atualizarStats(sucessos, avisos, erros);
        addLog('info', `✅ Processamento concluído!`);
        addLog('info', `📊 Sucessos: ${sucessos} | Avisos: ${avisos} | Erros: ${erros}`);
        
        showNotification(`Processamento concluído! ${sucessos} contracheques processados.`, 'success');

    } catch (error) {
        console.error('Erro no processamento:', error);
        addLog('error', `Erro fatal: ${error.message}`);
        showNotification('Erro durante o processamento. Verifique o log.', 'error');
    } finally {
        if (btnProcessar) {
            btnProcessar.disabled = false;
            btnProcessar.innerHTML = '<i class="fa-solid fa-scissors"></i> Dividir e Processar PDF';
        }
    }
}

// ============================================================
// EXTRAÇÃO DE DADOS DO PDF
// ============================================================
async function extrairTextoPagina(numeroPagina) {
    try {
        const page = await pdfDoc.getPage(numeroPagina);
        const textContent = await page.getTextContent();
        const texto = textContent.items.map(item => item.str).join(' ');
        return texto;
    } catch (error) {
        throw new Error(`Erro ao extrair texto da página ${numeroPagina}: ${error.message}`);
    }
}

function identificarColaborador(texto, numeroPagina) {
    // Padrão 1: "CC: 222" (Centro de Custo / Código)
    const regexCodigo = /CC:\s*(\d+)/i;
    const matchCodigo = texto.match(regexCodigo);
    const codigo = matchCodigo ? matchCodigo[1].trim() : null;

    // Padrão 2: O nome vem DEPOIS de "Código" e ANTES de "Nome do Funcionário"
    // Formato: "CC: 222  Código  ADALBERTO BATISTA DOS SANTOS  Nome do Funcionário"
    const regexNome = /C[óo]digo\s+((?:[A-Z]+\s*)+?)\s+Nome\s+do\s+Funcion[áa]rio/i;
    const matchNome = texto.match(regexNome);
    let nome = matchNome ? matchNome[1].trim() : null;

    // Limpar nome (normalizar espaços múltiplos para um único espaço)
    if (nome) {
        nome = nome.replace(/\s+/g, ' ').trim();
    }

    return { codigo, nome };
}

async function extrairPaginaIndividual(numeroPagina) {
    try {
        const arrayBuffer = await pdfCompilado.arrayBuffer();
        const pdfLibDoc = await PDFLib.PDFDocument.load(arrayBuffer);
        
        // Criar novo PDF com apenas 1 página
        const novoPdf = await PDFLib.PDFDocument.create();
        const [paginaCopiada] = await novoPdf.copyPages(pdfLibDoc, [numeroPagina - 1]);
        novoPdf.addPage(paginaCopiada);
        
        // Converter para Uint8Array
        const pdfBytes = await novoPdf.save();
        return pdfBytes;
    } catch (error) {
        throw new Error(`Erro ao extrair página ${numeroPagina}: ${error.message}`);
    }
}

// ============================================================
// INTEGRAÇÃO COM SUPABASE
// ============================================================
async function buscarColaboradorNoBanco(codigo, nome, centroCusto) {
    try {
        // DEBUG: Listar todos os colaboradores (apenas primeira vez)
        if (!window._colaboradoresListados) {
            const { data: todosColaboradores } = await supabaseClient
                .from('colaboradores')
                .select('codigo_funcionario, nome_completo, centro_custo')
                .order('codigo_funcionario');
            
            console.log('📋 COLABORADORES NO BANCO:');
            todosColaboradores?.forEach(c => {
                console.log(`   Código: "${c.codigo_funcionario}" | Nome: "${c.nome_completo}" | Centro: "${c.centro_custo}"`);
            });
            window._colaboradoresListados = true;
        }

        // Normalizar nome antes de buscar (remover espaços extras)
        const nomeNormalizado = nome.replace(/\s+/g, ' ').trim();
        
        console.log(`🔎 Buscando: "${nomeNormalizado}" | Centro: "${centroCusto}"`);

        // Buscar por nome e centro de custo
        let query = supabaseClient
            .from('colaboradores')
            .select('*')
            .ilike('nome_completo', `%${nomeNormalizado}%`);

        if (centroCusto) {
            query = query.eq('centro_custo', centroCusto);
        }

        let { data, error } = await query.maybeSingle();

        if (error && error.code !== 'PGRST116') {
            console.error('Erro ao buscar por nome:', error);
            return null;
        }

        if (data) {
            console.log(`✅ MATCH! ${nomeNormalizado} → ${data.nome_completo}`);
        }

        return data;
    } catch (error) {
        console.error('Erro na busca:', error);
        return null;
    }
}

async function uploadContracheque(pdfBytes, colaborador, tipoDocumento, ano, mes, centroCusto) {
    try {
        console.log(`🔧 uploadContracheque iniciado...`);
        console.log(`   Colaborador:`, colaborador.nome_completo);
        console.log(`   CPF:`, colaborador.cpf);
        console.log(`   PDF Size:`, pdfBytes?.length || pdfBytes?.byteLength, 'bytes');
        
        const nomeArquivo = `${colaborador.cpf}_${ano}_${mes}_${tipoDocumento}.pdf`;
        const caminhoArquivo = `${ano}/${mes}/${nomeArquivo}`;

        console.log(`   Caminho:`, caminhoArquivo);

        // Upload para Storage
        console.log(`📁 Iniciando upload para Storage...`);
        const { data: uploadData, error: uploadError } = await supabaseClient.storage
            .from('contracheques')
            .upload(caminhoArquivo, pdfBytes, {
                contentType: 'application/pdf',
                upsert: true
            });

        if (uploadError) {
            console.error(`❌ Erro no upload do Storage:`, uploadError);
            return { success: false, error: uploadError.message };
        }

        console.log(`✅ Upload Storage OK:`, uploadData);

        // Registrar no banco
        console.log(`💾 Registrando no banco de dados (contracheques)...`);
        
        // Verificar se já existe
        const { data: existente } = await supabaseClient
            .from('contracheques')
            .select('id')
            .eq('colaborador_id', colaborador.id)
            .eq('mes_referencia', parseInt(mes))
            .eq('ano', parseInt(ano))
            .single();

        let dbData;
        if (existente) {
            // Atualizar existente
            const { data, error: dbError } = await supabaseClient
                .from('contracheques')
                .update({
                    arquivo_url: caminhoArquivo,
                    nome_arquivo: nomeArquivo,
                    tamanho_arquivo: pdfBytes.length,
                    tipo_documento: tipoDocumento,
                    centro_custo: centroCusto || null,
                    enviado_por: 'Sistema Automático',
                    enviado_em: new Date().toISOString()
                })
                .eq('id', existente.id)
                .select();

            if (dbError) {
                console.error(`❌ Erro ao atualizar no banco:`, dbError);
                return { success: false, error: dbError.message };
            }
            dbData = data[0];
            console.log(`✅ Contracheque atualizado:`, dbData);
        } else {
            // Inserir novo
            const { data, error: dbError } = await supabaseClient
                .from('contracheques')
                .insert([{
                    colaborador_id: colaborador.id,
                    mes_referencia: parseInt(mes),
                    ano: parseInt(ano),
                    arquivo_url: caminhoArquivo,
                    nome_arquivo: nomeArquivo,
                    tamanho_arquivo: pdfBytes.length,
                    tipo_documento: tipoDocumento,
                    centro_custo: centroCusto || null,
                    enviado_por: 'Sistema Automático'
                }])
                .select();

            if (dbError) {
                console.error(`❌ Erro ao inserir no banco:`, dbError);
                return { success: false, error: dbError.message };
            }
            dbData = data[0];
            console.log(`✅ Contracheque criado:`, dbData);
        }

        console.log(`✅ Registro no banco OK`);
        return { success: true };
    } catch (error) {
        console.error(`❌ Erro geral no upload:`, error);
        return { success: false, error: error.message };
    }
}

// ============================================================
// INTERFACE - PROGRESSO E LOGS
// ============================================================
function mostrarProgresso(mostrar) {
    const progressoDiv = document.getElementById('progressoLote');
    const statsDiv = document.getElementById('statsLote');
    const logDiv = document.getElementById('logLote');

    if (progressoDiv) progressoDiv.style.display = mostrar ? 'block' : 'none';
    if (statsDiv) statsDiv.style.display = mostrar ? 'grid' : 'none';
    if (logDiv) logDiv.style.display = mostrar ? 'block' : 'none';
}

function atualizarProgresso(atual, total, texto) {
    const percentual = Math.round((atual / total) * 100);
    const progressFill = document.getElementById('progressFillLote');
    const progressoTexto = document.getElementById('progressoTexto');

    if (progressFill) {
        progressFill.style.width = percentual + '%';
        progressFill.textContent = percentual + '%';
    }

    if (progressoTexto) {
        progressoTexto.textContent = texto;
    }
}

function resetarStats() {
    document.getElementById('statSuccessLote').textContent = '0';
    document.getElementById('statWarningLote').textContent = '0';
    document.getElementById('statErrorLote').textContent = '0';
}

function atualizarStats(sucessos, avisos, erros) {
    document.getElementById('statSuccessLote').textContent = sucessos;
    document.getElementById('statWarningLote').textContent = avisos;
    document.getElementById('statErrorLote').textContent = erros;
}

function limparLog() {
    const logContent = document.getElementById('logLoteContent');
    if (logContent) logContent.innerHTML = '';
}

function addLog(tipo, mensagem) {
    const logContent = document.getElementById('logLoteContent');
    if (!logContent) return;

    const cores = {
        success: '#4caf50',
        warning: '#ff9800',
        error: '#f44336',
        info: '#2196f3'
    };

    const icones = {
        success: 'check-circle',
        warning: 'exclamation-triangle',
        error: 'times-circle',
        info: 'info-circle'
    };

    const hora = new Date().toLocaleTimeString('pt-BR');

    const logItem = document.createElement('div');
    logItem.style.cssText = `
        padding: 12px;
        margin-bottom: 8px;
        background: white;
        border-left: 4px solid ${cores[tipo]};
        border-radius: 6px;
        display: flex;
        align-items: start;
        gap: 12px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    `;

    logItem.innerHTML = `
        <i class="fa-solid fa-${icones[tipo]}" style="color: ${cores[tipo]}; margin-top: 2px;"></i>
        <div style="flex: 1;">
            <div style="color: #666; font-size: 0.85rem;">${hora}</div>
            <div style="color: #333; margin-top: 4px;">${mensagem}</div>
        </div>
    `;

    logContent.appendChild(logItem);
    logContent.scrollTop = logContent.scrollHeight;
}

// ============================================================
// UTILIDADES
// ============================================================
function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

function showNotification(mensagem, tipo = 'info') {
    console.log(`[${tipo.toUpperCase()}] ${mensagem}`);
    
    // Exibir notificação visual simples
    const notification = document.createElement('div');
    notification.className = `notification notification-${tipo}`;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 15px 20px;
        background: ${tipo === 'success' ? '#00a651' : tipo === 'error' ? '#dc3545' : '#0066cc'};
        color: white;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        z-index: 10000;
        animation: slideIn 0.3s ease;
        max-width: 400px;
    `;
    notification.textContent = mensagem;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => notification.remove(), 300);
    }, 4000);
}

// Carregar bibliotecas necessárias
function carregarBibliotecas() {
    // PDF.js
    if (typeof pdfjsLib === 'undefined') {
        const script1 = document.createElement('script');
        script1.src = 'https://cdn.jsdelivr.net/npm/pdfjs-dist@3.11.174/build/pdf.min.js';
        document.head.appendChild(script1);
        
        script1.onload = () => {
            pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdn.jsdelivr.net/npm/pdfjs-dist@3.11.174/build/pdf.worker.min.js';
        };
    }

    // PDF-lib
    if (typeof PDFLib === 'undefined') {
        const script2 = document.createElement('script');
        script2.src = 'https://cdn.jsdelivr.net/npm/pdf-lib@1.17.1/dist/pdf-lib.min.js';
        document.head.appendChild(script2);
    }
}

// Carregar bibliotecas ao iniciar
carregarBibliotecas();
