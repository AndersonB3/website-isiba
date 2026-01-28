/* ========================================
   PORTAL DO COLABORADOR - LOGIN
   INTEGRADO COM SUPABASE
   ======================================== */

// Inicialização
document.addEventListener('DOMContentLoaded', () => {
    // Verificar se Supabase foi inicializado
    if (!window.supabaseClient) {
        console.error('❌ Erro: Supabase não foi inicializado!');
        showStatus('error', 'Erro ao conectar com o banco de dados. Atualize a página.');
        return;
    }

    // Verificar se já está logado
    const colaboradorData = sessionStorage.getItem('colaborador_data');
    if (colaboradorData) {
        window.location.href = 'meus-contracheques.html';
        return;
    }

    initCPFMask();
    initPasswordToggle();
    initFormSubmit();
});

/* ========================================
   MÁSCARA DO CPF
   ======================================== */
function initCPFMask() {
    const cpfInput = document.getElementById('cpf');
    
    if (!cpfInput) return;

    cpfInput.addEventListener('input', (e) => {
        let value = e.target.value.replace(/\D/g, ''); // Remove tudo que não é número
        
        // Limita a 11 dígitos
        value = value.substring(0, 11);
        
        // Aplica a máscara XXX.XXX.XXX-XX
        if (value.length > 9) {
            value = value.replace(/(\d{3})(\d{3})(\d{3})(\d{0,2})/, '$1.$2.$3-$4');
        } else if (value.length > 6) {
            value = value.replace(/(\d{3})(\d{3})(\d{0,3})/, '$1.$2.$3');
        } else if (value.length > 3) {
            value = value.replace(/(\d{3})(\d{0,3})/, '$1.$2');
        }
        
        e.target.value = value;
    });

    // Permite apenas números e caracteres de formatação
    cpfInput.addEventListener('keypress', (e) => {
        const char = String.fromCharCode(e.keyCode);
        if (!/[0-9]/.test(char)) {
            e.preventDefault();
        }
    });
}

/* ========================================
   TOGGLE MOSTRAR/OCULTAR SENHA
   ======================================== */
function initPasswordToggle() {
    const toggleButton = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('senha');
    
    if (!toggleButton || !passwordInput) return;

    toggleButton.addEventListener('click', () => {
        const type = passwordInput.type === 'password' ? 'text' : 'password';
        passwordInput.type = type;
        
        const icon = toggleButton.querySelector('i');
        icon.classList.toggle('fa-eye');
        icon.classList.toggle('fa-eye-slash');
    });
}

/* ========================================
   SUBMIT DO FORMULÁRIO
   ======================================== */
function initFormSubmit() {
    const form = document.getElementById('loginForm');
    const btnLogin = document.getElementById('btnLogin');
    
    if (!form) return;

    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const cpf = document.getElementById('cpf').value.trim();
        const senha = document.getElementById('senha').value.trim();
        const remember = document.getElementById('remember') ? document.getElementById('remember').checked : false;
        
        // Validações
        if (!cpf || !senha) {
            showStatus('error', 'Por favor, preencha todos os campos');
            return;
        }

        const cpfLimpo = cpf.replace(/\D/g, '');
        if (cpfLimpo.length !== 11) {
            showStatus('error', 'CPF inválido. Digite 11 dígitos');
            return;
        }

        if (senha.length < 6) {
            showStatus('error', 'A senha deve ter no mínimo 6 caracteres');
            return;
        }

        // Desabilitar botão durante login
        btnLogin.disabled = true;
        const originalHtml = btnLogin.innerHTML;
        btnLogin.innerHTML = '<i class="fas fa-spinner fa-spin"></i> <span>Autenticando...</span>';

        try {
            // Autenticar com Supabase
            const result = await autenticarColaborador(cpf, senha);

            if (!result.success) {
                throw new Error(result.error || 'CPF ou senha incorretos');
            }

            // Salvar dados na sessão
            sessionStorage.setItem('colaborador_data', JSON.stringify(result.data));
            
            // Se "Lembrar-me" estiver marcado, salvar CPF
            if (remember) {
                localStorage.setItem('colaborador_cpf', cpf);
            } else {
                localStorage.removeItem('colaborador_cpf');
            }

            showStatus('success', 'Login realizado com sucesso! Redirecionando...');
            
            // Redirecionar para o dashboard
            setTimeout(() => {
                window.location.href = 'meus-contracheques.html';
            }, 1000);

        } catch (error) {
            console.error('Erro no login:', error);
            showStatus('error', error.message || 'Erro ao fazer login. Tente novamente.');
            btnLogin.disabled = false;
            btnLogin.innerHTML = originalHtml;
        }
    });

    // Carregar CPF salvo (se existir)
    const cpfSalvo = localStorage.getItem('colaborador_cpf');
    if (cpfSalvo) {
        const cpfInput = document.getElementById('cpf');
        const rememberCheck = document.getElementById('remember');
        if (cpfInput) cpfInput.value = cpfSalvo;
        if (rememberCheck) rememberCheck.checked = true;
    }
}

