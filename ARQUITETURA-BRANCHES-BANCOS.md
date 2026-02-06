# 🏗️ ARQUITETURA: BRANCHES E BANCOS DE DADOS

## 📅 Atualizado: 06/02/2026

---

## 🎯 ESTRUTURA COMPLETA

### 🌳 GIT BRANCHES

```
┌─────────────────────────────────────────────────────────────┐
│  BRANCH: master                                             │
│  ├─ Commit atual: 9c0ace3                                   │
│  ├─ Deploy: GitHub Pages (automático)                       │
│  ├─ URL: https://andersonb3.github.io/website-isiba/        │
│  ├─ Banco: PRODUÇÃO (kklhcmrnraroletwbbid)                  │
│  └─ Status: ✅ PRODUÇÃO ATIVA                               │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  BRANCH: develop                                            │
│  ├─ Commit atual: a11c751                                   │
│  ├─ Deploy: Localhost apenas                                │
│  ├─ URL: http://localhost:8000                              │
│  ├─ Banco: DESENVOLVIMENTO (ikwnemhqqkpjurdpauim)           │
│  └─ Status: ✅ DESENVOLVIMENTO ATIVO                        │
└─────────────────────────────────────────────────────────────┘
```

---

## 💾 BANCOS DE DADOS SUPABASE

### 🟢 BANCO DE PRODUÇÃO
```
┌─────────────────────────────────────────────────────────────┐
│  Projeto: ISIBA (Produção)                                  │
│  URL: https://kklhcmrnraroletwbbid.supabase.co              │
│  Key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...               │
│                                                              │
│  ✅ Usado por: GitHub Pages (branch master)                 │
│  ✅ Arquivo: assets/js/supabase-config.js                   │
│  ✅ Dados: REAIS (colaboradores, contracheques, etc)        │
│  ✅ Versionado: SIM (vai pro GitHub)                        │
└─────────────────────────────────────────────────────────────┘
```

### 🟡 BANCO DE DESENVOLVIMENTO
```
┌─────────────────────────────────────────────────────────────┐
│  Projeto: isiba-desenvolvimento                             │
│  URL: https://ikwnemhqqkpjurdpauim.supabase.co              │
│  Key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...               │
│                                                              │
│  ✅ Usado por: Localhost (branch develop)                   │
│  ✅ Arquivo: assets/js/supabase-config.dev.js               │
│  ✅ Dados: TESTE (dados falsos para desenvolvimento)        │
│  ❌ Versionado: NÃO (gitignore - não vai pro GitHub)        │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔄 FLUXO DE TRABALHO

### 📝 DESENVOLVIMENTO (Dia a Dia)

```bash
# 1. Trabalhar na branch develop
git checkout develop

# 2. Fazer alterações no código
# (editar arquivos HTML, CSS, JS...)

# 3. Testar localmente
INICIAR-TUDO.bat
# Abrir: http://localhost:8000

# 4. Verificar:
# ✅ Badge laranja: "🔧 DESENVOLVIMENTO"
# ✅ Console: "🔧 AMBIENTE: DESENVOLVIMENTO"
# ✅ Banco: ikwnemhqqkpjurdpauim (DEV)

# 5. Fazer commit
git add .
git commit -m "feat: nova funcionalidade"

# 6. Push para develop (opcional)
git push origin develop
```

### 🚀 PRODUÇÃO (Deploy)

```bash
# 1. Voltar para master
git checkout master

# 2. Fazer merge da develop
git merge develop

# 3. Push para GitHub
git push origin master

# 4. GitHub Pages faz deploy automático
# ✅ URL: https://andersonb3.github.io/website-isiba/
# ✅ Banco: kklhcmrnraroletwbbid (PRODUÇÃO)
# ✅ Sem badge de desenvolvimento
```

---

## 📂 ARQUIVOS DE CONFIGURAÇÃO

### Estrutura Completa:
```
assets/js/
├── supabase-config-loader.js       🔍 Detecta ambiente automaticamente
├── supabase-config.js              🟢 PRODUÇÃO (vai pro GitHub)
└── supabase-config.dev.js          🟡 DESENVOLVIMENTO (gitignored)

painel-rh/assets/js/
├── supabase-config.js              🟢 PRODUÇÃO (vai pro GitHub)
└── supabase-config.dev.js          🟡 DESENVOLVIMENTO (gitignored)
```

### 🔍 Como Funciona a Detecção:

O arquivo `supabase-config-loader.js` detecta automaticamente:

| Hostname | Ambiente | Arquivo Carregado | Banco Usado |
|----------|----------|-------------------|-------------|
| `localhost` | DESENVOLVIMENTO | `supabase-config.dev.js` | ikwnemhqqkpjurdpauim |
| `127.0.0.1` | DESENVOLVIMENTO | `supabase-config.dev.js` | ikwnemhqqkpjurdpauim |
| `file://` | DESENVOLVIMENTO | `supabase-config.dev.js` | ikwnemhqqkpjurdpauim |
| `*.github.io` | PRODUÇÃO | `supabase-config.js` | kklhcmrnraroletwbbid |
| Outros | PRODUÇÃO | `supabase-config.js` | kklhcmrnraroletwbbid |

---

## ⚠️ REGRAS IMPORTANTES

### ✅ O QUE FAZER:

1. **Desenvolver na branch `develop`**
   - Sempre trabalhar aqui para novas features
   - Testar localmente (localhost:8000)
   - Usar banco de DESENVOLVIMENTO

2. **Subir para `master` só quando pronto**
   - Merge develop → master
   - Push para GitHub
   - Deploy automático no GitHub Pages

