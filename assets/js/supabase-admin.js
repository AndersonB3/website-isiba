/**
 * Funções do Supabase para o Painel Admin
 * ISIBA Social - Sistema de Gestão de Contracheques
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

// ==================== AUTENTICAÇÃO DE ADMINISTRADOR ====================

/**
 * Autenticar administrador no banco de dados
 */
async function autenticarAdministrador(usuario, senha) {
    try {
        // Gerar hash da senha
        const senhaHash = await hashString(senha);
        
        // Buscar administrador no banco
        const { data, error } = await window.supabaseClient
            .from('administradores')
            .select('*')
            .eq('usuario', usuario)
            .eq('senha_hash', senhaHash)
            .eq('ativo', true)
            .single();
        
        if (error) {
            if (error.code === 'PGRST116') {
                // Nenhum registro encontrado
                throw new Error('Usuário ou senha incorretos');
            }
            throw error;
        }
        
        // Atualizar último acesso
        await window.supabaseClient
            .from('administradores')
            .update({ ultimo_acesso: new Date().toISOString() })
            .eq('id', data.id);
        
        console.log('✅ Administrador autenticado:', data.nome_completo);
        return { 
            success: true, 
            data: {
                id: data.id,
                usuario: data.usuario,
                nome_completo: data.nome_completo,
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

/**
 * Verificar se administrador existe
 */
async function verificarAdministrador(usuario) {
    try {
        const { data, error } = await window.supabaseClient
            .from('administradores')
            .select('usuario, ativo')
            .eq('usuario', usuario)
            .single();
        
        if (error) return { success: false, exists: false };
        
        return { 
            success: true, 
            exists: true, 
            ativo: data.ativo 
        };
        
    } catch (error) {
        return { success: false, exists: false };
    }
}

/**
 * Cadastrar novo administrador
 */
async function cadastrarAdministrador(dados) {
    try {
        // Gerar hash da senha
        const senhaHash = await hashString(dados.senha);
        
        // Verificar se usuário já existe
        const { data: existente } = await window.supabaseClient
            .from('administradores')
            .select('id')
            .eq('usuario', dados.usuario)
            .single();
        
        if (existente) {
            throw new Error('Usuário já existe no sistema');
        }
        
        // Inserir administrador
        const { data, error } = await window.supabaseClient
            .from('administradores')
            .insert([{
                usuario: dados.usuario,
                senha_hash: senhaHash,
                nome_completo: dados.nome,
                email: dados.email || null,
                ativo: true
            }])
            .select();
        
        if (error) throw error;
        
        console.log('✅ Administrador cadastrado:', data[0]);
        return { success: true, data: data[0] };
        
    } catch (error) {
        console.error('❌ Erro ao cadastrar administrador:', error);
        return { success: false, error: error.message };
    }
}

// ==================== COLABORADORES ====================

/**
 * Cadastrar novo colaborador
 */
async function cadastrarColaborador(dados) {
    try {
        // Remover formatação do CPF
        const cpfLimpo = dados.cpf.replace(/\D/g, '');
        
        // Gerar hashes
        const cpfHash = await hashString(cpfLimpo);
        const senhaHash = await hashString(dados.senha);
        
        // Verificar se CPF já existe
        const { data: existente, error: errorCheck } = await window.supabaseClient
            .from('colaboradores')
            .select('id')
            .eq('cpf', cpfLimpo)
            .single();
        
        if (existente) {
            throw new Error('CPF já cadastrado no sistema');
        }
        
        // Inserir colaborador
        const { data, error } = await window.supabaseClient
            .from('colaboradores')
            .insert([{
                nome_completo: dados.nome,
                cpf: cpfLimpo,
                cpf_hash: cpfHash,
                senha_hash: senhaHash,
                email: dados.email || null,
                ativo: dados.status === 'ativo'
            }])
            .select();
        
        if (error) throw error;
        
        console.log('✅ Colaborador cadastrado:', data[0]);
        return { success: true, data: data[0] };
        
    } catch (error) {
        console.error('❌ Erro ao cadastrar colaborador:', error);
        return { success: false, error: error.message };
    }
}

/**
 * Listar todos os colaboradores
 */
async function listarColaboradores(filtro = '') {
    try {
        let query = window.supabaseClient
            .from('colaboradores')
            .select('*')
            .order('nome_completo', { ascending: true });
        
        if (filtro) {
            query = query.or(`nome_completo.ilike.%${filtro}%,cpf.ilike.%${filtro}%`);
        }
        
        const { data, error } = await query;
        
        if (error) throw error;
        
        console.log(`✅ ${data.length} colaboradores encontrados`);
        return { success: true, data };
        
    } catch (error) {
        console.error('❌ Erro ao listar colaboradores:', error);
        return { success: false, error: error.message };
    }
}

/**
 * Buscar colaborador por ID
 */
async function buscarColaborador(id) {
    try {
        const { data, error } = await window.supabaseClient
            .from('colaboradores')
            .select('*')
            .eq('id', id)
            .single();
        
        if (error) throw error;
        
        return { success: true, data };
        
    } catch (error) {
        console.error('❌ Erro ao buscar colaborador:', error);
        return { success: false, error: error.message };
    }
}

/**
 * Atualizar colaborador
 */
async function atualizarColaborador(id, dados) {
    try {
        const updateData = {
            nome_completo: dados.nome,
            email: dados.email || null,
            ativo: dados.status === 'ativo'
        };
        
        // Se houver nova senha, atualizar hash
        if (dados.senha) {
            updateData.senha_hash = await hashString(dados.senha);
        }
        
        const { data, error } = await window.supabaseClient
            .from('colaboradores')
            .update(updateData)
            .eq('id', id)
            .select();
        
        if (error) throw error;
        
        console.log('✅ Colaborador atualizado:', data[0]);
        return { success: true, data: data[0] };
        
    } catch (error) {
        console.error('❌ Erro ao atualizar colaborador:', error);
        return { success: false, error: error.message };
    }
}

/**
 * Deletar colaborador
 */
async function deletarColaborador(id) {
    try {
        const { error } = await window.supabaseClient
            .from('colaboradores')
            .delete()
            .eq('id', id);
        
        if (error) throw error;
        
        console.log('✅ Colaborador deletado');
        return { success: true };
        
    } catch (error) {
        console.error('❌ Erro ao deletar colaborador:', error);
        return { success: false, error: error.message };
    }
}

// ==================== CONTRACHEQUES ====================

/**
 * Upload de contracheque (PDF)
 */
async function uploadContracheque(colaboradorId, mes, ano, arquivo) {
    try {
        // Buscar dados do colaborador
        const { data: colaborador, error: errorColab } = await window.supabaseClient
            .from('colaboradores')
            .select('cpf, nome_completo')
            .eq('id', colaboradorId)
            .single();
        
        if (errorColab) throw errorColab;
        
        // Gerar nome do arquivo: CPF/AAAA-MM.pdf
        const mesNumero = obterNumeroMes(mes);
        const fileName = `${colaborador.cpf}/${ano}-${mesNumero}.pdf`;
        
        // Upload do arquivo para o Storage
        const { data: uploadData, error: uploadError } = await window.supabaseClient
            .storage
            .from(window.CONFIG.bucket)
            .upload(fileName, arquivo, {
                cacheControl: '3600',
                upsert: true // Sobrescrever se já existir
            });
        
        if (uploadError) throw uploadError;
        
        // Verificar se já existe um contracheque para este período
        const { data: existente } = await window.supabaseClient
            .from('contracheques')
            .select('id')
            .eq('colaborador_id', colaboradorId)
            .eq('mes_referencia', mes)
            .eq('ano', parseInt(ano))
            .single();
        
        let dbData;
        
        if (existente) {
            // Atualizar contracheque existente
            const { data, error: dbError } = await window.supabaseClient
                .from('contracheques')
                .update({
                    arquivo_url: fileName,
                    nome_arquivo: arquivo.name,
                    tamanho_arquivo: arquivo.size,
                    enviado_por: window.CONFIG.adminUser,
                    enviado_em: new Date().toISOString()
                })
                .eq('id', existente.id)
                .select();
            
            if (dbError) throw dbError;
            dbData = data[0];
            console.log('✅ Contracheque atualizado:', dbData);
        } else {
            // Inserir novo contracheque
            const { data, error: dbError } = await window.supabaseClient
                .from('contracheques')
                .insert([{
                    colaborador_id: colaboradorId,
                    mes_referencia: mes,
                    ano: parseInt(ano),
                    arquivo_url: fileName,
                    nome_arquivo: arquivo.name,
                    tamanho_arquivo: arquivo.size,
                    enviado_por: window.CONFIG.adminUser
                }])
                .select();
            
            if (dbError) throw dbError;
            dbData = data[0];
            console.log('✅ Contracheque enviado:', dbData);
        }
        
        return { 
            success: true, 
            data: dbData, 
            updated: !!existente // Indica se foi atualização
        };
        
    } catch (error) {
        console.error('❌ Erro ao enviar contracheque:', error);
        return { success: false, error: error.message };
    }
}

/**
 * Listar histórico de contracheques
 */
async function listarHistorico(filtroMes = '') {
    try {
        let query = window.supabaseClient
            .from('contracheques')
            .select(`
                *,
                colaboradores (
                    nome_completo,
                    cpf
                )
            `)
            .order('enviado_em', { ascending: false });
        
        if (filtroMes) {
            query = query.eq('mes_referencia', filtroMes);
        }
        
        const { data, error } = await query;
        
        if (error) throw error;
        
        console.log(`✅ ${data.length} contracheques encontrados`);
        return { success: true, data };
        
    } catch (error) {
        console.error('❌ Erro ao listar histórico:', error);
        return { success: false, error: error.message };
    }
}

/**
 * Buscar contracheques de um colaborador
 */
async function buscarContracheques(colaboradorId) {
    try {
        const { data, error } = await window.supabaseClient
            .from('contracheques')
            .select('*')
            .eq('colaborador_id', colaboradorId)
            .order('ano', { ascending: false })
            .order('mes_referencia', { ascending: false });
        
        if (error) throw error;
        
        return { success: true, data };
        
    } catch (error) {
        console.error('❌ Erro ao buscar contracheques:', error);
        return { success: false, error: error.message };
    }
}

/**
 * Download de contracheque (gera URL assinada)
 */
async function downloadContracheque(arquivoUrl) {
    try {
        const { data, error } = await window.supabaseClient
            .storage
            .from(window.CONFIG.bucket)
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
 * Deletar contracheque
 */
async function deletarContracheque(id, arquivoUrl) {
    try {
        // Deletar arquivo do Storage
        const { error: storageError } = await window.supabaseClient
            .storage
            .from(window.CONFIG.bucket)
            .remove([arquivoUrl]);
        
        if (storageError) console.warn('⚠️ Erro ao deletar arquivo:', storageError);
        
        // Deletar registro do banco
        const { error: dbError } = await window.supabaseClient
            .from('contracheques')
            .delete()
            .eq('id', id);
        
        if (dbError) throw dbError;
        
        console.log('✅ Contracheque deletado');
        return { success: true };
        
    } catch (error) {
        console.error('❌ Erro ao deletar contracheque:', error);
        return { success: false, error: error.message };
    }
}

// ==================== ESTATÍSTICAS ====================

/**
 * Obter estatísticas do dashboard
 */
async function obterEstatisticas() {
    try {
        // Total de colaboradores ativos
        const { count: totalAtivos, error: errorAtivos } = await window.supabaseClient
            .from('colaboradores')
            .select('*', { count: 'exact', head: true })
            .eq('ativo', true);
        
        if (errorAtivos) throw errorAtivos;
        
        // Total de contracheques
        const { count: totalContracheques, error: errorTotal } = await window.supabaseClient
            .from('contracheques')
            .select('*', { count: 'exact', head: true });
        
        if (errorTotal) throw errorTotal;
        
        // Envios este mês
        const mesAtual = new Date().getMonth() + 1;
        const anoAtual = new Date().getFullYear();
        const { count: enviosMes, error: errorMes } = await window.supabaseClient
            .from('contracheques')
            .select('*', { count: 'exact', head: true })
            .eq('ano', anoAtual)
            .eq('mes_referencia', obterNomeMes(mesAtual));
        
        if (errorMes) throw errorMes;
        
        // Último envio
        const { data: ultimoEnvio, error: errorUltimo } = await window.supabaseClient
            .from('contracheques')
            .select('enviado_em')
            .order('enviado_em', { ascending: false })
            .limit(1)
            .single();
        
        return {
            success: true,
            data: {
                totalFuncionarios: totalAtivos || 0,
                totalContracheques: totalContracheques || 0,
                enviosMes: enviosMes || 0,
                ultimoEnvio: ultimoEnvio ? new Date(ultimoEnvio.enviado_em) : null
            }
        };
        
    } catch (error) {
        console.error('❌ Erro ao obter estatísticas:', error);
        return { 
            success: false, 
            data: {
                totalFuncionarios: 0,
                totalContracheques: 0,
                enviosMes: 0,
                ultimoEnvio: null
            }
        };
    }
}

// ==================== FUNÇÕES AUXILIARES ====================

/**
 * Converter nome do mês para número (01-12)
 */
function obterNumeroMes(nomeMes) {
    const meses = {
        'Janeiro': '01', 'Fevereiro': '02', 'Março': '03', 'Abril': '04',
        'Maio': '05', 'Junho': '06', 'Julho': '07', 'Agosto': '08',
        'Setembro': '09', 'Outubro': '10', 'Novembro': '11', 'Dezembro': '12'
    };
    return meses[nomeMes] || '01';
}

/**
 * Converter número do mês para nome
 */
function obterNomeMes(numeroMes) {
    const meses = [
        'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
        'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return meses[numeroMes - 1] || 'Janeiro';
}

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
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
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

console.log('✅ Funções do Supabase Admin carregadas!');


