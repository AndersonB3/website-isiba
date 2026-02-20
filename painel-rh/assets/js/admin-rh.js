/* ========================================
   PAINEL ADMINISTRATIVO RH - JAVASCRIPT
   INTEGRADO COM SUPABASE
   Autenticação via Banco de Dados
   ======================================== */

// ========================================
// INICIALIZAÇÃO
// ========================================

// Função auxiliar para aguardar o Supabase estar pronto
function aguardarSupabase(callback, tentativas = 0) {
    if (tentativas === 0) {
        console.log('🔍 Aguardando Supabase inicializar...');
    }
    
    if (window.supabaseClient) {
        console.log('✅ Supabase detectado, inicializando painel...');
        callback();
    } else if (tentativas < 50) {
        // Aumentado de 20 para 50 tentativas (5 segundos)
        if (tentativas % 10 === 0) {
            console.log(`⏳ Tentativa ${tentativas}/50...`);
        }
        setTimeout(() => aguardarSupabase(callback, tentativas + 1), 100);
    } else {
        console.error('❌ Erro: Supabase não foi inicializado após 5 segundos!');
        console.log('Debug:', {
            supabase: !!window.supabase,
            supabaseClient: !!window.supabaseClient,
            CONFIG: !!window.CONFIG
        });
        alert('Erro ao conectar com o banco de dados. Verifique a configuração.');
    }
}

document.addEventListener('DOMContentLoaded', () => {
    // Aguardar Supabase estar pronto antes de inicializar
    aguardarSupabase(() => {
        initLogin();
        initDashboard();
        initCadastro();
        initListagem();
        initUpload();
        initHistorico();
        initModalEdicao();
        populateYearSelect();
    });
});

// ========================================
// LOGIN
// ========================================
function initLogin() {
    const loginForm = document.getElementById('loginForm');
    const togglePassword = document.getElementById('toggleLoginPassword');
    const senhaInput = document.getElementById('loginSenha');
    const btnLogin = document.getElementById('btnLogin');

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
            
            const usuario = document.getElementById('loginUsuario').value.trim();
            const senha = document.getElementById('loginSenha').value;

            // Validação básica
            if (!usuario || !senha) {
                showLoginStatus('error', 'Preencha todos os campos!');
                return;
            }

            // Desabilitar botão e mostrar loading
            btnLogin.disabled = true;
            btnLogin.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Autenticando...';

            // Autenticar via Supabase
            const result = await autenticarAdministrador(usuario, senha);

            if (result.success) {
                showLoginStatus('success', `Bem-vindo, ${result.data.nome_completo}!`);
                
                // Salva sessão
                sessionStorage.setItem('admin_logged', 'true');
                sessionStorage.setItem('admin_user', result.data.usuario);
                sessionStorage.setItem('admin_nome', result.data.nome_completo);
                sessionStorage.setItem('admin_id', result.data.id);

                // Aguarda 1 segundo e mostra dashboard
                setTimeout(() => {
                    document.getElementById('loginScreen').style.display = 'none';
                    document.getElementById('dashboard').style.display = 'grid';
                    document.body.classList.add('dashboard-active');
                    document.getElementById('userName').textContent = result.data.nome_completo;
                    atualizarEstatisticas();
                }, 1000);
            } else {
                showLoginStatus('error', result.error || 'Usuário ou senha incorretos!');
                btnLogin.disabled = false;
                btnLogin.innerHTML = '<i class="fa-solid fa-sign-in-alt"></i> Entrar no Painel';
            }
        });
    }
}

function showLoginStatus(type, message) {
    const statusDiv = document.getElementById('loginStatus');
    statusDiv.className = `login-status ${type}`;
    statusDiv.textContent = message;
    statusDiv.style.display = 'block';

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
                'upload-lote': ['Upload Inteligente em Lote', 'Sistema automático de leitura de PDFs com IA'],
                'historico': ['Histórico de Envios', 'Consulte todos os envios realizados'],
                'recibos': ['Recibos de Documentos', 'Visualize todos os recibos digitais gerados']
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
            } else if (sectionId === 'overview') {
                atualizarEstatisticas();
            } else if (sectionId === 'recibos') {
                carregarRecibos();
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
        document.getElementById('userName').textContent = sessionStorage.getItem('admin_nome') || sessionStorage.getItem('admin_user');
        atualizarEstatisticas();
    }
}

