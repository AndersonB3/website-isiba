/*=============== RELATÓRIO - JAVASCRIPT ===============*/

// Flag para indicar se está usando dados do banco
let usandoBancoDeDados = false;

// Dados fictícios para as duas UPAs (fallback quando banco não disponível)
const dadosUPAs = {
    'gleba-a': {
        nome: 'UPA Gleba A',
        totalAtendimentos: 45892,
        satisfacaoMedia: 94.5,
        maiorVolume: { mes: 'Março', valor: 4521 },
        maiorSatisfacao: { mes: 'Setembro', valor: 97.2 },
        atendimentosMensais: [3845, 3654, 4521, 4102, 3987, 4234, 4012, 3876, 3945, 4087, 3798, 3831],
        satisfacaoMensal: [92.1, 93.5, 94.2, 95.1, 93.8, 94.5, 95.3, 94.8, 97.2, 96.1, 95.4, 94.5],
        faixaEtaria: {
            labels: ['0-12 anos', '13-17 anos', '18-29 anos', '30-44 anos', '45-59 anos', '60+ anos'],
            valores: [8234, 3102, 12456, 10234, 7654, 4212]
        },
        tempoMedio: {
            labels: ['Pouco Urgente', 'Não Urgente', 'Eletivo'],
            valores: [15, 28, 45]
        }
    },
    'lucas-evangelista': {
        nome: 'UPA Lucas Evangelista',
        totalAtendimentos: 38457,
        satisfacaoMedia: 92.8,
        maiorVolume: { mes: 'Janeiro', valor: 3876 },
        maiorSatisfacao: { mes: 'Novembro', valor: 96.5 },
        atendimentosMensais: [3876, 3234, 3456, 3102, 3287, 3134, 3212, 3076, 3145, 3087, 3298, 3550],
        satisfacaoMensal: [91.2, 92.5, 91.8, 93.1, 92.8, 93.5, 92.3, 91.8, 94.2, 93.1, 96.5, 94.0],
        faixaEtaria: {
            labels: ['0-12 anos', '13-17 anos', '18-29 anos', '30-44 anos', '45-59 anos', '60+ anos'],
            valores: [6890, 2654, 10234, 8765, 6432, 3482]
        },
        tempoMedio: {
            labels: ['Pouco Urgente', 'Não Urgente', 'Eletivo'],
            valores: [18, 32, 52]
        }
    }
};

// Meses do ano para labels
const meses = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];

// Variáveis para armazenar instâncias dos gráficos
let graficoMensal = null;
let graficoIdade = null;
let graficoTempo = null;

// Instâncias do Flatpickr
let pickerInicio = null;
let pickerFim = null;

// Instância do Choices.js
let selectUnidade = null;

// Cores para classificação de risco
const coresRisco = {
    amarelo: '#FBBF24', // Pouco Urgente
    verde: '#22C55E',   // Não Urgente
    azul: '#3B82F6'     // Eletivo
};

// Flag para indicar se os dados já foram buscados pelo usuário
let dadosJaCarregados = false;