3. **NUNCA commitar `supabase-config.dev.js`**
   - Já está no .gitignore
   - Cada desenvolvedor tem suas próprias credenciais

### ❌ O QUE NÃO FAZER:

1. **Não trabalhar direto na `master`**
   - master é para produção
   - Sempre use develop primeiro

2. **Não testar com banco de produção localmente**
   - Use sempre o banco de desenvolvimento
   - Evite mexer em dados reais

3. **Não commitar credenciais de desenvolvimento**
   - O .gitignore já protege
   - Mas sempre verifique antes de push

---

## 🎯 CENÁRIOS COMUNS

### 📝 Cenário 1: "Quero adicionar uma nova feature"

```bash
# Passo 1: Ir para develop
git checkout develop

# Passo 2: Criar nova branch (opcional)
git checkout -b feature/nome-da-feature

# Passo 3: Desenvolver e testar
# (código aqui)
INICIAR-TUDO.bat

# Passo 4: Commit
git add .
git commit -m "feat: descrição da feature"

# Passo 5: Merge para develop
git checkout develop
git merge feature/nome-da-feature

# Passo 6: Quando tudo estiver OK, subir para produção
git checkout master
git merge develop
git push origin master
```

### 🐛 Cenário 2: "Bug crítico em produção!"

```bash
# Passo 1: Criar hotfix direto da master
git checkout master
git checkout -b hotfix/nome-do-bug

# Passo 2: Corrigir o bug
# (código aqui)

# Passo 3: Merge para master
git checkout master
git merge hotfix/nome-do-bug
git push origin master

# Passo 4: Aplicar correção também na develop
git checkout develop
git merge hotfix/nome-do-bug
git push origin develop
```

### 🔄 Cenário 3: "Sincronizar develop com master"

```bash
# Passo 1: Ir para develop
git checkout develop

# Passo 2: Fazer merge da master
git merge master

# Passo 3: Resolver conflitos (se houver)
# (editar arquivos com conflito)

# Passo 4: Commit do merge
git add .
git commit -m "merge: sincronizar develop com master"
```

---

## 📊 VERIFICAÇÃO DE AMBIENTE

### Como saber em qual ambiente estou?

#### No Navegador:
1. **Badge visual:**
   - 🟡 Badge laranja "🔧 DESENVOLVIMENTO" = Ambiente de desenvolvimento
   - ⚪ Sem badge = Ambiente de produção

2. **Console do navegador (F12):**
   ```
   🔧 AMBIENTE: DESENVOLVIMENTO
   🗄️ Banco: https://ikwnemhqqkpjurdpauim.supabase.co
   ```
   ou
   ```
   🌐 AMBIENTE: PRODUÇÃO (GitHub Pages)
   🗄️ Banco: https://kklhcmrnraroletwbbid.supabase.co
   ```

#### No Git:
```bash
# Ver branch atual
git branch --show-current

# Ver último commit
git log -1 --oneline
```

---

## 🔒 SEGURANÇA

### Arquivos Protegidos pelo .gitignore:
```
✅ **/supabase-config.dev.js    (credenciais de desenvolvimento)
✅ .env                          (variáveis de ambiente)
✅ .env.local                    (variáveis locais)
✅ node_modules/                 (dependências)
```

### Arquivos que VÃO para o GitHub:
```
✅ assets/js/supabase-config.js         (produção - seguro)
✅ painel-rh/assets/js/supabase-config.js (produção - seguro)
✅ Todos os HTMLs, CSS, JS principais
```

**⚠️ IMPORTANTE:** As chaves do Supabase são públicas (anon key) e podem ser expostas no frontend. A segurança é garantida pelas políticas RLS no Supabase.

---

## ✅ CHECKLIST DE DEPLOY

Antes de fazer `git push origin master`:

- [ ] Testei tudo localmente (localhost:8000)?
- [ ] Verifiquei que estou na branch develop?
- [ ] Fiz commit de todas as alterações?
- [ ] Funcionalidades estão funcionando corretamente?
- [ ] Não comitei arquivos `supabase-config.dev.js`?
- [ ] Li o log de commits para confirmar?
- [ ] Fiz merge para master?
- [ ] Agora sim posso fazer push!

---

## 🎉 RESUMO VISUAL

```
┌─────────────────────────────────────────────────────────────┐
│                   FLUXO DE TRABALHO                         │
└─────────────────────────────────────────────────────────────┘

    DESENVOLVIMENTO                      PRODUÇÃO
    ───────────────                      ────────
         
    📝 Branch: develop                  🚀 Branch: master
    💻 Local: localhost:8000            🌐 Deploy: GitHub Pages
    🟡 Banco: DESENVOLVIMENTO           🟢 Banco: PRODUÇÃO
    🔧 Badge: Laranja                   ⚪ Badge: Sem badge
    📁 Config: .dev.js (gitignored)     📁 Config: .js (versionado)
         
         │                                    ▲
         │                                    │
         │  git checkout master               │
         │  git merge develop                 │
         │  git push origin master            │
         │                                    │
         └────────────────────────────────────┘
                   DEPLOY SEGURO
```

---

## 📞 CONTATOS E LINKS

- **GitHub Repository:** https://github.com/AndersonB3/website-isiba
- **GitHub Pages:** https://andersonb3.github.io/website-isiba/
- **Supabase Dashboard:** https://supabase.com/dashboard

---

**✅ CONFIGURAÇÃO ATUAL: TUDO CERTO!**
- Branch develop configurada para DESENVOLVIMENTO
- Branch master configurada para PRODUÇÃO
- Detecção automática de ambiente funcionando
- Arquivos .dev.js protegidos pelo .gitignore
