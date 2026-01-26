# 🎉 FormSubmit - Solução Completa COM Anexo PDF

## ✅ O que mudou?

**Substituímos o EmailJS pelo FormSubmit!**

### Por quê?
- ✅ **100% Gratuito e ilimitado** (sem limite de envios)
- ✅ **Suporta anexos PDF de qualquer tamanho** (até 10MB)
- ✅ **Não precisa cadastro ou configuração**
- ✅ **Muito mais simples**
- ✅ **O PDF VAI ANEXADO no email!**

---

## 🚀 Como funciona?

### 1. Primeira vez (Ativação única)

**⚠️ IMPORTANTE:** Na primeira vez que alguém enviar o formulário, o FormSubmit vai pedir para **ativar o email**.

**Passo a passo:**
1. Alguém preenche o formulário pela primeira vez
2. FormSubmit envia um email para: `ti.upaglebaa.isiba@gmail.com`
3. **Abra este email e clique no link de ativação**
4. Pronto! O serviço está ativado para sempre

### 2. Depois da ativação

Todos os currículos serão enviados automaticamente para: `ti.upaglebaa.isiba@gmail.com` **com o PDF anexado!**

---

## 📧 Como será o email recebido?

O RH receberá um email assim:

```
Assunto: Novo Currículo - Trabalhe Conosco ISIBA

Nome: João Silva
Email: joao@exemplo.com
Telefone: (11) 98765-4321
Mensagem: Tenho interesse em fazer parte da equipe.

📎 ANEXO: curriculo-joao-silva.pdf
```

---

## 🧪 Como Testar?

### Passo 1: Abrir o formulário
Abra o arquivo `trabalhe-conosco.html` no navegador

### Passo 2: Preencher dados de teste
- Nome: Seu Nome (para teste)
- Email: seu-email-de-teste@gmail.com
- Telefone: (11) 99999-9999
- Mensagem: Teste de formulário
- PDF: Qualquer PDF (pode ser grande!)

### Passo 3: Enviar
Clique em "Enviar Currículo"

### Passo 4: Primeira vez - Ativar
1. Você será redirecionado para uma página do FormSubmit
2. Verifique o email: `ti.upaglebaa.isiba@gmail.com`
3. **Clique no link de ativação** no email
4. Pronto! Ativado para sempre

### Passo 5: Testar novamente
Preencha o formulário novamente. Agora o email chegará automaticamente com o PDF anexado!

---

## ⚙️ Configurações Atuais

No formulário, adicionamos configurações ocultas:

```html
<!-- Assunto do email -->
<input type="hidden" name="_subject" value="Novo Currículo - Trabalhe Conosco ISIBA">

<!-- Desabilitar captcha -->
<input type="hidden" name="_captcha" value="false">

<!-- Template bonito -->
<input type="hidden" name="_template" value="box">

<!-- Anti-spam -->
<input type="text" name="_honey" style="display:none">
```

---

## 🎨 Personalizar (Opcional)

### Mudar o email de destino
No arquivo `trabalhe-conosco.html`, linha ~91:
```html
<form ... action="https://formsubmit.co/NOVO-EMAIL@gmail.com" ...>
```

### Adicionar página de sucesso personalizada
Adicione no formulário:
```html
<input type="hidden" name="_next" value="https://seu-site.com/obrigado.html">
```

### Adicionar CC (cópia)
```html
<input type="hidden" name="_cc" value="outro-email@gmail.com">
```

---

## 📊 Vantagens vs EmailJS

| Recurso | FormSubmit | EmailJS |
|---------|-----------|---------|
| **Preço** | 🆓 Grátis ilimitado | 🆓 200/mês grátis |
| **Anexos** | ✅ Até 10MB | ❌ Máx 50KB |
| **Configuração** | ✅ Zero setup | ⚠️ Precisa config |
| **Cadastro** | ✅ Não precisa | ⚠️ Precisa conta |
| **PDFs grandes** | ✅ Funciona | ❌ Erro |

---

## ⚠️ Limitações do FormSubmit

1. **Ativação única:** Precisa ativar o email na primeira vez (1 minuto)
2. **Sem personalização avançada:** Não dá para customizar o template do email tanto quanto no EmailJS
3. **Redirecionamento:** Por padrão, redireciona para página do FormSubmit após envio

---

## 🔒 Segurança

- ✅ **Anti-spam integrado** (campo honey)
- ✅ **Validação de email** no frontend
- ✅ **Limite de tamanho** (10MB)
- ✅ **Apenas PDFs** aceitos

---

## 📁 Arquivos Modificados

1. ✅ `trabalhe-conosco.html` - Adicionado action do FormSubmit
2. ✅ `assets/js/trabalhe-conosco-formsubmit.js` - Novo JavaScript simples
3. 📦 `assets/js/trabalhe-conosco.js` - Antigo (não é mais usado, pode apagar)

---

## 🆘 Problemas?

### Email não chegou?
1. ✅ Verificou pasta de SPAM?
2. ✅ Clicou no link de ativação na primeira vez?
3. ✅ Email correto no código? (`ti.upaglebaa.isiba@gmail.com`)

### PDF não anexou?
1. ✅ Arquivo é PDF mesmo?
2. ✅ Tamanho menor que 10MB?
3. ✅ Campo name="attachment" correto?

### Formulário não envia?
1. F12 → Console → Ver erros
2. Verificar se todos os campos estão preenchidos
3. Testar com outro navegador

---

## ✨ Pronto!

Agora o formulário:
- ✅ Envia email automaticamente
- ✅ **Anexa o PDF no email**
- ✅ Funciona com PDFs grandes
- ✅ É gratuito e ilimitado
- ✅ Não depende de limites técnicos

**Teste agora e veja o PDF chegando anexado no email!** 🎉
