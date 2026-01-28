/* ========================================
   PAINEL ADMINISTRATIVO RH - JAVASCRIPT
   (SEM SUPABASE - VERSÃO LOCAL)
   ======================================== */

// Dados simulados (localStorage)
let funcionarios = JSON.parse(localStorage.getItem('funcionarios')) || [];
let contracheques = JSON.parse(localStorage.getItem('contracheques')) || [];

// Credenciais de admin (temporário - depois virá do Supabase)
const ADMIN_USER = 'admin.rh';
const ADMIN_PASS = 'isiba2026';

// ========================================
// INICIALIZAÇÃO
// ========================================
document.addEventListener('DOMContentLoaded', () => {
    initLogin();
    initDashboard();
    initCadastro();
    initListagem();
    initUpload();
    initHistorico();
    populateYearSelect();
});

// ========================================
// LOGIN
// ========================================
function initLogin() {
    const loginForm = document.getElementById('loginForm');
    const togglePassword = document.getElementById('toggleLoginPassword');
    const senhaInput = document.getElementById('loginSenha');

    // Toggle senha
    if (togglePassword) {
        togglePassword.addEventListener('click', () => {
            const type = senhaInput.getAttribute('type');
            senhaInput.setAttribute('type', type === 'password' ? 'text' : 'password');
            togglePassword.innerHTML = type === 'password' ? '<i class="fas fa-eye-slash"></i>' : '<i class="fas fa-eye"></i>';
        });
    }

    // Submissão do login
    if (loginForm) {
        loginForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const usuario = document.getElementById('loginUsuario').value;
            const senha = document.getElementById('loginSenha').value;

            // Validação simples
            if (usuario === ADMIN_USER && senha === ADMIN_PASS) {
                showLoginStatus('success', 'Login realizado com sucesso!');
                
                // Salva sessão
                sessionStorage.setItem('admin_logged', 'true');
                sessionStorage.setItem('admin_user', usuario);

                // Aguarda 1 segundo e mostra dashboard
                setTimeout(() => {
                    document.getElementById('loginScreen').style.display = 'none';
                    document.getElementById('dashboard').style.display = 'grid';
                    document.body.classList.add('dashboard-active');
                    atualizarEstatisticas();
                }, 1000);
            } else {
                showLoginStatus('error', 'Usuário ou senha incorretos!');
            }
        });
    }
}

function showLoginStatus(type, message) {
    const statusDiv = document.getElementById('loginStatus');
    statusDiv.className = `login-status ${type}`;
    statusDiv.textContent = message;

    if (type === 'error') {
        setTimeout(() => {
            statusDiv.style.display = 'none';
        }, 3000);
    }
}

// ========================================
// DASHBOARD
// ========================================
function initDashboard() {
    // Navegação entre seções
    const navItems = document.querySelectorAll('.nav-item');
    const sections = document.querySelectorAll('.content-section');

    navItems.forEach(item => {
        item.addEventListener('click', () => {
            const sectionId = item.getAttribute('data-section');
            
            // Remove active de todos
            navItems.forEach(nav => nav.classList.remove('active'));
            sections.forEach(sec => sec.classList.remove('active'));

            // Adiciona active no clicado
            item.classList.add('active');
            document.getElementById(`section-${sectionId}`).classList.add('active');

            // Atualiza título
            const titles = {
                'overview': ['Visão Geral', 'Painel de controle do sistema'],
                'cadastrar': ['Cadastrar Funcionário', 'Adicione novos colaboradores ao sistema'],
                'listar': ['Listar Funcionários', 'Visualize e gerencie todos os cadastros'],
                'upload': ['Enviar Contracheque', 'Faça upload de contracheques em PDF'],
                'historico': ['Histórico de Envios', 'Consulte todos os envios realizados']
            };

            document.getElementById('pageTitle').textContent = titles[sectionId][0];
            document.getElementById('pageSubtitle').textContent = titles[sectionId][1];

            // Atualiza dados conforme a seção
            if (sectionId === 'listar') {
                renderFuncionarios();
            } else if (sectionId === 'upload') {
                popularSelectFuncionarios();
            } else if (sectionId === 'historico') {
                renderHistorico();
            }
        });
    });

    // Logout
    document.getElementById('btnLogout').addEventListener('click', () => {
        if (confirm('Deseja realmente sair?')) {
            sessionStorage.clear();
            location.reload();
        }
    });

    // Verifica se está logado
    if (sessionStorage.getItem('admin_logged') === 'true') {
        document.getElementById('loginScreen').style.display = 'none';
        document.getElementById('dashboard').style.display = 'grid';
        document.body.classList.add('dashboard-active');
        document.getElementById('userName').textContent = sessionStorage.getItem('admin_user');
        atualizarEstatisticas();
    }
}

