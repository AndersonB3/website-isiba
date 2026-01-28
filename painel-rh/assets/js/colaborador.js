/* ========================================
   PORTAL DO COLABORADOR - JAVASCRIPT
   ======================================== */

// Inicialização
document.addEventListener('DOMContentLoaded', () => {
    initCPFMask();
    initPasswordToggle();
    initFormValidation();
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
        const lembrarMe = document.getElementById('lembrarMe').checked;
        
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
        btnLogin.innerHTML = '<i class="fas fa-circle-notch"></i> Autenticando...';
        
        try {
            // TODO: Integração com Supabase
            // Por enquanto, simula uma autenticação
            await simulateLogin(cpf, senha);
            
            // Se chegou aqui, login foi bem-sucedido
            showStatus('success', 'Login realizado com sucesso! Redirecionando...');
            
            // Salva preferência de "lembrar-me"
            if (lembrarMe) {
                localStorage.setItem('rememberMe', 'true');
                localStorage.setItem('lastCPF', cpf);
            } else {
                localStorage.removeItem('rememberMe');
                localStorage.removeItem('lastCPF');
            }
            
            // Redireciona após 1.5 segundos
            setTimeout(() => {
                // TODO: Redirecionar para dashboard do colaborador
                window.location.href = 'meus-contracheques.html';
            }, 1500);
            
        } catch (error) {
            showStatus('error', error.message || 'Erro ao fazer login. Tente novamente.');
            
            // Reabilita o botão
            btnLogin.disabled = false;
            btnLogin.classList.remove('loading');
            btnLogin.innerHTML = '<i class="fas fa-sign-in-alt"></i> Entrar';
        }
    });
}

// Função temporária para simular login (será substituída pela integração com Supabase)
async function simulateLogin(cpf, senha) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            // Simula uma verificação
            // TODO: Substituir pela autenticação real com Supabase
            
            // Por enquanto, aceita qualquer CPF válido com senha "123456" para testes
            if (senha === '123456') {
                resolve({ success: true });
            } else {
                reject(new Error('CPF ou senha incorretos.'));
            }
        }, 1500); // Simula delay de rede
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
    const rememberMe = localStorage.getItem('rememberMe');
    const lastCPF = localStorage.getItem('lastCPF');
    
    if (rememberMe === 'true' && lastCPF) {
        const cpfInput = document.getElementById('cpf');
        const lembrarMeCheckbox = document.getElementById('lembrarMe');
        
        if (cpfInput) cpfInput.value = lastCPF;
        if (lembrarMeCheckbox) lembrarMeCheckbox.checked = true;
    }
});

/* ========================================
   INTEGRAÇÃO SUPABASE (FUTURO)
   ======================================== */

// TODO: Adicionar integração com Supabase
// Substituir a função simulateLogin() por:
/*
async function loginWithSupabase(cpf, senha) {
    // 1. Hash do CPF (para buscar no banco)
    // 2. Autenticação com Supabase Auth
    // 3. Verificação de usuário ativo
    // 4. Retornar dados do colaborador
}
*/

// TODO: Adicionar verificação de sessão ativa
/*
async function checkSession() {
    const { data: { session } } = await supabase.auth.getSession();
    if (session) {
        // Já está logado, redireciona para dashboard
        window.location.href = 'meus-contracheques.html';
    }
