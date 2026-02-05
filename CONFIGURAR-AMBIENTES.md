# 🎯 GUIA: CONFIGURAR AMBIENTE LOCAL E PRODUÇÃO

## 📋 RESUMO
- **Local (localhost:8000)** → Banco de DESENVOLVIMENTO
- **GitHub Pages** → Banco de PRODUÇÃO

## ✅ PASSO 1: Configurar Credenciais de Desenvolvimento

### 1.1 Abra o arquivo: `assets/js/supabase-config.dev.js`

### 1.2 Acesse seu projeto de DESENVOLVIMENTO no Supabase:
👉 https://supabase.com/dashboard

### 1.3 Copie as credenciais:
1. Clique no projeto de **DESENVOLVIMENTO**
2. Vá em **Settings** → **API**
3. Copie:
   - **Project URL** (ex: `https://xxxxxxxx.supabase.co`)
   - **anon public** key (começa com `eyJhbGciOi...`)

### 1.4 Cole no arquivo `supabase-config.dev.js`:

```javascript
const SUPABASE_URL_DEV = 'https://SEU_PROJETO_DEV.supabase.co';
const SUPABASE_ANON_KEY_DEV = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

**⚠️ IMPORTANTE:** Este arquivo está no `.gitignore` e **NÃO será enviado** ao GitHub!

---

## ✅ PASSO 2: Verificar Configuração de Produção

### 2.1 Abra: `assets/js/supabase-config.js`

Este arquivo já deve ter as credenciais de **PRODUÇÃO** (o banco atual).

Verifique se está assim:

```javascript
const SUPABASE_URL = 'https://kklhcmrnraroletwbbid.supabase.co';
const SUPABASE_ANON_KEY = 'eyJ... (sua chave de produção)';
```

✅ Este arquivo **SIM será enviado** ao GitHub (é público e seguro).

---

## ✅ PASSO 3: Testar Ambiente Local

### 3.1 Inicie o servidor local:

```powershell
cd "C:\Users\Usuario\Desktop\WEBSITE ISIBA"
python -m http.server 8000
```

### 3.2 Abra no navegador:
```
http://localhost:8000
```

### 3.3 Você verá um **badge laranja** no canto da tela:
```
🔧 DESENVOLVIMENTO
```

### 3.4 Abra o Console do navegador (F12) e veja:
```
🔧 AMBIENTE: DESENVOLVIMENTO
✅ Supabase configurado para DESENVOLVIMENTO!
```

---

## ✅ PASSO 4: Verificar Produção (GitHub Pages)

### 4.1 Acesse seu site no GitHub Pages:
```
https://andersonb3.github.io/website-isiba/
```

### 4.2 **NÃO verá** o badge laranja

### 4.3 Console mostrará:
```
🌐 AMBIENTE DETECTADO: PRODUÇÃO (GitHub Pages)
```

---

## 📂 ESTRUTURA DOS ARQUIVOS

```
assets/js/
├── supabase-config-loader.js       ✅ Detecta ambiente (LOCAL vs PRODUÇÃO)
├── supabase-config.dev.js          🔧 Configuração DESENVOLVIMENTO (gitignored)
└── supabase-config.js              🌐 Configuração PRODUÇÃO (vai pro GitHub)
```

---

## 🔄 COMO FUNCIONA?

### Cada página HTML carrega primeiro o **loader**:

```html
<!-- Carregado em TODOS os arquivos HTML -->
<script src="assets/js/supabase-config-loader.js"></script>
```

### O loader detecta automaticamente:

| Ambiente | URL | Arquivo Carregado |
|----------|-----|-------------------|
| **Desenvolvimento** | localhost:8000 | `supabase-config.dev.js` |
| **Desenvolvimento** | 127.0.0.1:8000 | `supabase-config.dev.js` |
| **Desenvolvimento** | file:/// | `supabase-config.dev.js` |
| **Produção** | andersonb3.github.io | `supabase-config.js` |

---

## ✅ PASSO 5: Testar Painel RH

### 5.1 Acesse localmente:
```
http://localhost:8000/painel-rh/admin-rh.html
```

### 5.2 Verá:
- Badge: `🔧 DESENVOLVIMENTO`
- Console: `🗄️ Banco: https://SEU_DEV.supabase.co`

### 5.3 Acesse em produção:
```
https://andersonb3.github.io/website-isiba/painel-rh/admin-rh.html
```

### 5.4 Verá:
- Sem badge
- Console: `🗄️ Banco: https://kklhcmrnraroletwbbid.supabase.co`

---

## 🎯 VERIFICAR ARQUIVOS HTML

Todos os arquivos HTML devem carregar o loader **ANTES** dos outros scripts:

### ✅ Ordem correta em **TODOS** os arquivos:

```html
<!-- 1. Biblioteca Supabase -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>

<!-- 2. LOADER (detecta ambiente) -->
<script src="assets/js/supabase-config-loader.js"></script>

<!-- 3. Seus scripts -->
<script src="assets/js/admin-rh.js"></script>
```

### 📁 Arquivos que precisam verificar:
- ✅ `index.html`
- ✅ `admin-rh.html`
- ✅ `colaborador.html`
- ✅ `portal-colaborador.html`
- ✅ `relatorio.html`
- ✅ `trabalhe-conosco.html`
- ✅ `painel-rh/admin-rh.html`

---

## 🚨 TROUBLESHOOTING

### ❌ Problema: Badge não aparece localmente
**Solução:** Verifique se configurou o `supabase-config.dev.js`

### ❌ Problema: Usando banco de produção localmente
**Solução:** 
1. Limpe o cache do navegador (Ctrl+Shift+Delete)
2. Recarregue com Ctrl+F5

### ❌ Problema: "ERRO: Configure as credenciais"
**Solução:** Cole as credenciais corretas no `supabase-config.dev.js`

---

## 📝 CHECKLIST FINAL

- [ ] `supabase-config.dev.js` configurado com credenciais de DEV
- [ ] `supabase-config.js` tem credenciais de PRODUÇÃO
- [ ] `.gitignore` tem `**/supabase-config.dev.js`
- [ ] Testou `localhost:8000` → vê badge laranja
- [ ] Testou GitHub Pages → não vê badge
- [ ] Console mostra ambiente correto
- [ ] Todos os HTMLs carregam o loader

---

## 🎉 PRONTO!

Agora você tem:
- 🔧 **Desenvolvimento local** → Banco DEV (pode testar à vontade!)
- 🌐 **GitHub Pages** → Banco PRODUÇÃO (dados reais protegidos!)

Qualquer alteração local NÃO afeta produção! 🚀
