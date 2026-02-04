// ════════════════════════════════════════════════════════════════
// 🤖 UPLOAD EM LOTE COM LEITURA AUTOMÁTICA DE PDFs
// ════════════════════════════════════════════════════════════════
// Versão 1.0
// Sistema que lê automaticamente código e nome dos PDFs
// e envia para o colaborador correto
// ════════════════════════════════════════════════════════════════

console.log('🤖 Upload em Lote v1.0 carregado');

// Configurar PDF.js
if (typeof pdfjsLib !== 'undefined') {
    pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js';
    console.log('✅ PDF.js configurado');
}

let arquivosSelecionados = [];

// ════════════════════════════════════════════════════════════════
// INICIALIZAÇÃO
// ════════════════════════════════════════════════════════════════

function initUploadLote() {
    const uploadZone = document.getElementById('uploadLoteZone');
    const fileInput = document.getElementById('uploadLoteFiles');
    const btnLimpar = document.getElementById('btnLimparLote');
    const btnProcessar = document.getElementById('btnProcessarLote');

    if (!uploadZone) {
        console.warn('⚠️ Elementos de upload em lote não encontrados');
        return;
    }

    console.log('✅ Inicializando Upload em Lote');

    // Click para selecionar
    uploadZone.addEventListener('click', () => fileInput.click());

    // Drag and drop
    uploadZone.addEventListener('dragover', (e) => {
        e.preventDefault();
        uploadZone.classList.add('dragover');
    });

    uploadZone.addEventListener('dragleave', () => {
        uploadZone.classList.remove('dragover');
    });

    uploadZone.addEventListener('drop', (e) => {
        e.preventDefault();
        uploadZone.classList.remove('dragover');
        handleArquivos(e.dataTransfer.files);
    });

    // Seleção de arquivos
    fileInput.addEventListener('change', (e) => {
        handleArquivos(e.target.files);
    });

    // Botões
    if (btnLimpar) {
        btnLimpar.addEventListener('click', limparSelecao);
    }

    if (btnProcessar) {
        btnProcessar.addEventListener('click', processarLote);
    }
}

// ════════════════════════════════════════════════════════════════
// MANIPULAÇÃO DE ARQUIVOS
// ════════════════════════════════════════════════════════════════

function handleArquivos(files) {
    const pdfFiles = Array.from(files).filter(f => f.type === 'application/pdf');
    
    if (pdfFiles.length === 0) {
        alert('Por favor, selecione apenas arquivos PDF');
        return;
    }

    // Validar tamanho (10MB cada)
    const maxSize = 10 * 1024 * 1024;
    const arquivosGrandes = pdfFiles.filter(f => f.size > maxSize);
    
    if (arquivosGrandes.length > 0) {
        alert(`${arquivosGrandes.length} arquivo(s) excedem 10MB e serão ignorados`);
    }

    // Adicionar apenas arquivos válidos
    const arquivosValidos = pdfFiles.filter(f => f.size <= maxSize);
    arquivosSelecionados.push(...arquivosValidos);

    console.log(`📄 ${arquivosSelecionados.length} arquivos selecionados`);
    
    exibirArquivos();
}

function exibirArquivos() {
    const container = document.getElementById('listaArquivosLote');
    const list = document.getElementById('arquivosLoteList');
    const total = document.getElementById('totalArquivos');
    const areaConfig = document.getElementById('configProcessar');
    const areaProcessar = document.getElementById('areaProcessar');

    if (arquivosSelecionados.length === 0) {
        container.style.display = 'none';
        areaConfig.style.display = 'none';
        areaProcessar.style.display = 'none';
        return;
    }

    container.style.display = 'block';
    areaConfig.style.display = 'block';
    areaProcessar.style.display = 'block';
    total.textContent = arquivosSelecionados.length;

    list.innerHTML = arquivosSelecionados.map((file, index) => `
        <div class="arquivo-item">
            <i class="fa-solid fa-file-pdf"></i>
            <span title="${file.name}">${file.name}</span>
        </div>
    `).join('');
}

