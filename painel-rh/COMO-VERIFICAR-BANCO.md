# 🔍 Como Verificar Alterações no Banco de Dados Supabase

## 📊 Método 1: Via Interface Web do Supabase (MAIS FÁCIL)

### **Passo a Passo:**

1. **Acesse o Supabase:**
   - URL: https://supabase.com/dashboard/project/kklhcmrnraroletwbbid
   - Faça login com sua conta

2. **Vá para Table Editor:**
   - No menu lateral esquerdo, clique em **"Table Editor"** (ícone de tabela)
   - Ou acesse direto: https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/editor

3. **Selecione a tabela `colaboradores`:**
   - No painel esquerdo, você verá todas as tabelas
   - Clique em **`colaboradores`**

4. **Visualize os dados:**
   - Você verá uma tabela com todos os funcionários cadastrados
   - Cada linha é um funcionário

5. **Verifique as alterações:**
   - 🔍 **Nome:** Veja se o `nome_completo` foi alterado
   - 📧 **E-mail:** Veja se o `email` foi atualizado
   - 🔐 **Senha:** Veja se o `senha_hash` mudou (string longa)
   - ✅ **Status:** Veja se o campo `ativo` é `true` ou `false`
   - 📅 **Data:** Veja o campo `atualizado_em` - deve ter a data/hora recente

---

## 🔎 O que Observar:

### **Antes da Edição:**
```
nome_completo: "João Silva"
email: "joao@email.com"
senha_hash: "8d969eef6ecad3c29a3a629280e686cf..."
ativo: true
atualizado_em: "2026-01-20 10:30:00"
```

### **Depois da Edição (se você mudou nome e senha):**
```
nome_completo: "João Silva Santos"  ← MUDOU
email: "joao@email.com"  ← NÃO MUDOU (se não alterou)
senha_hash: "5e884898da28047151d0e56f8dc62927..."  ← MUDOU (hash diferente)
ativo: true  ← NÃO MUDOU (se não alterou)
atualizado_em: "2026-01-28 15:45:23"  ← MUDOU (data atual)
```

---

## 📋 Método 2: Via SQL Query (MAIS TÉCNICO)

### **Verificar Dados de um Funcionário Específico:**

1. **Acesse SQL Editor:**
   - No Supabase, vá em **"SQL Editor"**
   - Ou acesse: https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/sql/new

2. **Cole e execute esta query:**

```sql
-- Ver todos os dados de um funcionário específico
SELECT 
    id,
    nome_completo,
    cpf,
    email,
    ativo,
    senha_hash,
    criado_em,
    atualizado_em
FROM colaboradores
WHERE nome_completo ILIKE '%João%'  -- Substitua por parte do nome
ORDER BY atualizado_em DESC;
```

3. **Clique em "Run"** ou pressione **F5**

4. **Resultado:** Você verá todos os dados do funcionário

---

## 🔐 Verificar se a Senha foi Alterada:

### **Query para ver hashes de senha:**

```sql
-- Ver CPF e hash da senha de todos os funcionários
SELECT 
    nome_completo,
    cpf,
    LEFT(senha_hash, 20) || '...' as senha_hash_inicio,
    LENGTH(senha_hash) as tamanho_hash,
    atualizado_em
FROM colaboradores
ORDER BY atualizado_em DESC;
```

**O que observar:**
- ✅ `senha_hash_inicio` mostra os primeiros 20 caracteres do hash
- ✅ Se mudou, o hash será diferente
- ✅ Hash SHA-256 sempre tem 64 caracteres
- ✅ Campo `atualizado_em` mostra quando foi a última alteração

---

## 📅 Verificar Última Modificação:

### **Query para ver alterações recentes:**

```sql
-- Ver funcionários ordenados por última modificação
SELECT 
    nome_completo,
    cpf,
    email,
    CASE 
        WHEN ativo = true THEN 'Ativo'
        ELSE 'Inativo'
    END as status,
    criado_em as cadastrado_em,
    atualizado_em as ultima_modificacao,
    EXTRACT(EPOCH FROM (NOW() - atualizado_em)) / 60 as minutos_desde_atualizacao
FROM colaboradores
ORDER BY atualizado_em DESC
LIMIT 10;
```

**Resultado:** Mostra os 10 funcionários modificados mais recentemente, com quanto tempo faz que foram atualizados.

---

## 🧪 Teste Prático - Verificar Senha Foi Alterada:

### **Passo 1: Anotar o Hash Atual**

