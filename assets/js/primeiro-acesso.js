/* ========================================
   PRIMEIRO ACESSO - TROCA DE SENHA OBRIGATÓRIA
   ======================================== */

// ========================================
// FUNÇÃO DE HASH (caso não esteja disponível)
// ========================================
if (!window.hashString) {
    window.hashString = async function(str) {
        const encoder = new TextEncoder();
        const data = encoder.encode(str);
        const hashBuffer = await crypto.subtle.digest('SHA-256', data);
        const hashArray = Array.from(new Uint8Array(hashBuffer));
        const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
        return hashHex;
    };
}

document.addEventListener('DOMContentLoaded', () => {
    console.log('🔄 [PRIMEIRO-ACESSO] Inicializando...');
    
    // Verificar se Supabase foi inicializado
    if (!window.supabaseClient) {
        console.error('❌ Erro: Supabase não foi inicializado!');
        showStatus('error', 'Erro ao conectar com o banco de dados. Verifique a configuração.');
        setTimeout(() => {
            window.location.href = 'colaborador.html';
        }, 3000);
        return;
    }

    // Verificar se tem dados do colaborador na sessão
    const colaboradorData = sessionStorage.getItem('colaborador_data');
    if (!colaboradorData) {
        showStatus('error', 'Sessão expirada. Faça login novamente.');
        setTimeout(() => {
            window.location.href = 'colaborador.html';
        }, 2000);
        return;
    }

    const colaborador = JSON.parse(colaboradorData);
    console.log('👤 Colaborador:', colaborador);

    // Inicializar requisitos como "não atendidos"
    const reqElements = ['req-length', 'req-uppercase', 'req-lowercase', 'req-number'];
    reqElements.forEach(id => {
        const element = document.getElementById(id);
        if (element) {
            element.classList.add('unmet');
        }
    });

    initPasswordStrength();
    initForm(colaborador);
    
    console.log('✅ [PRIMEIRO-ACESSO] Inicializado com sucesso!');
});

// ========================================
// TOGGLE DE SENHA
// ========================================
function togglePassword(inputId) {
    const input = document.getElementById(inputId);
    const icon = input.parentElement.querySelector('.toggle-password');
    
    if (input.type === 'password') {
        input.type = 'text';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
    } else {
        input.type = 'password';
        icon.classList.remove('fa-eye-slash');
        icon.classList.add('fa-eye');
    }
}

// ========================================
// INDICADOR DE FORÇA DA SENHA
// ========================================
function initPasswordStrength() {
    const novaSenhaInput = document.getElementById('novaSenha');
    const strengthBarFill = document.getElementById('strengthBarFill');
    const strengthText = document.getElementById('strengthText');

    novaSenhaInput.addEventListener('input', (e) => {
        const password = e.target.value;
        
        if (password.length === 0) {
            strengthBarFill.style.width = '0';
            strengthText.textContent = 'Digite uma senha';
            strengthText.style.color = '#666';
            updateRequirements(password);
            return;
        }

        const strength = calculatePasswordStrength(password);
        
        // Atualizar barra de força
        strengthBarFill.style.width = strength.percentage + '%';
        strengthBarFill.style.background = strength.color;
        strengthText.textContent = strength.text;
        strengthText.style.color = strength.color;

        // Atualizar requisitos
        updateRequirements(password);
    });
}

function updateRequirements(password) {
    const requirements = {
        'req-length': password.length >= 8,
        'req-uppercase': /[A-Z]/.test(password),
        'req-lowercase': /[a-z]/.test(password),
        'req-number': /[0-9]/.test(password)
    };

    for (const [id, met] of Object.entries(requirements)) {
        const element = document.getElementById(id);
        const icon = element.querySelector('i');
        
        if (met) {
            element.classList.add('met');
            element.classList.remove('unmet');
            icon.className = 'fas fa-check-circle';
        } else {
            element.classList.remove('met');
            element.classList.add('unmet');
            icon.className = 'fas fa-times-circle';
        }
    }
}

function calculatePasswordStrength(password) {
    let score = 0;
    
    // Critérios de força
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (/[a-z]/.test(password)) score++;
    if (/[A-Z]/.test(password)) score++;
    if (/[0-9]/.test(password)) score++;
    if (/[^a-zA-Z0-9]/.test(password)) score++;
    
    if (score <= 2) {
        return { 
            percentage: 33, 
            color: '#dc3545', 
            text: 'Senha Fraca' 
        };
    } else if (score <= 4) {
        return { 
            percentage: 66, 
            color: '#ffc107', 
            text: 'Senha Média' 
        };
    } else {
        return { 
            percentage: 100, 
            color: '#28a745', 
            text: 'Senha Forte' 
        };
    }
}