function limparSelecao() {
    arquivosSelecionados = [];
    document.getElementById('uploadLoteFiles').value = '';
    exibirArquivos();
    
    // Esconder progresso e logs
    document.getElementById('progressoLote').style.display = 'none';
    document.getElementById('statsLote').style.display = 'none';
    document.getElementById('logLote').style.display = 'none';
}

// ════════════════════════════════════════════════════════════════
// PROCESSAMENTO EM LOTE
// ════════════════════════════════════════════════════════════════

async function processarLote() {
    const btnProcessar = document.getElementById('btnProcessarLote');
    const progressoContainer = document.getElementById('progressoLote');
    const statsContainer = document.getElementById('statsLote');
    const logContainer = document.getElementById('logLote');

    // Desabilitar botão
    btnProcessar.disabled = true;
    btnProcessar.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Processando...';

    // Mostrar containers
    progressoContainer.style.display = 'block';
    statsContainer.style.display = 'grid';
    logContainer.style.display = 'block';

    // Limpar log anterior
    document.getElementById('logLoteContent').innerHTML = '';

    const stats = {
        success: 0,
        warning: 0,
        error: 0
    };

    for (let i = 0; i < arquivosSelecionados.length; i++) {
        const file = arquivosSelecionados[i];
        const progress = ((i + 1) / arquivosSelecionados.length * 100).toFixed(0);

        // Atualizar progresso
        const progressFill = document.getElementById('progressFillLote');
        progressFill.style.width = progress + '%';
        progressFill.textContent = progress + '%';

        document.getElementById('progressoTexto').textContent = 
            `Processando ${i + 1} de ${arquivosSelecionados.length}: ${file.name}`;

        try {
            const resultado = await processarPDF(file);

            if (resultado.success) {
                // Agora fazer upload real para o Supabase
                const uploadResult = await uploadParaSupabase(file, resultado);
                
                if (uploadResult.success) {
                    stats.success++;
                    const periodoTexto = resultado.mes ? `${resultado.mes}/${resultado.ano}` : `Ano ${resultado.ano}`;
                    const tipoTexto = resultado.tipo === 'contracheque' ? 'Contracheque' : 'Informe IR';
                    addLogLote('success', `✅ ${file.name} → ${resultado.colaborador.nome_completo} (Cód: ${resultado.codigo}) | ${tipoTexto} ${periodoTexto} | <a href="${uploadResult.url}" target="_blank" style="color: #0066cc;">Ver PDF</a>`);
                } else {
                    stats.error++;
                    addLogLote('error', `❌ ${file.name} → Erro no upload: ${uploadResult.mensagem}`);
                }
            } else if (resultado.warning) {
                stats.warning++;
                addLogLote('warning', `⚠️ ${file.name} → ${resultado.mensagem}`);
            } else {
                stats.error++;
                addLogLote('error', `❌ ${file.name} → ${resultado.mensagem}`);
            }
        } catch (error) {
            stats.error++;
            addLogLote('error', `❌ ${file.name} → Erro: ${error.message}`);
        }

        // Atualizar estatísticas
        updateStatsLote(stats);

        // Pequeno delay para não sobrecarregar
        await new Promise(resolve => setTimeout(resolve, 100));
    }

    // Finalizado
    btnProcessar.disabled = false;
    btnProcessar.innerHTML = '<i class="fa-solid fa-check"></i> Processamento Concluído!';
    
    document.getElementById('progressoTexto').textContent = 
        `✅ Processamento concluído! ${stats.success} sucesso, ${stats.warning} avisos, ${stats.error} erros`;

    // Atualizar estatísticas gerais
    if (typeof atualizarEstatisticas === 'function') {
        atualizarEstatisticas();
    }
}

// ════════════════════════════════════════════════════════════════
// LEITURA E ANÁLISE DE PDF
// ════════════════════════════════════════════════════════════════