// ==================== INICIALIZAÇÃO ====================
document.addEventListener('DOMContentLoaded', async function() {
    // Verificar conexão com banco de dados
    usandoBancoDeDados = await verificarConexaoBanco();
    
    if (usandoBancoDeDados) {
        console.log('📊 Conectado ao Supabase - aguardando busca do usuário');
        // Carregar unidades do banco para o select (sem carregar dados do relatório)
        await carregarUnidadesDoSelect();
    } else {
        console.log('📊 Usando dados fictícios (banco não disponível)');
    }
    
    // Inicializar Choices.js para o select de unidade
    selectUnidade = new Choices('#unidade', {
        searchEnabled: false,
        itemSelectText: '',
        shouldSort: false
    });
    
    // Definir datas padrão (ano atual)
    const hoje = new Date();
    const anoAtual = hoje.getFullYear();
    
    // Configurações comuns do Flatpickr
    const configFlatpickr = {
        locale: 'pt',
        dateFormat: 'd/m/Y',
        altInput: true,
        altFormat: 'd/m/Y',
        altInputClass: 'flatpickr-input form-control',
        allowInput: false,
        disableMobile: true,
        animate: true,
        clickOpens: true,
        monthSelectorType: 'dropdown',
        prevArrow: '<i class="fa-solid fa-chevron-left"></i>',
        nextArrow: '<i class="fa-solid fa-chevron-right"></i>',
        wrap: false,
        static: false
    };
    
    // Inicializar Flatpickr para Data Início
    pickerInicio = flatpickr('#dataInicio', {
        ...configFlatpickr,
        defaultDate: new Date(anoAtual, 0, 1),
        onChange: function(selectedDates) {
            if (selectedDates[0] && pickerFim) {
                pickerFim.set('minDate', selectedDates[0]);
            }
        }
    });
    
    // Inicializar Flatpickr para Data Fim
    pickerFim = flatpickr('#dataFim', {
        ...configFlatpickr,
        defaultDate: new Date(anoAtual, 11, 31),
        onChange: function(selectedDates) {
            if (selectedDates[0] && pickerInicio) {
                pickerInicio.set('maxDate', selectedDates[0]);
            }
        }
    });
    
    // Estado vazio já foi exibido no início da inicialização
    
    // Event listener para o formulário de filtro (botão Buscar)
    document.getElementById('filtroForm').addEventListener('submit', function(e) {
        e.preventDefault();
        const unidade = document.getElementById('unidade').value;
        dadosJaCarregados = true;
        
        // Salvar unidade e datas selecionadas no localStorage
        try {
            localStorage.setItem('isiba_unidade_selecionada', unidade);
            const dataInicioStr = pickerInicio?.selectedDates[0]?.toISOString() || '';
            const dataFimStr = pickerFim?.selectedDates[0]?.toISOString() || '';
            localStorage.setItem('isiba_data_inicio', dataInicioStr);
            localStorage.setItem('isiba_data_fim', dataFimStr);
            console.log('💾 Filtros salvos:', unidade);
        } catch(err) {
            console.error('Erro ao salvar:', err);
        }
        
        atualizarDados(unidade);
    });
    
    // Remover auto-atualização ao mudar unidade - só atualiza ao clicar em Buscar
    // document.getElementById('unidade').addEventListener('change', function() {
    //     atualizarDados(this.value);
    // });
    
    // Restaurar filtros salvos do localStorage
    const unidadeSalva = localStorage.getItem('isiba_unidade_selecionada');
    const dataInicioSalva = localStorage.getItem('isiba_data_inicio');
    const dataFimSalva = localStorage.getItem('isiba_data_fim');
    
    if (unidadeSalva) {
        console.log('📋 Restaurando filtros salvos');
        
        // Restaurar unidade no select
        const selectElement = document.getElementById('unidade');
        if (selectElement) selectElement.value = unidadeSalva;
        if (selectUnidade) {
            try { selectUnidade.setChoiceByValue(unidadeSalva); } catch(e) {}
        }
        
        // Restaurar datas nos pickers
        if (dataInicioSalva && pickerInicio) {
            pickerInicio.setDate(new Date(dataInicioSalva), false);
        }
        if (dataFimSalva && pickerFim) {
            pickerFim.setDate(new Date(dataFimSalva), false);
        }
        
        // Buscar dados
        dadosJaCarregados = true;
        atualizarDados(unidadeSalva);
    } else {
        console.log('📋 Exibindo estado vazio - aguardando usuário clicar em Buscar');
        exibirEstadoVazio();
    }
});

// ==================== ATUALIZAR DADOS ====================
async function atualizarDados(unidadeId) {
    let dados;
    
    if (usandoBancoDeDados) {
        // Buscar dados do banco
        const ano = new Date().getFullYear();
        dados = await carregarDadosRelatorio(unidadeId, ano);
        
        if (!dados) {
            console.warn('⚠️ Fallback para dados fictícios');
            dados = dadosUPAs[unidadeId];
        }
    } else {
        // Usar dados fictícios
        dados = dadosUPAs[unidadeId];
    }
    
    if (!dados) {
        console.error('❌ Nenhum dado disponível para:', unidadeId);
        return;
    }
    
    // Atualizar cards de resumo (SEMPRE dados anuais completos)
    atualizarResumo(dados);
    
    // Obter período selecionado nos filtros
    const dataInicio = pickerInicio?.selectedDates[0];
    const dataFim = pickerFim?.selectedDates[0];
    
    // Filtrar dados para os gráficos baseado no período selecionado
    const dadosFiltrados = filtrarDadosPorPeriodo(dados, dataInicio, dataFim);
    
    // Atualizar gráficos (dados filtrados por período)
    criarGraficos(dadosFiltrados);
    
    console.log('✅ Dados carregados. Período:', 
        dataInicio?.toLocaleDateString('pt-BR'), 'até', 
        dataFim?.toLocaleDateString('pt-BR'));
}

