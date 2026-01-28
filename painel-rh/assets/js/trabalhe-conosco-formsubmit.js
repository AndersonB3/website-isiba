/**
 * TRABALHE CONOSCO - FormSubmit Version
 * Formulário de envio de currículo com anexo PDF
 */

// ========================================
// INICIALIZAÇÃO
// ========================================
document.addEventListener('DOMContentLoaded', function() {
    // Inicializar AOS (animações)
    if (typeof AOS !== 'undefined') {
        AOS.init({
            duration: 800,
            easing: 'ease-out',
            once: true
        });
    }
    
    // Inicializar funcionalidades
    initFileUpload();
    initPhoneMask();
    initFormSubmit();
});

// ========================================
// UPLOAD DE ARQUIVO
// ========================================
function initFileUpload() {
    const fileInput = document.getElementById('curriculo');
    const uploadArea = document.querySelector('.formulario__upload');
    const fileName = document.getElementById('fileName');
    
    if (!fileInput || !uploadArea || !fileName) return;
    
    // Click no input
    fileInput.addEventListener('change', function() {
        if (this.files && this.files[0]) {
            const file = this.files[0];
            
            // Validar arquivo
            if (!file.type.includes('pdf')) {
                alert('Por favor, selecione apenas arquivos PDF');
                this.value = '';
                return;
            }
            
            if (file.size > 10 * 1024 * 1024) { // 10MB
                alert('O arquivo deve ter no máximo 10MB');
                this.value = '';
                return;
            }
            
            // Atualizar nome do arquivo
            fileName.textContent = file.name;
            uploadArea.classList.add('has-file');
        }
    });
    
    // Drag and drop
    uploadArea.addEventListener('dragover', function(e) {
        e.preventDefault();
        this.classList.add('dragover');
    });
    
    uploadArea.addEventListener('dragleave', function() {
        this.classList.remove('dragover');
    });
    
    uploadArea.addEventListener('drop', function(e) {
        e.preventDefault();
        this.classList.remove('dragover');
        
        const files = e.dataTransfer.files;
        if (files.length > 0) {
            fileInput.files = files;
            fileInput.dispatchEvent(new Event('change'));
        }
    });
}

// ========================================
// MÁSCARA DE TELEFONE
// ========================================
function initPhoneMask() {
    const telefoneInput = document.getElementById('telefone');
    if (!telefoneInput) return;
    
    telefoneInput.addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        
        if (value.length > 11) {
            value = value.slice(0, 11);
        }
        
        if (value.length > 6) {
            value = value.replace(/^(\d{2})(\d{5})(\d{0,4})/, '($1) $2-$3');
        } else if (value.length > 2) {
            value = value.replace(/^(\d{2})(\d{0,5})/, '($1) $2');
        } else if (value.length > 0) {
            value = value.replace(/^(\d{0,2})/, '($1');
        }
        
        e.target.value = value;
    });
}

// ========================================
// SUBMIT DO FORMULÁRIO
// ========================================
function initFormSubmit() {
    const form = document.getElementById('curriculoForm');
    const btnEnviar = document.getElementById('btnEnviar');
    
    if (!form || !btnEnviar) return;
    
    form.addEventListener('submit', function(e) {
        e.preventDefault(); // Prevenir envio padrão
        
        // Validações básicas
        const nome = document.getElementById('nome').value.trim();
        const email = document.getElementById('email').value.trim();
        const telefone = document.getElementById('telefone').value.trim();
        const curriculo = document.getElementById('curriculo').files[0];
        
        if (!nome || !email || !telefone || !curriculo) {
            showStatus('error', 'Por favor, preencha todos os campos obrigatórios.');
            return;
        }
        
        if (!isValidEmail(email)) {
            showStatus('error', 'Por favor, insira um e-mail válido.');
            return;
        }
        
        // Mostrar loading
        btnEnviar.disabled = true;
        btnEnviar.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> <span>Enviando...</span>';
        showStatus('', '');
        
        // Enviar via AJAX
        const formData = new FormData(form);
        
        fetch(form.action, {
            method: 'POST',
            body: formData,
            headers: {
                'Accept': 'application/json'
            }
        })
        .then(response => {
            // Resetar botão
            btnEnviar.disabled = false;
            btnEnviar.innerHTML = '<i class="fa-solid fa-paper-plane"></i> <span>Enviar Currículo</span>';
            
            if (response.ok) {
                // Sucesso!
                showStatus('success', '✅ Currículo enviado com sucesso! Entraremos em contato em breve.');
                form.reset();
                
                // Resetar upload
                const fileName = document.getElementById('fileName');
                const uploadArea = document.querySelector('.formulario__upload');
                if (fileName) fileName.textContent = 'Clique ou arraste seu currículo aqui';
                if (uploadArea) uploadArea.classList.remove('has-file');
            } else {
                throw new Error('Erro no envio');
            }
        })
        .catch(error => {
            console.error('Erro:', error);
            btnEnviar.disabled = false;
            btnEnviar.innerHTML = '<i class="fa-solid fa-paper-plane"></i> <span>Enviar Currículo</span>';
            showStatus('error', '❌ Erro ao enviar currículo. Por favor, tente novamente.');
        });
    });
}

// ========================================
// FUNÇÕES AUXILIARES
// ========================================

// Validar e-mail
function isValidEmail(email) {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
}

// Mostrar mensagem de status
function showStatus(type, message) {
    const statusEl = document.getElementById('formStatus');
    if (!statusEl) return;
    
    if (!message) {
        statusEl.style.display = 'none';
        return;
    }
    
    statusEl.className = 'formulario__status ' + type;
    statusEl.innerHTML = message;
    statusEl.style.display = 'block';
    
    // Scroll para a mensagem
    statusEl.scrollIntoView({ behavior: 'smooth', block: 'center' });
}