async function processarPDF(file) {
    try {
        // Ler PDF com pdf.js
        const arrayBuffer = await file.arrayBuffer();
        const pdf = await pdfjsLib.getDocument(arrayBuffer).promise;

        let textoCompleto = '';

        // Extrair texto de todas as páginas
        for (let i = 1; i <= Math.min(pdf.numPages, 3); i++) { // Apenas 3 primeiras páginas
            const page = await pdf.getPage(i);
            const content = await page.getTextContent();
            textoCompleto += content.items.map(item => item.str).join(' ') + '\n';
        }

        console.log(`📄 TEXTO COMPLETO extraído de ${file.name}:`);
        console.log(`📄 Total de caracteres: ${textoCompleto.length}`);
        console.log(`📄 Primeiros 500 caracteres:`, textoCompleto.substring(0, 500));
        console.log(`📄 Texto completo (todas as páginas):`, textoCompleto);

        // ══════════════════════════════════════════════════════════
        // DETECTAR MÊS E ANO
        // ══════════════════════════════════════════════════════════
        let mesDetectado = null;
        let anoDetectado = null;
        
        // Padrões para detectar mês e ano
        const patternsMesAno = [
            /Folha\s+Mensal\s+(Janeiro|Fevereiro|Março|Abril|Maio|Junho|Julho|Agosto|Setembro|Outubro|Novembro|Dezembro)\s+de\s+(\d{4})/i,
            /(Janeiro|Fevereiro|Março|Abril|Maio|Junho|Julho|Agosto|Setembro|Outubro|Novembro|Dezembro)\s+de\s+(\d{4})/i,
            /(Janeiro|Fevereiro|Março|Abril|Maio|Junho|Julho|Agosto|Setembro|Outubro|Novembro|Dezembro)[\/\s]+(\d{4})/i,
            /(\d{2})[\/\-](\d{4})/  // Formato: 12/2025
        ];

        for (const regex of patternsMesAno) {
            const match = textoCompleto.match(regex);
            if (match) {
                if (match[1] && match[2]) {
                    // Se match[1] é um número (formato 12/2025)
                    if (/^\d+$/.test(match[1])) {
                        const mesNum = parseInt(match[1]);
                        const meses = ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 
                                      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'];
                        if (mesNum >= 1 && mesNum <= 12) {
                            mesDetectado = meses[mesNum - 1];
                        }
                    } else {
                        // Match[1] já é o nome do mês
                        mesDetectado = match[1].charAt(0).toUpperCase() + match[1].slice(1).toLowerCase();
                    }
                    anoDetectado = match[2];
                    console.log(`📅 Mês/Ano detectado: ${mesDetectado} de ${anoDetectado}`);
                    break;
                }
            }
        }

        // Se não detectou, usar padrões de fallback das configurações
        const anoFallback = document.getElementById('anoLote').value;
        if (!anoDetectado) {
            anoDetectado = anoFallback;
            console.log(`⚠️ Ano não detectado, usando padrão: ${anoDetectado}`);
        }

        // ══════════════════════════════════════════════════════════
        // DETECTAR TIPO DE DOCUMENTO
        // ══════════════════════════════════════════════════════════
        let tipoDocumento = null;
        
        // PRIORIDADE 1: Contracheque (mais específico)
        if (textoCompleto.match(/folha\s+mensal|contracheque|folha\s+de\s+pagamento|holerite/i)) {
            tipoDocumento = 'contracheque';
            console.log(`📄 Tipo detectado: Contracheque`);
        }
        // PRIORIDADE 2: Informe de IR (mais genérico)
        else if (textoCompleto.match(/informe\s+de\s+rendimentos/i) || 
                 textoCompleto.match(/declaração\s+do\s+imposto/i) ||
                 textoCompleto.match(/comprovante\s+de\s+rendimentos/i)) {
            tipoDocumento = 'informe_ir';
            console.log(`📄 Tipo detectado: Informe de IR`);
        } 
        // FALLBACK: Usar padrão das configurações
        else {
            tipoDocumento = document.getElementById('tipoDocumentoLote').value;
            console.log(`⚠️ Tipo não detectado, usando padrão: ${tipoDocumento === 'contracheque' ? 'Contracheque' : 'Informe de IR'}`);
        }

        // ══════════════════════════════════════════════════════════
        // DETECTAR CÓDIGO E NOME
        // ══════════════════════════════════════════════════════════

        // REGEX PATTERNS para identificar código e nome
        const patterns = {
            // Padrões para CÓDIGO (ajustado para seu formato de contracheque)
            codigo: [
                /CC:\s*(\d+)\s+Código/i, // "CC: 251  Código"
                /Código\s+(\d+)/i, // "Código 251"
                /código[\s:]+(\d+)/i,
                /matricula[\s:]+(\d+)/i,
                /matrícula[\s:]+(\d+)/i,
                /registro[\s:]+(\d+)/i
            ],
            // Padrões para NOME (ajustado para "Código ANDERSON SILVA DE JESUS Nome do Funcionário")
            nome: [
                /Código\s+([A-ZÁÉÍÓÚÀÂÊÔÃÕÇ]+(?:\s+[A-ZÁÉÍÓÚÀÂÊÔÃÕÇ]+)+)\s+Nome\s+do\s+Funcionário/i,
                /([A-ZÁÉÍÓÚÀÂÊÔÃÕÇ]{3,}(?:\s+[A-ZÁÉÍÓÚÀÂÊÔÃÕÇ]+){2,})\s+Nome\s+do\s+Funcionário/i,
                /(?:nome|funcionário|colaborador)[\s:]+([A-ZÁÉÍÓÚÀÂÊÔÃÕÇ\s]{10,50})(?:\s+CBO|CPF)/i
            ]
        };

        // Buscar código
        let codigoEncontrado = null;
        for (const regex of patterns.codigo) {
            const match = textoCompleto.match(regex);
            if (match) {
                codigoEncontrado = match[1].trim().toUpperCase();
                console.log(`🔍 Código encontrado (regex): "${codigoEncontrado}"`);
                // Limpar caracteres especiais
                codigoEncontrado = codigoEncontrado.replace(/[^\w\-]/g, '');
                if (codigoEncontrado.length >= 1 && codigoEncontrado.length <= 20) {
                    console.log(`✅ Código válido: "${codigoEncontrado}"`);
                    break;
                } else {
                    console.log(`❌ Código inválido (tamanho ${codigoEncontrado.length})`);
                    codigoEncontrado = null;
                }
            }
        }

        // Buscar nome
        let nomeEncontrado = null;
        for (const regex of patterns.nome) {
            const match = textoCompleto.match(regex);
            if (match) {
                nomeEncontrado = match[1].trim();
                // Limpar espaços múltiplos e normalizar
                nomeEncontrado = nomeEncontrado.replace(/\s+/g, ' ').trim();
                console.log(`🔍 Nome encontrado (regex): "${nomeEncontrado}"`);
                // Validar se parece um nome (ao menos 2 palavras)
                if (nomeEncontrado.split(/\s+/).length >= 2) {
                    console.log(`✅ Nome válido: "${nomeEncontrado}"`);
                    break;
                } else {
                    console.log(`❌ Nome inválido (apenas 1 palavra)`);
                    nomeEncontrado = null;
                }
            }
        }

        console.log(`📊 RESULTADO EXTRAÇÃO: Código="${codigoEncontrado}" | Nome="${nomeEncontrado}"`);

        // Resultados
        if (!codigoEncontrado && !nomeEncontrado) {
            return {
                success: false,
                warning: false,
                mensagem: 'Código e nome não encontrados no PDF'
            };
        }

        if (!codigoEncontrado) {
            return {
                success: false,
                warning: true,
                mensagem: `Nome: ${nomeEncontrado}, mas código não detectado`
            };
        }

        if (!nomeEncontrado) {
            return {
                success: false,
                warning: true,
                mensagem: `Código: ${codigoEncontrado}, mas nome não detectado`
            };
        }

        // Buscar colaborador no banco
        console.log('🔍 Buscando colaborador no banco com código:', codigoEncontrado);
        const colaborador = await buscarColaboradorPorCodigo(codigoEncontrado);
        console.log('📊 Resultado da busca:', colaborador);
        console.log('📋 Campos disponíveis:', colaborador ? Object.keys(colaborador) : 'nenhum');

        if (!colaborador) {
            console.log('❌ Colaborador não encontrado no banco para código:', codigoEncontrado);
            return {
                success: false,
                warning: true,
                mensagem: `Código ${codigoEncontrado} não encontrado no sistema`
            };
        }

        console.log('✅ Colaborador encontrado no banco:', colaborador.nome_completo || colaborador.nome, '(CPF:', colaborador.cpf + ')');

        // Validar se tem mês (para contracheques)
        if (tipoDocumento === 'contracheque' && !mesDetectado) {
            console.log('⚠️ Mês não detectado para contracheque');
            return {
                success: false,
                warning: true,
                mensagem: `Colaborador: ${colaborador.nome_completo}, mas mês não detectado no PDF`
            };
        }

        // SUCESSO - Tudo detectado
        console.log('✅ SUCESSO! Todos os dados detectados');
        console.log(`   📄 Tipo: ${tipoDocumento === 'contracheque' ? 'Contracheque' : 'Informe de IR'}`);
        console.log(`   📅 Período: ${mesDetectado || 'N/A'} de ${anoDetectado}`);
        console.log(`   👤 Colaborador: ${colaborador.nome_completo} (Código: ${codigoEncontrado})`);

        return {
            success: true,
            codigo: codigoEncontrado,
            nome: nomeEncontrado,
            mes: mesDetectado,
            ano: anoDetectado,
            tipo: tipoDocumento,
            colaborador: colaborador,
            arquivo: file
        };

    } catch (error) {
        console.error('Erro ao processar PDF:', error);
        return {
            success: false,
            warning: false,
            mensagem: `Erro ao processar: ${error.message}`
        };
    }
}