/* ========================================
   MOSTRAR STATUS
   ======================================== */
function showStatus(type, message) {
    const statusDiv = document.getElementById('loginStatus');
    if (!statusDiv) return;

    statusDiv.className = `login-status ${type}`;
    statusDiv.innerHTML = `
        <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
        <span>${message}</span>
    `;
    statusDiv.style.display = 'flex';

    // Auto-ocultar mensagem de erro após 5 segundos
    if (type === 'error') {
        setTimeout(() => {
            statusDiv.style.display = 'none';
        }, 5000);
    }
}

console.log('✅ Portal do Colaborador (Login) carregado!');


/* ========================================
   MÁSCARA DO CPF
   ======================================== */
function initCPFMask() {
    const cpfInput = document.getElementById('cpf');
    
    if (!cpfInput) return;

    cpfInput.addEventListener('input', (e) => {
        let value = e.target.value.replace(/\D/g, ''); // Remove tudo que não é número
        
        // Limita a 11 dígitos
        value = value.substring(0, 11);
        
        // Aplica a máscara XXX.XXX.XXX-XX
        if (value.length > 9) {
            value = value.replace(/(\d{3})(\d{3})(\d{3})(\d{0,2})/, '$1.$2.$3-$4');
        } else if (value.length > 6) {
            value = value.replace(/(\d{3})(\d{3})(\d{0,3})/, '$1.$2.$3');
        } else if (value.length > 3) {
            value = value.replace(/(\d{3})(\d{0,3})/, '$1.$2');
        }
        
        e.target.value = value;
    });

    // Permite apenas números e caracteres de formatação
    cpfInput.addEventListener('keypress', (e) => {
        const char = String.fromCharCode(e.keyCode);
        if (!/[0-9]/.test(char)) {
            e.preventDefault();
        }
    });
}

/* ========================================
   TOGGLE MOSTRAR/OCULTAR SENHA
   ======================================== */
function initPasswordToggle() {
    const toggleBtn = document.getElementById('togglePassword');
    const passwordInput = document.getElementById('senha');
    
    if (!toggleBtn || !passwordInput) return;

    toggleBtn.addEventListener('click', () => {
        const type = passwordInput.getAttribute('type');
        
        if (type === 'password') {
            passwordInput.setAttribute('type', 'text');
            toggleBtn.innerHTML = '<i class="fas fa-eye-slash"></i>';
        } else {
            passwordInput.setAttribute('type', 'password');
            toggleBtn.innerHTML = '<i class="fas fa-eye"></i>';
        }
    });
}

/* ========================================
   VALIDAÇÃO DO FORMULÁRIO
   ======================================== */
function initFormValidation() {
    const cpfInput = document.getElementById('cpf');
    const senhaInput = document.getElementById('senha');
    
    // Validação em tempo real
    if (cpfInput) {
        cpfInput.addEventListener('blur', () => {
            validateCPF(cpfInput.value);
        });
    }
    
    if (senhaInput) {
        senhaInput.addEventListener('input', () => {
            validatePassword(senhaInput.value);
        });
    }
}

