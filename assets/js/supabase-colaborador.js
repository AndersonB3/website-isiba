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
        return { 
            success: true, 
            data: {
                id: data.id,
                nome: data.nome_completo,
                cpf: data.cpf,
                email: data.email
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
        const { data, error } = await window.supabaseClient
            .storage
            .from('contracheques')
            .createSignedUrl(arquivoUrl, 60); // URL válida por 60 segundos
        
        if (error) throw error;
        
        console.log('✅ URL de download gerada');
        return { success: true, url: data.signedUrl };
        
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