// Buscar colaborador por código
async function buscarColaboradorPorCodigo(codigo) {
    try {
        const { data, error } = await window.supabaseClient
            .from('colaboradores')
            .select('*')
            .eq('codigo_funcionario', codigo)
            .single();

        if (error) throw error;
        return data;
    } catch (error) {
        console.error('Erro ao buscar colaborador:', error);
        return null;
    }
}

// ════════════════════════════════════════════════════════════════
// UI - LOG E ESTATÍSTICAS
// ════════════════════════════════════════════════════════════════

function addLogLote(type, message) {
    const logContent = document.getElementById('logLoteContent');
    const div = document.createElement('div');
    div.className = `log-item-lote ${type}`;
    
    const icon = type === 'success' ? 'fa-check-circle' : 
                 type === 'warning' ? 'fa-exclamation-triangle' : 
                 'fa-times-circle';
    
    div.innerHTML = `<i class="fa-solid ${icon}"></i><span>${message}</span>`;
    logContent.insertBefore(div, logContent.firstChild);
}

function updateStatsLote(stats) {
    document.getElementById('statSuccessLote').textContent = stats.success;
    document.getElementById('statWarningLote').textContent = stats.warning;
    document.getElementById('statErrorLote').textContent = stats.error;
}

// ════════════════════════════════════════════════════════════════
// UPLOAD PARA SUPABASE STORAGE E BANCO DE DADOS
// ════════════════════════════════════════════════════════════════

