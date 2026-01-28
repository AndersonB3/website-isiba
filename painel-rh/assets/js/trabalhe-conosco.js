/**
 * TRABALHE CONOSCO - JavaScript
 * Funcionalidades do formulário de envio de currículo
 */

// ========================================
// CONFIGURAÇÃO EMAILJS
// ========================================
// ✅ CONFIGURADO - EmailJS pronto para uso!
const EMAILJS_CONFIG = {
    publicKey: '8wh9u9TAnooFUeUu7',      // Public Key da conta EmailJS
    serviceId: 'service_525itdc',        // Service ID do Gmail conectado
    templateId: 'template_9kxngda'       // Template ID para emails de currículo
};

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
    
    // Inicializar EmailJS
    if (typeof emailjs !== 'undefined' && EMAILJS_CONFIG.publicKey !== 'YOUR_PUBLIC_KEY') {
        emailjs.init(EMAILJS_CONFIG.publicKey);
        console.log('✅ EmailJS inicializado');
    } else {
        console.warn('⚠️ EmailJS não configurado. Configure as credenciais em trabalhe-conosco.js');
    }
    
    // Inicializar funcionalidades
    initMobileMenu();
    initFileUpload();
    initFormValidation();
    initPhoneMask();
});

// ========================================
// MENU MOBILE
// ========================================
function initMobileMenu() {
    const navToggle = document.getElementById('nav-toggle');
    const navClose = document.getElementById('nav-close');
    const navMenu = document.getElementById('nav-menu');
    
    if (navToggle) {
        navToggle.addEventListener('click', () => {
            navMenu.classList.add('show-menu');
        });
    }
    
    if (navClose) {
        navClose.addEventListener('click', () => {
            navMenu.classList.remove('show-menu');
        });
    }
}

// ========================================
// FILE UPLOAD
// ========================================
function initFileUpload() {
    const fileInput = document.getElementById('curriculo');
    const uploadArea = document.querySelector('.formulario__upload');
    const fileNameSpan = document.getElementById('fileName');
    
    if (!fileInput || !uploadArea || !fileNameSpan) return;
    
    // Atualizar nome do arquivo selecionado
    fileInput.addEventListener('change', function() {
        if (this.files && this.files[0]) {
            const file = this.files[0];
            
            // Validar tipo
            if (file.type !== 'application/pdf') {
                showStatus('error', 'Por favor, selecione apenas arquivos PDF.');
                this.value = '';
                fileNameSpan.textContent = 'Clique ou arraste seu currículo aqui';
                uploadArea.classList.remove('has-file');
                return;
            }
            
            // Validar tamanho (5MB)
            if (file.size > 5 * 1024 * 1024) {
                showStatus('error', 'O arquivo deve ter no máximo 5MB.');
                this.value = '';
                fileNameSpan.textContent = 'Clique ou arraste seu currículo aqui';
                uploadArea.classList.remove('has-file');
                return;
            }
            
            // Mostrar nome do arquivo
            fileNameSpan.innerHTML = `<i class="fa-solid fa-file-pdf"></i> ${file.name}`;
            uploadArea.classList.add('has-file');
            hideStatus();
        }
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
        
        if (value.length > 0) {
            value = '(' + value;
        }
        if (value.length > 3) {
            value = value.slice(0, 3) + ') ' + value.slice(3);
        }
        if (value.length > 10) {
            value = value.slice(0, 10) + '-' + value.slice(10);
        }
        
        e.target.value = value;
    });
}

