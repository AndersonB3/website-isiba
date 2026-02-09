/**
 * Funções do Supabase para o Portal do Colaborador
 * ISIBA - Sistema de Gestão de Contracheques
 */

// Verificar se o Supabase foi inicializado
if (!window.supabaseClient) {
    console.error('❌ Supabase não foi inicializado! Verifique se supabase-config.js foi carregado.');
}

// ==================== FUNÇÕES DE HASH ====================

/**
 * Gera hash SHA-256 de uma string
 */
async function hashString(str) {
    const encoder = new TextEncoder();
    const data = encoder.encode(str);
    const hashBuffer = await crypto.subtle.digest('SHA-256', data);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
    return hashHex;
}

// ==================== AUTENTICAÇÃO ====================

/**
 * Autenticar colaborador
 */
async function autenticarColaborador(cpf, senha) {
    try {
        console.log('🔍 [DEBUG] Iniciando autenticação...');
        
        // Remover formatação do CPF
        const cpfLimpo = cpf.replace(/\D/g, '');
        console.log('🔍 [DEBUG] CPF limpo:', cpfLimpo);
        
        // Gerar hash da senha
        const senhaHash = await hashString(senha);
        console.log('🔍 [DEBUG] Hash da senha gerado:', senhaHash);
        
        console.log('🔍 [DEBUG] Buscando no banco com:', {
            cpf: cpfLimpo,
            senha_hash: senhaHash,
            ativo: true
        });
        
        // Buscar colaborador no banco
        const { data, error } = await window.supabaseClient
            .from('colaboradores')
            .select('*')
            .eq('cpf', cpfLimpo)
            .eq('senha_hash', senhaHash)
            .eq('ativo', true)
            .single();
        
        console.log('🔍 [DEBUG] Resposta do Supabase:', { data, error });
        
        if (error) {
            console.error('❌ [DEBUG] Erro do Supabase:', error);
            if (error.code === 'PGRST116') {
                // Vamos fazer uma busca separada para ver o que está no banco
                console.log('🔍 [DEBUG] Tentando buscar apenas por CPF...');
                const { data: colaboradorPorCPF, error: erroCPF } = await window.supabaseClient
                    .from('colaboradores')
                    .select('id, nome_completo, cpf, ativo, senha_hash')
                    .eq('cpf', cpfLimpo)
                    .single();
                
                if (!erroCPF && colaboradorPorCPF) {
                    console.log('🔍 [DEBUG] Colaborador encontrado por CPF:', {
                        nome: colaboradorPorCPF.nome_completo,
                        cpf: colaboradorPorCPF.cpf,
                        ativo: colaboradorPorCPF.ativo,
                        senha_hash_no_banco: colaboradorPorCPF.senha_hash,
                        senha_hash_tentando: senhaHash,
                        hashes_coincidem: colaboradorPorCPF.senha_hash === senhaHash
                    });
                    
                    if (!colaboradorPorCPF.ativo) {
                        throw new Error('Usuário inativo. Entre em contato com o RH.');
                    }
                    if (colaboradorPorCPF.senha_hash !== senhaHash) {
                        throw new Error('Senha incorreta');
                    }
                } else {
                    console.log('❌ [DEBUG] CPF não encontrado no banco');
                }
                
                throw new Error('CPF ou senha incorretos');
            }
            throw error;
        }
        
        console.log('✅ Colaborador autenticado:', data.nome_completo);
        console.log('🔍 [DEBUG] primeiro_acesso:', data.primeiro_acesso);
        return { 
            success: true, 
            data: {
                id: data.id,
                nome: data.nome_completo,
                cpf: data.cpf,
                email: data.email,
                primeiro_acesso: data.primeiro_acesso || false
            }
        };
        
    } catch (error) {
        console.error('❌ Erro na autenticação:', error);
        return { 
            success: false, 
            error: error.message || 'Erro ao autenticar' 
        };
    }
}

// ==================== CONTRACHEQUES ====================

/**
 * Buscar contracheques do colaborador
 */
async function buscarMeusContracheques(colaboradorId) {
    try {
        const { data, error } = await window.supabaseClient
            .from('contracheques')
            .select('*')
            .eq('colaborador_id', colaboradorId)
            .order('ano', { ascending: false })
            .order('mes_referencia', { ascending: false });
        
        if (error) throw error;
        
        console.log(`✅ ${data.length} contracheques encontrados`);
        return { success: true, data };
        
    } catch (error) {
        console.error('❌ Erro ao buscar contracheques:', error);
        return { success: false, error: error.message };
    }
}

/**
 * Download de contracheque (gera URL assinada)
 */
async function downloadMeuContracheque(arquivoUrl) {
    try {
        // O arquivo_url do banco já contém o caminho correto dentro do bucket
        // Ex: "2026/01/08676044503_2026_01_contracheque.pdf"
        // ou "UUID/contracheque_Dezembro_2025.pdf" (formato antigo)
        let caminhoArquivo = arquivoUrl;
        
        // Se for URL completa (https://...), extrair apenas o caminho relativo
        if (arquivoUrl.includes('/contracheques/')) {
            const partes = arquivoUrl.split('/contracheques/');
            caminhoArquivo = partes[1];
        }
        
        console.log('🔍 Caminho do arquivo no Storage:', caminhoArquivo);
        
        const { data, error } = await window.supabaseClient
            .storage
            .from(window.CONFIG.bucket)
            .createSignedUrl(caminhoArquivo, 60); // URL válida por 60 segundos
        
        if (error) throw error;
        
        if (!data) {
            throw new Error('Resposta vazia do Supabase Storage');
        }
        
        // Tentar diferentes formatos de retorno
        const url = data.signedUrl || data.signedURL || data.url;
        
        if (!url) {
            throw new Error('URL não encontrada na resposta. Verifique se o arquivo existe no bucket.');
        }
        
        console.log('✅ URL de download gerada com sucesso');
        return { success: true, url };
        
    } catch (error) {
        console.error('❌ Erro ao gerar URL de download:', error);
        return { success: false, error: error.message };
    }
}

