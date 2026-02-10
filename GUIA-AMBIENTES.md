# 🔧 Guia Completo: Ambientes de Desenvolvimento e Produção

## 📋 Índice
1. [Visão Geral](#visão-geral)
2. [Passo a Passo](#passo-a-passo)
3. [Estrutura de Arquivos](#estrutura-de-arquivos)
4. [Como Funciona](#como-funciona)
5. [Troubleshooting](#troubleshooting)

---

## 🎯 Visão Geral

Agora o sistema possui **dois ambientes completamente separados**:

| Ambiente | Banco de Dados | Uso | Hostname |
|----------|---------------|-----|----------|
| **PRODUÇÃO** | `isiba-producao` | GitHub Pages (usuários reais) | `andersonb3.github.io` |
| **DESENVOLVIMENTO** | `isiba-desenvolvimento` | Testes locais (dados falsos) | `localhost:8000` |

### ✅ Vantagens:
- ✅ Dados de produção **100% seguros**
- ✅ Teste **sem medo** de quebrar nada
- ✅ Troca **automática** de ambiente
- ✅ Visual badge indicando ambiente

---

## 🚀 Passo a Passo

### 1️⃣ Criar Projeto de Desenvolvimento no Supabase

1. Acesse: https://supabase.com/dashboard
2. Clique em **"New Project"**
3. Configurações:
   - **Name:** `isiba-desenvolvimento` (ou `isiba-dev`)
   - **Database Password:** escolha uma senha forte e anote
   - **Region:** mesma da produção (`South America (São Paulo)`)
   - **Pricing Plan:** Free
4. Clique em **"Create new project"**
5. **Aguarde 2-3 minutos** até o projeto ser criado

---

### 2️⃣ Executar Script de Migração

1. No projeto de **DESENVOLVIMENTO**, vá em: **SQL Editor**
2. Clique em **"New Query"**
3. Abra o arquivo: `database/MIGRAÇÃO-DESENVOLVIMENTO.sql`
4. **Copie TODO o conteúdo** do arquivo
5. **Cole** no SQL Editor
6. Clique em **"Run"** (ou pressione `Ctrl + Enter`)
7. ✅ Aguarde a execução (leva ~10 segundos)

**Resultado esperado:**
```
Success. No rows returned
```

---

### 3️⃣ Criar Bucket de Storage

> ⚠️ **IMPORTANTE:** Buckets NÃO podem ser criados via SQL!

1. No projeto de **DESENVOLVIMENTO**, vá em: **Storage**
2. Clique em **"Create a new bucket"**
3. Configurações:
   - **Name:** `contracheques`
   - **Public bucket:** ❌ **NÃO** (deixe privado)
   - **File size limit:** `10 MB`
   - **Allowed MIME types:** `application/pdf`
4. Clique em **"Create bucket"**

---

### 4️⃣ Configurar Políticas de Storage

1. Ainda em **Storage**, clique no bucket `contracheques`
2. Vá na aba **"Policies"**
3. Execute o script de políticas:
   - Abra o arquivo: `POLITICAS_STORAGE.sql`
   - Cole no SQL Editor
   - Execute

---

### 5️⃣ Configurar Arquivo de Desenvolvimento

1. No projeto de **DESENVOLVIMENTO**, vá em: **Settings > API**
2. Copie:
   - **Project URL** (ex: `https://xyz.supabase.co`)
   - **anon public key** (a chave grande que começa com `eyJ...`)

3. Abra o arquivo: `assets/js/supabase-config.dev.js`
4. Cole as credenciais:

```javascript
const SUPABASE_URL_DEV = 'https://seu-projeto-dev.supabase.co';
const SUPABASE_ANON_KEY_DEV = 'eyJhbGciOiJI...sua-chave-completa';
```

5. **Salve o arquivo**

---

### 6️⃣ Testar Localmente

1. Inicie o servidor local:
```bash
python -m http.server 8000
```

2. Acesse: http://localhost:8000

3. ✅ Você deve ver:
   - Badge laranja no canto inferior direito: **"🔧 DESENVOLVIMENTO"**
   - No console do navegador: `🔧 AMBIENTE: DESENVOLVIMENTO`

4. Teste o login:
   - **Admin RH:** `admin.rh` / `admin123`
   - **Colaborador:** CPF `12345678901` / Senha `123456`

---

## 📁 Estrutura de Arquivos

```
assets/js/
├── supabase-config-loader.js  ← Detecta ambiente automaticamente
├── supabase-config.js          ← Configuração de PRODUÇÃO
└── supabase-config.dev.js      ← Configuração de DESENVOLVIMENTO
```

**Importante:**
- ✅ `supabase-config.js` → Vai para o GitHub (produção)
- ❌ `supabase-config.dev.js` → **NÃO** commitar (adicionar ao `.gitignore`)

---

## 🔍 Como Funciona

### Detecção Automática

O arquivo `supabase-config-loader.js` detecta o ambiente baseado no hostname:

| Hostname | Ambiente | Arquivo Carregado |
|----------|----------|-------------------|
| `localhost` | Desenvolvimento | `supabase-config.dev.js` |
| `127.0.0.1` | Desenvolvimento | `supabase-config.dev.js` |
| `file://` | Desenvolvimento | `supabase-config.dev.js` |
| `andersonb3.github.io` | Produção | `supabase-config.js` |
| Qualquer outro | Produção | `supabase-config.js` |

### Ordem de Carregamento (nos HTMLs)

```html
<!-- 1. Carregar biblioteca Supabase -->
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>

<!-- 2. Carregar detector de ambiente (NOVO) -->
<script src="assets/js/supabase-config-loader.js"></script>

<!-- 3. Outros scripts do sistema -->
<script src="assets/js/admin-rh.js"></script>
```

---

## 🎨 Indicadores Visuais

### Desenvolvimento
- **Badge:** 🔧 DESENVOLVIMENTO (laranja, canto inferior direito)
- **Console:** Fundo laranja, mensagem clara
- **Debug:** Logs detalhados habilitados

### Produção
- **Badge:** Nenhum (limpo)
- **Console:** Mensagem simples
- **Debug:** Desabilitado

---

## 🐛 Troubleshooting

### Problema: "Badge de desenvolvimento não aparece"

**Possíveis causas:**
1. Arquivo `supabase-config.dev.js` não configurado
2. Servidor não está rodando em `localhost`
3. Cache do navegador

**Solução:**
1. Verifique se as credenciais foram coladas corretamente
2. Limpe o cache (Ctrl + Shift + R)
3. Verifique o console: `F12` → aba "Console"

---

### Problema: "Erro ao conectar ao Supabase"

**Solução:**
1. Verifique se o projeto de desenvolvimento foi criado
2. Verifique se a chave `anon` está correta (não use a chave `service_role`)
3. Verifique se a URL está com `https://`

---

### Problema: "Sistema conecta ao banco de produção localmente"

**Solução:**
1. Verifique se o arquivo `supabase-config-loader.js` está sendo carregado **ANTES** dos outros scripts
2. Verifique o console: deve mostrar `🔧 AMBIENTE: DESENVOLVIMENTO`
3. Limpe o cache do navegador

---

### Problema: "Bucket 'contracheques' não existe"

**Solução:**
1. Vá em **Storage** no Supabase
2. Crie manualmente o bucket (veja Passo 3)
3. Configure as políticas (veja Passo 4)

---

## ✅ Checklist de Validação

Marque conforme for completando:

- [ ] Projeto de desenvolvimento criado no Supabase
- [ ] Script de migração executado sem erros
- [ ] Bucket `contracheques` criado
- [ ] Políticas de storage configuradas
- [ ] Arquivo `supabase-config.dev.js` configurado com credenciais
- [ ] Badge "🔧 DESENVOLVIMENTO" aparece localmente
- [ ] Login funciona com dados de teste
- [ ] GitHub Pages continua funcionando normalmente (produção)

---

## 📚 Próximos Passos

Após configurar o ambiente de desenvolvimento:

1. ✅ **Sempre trabalhe localmente** para testar mudanças
2. ✅ **Teste tudo** antes de fazer commit
3. ✅ **Só faça push** quando tiver certeza que funciona
4. ✅ **Dados de produção** ficam intocados

---

## 🆘 Suporte

Se tiver qualquer dúvida:
1. Verifique o console do navegador (`F12`)
2. Revise este guia
3. Verifique se seguiu todos os passos na ordem

---

**Data de Criação:** 05/02/2026  
**Versão:** 1.0  
**Autor:** Sistema ISIBA