// ========================================
// VALIDAÇÃO E ENVIO DO FORMULÁRIO
// ========================================
function initFormValidation() {
    const form = document.getElementById('curriculoForm');
    
    if (!form) return;
    
    form.addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const btnEnviar = document.getElementById('btnEnviar');
        const nome = document.getElementById('nome').value.trim();
        const email = document.getElementById('email').value.trim();
        const telefone = document.getElementById('telefone').value.trim();
        const mensagem = document.getElementById('mensagem').value.trim();
        const curriculo = document.getElementById('curriculo').files[0];
        
        // Validações
        if (!nome || nome.length < 3) {
            showStatus('error', 'Por favor, informe seu nome completo.');
            return;
        }
        
        if (!email || !isValidEmail(email)) {
            showStatus('error', 'Por favor, informe um e-mail válido.');
            return;
        }
        
        if (!telefone || telefone.length < 14) {
            showStatus('error', 'Por favor, informe um telefone válido.');
            return;
        }
        
        if (!curriculo) {
            showStatus('error', 'Por favor, anexe seu currículo em PDF.');
            return;
        }
        
        // Verificar se EmailJS está configurado
        if (EMAILJS_CONFIG.publicKey === 'YOUR_PUBLIC_KEY') {
            showStatus('error', 'Sistema de envio não configurado. Entre em contato pelo e-mail: rh@isiba.org.br');
            console.error('❌ Configure o EmailJS em trabalhe-conosco.js');
            return;
        }
        
        // Mostrar loading
        btnEnviar.disabled = true;
        btnEnviar.classList.add('loading');
        btnEnviar.innerHTML = '<i class="fa-solid fa-spinner"></i> <span>Enviando...</span>';
        
        try {
            // ⚠️ IMPORTANTE: EmailJS gratuito tem limite de 50KB
            // Por isso, NÃO enviamos o PDF anexado, apenas as informações
            
            // Preparar dados para envio (SEM PDF)
            const templateParams = {
                from_name: nome,
                from_email: email,
                phone: telefone,
                message: mensagem || 'Sem mensagem adicional.',
                pdf_name: curriculo.name,
                pdf_size: `${(curriculo.size / 1024).toFixed(2)} KB`
            };
            
            // Enviar via EmailJS
            const response = await emailjs.send(
                EMAILJS_CONFIG.serviceId,
                EMAILJS_CONFIG.templateId,
                templateParams
            );
            
            console.log('✅ Email enviado:', response);
            
            // Sucesso
            showStatus('success', '✅ Currículo enviado com sucesso! Entraremos em contato em breve. (Você receberá um email solicitando o envio do PDF)');
            form.reset();
            document.getElementById('fileName').textContent = 'Clique ou arraste seu currículo aqui';
            document.querySelector('.formulario__upload').classList.remove('has-file');
            
        } catch (error) {
            console.error('❌ Erro ao enviar:', error);
            
            // Mensagem de erro detalhada
            let errorMessage = 'Erro ao enviar o currículo. ';
            
            if (error.text) {
                errorMessage += `Detalhes: ${error.text}. `;
            }
            
            errorMessage += 'Tente novamente ou envie direto para: ti.upaglebaa.isiba@gmail.com';
            
            showStatus('error', errorMessage);
        } finally {
            // Restaurar botão
            btnEnviar.disabled = false;
            btnEnviar.classList.remove('loading');
            btnEnviar.innerHTML = '<i class="fa-solid fa-paper-plane"></i> <span>Enviar Currículo</span>';
        }
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

// Converter arquivo para Base64
function fileToBase64(file) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = () => {
            // Remover prefixo "data:application/pdf;base64,"
            const base64 = reader.result.split(',')[1];
            resolve(base64);
        };
        reader.onerror = error => reject(error);
    });
}

// Mostrar mensagem de status
function showStatus(type, message) {
    const statusEl = document.getElementById('formStatus');
    if (!statusEl) return;
    
    statusEl.className = 'formulario__status ' + type;
    statusEl.innerHTML = message;
    statusEl.style.display = 'block';
    
    // Scroll para a mensagem
    statusEl.scrollIntoView({ behavior: 'smooth', block: 'center' });
}

// Esconder mensagem de status
function hideStatus() {
    const statusEl = document.getElementById('formStatus');
    if (statusEl) {
        statusEl.style.display = 'none';
    }
}