async function uploadParaSupabase(file, dadosDetectados) {
    try {
        console.log('🚀 Iniciando upload para Supabase:', file.name);
        
        // 1. Preparar caminho com PASTA DO COLABORADOR (SEGURANÇA!)
        const colaboradorId = dadosDetectados.colaborador.id;
        const extensao = file.name.split('.').pop();
        const nomeArquivoSimples = `${dadosDetectados.tipo}_${dadosDetectados.mes || 'anual'}_${dadosDetectados.ano}.${extensao}`;
        const caminhoCompleto = `${colaboradorId}/${nomeArquivoSimples}`;
        
        console.log('� Pasta do colaborador:', colaboradorId);
        console.log('�📝 Nome do arquivo:', nomeArquivoSimples);
        console.log('🗂️ Caminho completo:', caminhoCompleto);

        // 2. Upload para Supabase Storage (dentro da pasta do colaborador)
        const { data: uploadData, error: uploadError } = await window.supabaseClient.storage
            .from('contracheques')
            .upload(caminhoCompleto, file, {
                cacheControl: '3600',
                upsert: true // Permite substituir se já existir (mesmo mês/ano/tipo)
            });

        if (uploadError) {
            console.error('❌ Erro no upload para Storage:', uploadError);
            return {
                success: false,
                mensagem: `Erro ao fazer upload: ${uploadError.message}`
            };
        }

        console.log('✅ Upload para Storage concluído:', uploadData);

        // 3. Obter URL pública do arquivo
        const { data: urlData } = window.supabaseClient.storage
            .from('contracheques')
            .getPublicUrl(caminhoCompleto);

        const arquivoUrl = urlData.publicUrl;
        console.log('🔗 URL pública gerada:', arquivoUrl);

        // 4. Verificar se documento já existe (mesmo colaborador, tipo, mês e ano)
        const { data: existente, error: checkError } = await window.supabaseClient
            .from('contracheques')
            .select('id')
            .eq('colaborador_id', dadosDetectados.colaborador.id)
            .eq('tipo_documento', dadosDetectados.tipo)
            .eq('ano', dadosDetectados.ano)
            .eq('mes_referencia', dadosDetectados.mes || null);

        if (checkError) {
            console.error('⚠️ Erro ao verificar duplicatas:', checkError);
            // Continuar mesmo com erro na verificação
        }

        if (existente && existente.length > 0) {
            console.log('⚠️ Documento duplicado encontrado, atualizando...');
            
            // Atualizar registro existente
            const { error: updateError } = await window.supabaseClient
                .from('contracheques')
                .update({
                    arquivo_url: arquivoUrl
                })
                .eq('id', existente[0].id);

            if (updateError) {
                console.error('❌ Erro ao atualizar registro:', updateError);
                return {
                    success: false,
                    mensagem: `Erro ao atualizar banco de dados: ${updateError.message}`
                };
            }

            console.log('✅ Registro atualizado com sucesso');
        } else {
            // 5. Inserir novo registro no banco de dados
            const { data: insertData, error: insertError } = await window.supabaseClient
                .from('contracheques')
                .insert([{
                    colaborador_id: dadosDetectados.colaborador.id,
                    tipo_documento: dadosDetectados.tipo,
                    mes_referencia: dadosDetectados.mes,
                    ano: dadosDetectados.ano,
                    arquivo_url: arquivoUrl,
                    nome_arquivo: dadosDetectados.arquivo.name,
                    tamanho_arquivo: dadosDetectados.arquivo.size,
                    recibo_gerado: false
                }])
                .select();

            if (insertError) {
                console.error('❌ Erro ao inserir no banco:', insertError);
                return {
                    success: false,
                    mensagem: `Erro ao salvar no banco de dados: ${insertError.message}`
                };
            }

            console.log('✅ Registro inserido no banco:', insertData);
        }

        // 6. Sucesso total!
        return {
            success: true,
            url: arquivoUrl,
            mensagem: 'Upload e registro concluídos com sucesso'
        };

    } catch (error) {
        console.error('❌ Erro geral no upload:', error);
        return {
            success: false,
            mensagem: `Erro inesperado: ${error.message}`
        };
    }
}

// ════════════════════════════════════════════════════════════════
// INICIALIZAR QUANDO PÁGINA CARREGAR
// ════════════════════════════════════════════════════════════════

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initUploadLote);
} else {
    initUploadLote();
}