// ==================== FILTRAR DADOS POR PERÍODO ====================
function filtrarDadosPorPeriodo(dados, dataInicio, dataFim) {
    // Se não houver datas, retorna todos os dados
    if (!dataInicio || !dataFim) {
        return dados;
    }
    
    const mesInicio = dataInicio.getMonth(); // 0-11
    const mesFim = dataFim.getMonth(); // 0-11
    
    // Criar cópia dos dados para não modificar o original
    const dadosFiltrados = JSON.parse(JSON.stringify(dados));
    
    // Determinar quais meses incluir
    let mesesIncluidos = [];
    
    if (mesInicio <= mesFim) {
        // Período normal (ex: janeiro a junho)
        for (let i = mesInicio; i <= mesFim; i++) {
            mesesIncluidos.push(i);
        }
    } else {
        // Período que cruza o ano (ex: dezembro a junho)
        for (let i = mesInicio; i <= 11; i++) {
            mesesIncluidos.push(i);
        }
        for (let i = 0; i <= mesFim; i++) {
            mesesIncluidos.push(i);
        }
    }
    
    console.log('📅 Meses filtrados:', mesesIncluidos.map(m => meses[m]).join(', '));
    
    // Filtrar atendimentos mensais - zerar meses fora do período
    dadosFiltrados.atendimentosMensais = dados.atendimentosMensais.map((valor, index) => 
        mesesIncluidos.includes(index) ? valor : 0
    );
    
    // Filtrar satisfação mensal
    dadosFiltrados.satisfacaoMensal = dados.satisfacaoMensal.map((valor, index) => 
        mesesIncluidos.includes(index) ? valor : 0
    );
    
    return dadosFiltrados;
}

// ==================== EXIBIR ESTADO VAZIO ====================
function exibirEstadoVazio() {
    // Mostrar zeros nos cards de resumo
    document.getElementById('totalAtendimentos').textContent = '—';
    document.getElementById('satisfacaoMedia').textContent = '—';
    document.getElementById('maiorVolume').textContent = '—';
    document.getElementById('maiorSatisfacao').textContent = '—';
    
    // Criar gráficos vazios
    criarGraficosVazios();
}

// ==================== CRIAR GRÁFICOS VAZIOS ====================
function criarGraficosVazios() {
    // Destruir gráficos existentes
    if (graficoMensal) graficoMensal.destroy();
    if (graficoIdade) graficoIdade.destroy();
    if (graficoTempo) graficoTempo.destroy();
    
    // Dados vazios
    const dadosVaziosMensais = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    const faixasVazias = [0, 0, 0, 0, 0, 0];
    const temposVazios = [0, 0, 0];
    
    // Gráfico 1: Atendimento Mensal (vazio)
    const ctxMensal = document.getElementById('graficoMensal').getContext('2d');
    graficoMensal = new Chart(ctxMensal, {
        type: 'bar',
        data: {
            labels: meses,
            datasets: [{
                label: 'Atendimentos',
                data: dadosVaziosMensais,
                backgroundColor: 'rgba(6, 182, 212, 0.2)',
                borderColor: '#06B6D4',
                borderWidth: 2,
                borderRadius: 6,
                yAxisID: 'y'
            }, {
                label: 'Satisfação (%)',
                data: dadosVaziosMensais,
                type: 'line',
                borderColor: '#10B981',
                backgroundColor: 'rgba(16, 185, 129, 0.1)',
                tension: 0.4,
                fill: true,
                yAxisID: 'y1'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { 
                    position: 'top',
                    labels: { font: { family: 'Poppins', size: 12 }, usePointStyle: true }
                }
            },
            scales: {
                y: { beginAtZero: true, max: 100, title: { display: true, text: 'Atendimentos' } },
                y1: { beginAtZero: true, max: 100, position: 'right', grid: { drawOnChartArea: false }, title: { display: true, text: 'Satisfação (%)' } }
            }
        }
    });
    
    // Gráfico 2: Faixa Etária (vazio)
    const ctxIdade = document.getElementById('graficoIdade').getContext('2d');
    graficoIdade = new Chart(ctxIdade, {
        type: 'doughnut',
        data: {
            labels: ['0-12 anos', '13-17 anos', '18-29 anos', '30-44 anos', '45-59 anos', '60+ anos'],
            datasets: [{
                data: faixasVazias,
                backgroundColor: ['#06B6D4', '#0891B2', '#0E7490', '#155E75', '#164E63', '#134E4A'],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'right', labels: { font: { family: 'Inter', size: 11 }, usePointStyle: true } }
            }
        }
    });
    
    // Gráfico 3: Tempo de Atendimento (vazio)
    const ctxTempo = document.getElementById('graficoTempo').getContext('2d');
    graficoTempo = new Chart(ctxTempo, {
        type: 'bar',
        data: {
            labels: ['Pouco Urgente', 'Não Urgente', 'Eletivo'],
            datasets: [{
                label: 'Tempo (minutos)',
                data: temposVazios,
                backgroundColor: [coresRisco.amarelo, coresRisco.verde, coresRisco.azul],
                borderWidth: 0,
                borderRadius: 8
            }]
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                x: { beginAtZero: true, max: 60, title: { display: true, text: 'Minutos' } }
            }
        }
    });
}

