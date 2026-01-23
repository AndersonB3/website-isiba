/*=============== RELATÓRIO - DATABASE FUNCTIONS ===============*/

/**
 * Busca todas as unidades (UPAs) do banco de dados
 * @returns {Promise<Array|null>} Array com as unidades ou null em caso de erro
 */
async function fetchUnidades() {
    try {
        console.log('🔄 Buscando unidades do banco de dados...');
        
        const { data, error } = await window.supabaseClient
            .from('unidades')
            .select('*')
            .eq('ativo', true)
            .order('nome', { ascending: true });

        if (error) {
            console.error('❌ Erro ao buscar unidades:', error);
            return null;
        }

        console.log('✅ Unidades carregadas:', data);
        return data;

    } catch (error) {
        console.error('❌ Erro inesperado:', error);
        return null;
    }
}

/**
 * Busca dados de atendimentos de uma unidade específica
 * @param {string} unidadeId - ID da unidade
 * @param {Date} dataInicio - Data inicial do período
 * @param {Date} dataFim - Data final do período
 * @returns {Promise<Object|null>} Dados agregados ou null em caso de erro
 */
async function fetchAtendimentos(unidadeId, dataInicio, dataFim) {
    try {
        console.log('🔄 Buscando atendimentos...', { unidadeId, dataInicio, dataFim });
        
        const { data, error } = await window.supabaseClient
            .from('atendimentos')
            .select('*')
            .eq('unidade_id', unidadeId)
            .gte('data', dataInicio.toISOString().split('T')[0])
            .lte('data', dataFim.toISOString().split('T')[0])
            .order('data', { ascending: true });

        if (error) {
            console.error('❌ Erro ao buscar atendimentos:', error);
            return null;
        }

        console.log('✅ Atendimentos carregados:', data?.length || 0, 'registros');
        return data;

    } catch (error) {
        console.error('❌ Erro inesperado:', error);
        return null;
    }
}

/**
 * Busca dados mensais de uma unidade para os gráficos
 * @param {string} unidadeId - ID da unidade
 * @param {number} ano - Ano dos dados
 * @returns {Promise<Object|null>} Dados mensais ou null em caso de erro
 */
async function fetchDadosMensais(unidadeId, ano) {
    try {
        console.log('🔄 Buscando dados mensais...', { unidadeId, ano });
        
        const { data, error } = await window.supabaseClient
            .from('dados_mensais')
            .select('*')
            .eq('unidade_id', unidadeId)
            .eq('ano', ano)
            .order('mes', { ascending: true });

        if (error) {
            console.error('❌ Erro ao buscar dados mensais:', error);
            return null;
        }

        console.log('✅ Dados mensais carregados:', data);
        return data;

    } catch (error) {
        console.error('❌ Erro inesperado:', error);
        return null;
    }
}

/**
 * Busca dados de faixa etária de uma unidade
 * @param {string} unidadeId - ID da unidade
 * @param {number} ano - Ano dos dados
 * @returns {Promise<Object|null>} Dados de faixa etária ou null em caso de erro
 */
async function fetchFaixaEtaria(unidadeId, ano) {
    try {
        console.log('🔄 Buscando dados de faixa etária...', { unidadeId, ano });
        
        const { data, error } = await window.supabaseClient
            .from('faixa_etaria')
            .select('*')
            .eq('unidade_id', unidadeId)
            .eq('ano', ano)
            .order('ordem', { ascending: true });

        if (error) {
            console.error('❌ Erro ao buscar faixa etária:', error);
            return null;
        }

        console.log('✅ Dados de faixa etária carregados:', data);
        return data;

    } catch (error) {
        console.error('❌ Erro inesperado:', error);
        return null;
    }
}

/**
 * Busca tempo médio de atendimento por classificação
 * @param {string} unidadeId - ID da unidade
 * @param {number} ano - Ano dos dados
 * @returns {Promise<Object|null>} Dados de tempo médio ou null em caso de erro
 */