function atualizarEstatisticas() {
    // Total de funcionários
    document.getElementById('totalFuncionarios').textContent = funcionarios.length;

    // Total de contracheques
    document.getElementById('totalContracheques').textContent = contracheques.length;

    // Envios este mês
    const mesAtual = new Date().getMonth();
    const enviosMes = contracheques.filter(c => {
        const data = new Date(c.dataEnvio);
        return data.getMonth() === mesAtual;
    }).length;
    document.getElementById('enviosMes').textContent = enviosMes;

    // Último envio
    if (contracheques.length > 0) {
        const ultimo = contracheques[contracheques.length - 1];
        const data = new Date(ultimo.dataEnvio);
        const hoje = new Date();
        const diffDias = Math.floor((hoje - data) / (1000 * 60 * 60 * 24));
        
        if (diffDias === 0) {
            document.getElementById('ultimoEnvio').textContent = 'Hoje';
        } else if (diffDias === 1) {
            document.getElementById('ultimoEnvio').textContent = 'Ontem';
        } else {
            document.getElementById('ultimoEnvio').textContent = `${diffDias} dias atrás`;
        }
    }
}

// ========================================
// CADASTRO DE FUNCIONÁRIO
// ========================================
function initCadastro() {
    const formCadastrar = document.getElementById('formCadastrar');
    const cpfInput = document.getElementById('cadCPF');
    const toggleSenha = document.getElementById('toggleCadSenha');
    const senhaInput = document.getElementById('cadSenha');

    // Máscara de CPF
    if (cpfInput) {
        cpfInput.addEventListener('input', (e) => {
            let value = e.target.value.replace(/\D/g, '');
            value = value.substring(0, 11);
            
            if (value.length > 9) {
                value = value.replace(/(\d{3})(\d{3})(\d{3})(\d{0,2})/, '$1.$2.$3-$4');
            } else if (value.length > 6) {
                value = value.replace(/(\d{3})(\d{3})(\d{0,3})/, '$1.$2.$3');
            } else if (value.length > 3) {
                value = value.replace(/(\d{3})(\d{0,3})/, '$1.$2');
            }
            
            e.target.value = value;
        });
    }

    // Toggle senha
    if (toggleSenha) {
        toggleSenha.addEventListener('click', () => {
            const type = senhaInput.getAttribute('type');
            senhaInput.setAttribute('type', type === 'password' ? 'text' : 'password');
            toggleSenha.innerHTML = type === 'password' ? '<i class="fas fa-eye-slash"></i>' : '<i class="fas fa-eye"></i>';
        });
    }

    // Limpar formulário
    document.getElementById('btnLimparCadastro').addEventListener('click', () => {
        formCadastrar.reset();
        hideCadastroStatus();
    });

    // Submissão do formulário
    if (formCadastrar) {
        formCadastrar.addEventListener('submit', (e) => {
            e.preventDefault();

            const nome = document.getElementById('cadNome').value.trim();
            const cpf = document.getElementById('cadCPF').value.replace(/\D/g, '');
            const email = document.getElementById('cadEmail').value.trim();
            const senha = document.getElementById('cadSenha').value;
            const status = document.getElementById('cadStatus').value;

            // Validações
            if (!validarCPF(cpf)) {
                showCadastroStatus('error', 'CPF inválido!');
                return;
            }

            // Verifica se CPF já existe
            if (funcionarios.some(f => f.cpf === cpf)) {
                showCadastroStatus('error', 'CPF já cadastrado!');
                return;
            }

            // Cadastra funcionário
            const novoFuncionario = {
                id: Date.now(),
                nome,
                cpf,
                email,
                senha, // TODO: Criptografar antes de salvar no Supabase
                status,
                dataCadastro: new Date().toISOString()
            };

            funcionarios.push(novoFuncionario);
            localStorage.setItem('funcionarios', JSON.stringify(funcionarios));

            showCadastroStatus('success', `Funcionário ${nome} cadastrado com sucesso!`);
            formCadastrar.reset();
            atualizarEstatisticas();

            // Auto-oculta após 3 segundos
            setTimeout(() => {
                hideCadastroStatus();
            }, 3000);
        });
    }
}

function validarCPF(cpf) {
    if (cpf.length !== 11 || /^(\d)\1{10}$/.test(cpf)) return false;

    let soma = 0;
    let resto;

    for (let i = 1; i <= 9; i++) {
        soma += parseInt(cpf.substring(i - 1, i)) * (11 - i);
    }
    resto = (soma * 10) % 11;
    if (resto === 10 || resto === 11) resto = 0;
    if (resto !== parseInt(cpf.substring(9, 10))) return false;

    soma = 0;
    for (let i = 1; i <= 10; i++) {
        soma += parseInt(cpf.substring(i - 1, i)) * (12 - i);
    }
    resto = (soma * 10) % 11;
    if (resto === 10 || resto === 11) resto = 0;
    if (resto !== parseInt(cpf.substring(10, 11))) return false;

    return true;
}

