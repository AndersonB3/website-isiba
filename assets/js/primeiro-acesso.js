/* ========================================
   PRIMEIRO ACESSO - TROCA DE SENHA OBRIGATÓRIA
   ======================================== */

// ========================================
// SISTEMA DE TOAST NOTIFICATION (Definir primeiro!)
// ========================================
function showToast(type, message) {
    // Remover toasts antigos
    const oldToasts = document.querySelectorAll('.custom-toast');
    oldToasts.forEach(toast => toast.remove());
    
    // Criar toast
    const toast = document.createElement('div');
    toast.className = `custom-toast custom-toast-${type}`;
    
    // Ícone baseado no tipo
    let icon = '';
    if (type === 'success') icon = '<i class="fas fa-check-circle"></i>';
    else if (type === 'error') icon = '<i class="fas fa-exclamation-circle"></i>';
    else if (type === 'warning') icon = '<i class="fas fa-exclamation-triangle"></i>';
    else if (type === 'info') icon = '<i class="fas fa-info-circle"></i>';
    
    toast.innerHTML = `
        <div class="toast-icon">${icon}</div>
        <div class="toast-message">${message}</div>
        <button class="toast-close" onclick="this.parentElement.remove()">
            <i class="fas fa-times"></i>
        </button>
    `;
    
    document.body.appendChild(toast);
    
    // Animar entrada
    setTimeout(() => toast.classList.add('show'), 10);
    
    // Auto-remover após 5 segundos (exceto success que fica mais tempo)
    const duration = type === 'success' ? 3000 : 5000;
    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 300);
    }, duration);
}

document.addEventListener('DOMContentLoaded', () => {
    // Verificar se Supabase foi inicializado
    if (!window.supabase || !window.supabaseClient) {
        console.error('❌ Erro: Supabase não foi inicializado!');
        showToast('error', 'Erro ao conectar com o banco de dados. Verifique a configuração.');
        setTimeout(() => {
            window.location.href = 'colaborador.html';
        }, 3000);
        return;
    }

    // Verificar se tem dados do colaborador na sessão
    const colaboradorData = sessionStorage.getItem('colaborador_data');
    if (!colaboradorData) {
        showToast('error', 'Sessão expirada. Faça login novamente.');
        setTimeout(() => {
            window.location.href = 'colaborador.html';
        }, 2000);
        return;
    }

    const colaborador = JSON.parse(colaboradorData);
    
    // Atualizar nome do colaborador
    const primeiroNome = colaborador.nome.split(' ')[0];
    document.getElementById('nomeColaborador').textContent = primeiroNome;

    initPasswordToggles();
    initPasswordStrength();
    initForm(colaborador);
});

// ========================================
// TOGGLE DE SENHA
// ========================================
function initPasswordToggles() {
    const toggles = [
        { btn: 'toggleSenhaAtual', input: 'senhaAtual' },
        { btn: 'toggleNovaSenha', input: 'novaSenha' },
        { btn: 'toggleConfirmarSenha', input: 'confirmarSenha' }
    ];

    toggles.forEach(({ btn, input }) => {
        const button = document.getElementById(btn);
        const inputField = document.getElementById(input);
        
        if (button && inputField) {
            button.addEventListener('click', () => {
                const type = inputField.getAttribute('type');
                inputField.setAttribute('type', type === 'password' ? 'text' : 'password');
                button.innerHTML = type === 'password' 
                    ? '<i class="fas fa-eye-slash"></i>' 
                    : '<i class="fas fa-eye"></i>';
            });
        }
    });
}

// ========================================
// INDICADOR DE FORÇA DA SENHA
// ========================================
function initPasswordStrength() {
    const novaSenhaInput = document.getElementById('novaSenha');
    const strengthContainer = document.getElementById('passwordStrength');
    const strengthFill = document.getElementById('strengthFill');
    const strengthText = document.getElementById('strengthText');

    novaSenhaInput.addEventListener('input', (e) => {
        const password = e.target.value;
        
        if (password.length === 0) {
            strengthContainer.style.display = 'none';
            return;
        }

        strengthContainer.style.display = 'block';
        
        const strength = calculatePasswordStrength(password);
        
        // Remover classes anteriores
        strengthFill.className = 'strength-fill';
        strengthText.className = 'strength-text';
        
        // Adicionar novas classes
        strengthFill.classList.add(strength.level);
        strengthText.classList.add(strength.level);
        strengthText.textContent = strength.text;
    });
}

function calculatePasswordStrength(password) {
    let score = 0;
    
    // Critérios de força
    if (password.length >= 6) score++;
    if (password.length >= 8) score++;
    if (/[a-z]/.test(password)) score++;
    if (/[A-Z]/.test(password)) score++;
    if (/[0-9]/.test(password)) score++;
    if (/[^a-zA-Z0-9]/.test(password)) score++;
    
    if (score <= 2) {
        return { level: 'weak', text: 'Fraca - Considere uma senha mais forte' };
    } else if (score <= 4) {
        return { level: 'medium', text: 'Média - Boa senha' };
    } else {
        return { level: 'strong', text: 'Forte - Excelente senha!' };
    }
}

