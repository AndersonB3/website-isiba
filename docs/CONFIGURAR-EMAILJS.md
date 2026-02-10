# Configuração do EmailJS - Trabalhe Conosco

## O que é o EmailJS?
EmailJS é um serviço gratuito que permite enviar emails diretamente do frontend (JavaScript) sem precisar de um servidor backend.

**Plano Gratuito:**
- 200 emails por mês
- 2 templates de email
- Suporte a anexos (até 50KB em base64)

---

## Passo a Passo para Configurar

### 1. Criar Conta no EmailJS
1. Acesse: https://www.emailjs.com/
2. Clique em "Sign Up Free"
3. Crie sua conta (pode usar Google ou email)

### 2. Configurar Serviço de Email
1. No Dashboard, vá em **"Email Services"**
2. Clique em **"Add New Service"**
3. Escolha **"Gmail"** (mais fácil) ou outro provedor
4. Clique em **"Connect Account"** e autorize
5. Dê um nome ao serviço (ex: "ISIBA RH")
6. Copie o **Service ID** (ex: `service_abc123`)

### 3. Criar Template de Email
1. Vá em **"Email Templates"**
2. Clique em **"Create New Template"**
3. Configure o template:

**To Email:** `rh@isiba.org.br` (email do RH)

**Subject:**
```
Novo Currículo - {{from_name}}
```

**Content (HTML):**
```html
<h2>Novo Currículo Recebido</h2>

<p><strong>Nome:</strong> {{from_name}}</p>
<p><strong>E-mail:</strong> {{from_email}}</p>
<p><strong>Telefone:</strong> {{phone}}</p>

<h3>Mensagem:</h3>
<p>{{message}}</p>

<hr>
<p><em>Currículo anexado: {{pdf_name}}</em></p>
<p><small>Enviado através do site ISIBA</small></p>
```

4. Copie o **Template ID** (ex: `template_xyz789`)

### 4. Obter Public Key
1. Vá em **"Account"** (canto superior direito)
2. Na aba **"General"**, copie a **Public Key**

### 5. Configurar no Código
Abra o arquivo `assets/js/trabalhe-conosco.js` e substitua:

```javascript
const EMAILJS_CONFIG = {
    publicKey: 'SUA_PUBLIC_KEY_AQUI',
    serviceId: 'SEU_SERVICE_ID_AQUI',
    templateId: 'SEU_TEMPLATE_ID_AQUI'
};
```

---

## Limitação de Anexos

O EmailJS gratuito tem limite de 50KB para anexos em base64. Para currículos maiores, existem alternativas:

### Opção 1: Usar link do arquivo (Recomendado)
Em vez de anexar o PDF, fazer upload para um serviço como:
- Google Drive
- Dropbox
- AWS S3

### Opção 2: Serviços Alternativos Gratuitos

1. **Formspree** (https://formspree.io/)
   - 50 envios/mês grátis
   - Suporta anexos maiores

2. **Web3Forms** (https://web3forms.com/)
   - 250 envios/mês grátis
   - Fácil configuração

3. **FormSubmit** (https://formsubmit.co/)
   - Ilimitado e gratuito
   - Suporta anexos

---

## Teste Local
1. Configure as credenciais no `trabalhe-conosco.js`
2. Abra `trabalhe-conosco.html` no navegador
3. Preencha o formulário com dados de teste
4. Verifique se o email chegou

---

## Suporte
Em caso de dúvidas, consulte a documentação oficial:
- EmailJS Docs: https://www.emailjs.com/docs/