async function fetchTempoMedio(unidadeId, ano) {
    try {
        console.log('🔄 Buscando tempo médio de atendimento...', { unidadeId, ano });
        
        const { data, error } = await window.supabaseClient
            .from('tempo_atendimento')
            .select('*')
            .eq('unidade_id', unidadeId)
            .eq('ano', ano);

        if (error) {
            console.error('❌ Erro ao buscar tempo médio:', error);
            return null;
        }

        console.log('✅ Dados de tempo médio carregados:', data);
        return data;

    } catch (error) {
        console.error('❌ Erro inesperado:', error);
        return null;
    }
}

/**
 * Busca resumo anual de uma unidade
 * @param {string} unidadeId - ID da unidade
 * @param {number} ano - Ano dos dados
 * @returns {Promise<Object|null>} Resumo anual ou null em caso de erro
 */
async function fetchResumoAnual(unidadeId, ano) {
    try {
        console.log('🔄 Buscando resumo anual...', { unidadeId, ano });
        
        const { data, error } = await window.supabaseClient
            .from('resumo_anual')
            .select('*')
            .eq('unidade_id', unidadeId)
            .eq('ano', ano)
            .single();

        if (error && error.code !== 'PGRST116') { // PGRST116 = no rows returned
            console.error('❌ Erro ao buscar resumo anual:', error);
            return null;
        }

        console.log('✅ Resumo anual carregado:', data);
        return data;

    } catch (error) {
        console.error('❌ Erro inesperado:', error);
        return null;
    }
}

/**
 * Carrega todos os dados de relatório para uma unidade e ano
 * @param {string} unidadeId - ID da unidade
 * @param {number} ano - Ano dos dados
 * @returns {Promise<Object|null>} Todos os dados agregados
 */
async function carregarDadosRelatorio(unidadeId, ano) {
    try {
        console.log('🚀 Carregando todos os dados do relatório...', { unidadeId, ano });

        // Carregar todos os dados em paralelo
        const [resumo, mensais, faixaEtaria, tempoMedio] = await Promise.all([
            fetchResumoAnual(unidadeId, ano),
            fetchDadosMensais(unidadeId, ano),
            fetchFaixaEtaria(unidadeId, ano),
            fetchTempoMedio(unidadeId, ano)
        ]);

        // Estruturar dados no formato esperado
        const dados = {
            totalAtendimentos: resumo?.total_atendimentos || 0,
            satisfacaoMedia: resumo?.satisfacao_media || 0,
            maiorVolume: {
                mes: resumo?.maior_volume_mes || '-',
                valor: resumo?.maior_volume_valor || 0
            },
            maiorSatisfacao: {
                mes: resumo?.maior_satisfacao_mes || '-',
                valor: resumo?.maior_satisfacao_valor || 0
            },
            atendimentosMensais: mensais?.map(m => m.atendimentos) || Array(12).fill(0),
            satisfacaoMensal: mensais?.map(m => m.satisfacao) || Array(12).fill(0),
            faixaEtaria: {
                labels: faixaEtaria?.map(f => f.faixa) || [],
                valores: faixaEtaria?.map(f => f.quantidade) || []
            },
            tempoMedio: {
                labels: tempoMedio?.map(t => t.classificacao) || [],
                valores: tempoMedio?.map(t => t.tempo_minutos) || []
            }
        };

        console.log('✅ Dados do relatório estruturados:', dados);
        return dados;

    } catch (error) {
        console.error('❌ Erro ao carregar dados do relatório:', error);
        return null;
    }
}

/**
 * Verifica se o banco de dados está configurado e acessível
 * @returns {Promise<boolean>} True se o banco está acessível
 */
async function verificarConexaoBanco() {
    try {
        if (typeof window.supabaseClient === 'undefined') {
            console.warn('⚠️ Supabase não está carregado');
            return false;
        }

        // Tentar uma consulta simples
        const { data, error } = await window.supabaseClient
            .from('unidades')
            .select('id')
            .limit(1);

        if (error) {
            console.warn('⚠️ Banco não acessível:', error.message);
            return false;
        }

        console.log('✅ Conexão com banco estabelecida');
        return true;

    } catch (error) {
        console.warn('⚠️ Erro ao verificar conexão:', error);
        return false;
    }
}