// Valida CPF
function validateCPF(cpf) {
    // Remove formatação
    const cleanCPF = cpf.replace(/\D/g, '');
    
    // Verifica se tem 11 dígitos
    if (cleanCPF.length !== 11) {
        return false;
    }
    
    // Verifica se todos os dígitos são iguais (CPF inválido)
    if (/^(\d)\1{10}$/.test(cleanCPF)) {
        return false;
    }
    
    // Validação dos dígitos verificadores
    let soma = 0;
    let resto;
    
    // Primeiro dígito verificador
    for (let i = 1; i <= 9; i++) {
        soma += parseInt(cleanCPF.substring(i - 1, i)) * (11 - i);
    }
    resto = (soma * 10) % 11;
    if (resto === 10 || resto === 11) resto = 0;
    if (resto !== parseInt(cleanCPF.substring(9, 10))) return false;
    
    // Segundo dígito verificador
    soma = 0;
    for (let i = 1; i <= 10; i++) {
        soma += parseInt(cleanCPF.substring(i - 1, i)) * (12 - i);
    }
    resto = (soma * 10) % 11;
    if (resto === 10 || resto === 11) resto = 0;
    if (resto !== parseInt(cleanCPF.substring(10, 11))) return false;
    
    return true;
}

// Valida senha
function validatePassword(password) {
    if (password.length < 6) {
        return false;
    }
    return true;
}

/* ========================================
   SUBMISSÃO DO FORMULÁRIO
   ======================================== */
function initFormSubmit() {
    const form = document.getElementById('loginForm');
    const btnLogin = document.getElementById('btnLogin');
    const statusDiv = document.getElementById('loginStatus');
    
    if (!form) return;
    
    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        // Obtém os valores
        const cpf = document.getElementById('cpf').value;
        const senha = document.getElementById('senha').value;
        const lembrarCheckbox = document.getElementById('lembrar');
        const lembrarMe = lembrarCheckbox ? lembrarCheckbox.checked : false;
        
        // Validações
        if (!validateCPF(cpf)) {
            showStatus('error', 'CPF inválido. Verifique e tente novamente.');
            return;
        }
        
        if (!validatePassword(senha)) {
            showStatus('error', 'A senha deve ter no mínimo 6 caracteres.');
            return;
        }
        
        // Desabilita o botão e mostra loading
        btnLogin.disabled = true;
        btnLogin.classList.add('loading');
        btnLogin.innerHTML = '<i class="fas fa-circle-notch fa-spin"></i> Autenticando...';
        
        try {
            // Autenticar com Supabase
            const resultado = await autenticarColaborador(cpf, senha);
            
            if (!resultado.success) {
                throw new Error(resultado.error);
            }
            
            // Login bem-sucedido
            showStatus('success', 'Login realizado com sucesso! Redirecionando...');
            
            // Salvar dados do colaborador na sessão
            sessionStorage.setItem('colaborador_data', JSON.stringify(resultado.data));
            
            // Salvar preferência de "lembrar-me"
            if (lembrarMe) {
                localStorage.setItem('colaborador_cpf', cpf);
            } else {
                localStorage.removeItem('colaborador_cpf');
            }
            
            // Redirecionar para dashboard
            setTimeout(() => {
                window.location.href = 'meus-contracheques.html';
            }, 1000);
            
        } catch (error) {
            showStatus('error', error.message || 'Erro ao fazer login. Tente novamente.');
            
            // Reabilita o botão
            btnLogin.disabled = false;
            btnLogin.classList.remove('loading');
            btnLogin.innerHTML = '<i class="fa-solid fa-right-to-bracket"></i> <span>Entrar</span>';
        }
    });
}

// Mostra mensagem de status
function showStatus(type, message) {
    const statusDiv = document.getElementById('loginStatus');
    
    if (!statusDiv) return;
    
    // Remove classes anteriores
    statusDiv.className = 'login-status';
    
    // Adiciona nova classe e mensagem
    statusDiv.classList.add(type);
    statusDiv.textContent = message;
    statusDiv.style.display = 'block';
    
    // Auto-oculta mensagens de erro após 5 segundos
    if (type === 'error') {
        setTimeout(() => {
            statusDiv.style.display = 'none';
        }, 5000);
    }
}

/* ========================================
   RECUPERAR PREFERÊNCIAS
   ======================================== */
// Recupera CPF salvo se "lembrar-me" estava marcado
window.addEventListener('load', () => {
    const cpfSalvo = localStorage.getItem('colaborador_cpf');
    const lembrarCheckbox = document.getElementById('lembrar');
    
    if (cpfSalvo) {
        const cpfInput = document.getElementById('cpf');
        if (cpfInput) cpfInput.value = cpfSalvo;
        if (lembrarCheckbox) lembrarCheckbox.checked = true;
    }
});

console.log('✅ Portal do Colaborador (Login) carregado!');