function showCadastroStatus(type, message) {
    const statusDiv = document.getElementById('cadastroStatus');
    statusDiv.className = `form-status ${type}`;
    statusDiv.textContent = message;
}

function hideCadastroStatus() {
    const statusDiv = document.getElementById('cadastroStatus');
    statusDiv.style.display = 'none';
}

// ========================================
// LISTAGEM DE FUNCIONÁRIOS
// ========================================
function initListagem() {
    const searchInput = document.getElementById('searchFuncionario');
    
    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            renderFuncionarios(e.target.value);
        });
    }
}

function renderFuncionarios(filtro = '') {
    const tbody = document.getElementById('tabelaFuncionarios');
    
    let funcionariosFiltrados = funcionarios;
    
    if (filtro) {
        funcionariosFiltrados = funcionarios.filter(f => 
            f.nome.toLowerCase().includes(filtro.toLowerCase()) ||
            f.cpf.includes(filtro.replace(/\D/g, ''))
        );
    }

    if (funcionariosFiltrados.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="5" class="empty-state">
                    <i class="fa-solid fa-users-slash"></i>
                    <p>${filtro ? 'Nenhum funcionário encontrado' : 'Nenhum funcionário cadastrado ainda'}</p>
                </td>
            </tr>
        `;
        return;
    }

    tbody.innerHTML = funcionariosFiltrados.map(f => `
        <tr>
            <td>${f.nome}</td>
            <td>${formatarCPF(f.cpf)}</td>
            <td>${f.email || '-'}</td>
            <td><span class="badge ${f.status === 'ativo' ? 'badge-success' : 'badge-danger'}">${f.status}</span></td>
            <td>
                <button class="btn-action btn-edit" onclick="editarFuncionario(${f.id})">
                    <i class="fa-solid fa-edit"></i> Editar
                </button>
                <button class="btn-action btn-delete" onclick="deletarFuncionario(${f.id})">
                    <i class="fa-solid fa-trash"></i> Excluir
                </button>
            </td>
        </tr>
    `).join('');
}

function formatarCPF(cpf) {
    return cpf.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4');
}

function editarFuncionario(id) {
    alert('Funcionalidade de edição será implementada com Supabase!');
    // TODO: Implementar com Supabase
}

function deletarFuncionario(id) {
    if (confirm('Deseja realmente excluir este funcionário?')) {
        funcionarios = funcionarios.filter(f => f.id !== id);
        localStorage.setItem('funcionarios', JSON.stringify(funcionarios));
        renderFuncionarios();
        atualizarEstatisticas();
    }
}

// ========================================
// UPLOAD DE CONTRACHEQUE
// ========================================
function initUpload() {
    const formUpload = document.getElementById('formUpload');
    const uploadArea = document.getElementById('uploadArea');
    const uploadFile = document.getElementById('uploadFile');
    const uploadPreview = document.getElementById('uploadPreview');

    // Click na área de upload
    uploadArea.addEventListener('click', () => {
        uploadFile.click();
    });

    // Drag and drop
    uploadArea.addEventListener('dragover', (e) => {
        e.preventDefault();
        uploadArea.style.borderColor = 'var(--primary-color)';
    });

    uploadArea.addEventListener('dragleave', () => {
        uploadArea.style.borderColor = 'var(--border-color)';
    });

    uploadArea.addEventListener('drop', (e) => {
        e.preventDefault();
        uploadArea.style.borderColor = 'var(--border-color)';
        
        const files = e.dataTransfer.files;
        if (files.length > 0) {
            uploadFile.files = files;
            previewFile(files[0]);
        }
    });

    // Seleção de arquivo
    uploadFile.addEventListener('change', (e) => {
        if (e.target.files.length > 0) {
            previewFile(e.target.files[0]);
        }
    });

    // Remover arquivo
    document.getElementById('btnRemoveFile').addEventListener('click', (e) => {
        e.stopPropagation();
        uploadFile.value = '';
        document.querySelector('.upload-content').style.display = 'block';
        uploadPreview.style.display = 'none';
    });

    // Limpar formulário
    document.getElementById('btnLimparUpload').addEventListener('click', () => {
        formUpload.reset();
        uploadFile.value = '';
        document.querySelector('.upload-content').style.display = 'block';
        uploadPreview.style.display = 'none';
        hideUploadStatus();
    });

    // Submissão do formulário
    formUpload.addEventListener('submit', (e) => {
        e.preventDefault();

        const funcionarioId = document.getElementById('uploadFuncionario').value;
        const mes = document.getElementById('uploadMes').value;
        const ano = document.getElementById('uploadAno').value;
        const arquivo = uploadFile.files[0];

        if (!arquivo) {
            showUploadStatus('error', 'Selecione um arquivo PDF!');
            return;
        }

        if (arquivo.type !== 'application/pdf') {
            showUploadStatus('error', 'Apenas arquivos PDF são permitidos!');
            return;
        }

        if (arquivo.size > 10 * 1024 * 1024) {
            showUploadStatus('error', 'Arquivo muito grande! Máximo 10MB.');
            return;
        }

        // Simula envio (depois será para Supabase Storage)
        const funcionario = funcionarios.find(f => f.id == funcionarioId);
        
        const novoContracheque = {
            id: Date.now(),
            funcionarioId: parseInt(funcionarioId),
            funcionarioNome: funcionario.nome,
            mes,
            ano: parseInt(ano),
            nomeArquivo: arquivo.name,
            tamanhoArquivo: arquivo.size,
            dataEnvio: new Date().toISOString()
        };

        contracheques.push(novoContracheque);
        localStorage.setItem('contracheques', JSON.stringify(contracheques));

        showUploadStatus('success', `Contracheque enviado com sucesso para ${funcionario.nome}!`);
        formUpload.reset();
        uploadFile.value = '';
        document.querySelector('.upload-content').style.display = 'block';
        uploadPreview.style.display = 'none';
        atualizarEstatisticas();

        setTimeout(() => {
            hideUploadStatus();
        }, 3000);
    });
}

function popularSelectFuncionarios() {
    const select = document.getElementById('uploadFuncionario');
    
    select.innerHTML = '<option value="">Escolha um funcionário...</option>';
    
    funcionarios
        .filter(f => f.status === 'ativo')
        .forEach(f => {
            const option = document.createElement('option');
            option.value = f.id;
            option.textContent = `${f.nome} - ${formatarCPF(f.cpf)}`;
            select.appendChild(option);
        });
}

function previewFile(file) {
    if (file.type !== 'application/pdf') {
        alert('Apenas arquivos PDF são permitidos!');
        return;
    }

    document.querySelector('.upload-content').style.display = 'none';
    document.getElementById('uploadPreview').style.display = 'flex';
    document.getElementById('fileName').textContent = file.name;
    document.getElementById('fileSize').textContent = formatBytes(file.size);
}

function formatBytes(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
}

function showUploadStatus(type, message) {
    const statusDiv = document.getElementById('uploadStatus');
    statusDiv.className = `form-status ${type}`;
    statusDiv.textContent = message;
}

function hideUploadStatus() {
    const statusDiv = document.getElementById('uploadStatus');
    statusDiv.style.display = 'none';
}

// ========================================
// HISTÓRICO
// ========================================
function initHistorico() {
    const filterMes = document.getElementById('filterMes');
    
    if (filterMes) {
        filterMes.addEventListener('change', (e) => {
            renderHistorico(e.target.value);
        });
    }
}

function renderHistorico(filtroMes = '') {
    const tbody = document.getElementById('tabelaHistorico');
    
    let historicoFiltrado = contracheques;
    
    if (filtroMes) {
        historicoFiltrado = contracheques.filter(c => c.mes === filtroMes);
    }

    if (historicoFiltrado.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="5" class="empty-state">
                    <i class="fa-solid fa-inbox"></i>
                    <p>${filtroMes ? 'Nenhum envio encontrado para este mês' : 'Nenhum contracheque enviado ainda'}</p>
                </td>
            </tr>
        `;
        return;
    }

    tbody.innerHTML = historicoFiltrado.map(c => {
        const data = new Date(c.dataEnvio);
        const dataFormatada = data.toLocaleDateString('pt-BR') + ' às ' + data.toLocaleTimeString('pt-BR');
        
        return `
            <tr>
                <td>${c.funcionarioNome}</td>
                <td>${c.mes}/${c.ano}</td>
                <td>${dataFormatada}</td>
                <td>${formatBytes(c.tamanhoArquivo)}</td>
                <td><span class="badge badge-success">Enviado</span></td>
            </tr>
        `;
    }).join('');
}

// ========================================
// UTILITÁRIOS
// ========================================
function populateYearSelect() {
    const select = document.getElementById('uploadAno');
    const currentYear = new Date().getFullYear();
    
    for (let i = 0; i < 5; i++) {
        const year = currentYear - i;
        const option = document.createElement('option');
        option.value = year;
        option.textContent = year;
        if (i === 0) option.selected = true;
        select.appendChild(option);
    }
}