// ========================================
// FORMULÁRIO DE TROCA DE SENHA
// ========================================
function initForm(colaborador) {
    const form = document.getElementById('changePasswordForm');
    
    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const senhaAtual = document.getElementById('senhaAtual').value;
        const novaSenha = document.getElementById('novaSenha').value;
        const confirmarSenha = document.getElementById('confirmarSenha').value;
        
        // Validações
        if (novaSenha.length < 6) {
            showStatus('error', 'A nova senha deve ter no mínimo 6 caracteres!');
            return;
        }
        
        if (novaSenha !== confirmarSenha) {
            showStatus('error', 'As senhas não coincidem! Digite novamente.');
            return;
        }
        
        if (novaSenha === senhaAtual) {
            showStatus('error', 'A nova senha deve ser diferente da senha temporária!');
            return;
        }
        
        // Desabilitar botão
        const btnSubmit = document.getElementById('btnSubmit');
        btnSubmit.disabled = true;
        btnSubmit.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Verificando senha...';
        
        // BUSCAR HASH ATUAL DIRETO DO BANCO (não confiar na sessão!)
        console.log('🔍 [DEBUG] Buscando senha atual do banco para colaborador:', colaborador.id);
        const { data: dadosBanco, error: erroBusca } = await window.supabaseClient
            .from('colaboradores')
            .select('senha_hash')
            .eq('id', colaborador.id)
            .single();
        
        if (erroBusca) {
            console.error('❌ Erro ao buscar dados do banco:', erroBusca);
            showStatus('error', 'Erro ao verificar senha. Tente novamente.');
            btnSubmit.disabled = false;
            btnSubmit.innerHTML = '<i class="fa-solid fa-check"></i> Confirmar e Acessar Portal';
            return;
        }
        
        console.log('🔍 [DEBUG] Hash no banco:', dadosBanco.senha_hash);
        
        // Gerar hash da senha digitada
        const senhaAtualHash = await hashString(senhaAtual);
        console.log('🔍 [DEBUG] Hash da senha digitada:', senhaAtualHash);
        console.log('🔍 [DEBUG] Hashes coincidem?', senhaAtualHash === dadosBanco.senha_hash);
        
        // Verificar se a senha atual está correta (comparar com banco, não com sessão!)
        if (senhaAtualHash !== dadosBanco.senha_hash) {
            showStatus('error', 'Senha temporária incorreta! Verifique com o RH.');
            btnSubmit.disabled = false;
            btnSubmit.innerHTML = '<i class="fa-solid fa-check"></i> Confirmar e Acessar Portal';
            return;
        }
        
        console.log('✅ [DEBUG] Senha temporária correta! Atualizando...');
        btnSubmit.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Atualizando senha...';
        
        // Atualizar senha no banco de dados
        const result = await trocarSenhaPrimeiroAcesso(colaborador.id, novaSenha);
        
        if (result.success) {
            showStatus('success', '✅ Senha atualizada com sucesso! Redirecionando...');
            
            // Atualizar dados na sessão
            colaborador.primeiro_acesso = false;
            sessionStorage.setItem('colaborador_data', JSON.stringify(colaborador));
            
            // Redirecionar para o portal
            setTimeout(() => {
                window.location.href = 'portal-colaborador.html';
            }, 2000);
        } else {
            showStatus('error', 'Erro ao atualizar senha: ' + result.error);
            btnSubmit.disabled = false;
            btnSubmit.innerHTML = '<i class="fa-solid fa-check"></i> Confirmar e Acessar Portal';
        }
    });
}

// ========================================
// ATUALIZAR SENHA NO BANCO
// ========================================
async function trocarSenhaPrimeiroAcesso(colaboradorId, novaSenha) {
    try {
        console.log('🔄 Atualizando senha do colaborador:', colaboradorId);
        
        // Gerar hash da nova senha
        const novaSenhaHash = await hashString(novaSenha);
        
        // Atualizar no banco de dados
        const { data, error } = await window.supabaseClient
            .from('colaboradores')
            .update({
                senha_hash: novaSenhaHash,
                primeiro_acesso: false,
                atualizado_em: new Date().toISOString()
            })
            .eq('id', colaboradorId)
            .select();
        
        if (error) throw error;
        
        console.log('✅ Senha atualizada com sucesso!', data);
        return { success: true, data: data[0] };
        
    } catch (error) {
        console.error('❌ Erro ao trocar senha:', error);
        return { success: false, error: error.message };
    }
}

// ========================================
// MOSTRAR STATUS (MANTIDO PARA COMPATIBILIDADE)
// ========================================
function showStatus(type, message) {
    showToast(type, message);
}

console.log('✅ Primeiro Acesso carregado!');
