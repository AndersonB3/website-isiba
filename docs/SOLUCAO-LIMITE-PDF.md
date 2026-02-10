# 🔧 Atualizar Template do EmailJS - SEM Anexo PDF

## ⚠️ Mudança Importante

**Problema resolvido:** O EmailJS gratuito tem limite de 50KB. PDFs em base64 ultrapassam esse limite.

**Solução:** O formulário agora envia apenas as informações do candidato. O RH pode solicitar o PDF diretamente por email depois.

---

## 📝 Atualizar o Template

### 1. Acesse o Template
- Entre em: https://dashboard.emailjs.com/admin/templates
- Abra o template: `template_9kxngda`

### 2. Atualize o Conteúdo (Content)

**Cole este novo código HTML:**

```html
<h2>📄 Novo Candidato - Trabalhe Conosco</h2>

<p><strong>👤 Nome:</strong> {{from_name}}</p>
<p><strong>📧 E-mail:</strong> {{from_email}}</p>
<p><strong>📱 Telefone:</strong> {{phone}}</p>

<h3>💬 Mensagem:</h3>
<p>{{message}}</p>

<hr>

<h3>📎 Currículo</h3>
<p><strong>Arquivo:</strong> {{pdf_name}} ({{pdf_size}})</p>
<p><em>⚠️ O currículo NÃO foi anexado automaticamente devido às limitações técnicas.</em></p>

<h4>✉️ Próximos Passos:</h4>
<p>
    <strong>Responda para o email do candidato ({{from_email}}) solicitando o envio do PDF:</strong>
</p>
<blockquote style="background: #f0f0f0; padding: 15px; border-left: 4px solid #0066cc; margin: 10px 0;">
    <p>Olá {{from_name}},</p>
    <p>Obrigado por seu interesse em trabalhar conosco!</p>
    <p>Por favor, responda este email anexando seu currículo em PDF para que possamos avaliar sua candidatura.</p>
    <p><strong>Atenciosamente,</strong><br>Equipe RH - ISIBA</p>
</blockquote>

<hr>
<p><small>✉️ Enviado através do site ISIBA - Trabalhe Conosco</small></p>
```

### 3. Remover Anexo (se existir)

Se você adicionou um **Attachment** no template:
1. Vá na seção **"Attachments"** (no final do template)
2. **Remova** qualquer anexo configurado
3. Deixe a seção de anexos **vazia**

### 4. Salvar

1. Clique em **"Save"**
2. Pronto! Template atualizado

---

## ✅ Como Funciona Agora

### Processo Atualizado:

1. **Candidato preenche o formulário** → Nome, email, telefone, mensagem e seleciona PDF
2. **Sistema envia email para RH** → Com as informações do candidato (sem PDF)
3. **RH recebe email** → Com dados do candidato e instruções
4. **RH responde** → Solicitando o envio do PDF diretamente
5. **Candidato envia PDF** → Por email comum (sem limite de tamanho)

### Vantagens:
- ✅ Funciona com PDFs de qualquer tamanho
- ✅ Não depende de limites do EmailJS
- ✅ RH tem contato direto com o candidato
- ✅ Processo mais profissional

---

## 🧪 Teste Novamente

1. Abra `trabalhe-conosco.html` no navegador
2. Preencha o formulário
3. Selecione um PDF (pode ser grande agora)
4. Clique em "Enviar Currículo"
5. ✅ Deve funcionar perfeitamente!

---

## 📧 Email que o RH Vai Receber

```
📄 Novo Candidato - Trabalhe Conosco

👤 Nome: João Silva
📧 E-mail: joao@exemplo.com
📱 Telefone: (11) 98765-4321

💬 Mensagem:
Tenho interesse em fazer parte da equipe ISIBA.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📎 Currículo
Arquivo: curriculo-joao-silva.pdf (245.67 KB)
⚠️ O currículo NÃO foi anexado automaticamente devido às limitações técnicas.

✉️ Próximos Passos:
Responda para o email do candidato (joao@exemplo.com) solicitando o envio do PDF:

[Template de resposta incluso no email]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✉️ Enviado através do site ISIBA - Trabalhe Conosco
```

---

## 💡 Alternativas Futuras (Se quiser anexo automático)

Se no futuro quiser que o PDF seja enviado automaticamente, há opções:

### 1. **FormSubmit** (Recomendado)
- 🆓 Gratuito e ilimitado
- ✅ Suporta anexos grandes
- 🔗 https://formsubmit.co/

### 2. **Web3Forms**
- 🆓 250 envios/mês grátis
- ✅ Suporta anexos
- 🔗 https://web3forms.com/

### 3. **Backend próprio**
- Node.js + Nodemailer
- PHP + PHPMailer
- Python + Flask/Django

---

## ✅ Pronto!

Agora o formulário funciona perfeitamente e não tem mais erro de limite de tamanho! 🎉