/**
 * Obter estatísticas do colaborador
 */
async function obterMinhasEstatisticas(colaboradorId) {
    try {
        // Total de contracheques
        const { count: total, error: errorTotal } = await window.supabaseClient
            .from('contracheques')
            .select('*', { count: 'exact', head: true })
            .eq('colaborador_id', colaboradorId);
        
        if (errorTotal) throw errorTotal;
        
        // Último contracheque
        const { data: ultimo, error: errorUltimo } = await window.supabaseClient
            .from('contracheques')
            .select('mes_referencia, ano, enviado_em')
            .eq('colaborador_id', colaboradorId)
            .order('ano', { ascending: false })
            .order('mes_referencia', { ascending: false })
            .limit(1)
            .single();
        
        return {
            success: true,
            data: {
                total: total || 0,
                ultimoMes: ultimo ? ultimo.mes_referencia : null,
                ultimoAno: ultimo ? ultimo.ano : null,
                ultimaData: ultimo ? new Date(ultimo.enviado_em) : null
            }
        };
        
    } catch (error) {
        console.error('❌ Erro ao obter estatísticas:', error);
        return { 
            success: false, 
            data: {
                total: 0,
                ultimoMes: null,
                ultimoAno: null,
                ultimaData: null
            }
        };
    }
}

/**
 * Buscar todos os documentos do colaborador (contracheques + informes)
 */
async function buscarMeusDocumentos(colaboradorId) {
    try {
        const { data, error } = await window.supabaseClient
            .from('contracheques')
            .select('*')
            .eq('colaborador_id', colaboradorId)
            .order('ano', { ascending: false })
            .order('tipo_documento', { ascending: true })
            .order('mes_referencia', { ascending: false });
        
        if (error) throw error;
        
        console.log(`✅ ${data.length} documentos encontrados`);
        return { success: true, data };
        
    } catch (error) {
        console.error('❌ Erro ao buscar documentos:', error);
        return { success: false, error: error.message };
    }
}

/**
 * Obter estatísticas completas do colaborador (contracheques + informes)
 */
async function obterMinhasEstatisticasCompletas(colaboradorId) {
    try {
        // Total de contracheques
        const { count: totalContracheques, error: errorContracheques } = await window.supabaseClient
            .from('contracheques')
            .select('*', { count: 'exact', head: true })
            .eq('colaborador_id', colaboradorId)
            .eq('tipo_documento', 'contracheque');
        
        if (errorContracheques) throw errorContracheques;
        
        // Total de informes
        const { count: totalInformes, error: errorInformes } = await window.supabaseClient
            .from('contracheques')
            .select('*', { count: 'exact', head: true })
            .eq('colaborador_id', colaboradorId)
            .eq('tipo_documento', 'informe_ir');
        
        if (errorInformes) throw errorInformes;
        
        // Último documento
        const { data: ultimoDoc, error: errorUltimo } = await window.supabaseClient
            .from('contracheques')
            .select('*')
            .eq('colaborador_id', colaboradorId)
            .order('enviado_em', { ascending: false })
            .limit(1)
            .single();
        
        return {
            success: true,
            data: {
                totalContracheques: totalContracheques || 0,
                totalInformes: totalInformes || 0,
                total: (totalContracheques || 0) + (totalInformes || 0),
                ultimoDocumento: ultimoDoc || null
            }
        };
        
    } catch (error) {
        console.error('❌ Erro ao obter estatísticas completas:', error);
        return { 
            success: false, 
            data: {
                totalContracheques: 0,
                totalInformes: 0,
                total: 0,
                ultimoDocumento: null
            }
        };
    }
}

// ==================== FUNÇÕES AUXILIARES ====================

/**
 * Formatar CPF (XXX.XXX.XXX-XX)
 */
function formatarCPF(cpf) {
    return cpf.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4');
}

/**
 * Formatar data para exibição
 */
function formatarData(data) {
    return new Date(data).toLocaleString('pt-BR', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric'
    });
}

/**
 * Formatar tamanho de arquivo
 */
function formatarTamanho(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
}

/**
 * Obter nome do mês por extenso
 */
function obterNomeMes(mes) {
    const meses = {
        'Janeiro': 'Janeiro', 'Fevereiro': 'Fevereiro', 'Março': 'Março',
        'Abril': 'Abril', 'Maio': 'Maio', 'Junho': 'Junho',
        'Julho': 'Julho', 'Agosto': 'Agosto', 'Setembro': 'Setembro',
        'Outubro': 'Outubro', 'Novembro': 'Novembro', 'Dezembro': 'Dezembro'
    };
    return meses[mes] || mes;
}

console.log('✅ Funções do Supabase Colaborador carregadas!');
