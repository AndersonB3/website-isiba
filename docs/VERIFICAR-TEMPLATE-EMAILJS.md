# ✅ Como Verificar e Corrigir o Template do EmailJS

## Problema Atual
Mensagem de erro ao enviar: "Erro ao enviar. Tente novamente..."

## Passos para Verificar

### 1. Acessar o Template
1. Entre em: https://dashboard.emailjs.com/admin/templates
2. Localize o template: `template_9kxngda`
3. Clique para editar

### 2. Verificar o Email de Destino
No template, procure o campo **"To Email"**:
- ✅ **Deve estar**: `ti.upaglebaa.isiba@gmail.com`
- ❌ **Se estiver diferente**: Corrija e salve

### 3. Verificar as Variáveis do Template

**Subject (Assunto):**
```
Novo Currículo - {{from_name}}
```

**Content (Corpo do Email):**
```html
<h2>📄 Novo Currículo Recebido</h2>

<p><strong>👤 Nome:</strong> {{from_name}}</p>
<p><strong>📧 E-mail:</strong> {{from_email}}</p>
<p><strong>📱 Telefone:</strong> {{phone}}</p>

<h3>💬 Mensagem:</h3>
<p>{{message}}</p>

<hr>
<p><strong>📎 Currículo:</strong> {{pdf_name}}</p>
<p><small>✉️ Enviado através do site ISIBA - Trabalhe Conosco</small></p>
```

**⚠️ IMPORTANTE:** 
- As variáveis devem estar EXATAMENTE como acima: `{{from_name}}`, `{{from_email}}`, etc.
- Não adicione `{{pdf_content}}` no corpo do email (use apenas para anexo)

### 4. Verificar Anexo (Attachment)

Na seção **"Attachments"** do template:
1. Clique em **"Add Attachment"**
2. Configure:
   - **Name:** `{{pdf_name}}`
   - **Content:** `{{pdf_content}}`
   - **Base64:** ✅ Marque esta opção!

### 5. Salvar e Testar

1. Clique em **"Save"**
2. Volte ao site e teste novamente
3. Pressione **F12** no navegador para ver erros no Console

---

## Problemas Comuns

### ❌ Erro: "The request did not have sufficient authentication scopes"
**Solução:** Reconecte o Gmail no EmailJS:
1. Vá em **Email Services**
2. Remova o serviço Gmail atual
3. Adicione novamente e autorize TODAS as permissões

### ❌ Erro: "Payload too large" ou arquivo muito grande
**Solução:** O EmailJS gratuito tem limite de ~50KB para anexos em base64.
- Teste com um PDF pequeno (menos de 50KB)
- Se precisar enviar PDFs maiores, use alternativa (FormSubmit, Web3Forms, etc.)

### ❌ Erro: "Template not found"
**Solução:** Verifique se o Template ID está correto:
- No código: `template_9kxngda`
- No EmailJS: Deve ser exatamente igual

### ❌ Email não chega
**Solução:**
1. Verifique a pasta de SPAM em `ti.upaglebaa.isiba@gmail.com`
2. No EmailJS, vá em **"Email History"** para ver se o email foi enviado
3. Confirme se o email no campo "To Email" está correto

---

## Teste Passo a Passo

1. **Abra o Console do Navegador** (F12)
2. Vá para a aba **"Console"**
3. Preencha o formulário
4. Clique em "Enviar Currículo"
5. Veja as mensagens no console:
   - ✅ `EmailJS inicializado`
   - ✅ `Email enviado:` (se sucesso)
   - ❌ `Erro ao enviar:` (se falha - copie o erro completo)

---

## Precisa de Ajuda?

Se o erro persistir, me envie:
1. O erro completo que aparece no Console (F12)
2. O tamanho do arquivo PDF que está testando
3. Print da configuração do template no EmailJS

---

## Email Alternativo para Testes

Se quiser testar com outro email temporário:
1. Use um Gmail pessoal primeiro
2. Depois mude para `ti.upaglebaa.isiba@gmail.com`
3. Isso ajuda a identificar se o problema é com o email específico
