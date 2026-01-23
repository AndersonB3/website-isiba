# 🚀 GUIA COMPLETO - Configurar Supabase + PostgreSQL

## 📋 Índice
1. [Criar Conta no Supabase](#passo-1-criar-conta)
2. [Criar Projeto](#passo-2-criar-projeto)
3. [Executar Script SQL](#passo-3-executar-script)
4. [Configurar Credenciais](#passo-4-configurar-credenciais)
5. [Testar Integração](#passo-5-testar)
6. [Atualizar Dados](#passo-6-atualizar-dados)

---

## 🎯 PASSO 1: Criar Conta no Supabase

1. Acesse: **https://supabase.com**
2. Clique em **"Start your project"**
3. Escolha login com:
   - GitHub (recomendado)
   - Google
   - Email

✅ **Conta criada!**

---

## 🎯 PASSO 2: Criar Novo Projeto

1. No dashboard, clique em **"New Project"**
2. Preencha os dados:
   ```
   Nome: ISIBA Social
   Database Password: [crie uma senha forte]
   Region: South America (São Paulo) - MAIS RÁPIDO
   Pricing Plan: Free
   ```
3. Clique em **"Create new project"**
4. ⏳ Aguarde 1-2 minutos enquanto o banco é criado

✅ **Projeto criado!**

---

## 🎯 PASSO 3: Executar Script SQL

### 3.1 Abrir SQL Editor
1. No menu lateral, clique em **"SQL Editor"** (ícone </> )
2. Clique em **"New Query"**

### 3.2 Executar Schema
1. Abra o arquivo: `database/schema.sql`
2. **Copie TODO o conteúdo**
3. Cole no SQL Editor do Supabase
4. Clique em **"Run"** (ou pressione Ctrl+Enter)
5. Aguarde a mensagem: ✅ **"Success. No rows returned"**

### 3.3 Verificar Tabela Criada
1. No menu lateral, clique em **"Table Editor"**
2. Você deve ver a tabela **"statistics"**
3. Clique nela para ver os dados iniciais

✅ **Banco configurado!**

---

## 🎯 PASSO 4: Configurar Credenciais

### 4.1 Obter URL e API Key

⚠️ **ATENÇÃO**: Você está vendo a chave ERRADA! 

O Supabase mostra `sb_publishable_...` na tela de **"Conectar"**, mas essa NÃO é a chave correta!

**Siga EXATAMENTE estes passos:**

1. **IGNORE o botão "Conectar" que você está vendo!** ❌
2. No canto inferior esquerdo, procure o ícone de **engrenagem ⚙️** (Settings)
3. Clique em **"Project Settings"** (Configurações do Projeto)
4. No menu lateral que abrir, clique em **"API"**
5. Agora sim! Role a página até encontrar **"Project API keys"**
6. Você verá uma tela com **Configuration** e várias chaves:
   ```
   � URL (Project URL):
   https://kklhcmrnraroletwbbid.supabase.co
   
   � API Keys:
   
   🔑 anon public (ESTA É A CORRETA!) ✅
   eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtrbGhjbXJucmFyb2xldHdiYmlkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc1NTU2MTgsImV4cCI6MjA1MzEzMTYxOH0...
   (É LONGA - mais de 200 caracteres!)
   (Tem 3 partes separadas por pontos)
   
   � service_role (NÃO USE!) ❌
   eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9... (outra chave secreta)
   ```

7. **Clique no ícone de copiar** 📋 ao lado da chave **"anon public"**

### 4.2 Configurar no Site
1. Abra o arquivo: `assets/js/supabase-config.js`
2. Substitua os valores:

```javascript
const SUPABASE_URL = 'https://kklhcmrnraroletwbbid.supabase.co'; // ✅ Já está correto
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI...'; // ← Cole APENAS a chave "anon public"
```

3. Salve o arquivo (Ctrl+S)

### 4.3 Verificar se copiou a chave correta

A chave **anon** correta:
- ✅ Começa com: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9`
- ✅ Tem mais de 200 caracteres
- ✅ Contém pontos: `ey...alguma_coisa...mais_coisa`
- ✅ Exemplo do seu projeto: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtrbGhjbXJucmFyb2xldHdiYmlkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc1NTU2MTgsImV4cCI6MjA1MzEzMTYxOH0...`

A chave **errada** (publishable):
- ❌ Começa com: `sb_publishable_`
- ❌ É curta (30-40 caracteres)
- ❌ **NÃO FUNCIONA para API!**
- ❌ É a que aparece no botão "Conectar" - IGNORE!

### 🎯 RESUMO DO CAMINHO CORRETO:
```
1️⃣ Canto inferior esquerdo → ⚙️ (ícone engrenagem)
2️⃣ Project Settings
3️⃣ Menu lateral → API
4️⃣ Seção "Project API keys"
5️⃣ Copiar a chave "anon public"
```

✅ **Credenciais configuradas!**

---

## 🎯 PASSO 5: Testar Integração

### 5.1 Abrir Site
1. Acesse: http://localhost:8000
2. Abra o Console do navegador (F12 > Console)

### 5.2 Verificar Mensagens
Você deve ver:
```
✅ Supabase configurado com sucesso!
🚀 Inicializando sistema de estatísticas...
🔄 Buscando estatísticas do banco de dados...
✅ Estatísticas carregadas: {atendimentos: 250000, ...}
✅ Interface atualizada com dados do banco!
✨ Sistema de estatísticas inicializado com sucesso!
🔄 Configurando atualizações em tempo real...
✅ Atualizações em tempo real ativadas!
```

### 5.3 Verificar Números na Página
Os números devem aparecer:
- **250.000** Atendimentos
- **12** Unidades
- **850** Profissionais
- **98%** Satisfação

✅ **Tudo funcionando!**

---

## 🎯 PASSO 6: Atualizar Dados

### Método 1: Via Interface do Supabase (FÁCIL) ⭐

1. Acesse **Table Editor**
2. Clique na tabela **"statistics"**
3. Clique no registro ativo (linha com `ativo = true`)
4. Clique em **"Edit"** (ícone de lápis)
5. Altere os valores:
   ```
   atendimentos: 300000
   unidades: 15
   profissionais: 920
   satisfacao: 99
   ano: 2026
   ```
6. Clique em **"Save"**
7. 🎉 O site atualiza AUTOMATICAMENTE!

### Método 2: Via SQL

```sql
-- Desativar registro antigo
UPDATE statistics SET ativo = false WHERE ativo = true;

-- Inserir novos dados
INSERT INTO statistics (atendimentos, unidades, profissionais, satisfacao, ano, mes, ativo)
VALUES (300000, 15, 920, 99, 2026, 'Janeiro', true);
```

### Método 3: Criar Painel Administrativo

Quer um painel web para atualizar? Me avise e eu crio!

---

## 📊 Estrutura do Banco

```sql
statistics
├── id (serial) - ID único
├── atendimentos (integer) - Total de atendimentos
├── unidades (integer) - Número de unidades
├── profissionais (integer) - Número de profissionais
├── satisfacao (integer) - % de satisfação (0-100)
├── ano (integer) - Ano de referência
├── mes (varchar) - Mês (opcional)
├── ativo (boolean) - Registro ativo para exibição
├── created_at (timestamp) - Data de criação
└── updated_at (timestamp) - Data de atualização
```

---

## 🔐 Segurança Configurada

✅ **Row Level Security (RLS)** ativado
✅ **Leitura pública** apenas de dados ativos
✅ **Escrita protegida** (apenas autenticados)
✅ **API Key pública** segura para frontend

---

## 🚨 Solução de Problemas

### Erro: "Invalid API key"
- Verifique se copiou a chave correta (anon public)
- Não use a `service_role` key (é secreta!)

### Erro: "Failed to fetch"
- Verifique a URL do projeto
- Certifique-se que o projeto está ativo

### Números não aparecem
- Abra o Console (F12)
- Verifique se há erros em vermelho
- Certifique-se que tem dados com `ativo = true`

### Erro: "supabase is not defined"
- Verifique se o script CDN está carregando
- Veja a aba Network no DevTools

---

## 📞 Suporte

- **Documentação Supabase**: https://supabase.com/docs
- **PostgreSQL Docs**: https://www.postgresql.org/docs/

---

## 🎉 Pronto!

Agora você tem:
✅ Banco de dados PostgreSQL profissional
✅ Dados dinâmicos no site
✅ Atualização em tempo real
✅ Sistema seguro e escalável
✅ Painel administrativo no Supabase

**Próximos passos:**
- Atualizar com dados reais
- Adicionar mais estatísticas
- Criar gráficos e relatórios
- Integrar com outros sistemas

🚀 **Seu site agora é DINÂMICO!**