// ========================================
// FORMULÁRIO DE TROCA DE SENHA
// ========================================
function initForm(colaborador) {
    const form = document.getElementById('passwordForm');
    
    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const senhaAtual = document.getElementById('senhaAtual').value;
        const novaSenha = document.getElementById('novaSenha').value;
        const confirmarSenha = document.getElementById('confirmarSenha').value;
        
        // Validações
        if (novaSenha.length < 8) {
            showStatus('error', 'A nova senha deve ter no mínimo 8 caracteres!');
            return;
        }

        // Verificar requisitos da senha
        if (!/[A-Z]/.test(novaSenha)) {
            showStatus('error', 'A senha deve conter pelo menos uma letra maiúscula!');
            return;
        }
        
        if (!/[a-z]/.test(novaSenha)) {
            showStatus('error', 'A senha deve conter pelo menos uma letra minúscula!');
            return;
        }
        
        if (!/[0-9]/.test(novaSenha)) {
            showStatus('error', 'A senha deve conter pelo menos um número!');
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
        const btnSubmit = document.getElementById('submitBtn');
        btnSubmit.disabled = true;
        btnSubmit.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Verificando senha...';
        
        try {
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
                btnSubmit.innerHTML = '<i class="fas fa-check"></i> Alterar Senha e Continuar';
                return;
            }
            
            console.log('🔍 [DEBUG] Hash no banco:', dadosBanco.senha_hash);
            
            // Gerar hash da senha digitada
            console.log('🔍 [DEBUG] Gerando hash da senha atual...');
            const senhaAtualHash = await window.hashString(senhaAtual);
            console.log('🔍 [DEBUG] Hash da senha digitada:', senhaAtualHash);
            console.log('🔍 [DEBUG] Hashes coincidem?', senhaAtualHash === dadosBanco.senha_hash);
            
            // Verificar se a senha atual está correta (comparar com banco, não com sessão!)
            if (senhaAtualHash !== dadosBanco.senha_hash) {
                showStatus('error', 'Senha temporária incorreta! Verifique com o RH.');
                btnSubmit.disabled = false;
                btnSubmit.innerHTML = '<i class="fas fa-check"></i> Alterar Senha e Continuar';
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
                btnSubmit.innerHTML = '<i class="fas fa-check"></i> Alterar Senha e Continuar';
            }
        } catch (error) {
            console.error('❌ [ERRO CRÍTICO]', error);
            showStatus('error', 'Erro inesperado: ' + error.message);
            btnSubmit.disabled = false;
            btnSubmit.innerHTML = '<i class="fas fa-check"></i> Alterar Senha e Continuar';
        }
    });
}

// ========================================
// ATUALIZAR SENHA NO BANCO
// ========================================
async function trocarSenhaPrimeiroAcesso(colaboradorId, novaSenha) {
    try {
        console.log('🔄 [TROCA-SENHA] Atualizando senha do colaborador:', colaboradorId);
        
        // Gerar hash da nova senha
        console.log('🔄 [TROCA-SENHA] Gerando hash da nova senha...');
        const novaSenhaHash = await window.hashString(novaSenha);
        console.log('✅ [TROCA-SENHA] Hash gerado:', novaSenhaHash);
        
        // Atualizar no banco de dados
        console.log('🔄 [TROCA-SENHA] Atualizando no banco de dados...');
        const { data, error } = await window.supabaseClient
            .from('colaboradores')
            .update({
                senha_hash: novaSenhaHash,
                primeiro_acesso: false,
                atualizado_em: new Date().toISOString()
            })
            .eq('id', colaboradorId)
            .select();
        
        if (error) {
            console.error('❌ [TROCA-SENHA] Erro ao atualizar:', error);
            throw error;
        }
        
        console.log('✅ [TROCA-SENHA] Senha atualizada com sucesso!', data);
        return { success: true, data: data[0] };
        
    } catch (error) {
        console.error('❌ [TROCA-SENHA] Erro ao trocar senha:', error);
        return { success: false, error: error.message };
    }
}

// ========================================
// MOSTRAR STATUS
// ========================================
function showStatus(type, message) {
    const statusDiv = document.getElementById('statusMessage');
    statusDiv.className = 'status-message ' + type;
    statusDiv.style.display = 'flex';
    
    const icon = type === 'success' ? 'check-circle' : 'exclamation-circle';
    statusDiv.innerHTML = `<i class="fas fa-${icon}"></i> ${message}`;
    
    // Auto-esconder após 5 segundos (exceto success)
    if (type !== 'success') {
        setTimeout(() => {
            statusDiv.style.display = 'none';
        }, 5000);
    }
}

console.log('✅ Primeiro Acesso carregado!');
