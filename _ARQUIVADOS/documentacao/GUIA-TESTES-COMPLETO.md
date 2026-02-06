# ✅ GUIA DE TESTES - AMBIENTE LOCAL

## 🚀 PASSO 1: Iniciar Servidores

### Opção A: Iniciar TUDO de uma vez (Recomendado)
1. Dê duplo clique em: **`INICIAR-TUDO.bat`**
2. Vai abrir 2 janelas:
   - Website ISIBA (porta 8000)
   - Painel RH (porta 3000)

### Opção B: Iniciar individualmente
1. **Website:** Duplo clique em `INICIAR-SERVIDOR.bat`
2. **Painel RH:** Duplo clique em `INICIAR-PAINEL-RH.bat`

---

## 🧪 PASSO 2: Testes do Website Principal

### 2.1 Abra o navegador:
```
http://localhost:8000
```

### 2.2 Verificações Visuais:
- [ ] ✅ Badge laranja no canto superior direito: **`🔧 DESENVOLVIMENTO`**
- [ ] ✅ Site carrega normalmente
- [ ] ✅ Logomarcas aparecem
- [ ] ✅ Menu funciona

### 2.3 Console do Navegador (F12):
Pressione **F12** e veja a aba **Console**

**Deve mostrar:**
```
🔧 AMBIENTE DETECTADO: DESENVOLVIMENTO
📍 Hostname: localhost
✅ Supabase configurado para DESENVOLVIMENTO!
🗄️ Banco: https://SEU_DEV.supabase.co
📦 Bucket: contracheques
```

### 2.4 Teste Portal do Colaborador:
1. Acesse: http://localhost:8000/portal-colaborador.html
2. Tente fazer login com algum dos 7 colaboradores (se já importou os dados)
3. Verifique se:
   - [ ] Badge laranja aparece
   - [ ] Console mostra banco DEV
   - [ ] Login funciona (ou dá erro esperado se ainda não importou dados)

---

## 🧪 PASSO 3: Testes do Painel RH

### 3.1 Abra o Painel RH:
```
http://localhost:3000
```
ou
```
http://localhost:8000/painel-rh/admin-rh.html
```

### 3.2 Verificações Visuais:
- [ ] ✅ Badge laranja: **`🔧 DESENVOLVIMENTO`**
- [ ] ✅ Painel carrega normalmente
- [ ] ✅ Formulários aparecem

### 3.3 Console do Navegador (F12):
```
🔧 AMBIENTE DETECTADO: DESENVOLVIMENTO
🗄️ Banco: https://SEU_DEV.supabase.co
```

### 3.4 Teste Funcionalidades:
- [ ] Formulário de adicionar colaborador
- [ ] Upload de contracheques
- [ ] Lista de colaboradores (se já importou os 7)

---

## 🧪 PASSO 4: Comparar com Produção

### 4.1 Abra o GitHub Pages:
```
https://andersonb3.github.io/website-isiba/
```

### 4.2 Verificações:
- [ ] ❌ NÃO tem badge laranja
- [ ] ✅ Site funciona normalmente
- [ ] ✅ Console (F12) mostra:
```
🌐 AMBIENTE DETECTADO: PRODUÇÃO (GitHub Pages)
🗄️ Banco: https://kklhcmrnraroletwbbid.supabase.co
```

---

## 📊 TABELA DE COMPARAÇÃO

| Item | Local (localhost) | Produção (GitHub) |
|------|-------------------|-------------------|
| **Badge** | 🔧 Laranja | ❌ Nenhum |
| **Banco** | Desenvolvimento | Produção |
| **URL** | localhost:8000 | andersonb3.github.io |
| **Console** | "DESENVOLVIMENTO" | "PRODUÇÃO" |
| **Dados** | Teste (DEV) | Reais (PROD) |

---

## 🐛 TROUBLESHOOTING

### ❌ Problema: Badge NÃO aparece no localhost
**Causa:** Credenciais DEV não configuradas

**Solução:**
1. Abra: `assets/js/supabase-config.dev.js`
2. Cole suas credenciais do projeto DEV
3. Recarregue a página (Ctrl+F5)

### ❌ Problema: Console mostra banco de PRODUÇÃO no localhost
**Causa:** Cache do navegador

**Solução:**
1. Pressione: **Ctrl+Shift+Delete**
2. Limpe cache e cookies
3. Feche e reabra o navegador
4. Acesse novamente: http://localhost:8000

### ❌ Problema: "Erro ao conectar com Supabase"
**Causa:** Credenciais incorretas ou banco não criado

**Solução:**
1. Verifique se criou o projeto DEV no Supabase
2. Verifique se as credenciais estão corretas
3. Verifique se as tabelas foram criadas

### ❌ Problema: Porta 8000 já está em uso
**Solução:**
```powershell
# Matar processo na porta 8000
netstat -ano | findstr :8000
taskkill /PID [número_do_processo] /F
```

Ou use outra porta:
```powershell
python -m http.server 8080
# Acesse: http://localhost:8080
```

---

## ✅ CHECKLIST DE VERIFICAÇÃO

### Website (localhost:8000)
- [ ] Servidor iniciado com sucesso
- [ ] Badge laranja visível
- [ ] Console mostra ambiente DEV
- [ ] Banco DEV conectado
- [ ] Site carrega normalmente

### Painel RH (localhost:3000 ou :8000/painel-rh/)
- [ ] Servidor iniciado
- [ ] Badge laranja visível
- [ ] Console mostra ambiente DEV
- [ ] Formulários funcionam

### Produção (GitHub Pages)
- [ ] Sem badge laranja
- [ ] Console mostra ambiente PROD
- [ ] Banco PROD conectado
- [ ] Site funciona normalmente

---

## 📸 CAPTURAS ESPERADAS

### Console Local (DEV):
```
🔧 AMBIENTE DETECTADO: DESENVOLVIMENTO
📍 Hostname: localhost
✅ Supabase configurado para DESENVOLVIMENTO!
🗄️ Banco: https://xxxxxxx.supabase.co
📦 Bucket: contracheques
```

### Console Produção:
```
🌐 AMBIENTE DETECTADO: PRODUÇÃO (GitHub Pages)
📍 Hostname: andersonb3.github.io
✅ Supabase configurado para PRODUÇÃO!
🗄️ Banco: https://kklhcmrnraroletwbbid.supabase.co
```

---

## 🎯 PRÓXIMOS PASSOS

Depois que confirmar que está tudo funcionando:

1. ✅ Importar os 7 colaboradores para o banco DEV
2. ✅ Importar contracheques e recibos
3. ✅ Testar upload de documentos
4. ✅ Testar funcionalidade de lote de PDFs
5. ✅ Quando tudo funcionar, atualizar produção

---

## 🎉 TUDO FUNCIONANDO?

Se você viu:
- ✅ Badge laranja no local
- ✅ Sem badge na produção
- ✅ Console correto em ambos
- ✅ Bancos diferentes conectados

**PARABÉNS! Sistema de ambientes está 100% funcional!** 🚀🔒

Agora você pode desenvolver com segurança! 💪