async function atualizarEstatisticas() {
    try {
        // Buscar estatísticas do Supabase
        const result = await obterEstatisticas();
        
        if (result.success) {
            const stats = result.data;
            
            document.getElementById('totalFuncionarios').textContent = stats.totalFuncionarios;
            document.getElementById('totalContracheques').textContent = stats.totalContracheques;
            document.getElementById('enviosMes').textContent = stats.enviosMes;
            
            if (stats.ultimoEnvio) {
                const hoje = new Date();
                const diffDias = Math.floor((hoje - stats.ultimoEnvio) / (1000 * 60 * 60 * 24));
                
                if (diffDias === 0) {
                    document.getElementById('ultimoEnvio').textContent = 'Hoje';
                } else if (diffDias === 1) {
                    document.getElementById('ultimoEnvio').textContent = 'Ontem';
                } else {
                    document.getElementById('ultimoEnvio').textContent = `${diffDias} dias atrás`;
                }
            } else {
                document.getElementById('ultimoEnvio').textContent = 'Nenhum';
            }
        }
    } catch (error) {
        console.error('Erro ao atualizar estatísticas:', error);
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
        formCadastrar.addEventListener('submit', async (e) => {
            e.preventDefault();

            const btnCadastrar = document.getElementById('btnCadastrar');
            btnCadastrar.disabled = true;
            btnCadastrar.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Cadastrando...';

            const nome = document.getElementById('cadNome').value.trim();
            const codigo = document.getElementById('cadCodigo').value.trim().toUpperCase();
            const cpf = document.getElementById('cadCPF').value;
            const email = document.getElementById('cadEmail').value.trim();
            const senha = document.getElementById('cadSenha').value;
            const status = document.getElementById('cadStatus').value;
            const centro_custo = document.getElementById('cadCentroCusto').value;

            // Validações
            if (!codigo) {
                showCadastroStatus('error', 'Código do funcionário é obrigatório!');
                btnCadastrar.disabled = false;
                btnCadastrar.innerHTML = '<i class="fa-solid fa-save"></i> Cadastrar Funcionário';
                return;
            }

            if (!centro_custo) {
                showCadastroStatus('error', 'Selecione o Centro de Custo!');
                btnCadastrar.disabled = false;
                btnCadastrar.innerHTML = '<i class="fa-solid fa-save"></i> Cadastrar Funcionário';
                return;
            }

            const cpfLimpo = cpf.replace(/\D/g, '');
            if (!validarCPF(cpfLimpo)) {
                showCadastroStatus('error', 'CPF inválido!');
                btnCadastrar.disabled = false;
                btnCadastrar.innerHTML = '<i class="fa-solid fa-save"></i> Cadastrar Funcionário';
                return;
            }

            // Cadastrar no Supabase
            const result = await cadastrarColaborador({
                nome,
                codigo_funcionario: codigo,
                cpf,
                email,
                senha,
                status,
                centro_custo
            });

            if (result.success) {
                showCadastroStatus('success', 'Funcionário cadastrado com sucesso!');
                formCadastrar.reset();
                atualizarEstatisticas();
                
                setTimeout(() => {
                    hideCadastroStatus();
                }, 3000);
            } else {
                showCadastroStatus('error', result.error || 'Erro ao cadastrar funcionário');
            }

            btnCadastrar.disabled = false;
            btnCadastrar.innerHTML = '<i class="fa-solid fa-save"></i> Cadastrar Funcionário';
        });
    }
}

function showCadastroStatus(type, message) {
    const statusDiv = document.getElementById('cadastroStatus');
    statusDiv.className = `form-status ${type}`;
    statusDiv.innerHTML = `<i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i> ${message}`;
    statusDiv.style.display = 'block';
}

function hideCadastroStatus() {
    document.getElementById('cadastroStatus').style.display = 'none';
}