```sql
-- Antes de editar, anote o hash atual
SELECT nome_completo, senha_hash 
FROM colaboradores 
WHERE nome_completo = 'João Silva Santos';
```

**Resultado exemplo:**
```
nome_completo: João Silva Santos
senha_hash: 8d969eef6ecad3c29a3a629280e686cf0b98d519e0cd9e...
```

### **Passo 2: Editar a Senha no Painel**
- Vá no painel RH
- Edite o funcionário
- Digite nova senha: `novaSenha123`
- Salve

### **Passo 3: Verificar se o Hash Mudou**

```sql
-- Depois de editar, verificar se hash mudou
SELECT nome_completo, senha_hash, atualizado_em
FROM colaboradores 
WHERE nome_completo = 'João Silva Santos';
```

**Resultado esperado:**
```
nome_completo: João Silva Santos
senha_hash: 5e884898da28047151d0e56f8dc6292773603d0d6aabdd...  ← DIFERENTE!
atualizado_em: 2026-01-28 15:45:23  ← ATUALIZADO!
```

✅ **Se o hash mudou = Senha foi alterada no banco!**

---

## 🎯 Teste Final - Validar Senha Nova Funciona:

### **Calcular hash da senha para comparar:**

Se você quiser ter certeza absoluta, pode calcular o hash da senha manualmente e comparar:

**No SQL Editor:**

```sql
-- Função para calcular SHA-256 (só funciona com extensão pgcrypto)
SELECT encode(digest('novaSenha123', 'sha256'), 'hex') as hash_calculado;
```

**Compare o resultado com o `senha_hash` do banco:**
- Se forem iguais = Senha foi salva corretamente!

---

## 📸 Visual Guide - Onde Clicar:

### **1. Dashboard do Supabase:**
```
┌─────────────────────────────────────┐
│ 🏠 Home                             │
│ 📊 Table Editor  ← CLIQUE AQUI      │
│ 🗄️  SQL Editor                      │
│ 🔐 Authentication                   │
│ 📦 Storage                          │
│ ⚙️  Settings                        │
└─────────────────────────────────────┘
```

### **2. Table Editor:**
```
┌─────────────────────────────────────────────┐
│ Tables:                │ colaboradores      │
│ ├─ administradores     ├──────────────────  │
│ ├─ colaboradores  ←─── │ id  │ nome        │
│ └─ contracheques       │ 123 │ João Silva  │
└─────────────────────────────────────────────┘
```

### **3. Ver Detalhes:**
- Clique em qualquer linha da tabela
- Abre um painel lateral com todos os campos
- Você vê todos os valores, incluindo `senha_hash`

---

## ✅ Checklist de Verificação:

Após editar um funcionário, verifique:

- [ ] Abri o Supabase no navegador
- [ ] Fui em **Table Editor** → **colaboradores**
- [ ] Encontrei o funcionário que editei
- [ ] ✅ Campo `nome_completo` mudou (se editei o nome)
- [ ] ✅ Campo `email` mudou (se editei o e-mail)
- [ ] ✅ Campo `senha_hash` mudou (se editei a senha)
- [ ] ✅ Campo `ativo` mudou (se mudei o status)
- [ ] ✅ Campo `atualizado_em` tem data/hora recente
- [ ] ✅ Campo `cpf` NÃO mudou (é bloqueado)

---

## 🔴 Se Não Mudou no Banco:

### **Possíveis Causas:**

1. **Erro na requisição:**
   - Abra o **Console do navegador** (F12)
   - Veja se há erros em vermelho
   - Copie e me envie a mensagem de erro

2. **Problemas de permissão:**
   - Verifique as políticas RLS do Supabase
   - Execute os scripts de RLS do arquivo `SCRIPTS-SQL-SUPABASE.md`

3. **Validação falhou:**
   - Verifique se a mensagem de sucesso apareceu
   - Veja no console se há log: "✅ Colaborador atualizado"

---

## 💡 Dica Rápida:

**Forma mais rápida de verificar:**

1. Acesse: https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/editor
2. Clique em **`colaboradores`**
3. Procure o funcionário editado
4. Veja o campo **`atualizado_em`**
5. Se está com data/hora recente = **Funcionou!** ✅

---

## 🎥 Video Tutorial (se precisar):

Se quiser um tutorial visual, posso criar screenshots ou um guia passo a passo mais detalhado.

---

**🎉 Agora verifique no Supabase e me conte o resultado!**

