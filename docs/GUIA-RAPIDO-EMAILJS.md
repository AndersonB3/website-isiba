# 🚀 Guia Rápido - Configurar EmailJS (5 minutos)

## ⚡ Passo a Passo Simples

### 📝 PASSO 1: Criar Conta (2 min)
1. Acesse: **https://www.emailjs.com/**
2. Clique em **"Sign Up"**
3. Entre com Google ou crie conta
4. ✅ Pronto! Você está no Dashboard

---

### 📧 PASSO 2: Conectar seu Email (1 min)
1. No menu lateral, clique em **"Email Services"**
2. Clique em **"Add New Service"**
3. Escolha **"Gmail"** (mais fácil)
4. Clique em **"Connect Account"** → Autorize com sua conta Gmail
5. 📋 **COPIE O SERVICE ID** (exemplo: `service_abc123`)
   - Anote em algum lugar!

---

### 📄 PASSO 3: Criar Template do Email (1 min)
1. No menu lateral, clique em **"Email Templates"**
2. Clique em **"Create New Template"**
3. Preencha:

**Settings (Configurações):**
- **Template Name:** `ISIBA - Trabalhe Conosco`

**To Email:**
```
rh@isiba.org.br
```
*(ou o email que vai receber os currículos)*

**Subject (Assunto):**
```
Novo Currículo - {{from_name}}
```

**Content (Conteúdo):** Cole isto:
```html
<h2>📄 Novo Currículo Recebido</h2>

<p><strong>👤 Nome:</strong> {{from_name}}</p>
<p><strong>📧 E-mail:</strong> {{from_email}}</p>
<p><strong>📱 Telefone:</strong> {{phone}}</p>

<h3>💬 Mensagem:</h3>
<p>{{message}}</p>

<hr>
<p><strong>📎 Currículo:</strong> {{pdf_name}} ({{pdf_size}})</p>
<p><small>✉️ Enviado através do site ISIBA Social - Trabalhe Conosco</small></p>
```

4. Clique em **"Save"**
5. 📋 **COPIE O TEMPLATE ID** (exemplo: `template_xyz789`)

---

### 🔑 PASSO 4: Pegar a Public Key (30 seg)
1. Clique no **seu nome** (canto superior direito)
2. Vá em **"Account"** → aba **"General"**
3. 📋 **COPIE A PUBLIC KEY** (exemplo: `xK7mP9qL2nR8t`)

---

### 💻 PASSO 5: Configurar no Código (1 min)

Agora que você tem:
- ✅ **Public Key**
- ✅ **Service ID** 
- ✅ **Template ID**

**Abra o arquivo:** `assets/js/trabalhe-conosco.js`

**Encontre estas linhas (linhas 10-14):**
```javascript
const EMAILJS_CONFIG = {
    publicKey: 'YOUR_PUBLIC_KEY',
    serviceId: 'YOUR_SERVICE_ID',
    templateId: 'YOUR_TEMPLATE_ID'
};
```

**Substitua pelos seus dados:**
```javascript
const EMAILJS_CONFIG = {
    publicKey: 'xK7mP9qL2nR8t',        // ← Cole sua Public Key aqui
    serviceId: 'service_abc123',       // ← Cole seu Service ID aqui
    templateId: 'template_xyz789'      // ← Cole seu Template ID aqui
};
```

**Salve o arquivo!** (Ctrl + S)

---

### 🧪 PASSO 6: Testar! (1 min)

1. Abra o arquivo `trabalhe-conosco.html` no navegador
2. Preencha o formulário com dados de teste
3. Anexe um PDF pequeno (menos de 5MB)
4. Clique em **"Enviar Currículo"**
5. Aguarde a mensagem de **"✅ Currículo enviado com sucesso!"**
6. Verifique o email `rh@isiba.org.br` (ou o que você configurou)

---

## ⚠️ Problemas Comuns

### ❌ "EmailJS não configurado"
- Certifique-se de substituir `YOUR_PUBLIC_KEY` pelos valores reais
- Recarregue a página (F5)

### ❌ "Failed to send email"
- Verifique se o Service ID e Template ID estão corretos
- Veja o Console do navegador (F12) para mais detalhes

### ❌ Email não chegou
- Verifique a pasta de SPAM
- Confirme se o email em "To Email" está correto
- No Dashboard do EmailJS, vá em "Email History" para ver o status

### ⚠️ PDF muito grande
- O EmailJS gratuito tem limite de ~50KB para anexos em base64
- Se o PDF for maior, considere usar alternativas (veja CONFIGURAR-EMAILJS.md)

---

## 📊 Seu Plano Gratuito Inclui:
- ✅ **200 emails por mês**
- ✅ **2 templates de email**
- ✅ **Anexos até 50KB**
- ✅ **Suporte básico**

---

## 🎯 Exemplo Completo

Seus dados ficaram assim:
```javascript
const EMAILJS_CONFIG = {
    publicKey: 'xK7mP9qL2nR8t',        // Copiado do Account
    serviceId: 'service_gmail123',     // Copiado do Email Services
    templateId: 'template_trabalhe789' // Copiado do Email Templates
};
```

---

## 🆘 Precisa de Ajuda?

1. **Documentação Completa:** `docs/CONFIGURAR-EMAILJS.md`
2. **EmailJS Docs:** https://www.emailjs.com/docs/
3. **Console do Browser:** Pressione F12 para ver mensagens de erro

---

## ✨ Pronto!

Agora seu formulário está funcionando! Quando alguém enviar um currículo:
1. O formulário valida os dados
2. Converte o PDF para base64
3. Envia via EmailJS
4. Você recebe no email configurado

**Boa sorte com as contratações! 🎉**