function validarCPF(cpf) {
    cpf = cpf.replace(/\D/g, '');
    
    if (cpf.length !== 11) return false;
    if (/^(\d)\1{10}$/.test(cpf)) return false;

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

// ========================================
// LISTAGEM DE FUNCIONÁRIOS
// ========================================
function initListagem() {
    const searchInput = document.getElementById('searchFuncionario');
    const filterCentro = document.getElementById('filterCentroCusto');
    
    if (searchInput) {
        searchInput.addEventListener('input', () => {
            const filtro = searchInput.value;
            const centro = filterCentro ? filterCentro.value : '';
            renderFuncionarios(filtro, centro);
        });
    }

    if (filterCentro) {
        filterCentro.addEventListener('change', () => {
            const filtro = searchInput ? searchInput.value : '';
            renderFuncionarios(filtro, filterCentro.value);
        });
    }
}

async function renderFuncionarios(filtro = '', centroCusto = '') {
    const tbody = document.getElementById('tabelaFuncionarios');
    tbody.innerHTML = '<tr><td colspan="6" class="empty-state"><i class="fas fa-spinner fa-spin"></i><p>Carregando...</p></td></tr>';

    // Buscar funcionários do Supabase
    const result = await listarColaboradores(filtro, centroCusto);

    if (!result.success || result.data.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="6" class="empty-state">
                    <i class="fa-solid fa-users-slash"></i>
                    <p>${filtro || centroCusto ? 'Nenhum funcionário encontrado' : 'Nenhum funcionário cadastrado ainda'}</p>
                </td>
            </tr>
        `;
        return;
    }

    // Cores por centro de custo
    const coresCentro = {
        'UPA GLEBA-A': '#1976d2',
        'UPA LUCAS EVANGELISTA': '#388e3c',
        'AMEX': '#f57c00',
        'LAMAC': '#7b1fa2'
    };

    // Renderizar funcionários
    tbody.innerHTML = result.data.map(func => {
        const cor = coresCentro[func.centro_custo] || '#666';
        return `
        <tr>
            <td>${func.codigo_funcionario || '-'}</td>
            <td>${func.nome_completo}</td>
            <td>${formatarCPF(func.cpf)}</td>
            <td>
                ${func.centro_custo 
                    ? `<span style="background:${cor}20; color:${cor}; padding:3px 10px; border-radius:12px; font-size:0.75rem; font-weight:600; border:1px solid ${cor}40; white-space:nowrap; display:inline-block;">${func.centro_custo}</span>`
                    : '<span style="color:#999; font-size:0.85rem;">—</span>'
                }
            </td>
            <td>
                <span class="badge ${func.ativo ? 'success' : 'danger'}">
                    ${func.ativo ? 'Ativo' : 'Inativo'}
                </span>
            </td>
            <td>
                <button class="btn-action edit" onclick="editarFuncionario('${func.id}')" title="Editar">
                    <i class="fas fa-edit"></i>
                </button>
                <button class="btn-action delete" onclick="deletarFuncionario('${func.id}', '${func.nome_completo}')" title="Excluir">
                    <i class="fas fa-trash"></i>
                </button>
            </td>
        </tr>
    `}).join('');
}

async function editarFuncionario(id) {
    // Buscar dados do funcionário
    const result = await buscarColaborador(id);
    
    if (!result.success) {
        alert('Erro ao buscar dados do funcionário: ' + result.error);
        return;
    }
    
    const func = result.data;
    
    // Preencher o modal com os dados
    document.getElementById('editId').value = func.id;
    document.getElementById('editNome').value = func.nome_completo;
    document.getElementById('editCodigo').value = func.codigo_funcionario || '';
    document.getElementById('editCPF').value = formatarCPF(func.cpf);
    document.getElementById('editEmail').value = func.email || '';
    document.getElementById('editSenha').value = '';
    document.getElementById('editStatus').value = func.ativo ? 'ativo' : 'inativo';
    document.getElementById('editCentroCusto').value = func.centro_custo || '';
    
    // Mostrar modal
    document.getElementById('modalEditarFuncionario').style.display = 'flex';
}

// Inicializar modal de edição
function initModalEdicao() {
    const modal = document.getElementById('modalEditarFuncionario');
    const btnClose = document.getElementById('btnCloseModal');
    const btnCancelar = document.getElementById('btnCancelarEdicao');
    const formEditar = document.getElementById('formEditarFuncionario');
    const toggleSenha = document.getElementById('toggleEditSenha');
    const inputSenha = document.getElementById('editSenha');
    
    // Fechar modal ao clicar no X ou Cancelar
    btnClose.addEventListener('click', () => {
        modal.style.display = 'none';
    });
    
    btnCancelar.addEventListener('click', () => {
        modal.style.display = 'none';
    });
    
    // Fechar modal ao clicar fora
    modal.addEventListener('click', (e) => {
        if (e.target === modal) {
            modal.style.display = 'none';
        }
    });
    
    // Toggle mostrar/ocultar senha
    toggleSenha.addEventListener('click', () => {
        const type = inputSenha.type === 'password' ? 'text' : 'password';
        inputSenha.type = type;
        const icon = toggleSenha.querySelector('i');
        icon.classList.toggle('fa-eye');
        icon.classList.toggle('fa-eye-slash');
    });
    
    // Submeter edição
    formEditar.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const btnSalvar = document.getElementById('btnSalvarEdicao');
        btnSalvar.disabled = true;
        btnSalvar.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Salvando...';
        
        const id = document.getElementById('editId').value;
        const nome = document.getElementById('editNome').value.trim();
        const codigo = document.getElementById('editCodigo').value.trim().toUpperCase();
        const email = document.getElementById('editEmail').value.trim();
        const senha = document.getElementById('editSenha').value.trim();
        const status = document.getElementById('editStatus').value;
        const centroCusto = document.getElementById('editCentroCusto').value;
        
        // Validação do código
        if (!codigo) {
            alert('O código do funcionário é obrigatório!');
            btnSalvar.disabled = false;
            btnSalvar.innerHTML = '<i class="fa-solid fa-save"></i> Salvar Alterações';
            return;
        }

        // Validação do centro de custo
        if (!centroCusto) {
            alert('Selecione o Centro de Custo!');
            btnSalvar.disabled = false;
            btnSalvar.innerHTML = '<i class="fa-solid fa-save"></i> Salvar Alterações';
            return;
        }
        
        // Montar dados para atualização
        const dados = {
            nome,
            codigo_funcionario: codigo,
            email: email || null,
            status,
            centro_custo: centroCusto
        };
        
        // Adicionar senha apenas se foi preenchida
        if (senha) {
            if (senha.length < 6) {
                alert('A senha deve ter no mínimo 6 caracteres!');
                btnSalvar.disabled = false;
                btnSalvar.innerHTML = '<i class="fa-solid fa-save"></i> Salvar Alterações';
                return;
            }
            dados.senha = senha;
        }
        
        // Atualizar no Supabase
        const result = await atualizarColaborador(id, dados);
        
        if (result.success) {
            alert('Funcionário atualizado com sucesso!');
            modal.style.display = 'none';
            renderFuncionarios();
            atualizarEstatisticas();
        } else {
            alert('Erro ao atualizar funcionário: ' + result.error);
        }
        
        btnSalvar.disabled = false;
        btnSalvar.innerHTML = '<i class="fa-solid fa-save"></i> Salvar Alterações';
    });
}

async function deletarFuncionario(id, nome) {
    if (!confirm(`Deseja realmente excluir o funcionário:\n${nome}?\n\nEsta ação não pode ser desfeita!`)) {
        return;
    }

    const result = await deletarColaborador(id);

    if (result.success) {
        alert('Funcionário excluído com sucesso!');
        renderFuncionarios();
        atualizarEstatisticas();
    } else {
        alert('Erro ao excluir funcionário: ' + result.error);
    }
}

// ========================================
// UPLOAD DE DOCUMENTOS
// ========================================
function initUpload() {
    const formUpload = document.getElementById('formUpload');
    const uploadArea = document.getElementById('uploadArea');
    const uploadFile = document.getElementById('uploadFile');
    const uploadPreview = document.getElementById('uploadPreview');
    const btnRemove = document.getElementById('btnRemoveFile');
    const uploadTipo = document.getElementById('uploadTipo');
    const groupMes = document.getElementById('groupMes');
    const uploadMes = document.getElementById('uploadMes');
    const btnEnviarTexto = document.getElementById('btnEnviarTexto');
    let selectedFile = null;

    // Controlar exibição do campo Mês baseado no tipo
    uploadTipo.addEventListener('change', function() {
        if (this.value === 'informe_ir') {
            groupMes.style.display = 'none';
            uploadMes.removeAttribute('required');
            btnEnviarTexto.textContent = 'Enviar Informe de IR';
        } else if (this.value === 'contracheque') {
            groupMes.style.display = 'block';
            uploadMes.setAttribute('required', 'required');
            btnEnviarTexto.textContent = 'Enviar Contracheque';
        } else {
            groupMes.style.display = 'block';
            uploadMes.setAttribute('required', 'required');
            btnEnviarTexto.textContent = 'Enviar Documento';
        }
    });

    // Click para selecionar arquivo
    uploadArea.addEventListener('click', (e) => {
        if (e.target.classList.contains('btn-remove') || e.target.closest('.btn-remove')) return;
        uploadFile.click();
    });

    // Drag and drop
    uploadArea.addEventListener('dragover', (e) => {
        e.preventDefault();
        uploadArea.classList.add('dragover');
    });

    uploadArea.addEventListener('dragleave', () => {
        uploadArea.classList.remove('dragover');
    });

    uploadArea.addEventListener('drop', (e) => {
        e.preventDefault();
        uploadArea.classList.remove('dragover');
        
        const file = e.dataTransfer.files[0];
        if (file) handleFileSelect(file);
    });

    // Arquivo selecionado
    uploadFile.addEventListener('change', (e) => {
        const file = e.target.files[0];
        if (file) handleFileSelect(file);
    });

    // Remover arquivo
    btnRemove.addEventListener('click', (e) => {
        e.stopPropagation();
        selectedFile = null;
        uploadFile.value = '';
        document.querySelector('.upload-content').style.display = 'flex';
        uploadPreview.style.display = 'none';
    });

    // Limpar formulário
    document.getElementById('btnLimparUpload').addEventListener('click', () => {
        formUpload.reset();
        selectedFile = null;
        uploadFile.value = '';
        document.querySelector('.upload-content').style.display = 'flex';
        uploadPreview.style.display = 'none';
        groupMes.style.display = 'block';
        uploadMes.setAttribute('required', 'required');
        btnEnviarTexto.textContent = 'Enviar Documento';
        hideUploadStatus();
    });

    // Submissão do formulário
    formUpload.addEventListener('submit', async (e) => {
        e.preventDefault();

        const btnEnviar = document.getElementById('btnEnviar');
        btnEnviar.disabled = true;
        btnEnviar.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Enviando...';

        const colaboradorId = document.getElementById('uploadFuncionario').value;
        const tipoDocumento = document.getElementById('uploadTipo').value;
        const mes = tipoDocumento === 'informe_ir' ? 'Anual' : document.getElementById('uploadMes').value;
        const ano = document.getElementById('uploadAno').value;

        if (!selectedFile) {
            showUploadStatus('error', 'Selecione um arquivo PDF');
            btnEnviar.disabled = false;
            btnEnviar.innerHTML = '<i class="fa-solid fa-paper-plane"></i> <span id="btnEnviarTexto">Enviar Documento</span>';
            return;
        }

        // Upload para o Supabase
        const result = await uploadDocumento(colaboradorId, mes, ano, selectedFile, tipoDocumento);

        if (result.success) {
            const tipoTexto = tipoDocumento === 'informe_ir' ? 'Informe de IR' : 'Contracheque';
            const mensagem = result.updated 
                ? `${tipoTexto} atualizado com sucesso!` 
                : `${tipoTexto} enviado com sucesso!`;
            showUploadStatus('success', mensagem);
            formUpload.reset();
            selectedFile = null;
            uploadFile.value = '';
            document.querySelector('.upload-content').style.display = 'flex';
            uploadPreview.style.display = 'none';
            groupMes.style.display = 'block';
            uploadMes.setAttribute('required', 'required');
            btnEnviarTexto.textContent = 'Enviar Documento';
            atualizarEstatisticas();
            
            setTimeout(() => {
                hideUploadStatus();
            }, 3000);
        } else {
            showUploadStatus('error', result.error || 'Erro ao enviar documento');
        }

        btnEnviar.disabled = false;
        btnEnviar.innerHTML = '<i class="fa-solid fa-paper-plane"></i> <span id="btnEnviarTexto">Enviar Documento</span>';
    });

    function handleFileSelect(file) {
        // Validações
        if (file.type !== 'application/pdf') {
            alert('Apenas arquivos PDF são permitidos!');
            return;
        }

        if (file.size > 10 * 1024 * 1024) {
            alert('O arquivo deve ter no máximo 10MB!');
            return;
        }

        selectedFile = file;

        // Mostrar preview
        document.querySelector('.upload-content').style.display = 'none';
        uploadPreview.style.display = 'flex';
        document.getElementById('fileName').textContent = file.name;
        document.getElementById('fileSize').textContent = formatarTamanho(file.size);
    }
}

async function popularSelectFuncionarios() {
    const select = document.getElementById('uploadFuncionario');
    select.innerHTML = '<option value="">Carregando...</option>';

    const result = await listarColaboradores();

    if (result.success && result.data.length > 0) {
        const ativos = result.data.filter(f => f.ativo);
        
        select.innerHTML = '<option value="">Escolha um funcionário...</option>' +
            ativos.map(func => `<option value="${func.id}">${func.nome_completo} - ${formatarCPF(func.cpf)}</option>`).join('');
    } else {
        select.innerHTML = '<option value="">Nenhum funcionário ativo</option>';
    }
}

function showUploadStatus(type, message) {
    const statusDiv = document.getElementById('uploadStatus');
    statusDiv.className = `form-status ${type}`;
    statusDiv.innerHTML = `<i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i> ${message}`;
    statusDiv.style.display = 'block';
}

function hideUploadStatus() {
    document.getElementById('uploadStatus').style.display = 'none';
}

function formatarTamanho(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
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

async function renderHistorico(filtroMes = '') {
    const tbody = document.getElementById('tabelaHistorico');
    tbody.innerHTML = '<tr><td colspan="5" class="empty-state"><i class="fas fa-spinner fa-spin"></i><p>Carregando...</p></td></tr>';

    const result = await listarHistorico(filtroMes);

    if (!result.success || result.data.length === 0) {
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

    tbody.innerHTML = result.data.map(item => `
        <tr>
            <td>${item.colaboradores.nome_completo}</td>
            <td>${item.mes_referencia}/${item.ano}</td>
            <td>${formatarData(item.enviado_em)}</td>
            <td>${formatarTamanho(item.tamanho_arquivo)}</td>
            <td>
                <span class="badge success">Enviado</span>
            </td>
        </tr>
    `).join('');
}

function formatarData(data) {
    return new Date(data).toLocaleString('pt-BR', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
}

function formatarCPF(cpf) {
    return cpf.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4');
}

// ========================================
// AUXILIARES
// ========================================
function populateYearSelect() {
    const select = document.getElementById('uploadAno');
    const currentYear = new Date().getFullYear();
    
    for (let i = currentYear; i >= currentYear - 5; i--) {
        const option = document.createElement('option');
        option.value = i;
        option.textContent = i;
        select.appendChild(option);
    }
}

console.log('✅ Admin RH (com Supabase) carregado!');

// ========================================
// RECIBOS DE DOCUMENTOS
// ========================================

/**
 * Carregar dados da seção de recibos
 */
async function carregarRecibos() {
    console.log('📝 Carregando seção de recibos...');
    
    try {
        // Buscar estatísticas
        const stats = await buscarEstatisticasRecibos();
        if (stats.success) {
            // Atualizar cards de estatísticas
            document.getElementById('totalRecibos').textContent = stats.data.total || 0;
            document.getElementById('totalContrachequeRecibo').textContent = stats.data.porTipo.contracheque || 0;
            document.getElementById('totalInformesRecibo').textContent = stats.data.porTipo.informe_ir || 0;
            document.getElementById('totalSemRecibo').textContent = stats.data.semRecibo || 0;
        }

        // Buscar recibos com filtros
        const filtros = {
            tipoDocumento: document.getElementById('filtroTipoRecibo').value,
            ano: document.getElementById('filtroAnoRecibo').value
        };

        const recibos = await buscarTodosRecibos(filtros);
        if (recibos.success) {
            renderizarTabelaRecibosLocal(recibos.data);
        }

        // Buscar documentos sem recibo
        const semRecibo = await buscarDocumentosSemRecibo();
        if (semRecibo.success) {
            renderizarDocsSemRecibo(semRecibo.data);
        }

    } catch (error) {
        console.error('❌ Erro ao carregar recibos:', error);
    }
}

/**
 * Renderizar tabela de recibos (versão local adaptada)
 */
function renderizarTabelaRecibosLocal(recibos) {
    const tbody = document.getElementById('tabelaRecibos');
    
    if (!recibos || recibos.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="7" class="empty-state">
                    <i class="fa-solid fa-inbox"></i>
                    <p>Nenhum recibo registrado ainda</p>
                </td>
            </tr>
        `;
        return;
    }

    tbody.innerHTML = recibos.map(recibo => `
        <tr>
            <td>
                <strong>${recibo.nome_completo}</strong>
                ${recibo.email ? `<br><small style="color: #666;">${recibo.email}</small>` : ''}
            </td>
            <td>${formatarCPF(recibo.cpf)}</td>
            <td>
                <span class="badge" style="background: ${recibo.tipo_documento === 'informe_ir' ? '#ff6b35' : '#0066cc'}; color: white; padding: 4px 12px; border-radius: 12px; font-size: 0.85rem;">
                    ${recibo.tipo_documento === 'informe_ir' ? 'Informe IR' : 'Contracheque'}
                </span>
            </td>
            <td>
                ${recibo.tipo_documento === 'informe_ir' 
                    ? `Ano ${recibo.ano}` 
                    : `${recibo.mes_referencia}/${recibo.ano}`
                }
            </td>
            <td>${formatarDataHora(recibo.data_recebimento)}</td>
            <td><small>${recibo.ip_address || '-'}</small></td>
            <td>
                <button 
                    class="btn-icon" 
                    onclick="visualizarDetalheReciboLocal('${recibo.recibo_id}')"
                    title="Ver detalhes"
                    style="background: #0066cc; color: white; border: none; padding: 8px 12px; border-radius: 6px; cursor: pointer;"
                >
                    <i class="fa-solid fa-eye"></i>
                </button>
            </td>
        </tr>
    `).join('');
}

/**
 * Renderizar documentos sem recibo
 */
function renderizarDocsSemRecibo(docs) {
    const container = document.getElementById('docsSemRecibo');
    
    if (!docs || docs.length === 0) {
        container.innerHTML = '<p style="margin: 0; color: #28a745;"><i class="fa-solid fa-check-circle"></i> Todos os documentos possuem recibo!</p>';
        return;
    }

    container.innerHTML = `
        <p style="margin: 0 0 12px 0; color: #856404;">
            <strong>${docs.length}</strong> documento(s) aguardando recibo:
        </p>
        <ul style="margin: 0; padding-left: 20px; color: #856404;">
            ${docs.map(doc => `
                <li style="margin-bottom: 8px;">
                    <strong>${doc.colaboradores.nome_completo}</strong> - 
                    ${doc.tipo_documento === 'informe_ir' ? 'Informe IR' : 'Contracheque'} 
                    ${doc.mes_referencia ? doc.mes_referencia + '/' : ''}${doc.ano}
                    <small style="color: #999;">(Enviado em ${formatarDataHora(doc.enviado_em)})</small>
                </li>
            `).join('')}
        </ul>
    `;
}

/**
 * Visualizar detalhes do recibo (modal)
 */
async function visualizarDetalheReciboLocal(reciboId) {
    try {
        console.log('🔍 Buscando detalhes do recibo:', reciboId);

        const { data, error } = await window.supabaseClient
            .from('view_recibos_completos')
            .select('*')
            .eq('recibo_id', reciboId)
            .single();

        if (error) throw error;

        // 🐛 DEBUG: Verificar campos da assinatura
        console.log('📋 DADOS COMPLETOS DO RECIBO:', data);
        console.log('🔍 assinatura_canvas:', data.assinatura_canvas ? 'EXISTE ✅' : 'NÃO EXISTE ❌');
        console.log('🔍 assinatura_digital:', data.assinatura_digital ? 'EXISTE ✅' : 'NÃO EXISTE ❌');
        console.log('🔍 assinatura_texto:', data.assinatura_texto);
        
        if (data.assinatura_canvas) {
            console.log('✅ Preview da assinatura:', data.assinatura_canvas.substring(0, 50) + '...');
        }

        // Chamar função do recibo-admin.js se existir
        if (typeof mostrarModalDetalheRecibo === 'function') {
            mostrarModalDetalheRecibo(data);
        } else {
            // Fallback: mostrar alert com informações
            alert(`📄 DETALHES DO RECIBO\n\n` +
                  `Colaborador: ${data.nome_completo}\n` +
                  `CPF: ${formatarCPF(data.cpf)}\n` +
                  `Documento: ${data.tipo_documento === 'informe_ir' ? 'Informe IR' : 'Contracheque'}\n` +
                  `Período: ${data.tipo_documento === 'informe_ir' ? 'Ano ' + data.ano : data.mes_referencia + '/' + data.ano}\n` +
                  `Assinatura: ${data.assinatura_texto}\n` +
                  `Data Recebimento: ${formatarDataHora(data.data_recebimento)}\n` +
                  `IP: ${data.ip_address || '-'}`);
        }

    } catch (error) {
        console.error('❌ Erro ao buscar detalhes do recibo:', error);
        alert('Erro ao carregar detalhes do recibo');
    }
}

console.log('✅ Funções de Recibos carregadas!');