// ==================== ATUALIZAR RESUMO ====================
function atualizarResumo(dados) {
    // Animação de contagem para números
    animarNumero('totalAtendimentos', dados.totalAtendimentos, '');
    animarNumero('satisfacaoMedia', dados.satisfacaoMedia, '%', 1);
    
    document.getElementById('maiorVolume').textContent = dados.maiorVolume.mes;
    document.getElementById('maiorSatisfacao').textContent = dados.maiorSatisfacao.mes;
}

// ==================== ANIMAÇÃO DE NÚMEROS ====================
function animarNumero(elementoId, valorFinal, sufixo = '', decimais = 0) {
    const elemento = document.getElementById(elementoId);
    const duracao = 1500;
    const inicio = performance.now();
    const valorInicial = 0;
    
    function atualizar(tempoAtual) {
        const progresso = Math.min((tempoAtual - inicio) / duracao, 1);
        const easeOutQuart = 1 - Math.pow(1 - progresso, 4);
        const valorAtual = valorInicial + (valorFinal - valorInicial) * easeOutQuart;
        
        if (decimais > 0) {
            elemento.textContent = valorAtual.toFixed(decimais) + sufixo;
        } else {
            elemento.textContent = formatarNumero(Math.floor(valorAtual)) + sufixo;
        }
        
        if (progresso < 1) {
            requestAnimationFrame(atualizar);
        }
    }
    
    requestAnimationFrame(atualizar);
}

// ==================== FORMATAR NÚMERO ====================
function formatarNumero(numero) {
    return numero.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.');
}

