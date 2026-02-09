# 🎯 INICIAR E TESTAR AMBIENTE LOCAL

## ⚡ INÍCIO RÁPIDO

### 1️⃣ ANTES DE INICIAR - Configure Credenciais DEV

**📁 Abra:** `assets/js/supabase-config.dev.js`

**✏️ Substitua:**
```javascript
const SUPABASE_URL_DEV = 'COLE_AQUI_A_URL_DO_PROJETO_DESENVOLVIMENTO';
const SUPABASE_ANON_KEY_DEV = 'COLE_AQUI_A_CHAVE_ANON_DO_DESENVOLVIMENTO';
```

**Por suas credenciais:**
```javascript
const SUPABASE_URL_DEV = 'https://seu-projeto-dev.supabase.co';
const SUPABASE_ANON_KEY_DEV = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

👉 **Pegue em:** https://supabase.com/dashboard → Seu Projeto DEV → Settings → API

---

### 2️⃣ INICIAR SERVIDORES

**Duplo clique em:** `INICIAR-TUDO.bat`

Isso vai abrir 2 janelas:
- 🌐 **Website ISIBA** → `http://localhost:8000`
- 📊 **Painel RH** → `http://localhost:3000`

---

### 3️⃣ TESTAR - Website Principal

**Abra:** http://localhost:8000

**✅ Você DEVE ver:**
- Badge laranja no canto: `🔧 DESENVOLVIMENTO`

**Pressione F12 (Console):**
```
🔧 AMBIENTE DETECTADO: DESENVOLVIMENTO
🗄️ Banco: https://seu-dev.supabase.co
```

---

### 4️⃣ TESTAR - Painel RH

**Abra:** http://localhost:3000

ou

**Abra:** http://localhost:8000/painel-rh/admin-rh.html

**✅ Você DEVE ver:**
- Badge laranja: `🔧 DESENVOLVIMENTO`
- Console mostra banco DEV

---

### 5️⃣ COMPARAR - Produção

**Abra:** https://andersonb3.github.io/website-isiba/

**✅ Você DEVE ver:**
- ❌ SEM badge laranja
- Console mostra: `🌐 PRODUÇÃO`
- Banco: `kklhcmrnraroletwbbid.supabase.co`

---

## 📊 RESUMO VISUAL

```
┌─────────────────────────────────────────────────────────────┐
│  LOCALHOST:8000                                             │
├─────────────────────────────────────────────────────────────┤
│  🔧 DESENVOLVIMENTO  ← Badge Laranja                        │
│                                                             │
│  Console (F12):                                             │
│  🔧 AMBIENTE: DESENVOLVIMENTO                               │
│  🗄️ Banco: seu-projeto-dev.supabase.co                     │
│                                                             │
│  ✅ Pode testar à vontade!                                  │
│  ✅ Nada afeta produção!                                    │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  GITHUB PAGES                                               │
├─────────────────────────────────────────────────────────────┤
│  (sem badge)                                                │
│                                                             │
│  Console (F12):                                             │
│  🌐 AMBIENTE: PRODUÇÃO                                      │
│  🗄️ Banco: kklhcmrnraroletwbbid.supabase.co               │
│                                                             │
│  ⚠️ Dados reais de produção!                                │
│  🔒 Protegido!                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🚨 STATUS ATUAL

### ✅ PRONTOS
- [x] Sistema de detecção de ambiente
- [x] Arquivos de configuração criados
- [x] 7 HTMLs atualizados com loader
- [x] Scripts de inicialização criados
- [x] Banco de produção conectado
- [x] Estrutura do banco DEV criada

### ⏳ FALTA FAZER
- [ ] **Configurar credenciais DEV** no `supabase-config.dev.js`
- [ ] Testar localhost:8000 (ver badge laranja)
- [ ] Importar 7 colaboradores para banco DEV
- [ ] Importar contracheques para banco DEV
- [ ] Importar recibos para banco DEV
- [ ] Testar funcionalidades localmente

---

## 🎬 ORDEM DE EXECUÇÃO

1. **Configure:** `supabase-config.dev.js` (cole suas credenciais)
2. **Execute:** `INICIAR-TUDO.bat`
3. **Abra:** http://localhost:8000
4. **Verifique:** Badge laranja e console
5. **Compare:** com GitHub Pages (sem badge)
6. **Importe dados:** Execute os INSERTs no banco DEV
7. **Teste tudo:** Formulários, login, upload, etc.

---

## 📁 ARQUIVOS CRIADOS PARA VOCÊ

```
WEBSITE ISIBA/
├── INICIAR-TUDO.bat              ← Execute ESTE para iniciar tudo
├── INICIAR-SERVIDOR.bat          ← Website (porta 8000)
├── INICIAR-PAINEL-RH.bat         ← Painel RH (porta 3000)
├── GUIA-TESTES-COMPLETO.md       ← Guia detalhado de testes
├── CONFIGURAR-AMBIENTES.md       ← Guia completo de configuração
├── SETUP-RAPIDO-LOCAL.md         ← Setup rápido
└── RESUMO-CONFIGURACAO.md        ← Este arquivo
```

---

## 🎯 PRÓXIMO PASSO AGORA

**👉 Abra o arquivo:** `assets/js/supabase-config.dev.js`

**👉 Cole suas credenciais** do projeto de DESENVOLVIMENTO

**👉 Salve o arquivo**

**👉 Execute:** `INICIAR-TUDO.bat`

**👉 Abra:** http://localhost:8000

**👉 Veja o badge laranja!** 🎉

---

## 💡 DICA

Se você **ainda não criou** o projeto de desenvolvimento no Supabase:

1. Acesse: https://supabase.com/dashboard
2. Clique em: **New Project**
3. Nome: **ISIBA-DEV** (ou outro nome)
4. Password: (crie uma senha)
5. Region: **East US** (mesma da produção)
6. Aguarde 2 minutos (criação do projeto)
7. Vá em: **Settings → API**
8. Copie a URL e a chave anon
9. Cole no `supabase-config.dev.js`

---

## ✅ QUANDO ESTIVER PRONTO

Me avise quando:
- ✅ Configurou as credenciais DEV
- ✅ Iniciou os servidores
- ✅ Viu o badge laranja no localhost

Aí vamos testar tudo e importar os dados! 🚀
