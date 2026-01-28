/*=============== DATABASE FUNCTIONS ===============*/

/**
 * Busca estatísticas ativas do banco de dados
 * @returns {Promise<Object|null>} Objeto com as estatísticas ou null em caso de erro
 */
async function fetchStatistics() {
    try {
        console.log('🔄 Buscando estatísticas do banco de dados...');
        
        // Buscar o registro ativo mais recente
        const { data, error } = await window.supabaseClient
            .from('statistics')
            .select('*')
            .eq('ativo', true)
            .order('ano', { ascending: false })
            .order('created_at', { ascending: false })
            .limit(1)
            .single();

        if (error) {
            console.error('❌ Erro ao buscar estatísticas:', error);
            return null;
        }

        if (!data) {
            console.warn('⚠️ Nenhuma estatística ativa encontrada');
            return null;
        }

        console.log('✅ Estatísticas carregadas:', data);
        return data;

    } catch (error) {
        console.error('❌ Erro inesperado:', error);
        return null;
    }
}

/**
 * Atualiza os números das estatísticas na página
 * @param {Object} stats - Objeto com as estatísticas
 */
function updateStatisticsUI(stats) {
    if (!stats) {
        console.warn('⚠️ Usando valores padrão (banco não configurado)');
        return;
    }

    // Selecionar todos os elementos de estatística
    const statElements = document.querySelectorAll('.stat__number');
    
    if (statElements.length !== 4) {
        console.error('❌ Erro: Número incorreto de elementos de estatística');
        return;
    }

    // Atualizar cada estatística
    const statsArray = [
        stats.atendimentos,
        stats.unidades,
        stats.profissionais,
        stats.satisfacao
    ];

    statElements.forEach((element, index) => {
        const newValue = statsArray[index];
        element.setAttribute('data-target', newValue);
        element.textContent = '0'; // Resetar para animação funcionar
    });

    console.log('✅ Interface atualizada com dados do banco!');
    
    // Reiniciar animação dos contadores
    if (typeof animateCounter === 'function') {
        animateCounter();
    }
}

/**
 * Inicializar sistema de estatísticas
 * Carrega dados do banco e atualiza a interface
 */
async function initializeStatistics() {
    console.log('🚀 Inicializando sistema de estatísticas...');
    
    // Verificar se Supabase está disponível
    if (typeof window.supabaseClient === 'undefined') {
        console.error('❌ Supabase não está carregado! Verifique o script no HTML.');
        return;
    }

    // Buscar e atualizar estatísticas
    const stats = await fetchStatistics();
    
    if (stats) {
        updateStatisticsUI(stats);
        console.log('✨ Sistema de estatísticas inicializado com sucesso!');
    } else {
        console.log('📊 Usando valores padrão do HTML');
    }
}

/**
 * Atualizar estatísticas em tempo real
 * Configura listener para mudanças no banco
 */
function setupRealtimeUpdates() {
    console.log('🔄 Configurando atualizações em tempo real...');
    
    // Criar subscription para mudanças na tabela
    const subscription = window.supabaseClient
        .channel('statistics-changes')
        .on(
            'postgres_changes',
            {
                event: '*', // INSERT, UPDATE, DELETE
                schema: 'public',
                table: 'statistics',
                filter: 'ativo=eq.true'
            },
            (payload) => {
                console.log('🔔 Dados atualizados no banco:', payload);
                
                if (payload.new && payload.new.ativo) {
                    updateStatisticsUI(payload.new);
                }
            }
        )
        .subscribe();

    console.log('✅ Atualizações em tempo real ativadas!');
}

// Inicializar quando o DOM estiver pronto
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        initializeStatistics();
        setupRealtimeUpdates();
    });
} else {
    initializeStatistics();
    setupRealtimeUpdates();
}