// ==================== CRIAR GRÁFICOS ====================
function criarGraficos(dados) {
    // Destruir gráficos existentes
    if (graficoMensal) graficoMensal.destroy();
    if (graficoIdade) graficoIdade.destroy();
    if (graficoTempo) graficoTempo.destroy();
    
    // Gráfico 1: Atendimento e Satisfação Mensal
    const ctxMensal = document.getElementById('graficoMensal').getContext('2d');
    graficoMensal = new Chart(ctxMensal, {
        type: 'bar',
        data: {
            labels: meses,
            datasets: [
                {
                    label: 'Atendimentos',
                    data: dados.atendimentosMensais,
                    backgroundColor: 'rgba(59, 130, 246, 0.8)',
                    borderColor: '#3b82f6',
                    borderWidth: 2,
                    borderRadius: 6,
                    yAxisID: 'y'
                },
                {
                    label: 'Satisfação (%)',
                    data: dados.satisfacaoMensal,
                    type: 'line',
                    borderColor: '#10b981',
                    backgroundColor: 'rgba(16, 185, 129, 0.1)',
                    borderWidth: 3,
                    pointRadius: 5,
                    pointBackgroundColor: '#10b981',
                    pointBorderColor: '#ffffff',
                    pointBorderWidth: 2,
                    tension: 0.4,
                    fill: true,
                    yAxisID: 'y1'
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                intersect: false,
                mode: 'index'
            },
            plugins: {
                legend: {
                    position: 'top',
                    labels: {
                        usePointStyle: true,
                        padding: 20,
                        font: { family: 'Inter', size: 12 }
                    }
                },
                tooltip: {
                    backgroundColor: '#1e293b',
                    titleFont: { family: 'Poppins', size: 14, weight: '600' },
                    bodyFont: { family: 'Inter', size: 13 },
                    padding: 12,
                    cornerRadius: 8,
                    callbacks: {
                        label: function(context) {
                            if (context.dataset.label === 'Atendimentos') {
                                return `Atendimentos: ${formatarNumero(context.raw)}`;
                            } else {
                                return `Satisfação: ${context.raw}%`;
                            }
                        }
                    }
                }
            },
            scales: {
                x: {
                    grid: { display: false },
                    ticks: { font: { family: 'Inter', size: 12 } }
                },
                y: {
                    type: 'linear',
                    display: true,
                    position: 'left',
                    title: {
                        display: true,
                        text: 'Atendimentos',
                        font: { family: 'Inter', size: 12, weight: '500' }
                    },
                    grid: { color: 'rgba(0, 0, 0, 0.05)' },
                    ticks: { font: { family: 'Inter', size: 11 } }
                },
                y1: {
                    type: 'linear',
                    display: true,
                    position: 'right',
                    min: 85,
                    max: 100,
                    title: {
                        display: true,
                        text: 'Satisfação (%)',
                        font: { family: 'Inter', size: 12, weight: '500' }
                    },
                    grid: { drawOnChartArea: false },
                    ticks: { 
                        font: { family: 'Inter', size: 11 },
                        callback: function(value) { return value + '%'; }
                    }
                }
            }
        }
    });
    
    // Gráfico 2: Distribuição por Faixa Etária
    const ctxIdade = document.getElementById('graficoIdade').getContext('2d');
    graficoIdade = new Chart(ctxIdade, {
        type: 'doughnut',
        data: {
            labels: dados.faixaEtaria.labels,
            datasets: [{
                data: dados.faixaEtaria.valores,
                backgroundColor: [
                    '#3b82f6',
                    '#8b5cf6',
                    '#ec4899',
                    '#f59e0b',
                    '#10b981',
                    '#64748b'
                ],
                borderWidth: 3,
                borderColor: '#ffffff'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '60%',
            plugins: {
                legend: {
                    position: 'right',
                    labels: {
                        usePointStyle: true,
                        padding: 15,
                        font: { family: 'Inter', size: 11 }
                    }
                },
                tooltip: {
                    backgroundColor: '#1e293b',
                    titleFont: { family: 'Poppins', size: 14, weight: '600' },
                    bodyFont: { family: 'Inter', size: 13 },
                    padding: 12,
                    cornerRadius: 8,
                    callbacks: {
                        label: function(context) {
                            const total = context.dataset.data.reduce((a, b) => a + b, 0);
                            const percentual = ((context.raw / total) * 100).toFixed(1);
                            return `${formatarNumero(context.raw)} (${percentual}%)`;
                        }
                    }
                }
            }
        }
    });
    
    // Gráfico 3: Tempo Médio de Atendimento (com cores de classificação de risco)
    const ctxTempo = document.getElementById('graficoTempo').getContext('2d');
    graficoTempo = new Chart(ctxTempo, {
        type: 'bar',
        data: {
            labels: dados.tempoMedio.labels,
            datasets: [{
                label: 'Tempo (minutos)',
                data: dados.tempoMedio.valores,
                backgroundColor: [
                    coresRisco.amarelo,  // Pouco Urgente - Amarelo
                    coresRisco.verde,    // Não Urgente - Verde
                    coresRisco.azul      // Eletivo - Azul
                ],
                borderWidth: 0,
                borderRadius: 8
            }]
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: '#1e293b',
                    titleFont: { family: 'Poppins', size: 14, weight: '600' },
                    bodyFont: { family: 'Inter', size: 13 },
                    padding: 12,
                    cornerRadius: 8,
                    callbacks: {
                        label: function(context) {
                            return `Tempo médio: ${context.raw} minutos`;
                        }
                    }
                }
            },
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Minutos',
                        font: { family: 'Inter', size: 12, weight: '500' }
                    },
                    grid: { color: 'rgba(0, 0, 0, 0.05)' },
                    ticks: { font: { family: 'Inter', size: 11 } }
                },
                y: {
                    grid: { display: false },
                    ticks: { font: { family: 'Inter', size: 12, weight: '500' } }
                }
            }
        }
    });
}

// ==================== CARREGAR UNIDADES DO BANCO ====================
async function carregarUnidadesDoSelect() {
    try {
        const unidades = await fetchUnidades();
        
        if (!unidades || unidades.length === 0) {
            console.log('📋 Nenhuma unidade encontrada no banco, usando opções padrão');
            return;
        }
        
        // Limpar opções existentes
        const select = document.getElementById('unidade');
        select.innerHTML = '';
        
        // Adicionar unidades do banco
        unidades.forEach(unidade => {
            const option = document.createElement('option');
            option.value = unidade.id;
            option.textContent = unidade.nome;
            select.appendChild(option);
        });
        
        console.log('✅ Unidades carregadas no select:', unidades.length);
        
    } catch (error) {
        console.error('❌ Erro ao carregar unidades:', error);
    }
}

console.log('✅ Relatório JavaScript carregado com sucesso!');
