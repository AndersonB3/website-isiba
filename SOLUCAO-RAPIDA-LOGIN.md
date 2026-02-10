# 🚨 SOLUÇÃO RÁPIDA - Usuário ou Senha Incorretos

## ⚡ Diagnóstico Atual

Você está vendo este erro:
```
❌ Erro na autenticação: Error: Usuário ou senha incorretos
```

**Causa:** O usuário `admin.isiba` NÃO EXISTE no banco de dados Supabase.

---

## ✅ SOLUÇÃO EM 3 PASSOS

### **PASSO 1: Verificar o Banco** 🔍

1. Acesse: https://supabase.com/dashboard
2. Entre no seu projeto **ISIBA**
3. Clique em **SQL Editor** (ícone </> na lateral esquerda)
4. Cole e execute este comando:

```sql
SELECT * FROM administradores;
```

**Resultado esperado:**
- ✅ Se mostrar linhas: A tabela existe mas pode estar vazia
- ❌ Se der erro: A tabela não existe

---

### **PASSO 2: Executar Script de Criação** 🚀

No mesmo **SQL Editor**, cole e execute **TODO** este script:

```sql
-- Criar tabela (se não existir)
CREATE TABLE IF NOT EXISTS administradores (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    usuario TEXT NOT NULL UNIQUE,
    senha_hash TEXT NOT NULL,
    nome_completo TEXT NOT NULL,
    email TEXT,
    ativo BOOLEAN DEFAULT true,
    ultimo_acesso TIMESTAMP WITH TIME ZONE,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Criar índices
CREATE INDEX IF NOT EXISTS idx_administradores_usuario ON administradores(usuario);
CREATE INDEX IF NOT EXISTS idx_administradores_ativo ON administradores(ativo);

-- Limpar admin antigo (se existir)
DELETE FROM administradores WHERE usuario IN ('admin', 'admin.isiba');

-- Inserir admin com senha correta
INSERT INTO administradores (
    usuario,
    senha_hash,
    nome_completo,
    email,
    ativo
) VALUES (
    'admin.isiba',
    'e8eb6f5b40251795e7003e28ceb3094ff2cbe18d31f7d503503c5515351ce40e',
    'Administrador ISIBA',
    'admin@isiba.com.br',
    true
);

-- Verificar se foi criado
SELECT usuario, nome_completo, email, ativo, criado_em 
FROM administradores 
WHERE usuario = 'admin.isiba';
```

**Resultado esperado:**
```
usuario: admin.isiba
nome_completo: Administrador ISIBA
email: admin@isiba.com.br
ativo: true
criado_em: [data atual]
```

---

### **PASSO 3: Fazer Login** 🔐

1. Acesse: `painel-rh/admin-rh.html`
2. Use as credenciais:

```
👤 Usuário: admin.isiba
🔐 Senha: Isiba@2026Seguro!
```

3. Clique em **Entrar**

**Resultado esperado:**
```
✅ Bem-vindo, Administrador ISIBA!
```

---

## 🔧 Ferramentas de Diagnóstico

### **Teste de Hash (Validar Senha)**

Abra no navegador: `teste-hash.html`

Isso vai:
- ✅ Gerar o hash da senha `Isiba@2026Seguro!`
- ✅ Comparar com o hash esperado
- ✅ Mostrar se estão iguais

**Hash correto:** `e8eb6f5b40251795e7003e28ceb3094ff2cbe18d31f7d503503c5515351ce40e`

### **Verificar Banco de Dados**

Execute no SQL Editor: `VERIFICAR_BANCO.sql`

Isso vai:
- ✅ Verificar se tabela existe
- ✅ Listar todos os administradores
- ✅ Contar quantos existem
- ✅ Verificar se `admin.isiba` existe

---

## 🐛 Problemas Comuns

### ❌ "Table 'administradores' does not exist"

**Solução:** Execute o **PASSO 2** completo (script de criação)

### ❌ "Query returned successfully but no rows"

**Solução:** A tabela está vazia. Execute o INSERT do **PASSO 2**

### ❌ "Usuário ou senha incorretos" (após executar script)

**Possíveis causas:**

1. **Hash incorreto no banco**
   - Solução: Execute este UPDATE:
   ```sql
   UPDATE administradores 
   SET senha_hash = 'e8eb6f5b40251795e7003e28ceb3094ff2cbe18d31f7d503503c5515351ce40e'
   WHERE usuario = 'admin.isiba';
   ```

2. **Usuário desativado**
   - Solução: Execute este UPDATE:
   ```sql
   UPDATE administradores 
   SET ativo = true
   WHERE usuario = 'admin.isiba';
   ```

3. **Digitou a senha errada**
   - Senha correta: `Isiba@2026Seguro!` (com I maiúsculo, @ no meio, ! no final)

### ❌ "Erro ao conectar com banco de dados"

**Solução:** Verifique `painel-rh/assets/js/supabase-config.js`:
```javascript
const CONFIG = {
    SUPABASE_URL: 'https://seu-projeto.supabase.co',
    SUPABASE_ANON_KEY: 'sua-chave-aqui'
};
```

---

## 📋 Checklist Final

Execute na ordem:

- [ ] **1.** Abri o Supabase Dashboard
- [ ] **2.** Fui em SQL Editor
- [ ] **3.** Executei o script completo (criação + inserção)
- [ ] **4.** Vi a mensagem de sucesso no SQL Editor
- [ ] **5.** Executei o SELECT para verificar
- [ ] **6.** Vi que `admin.isiba` apareceu na lista
- [ ] **7.** Acessei `painel-rh/admin-rh.html`
- [ ] **8.** Digitei `admin.isiba` no usuário
- [ ] **9.** Digitei `Isiba@2026Seguro!` na senha (EXATAMENTE assim)
- [ ] **10.** Cliquei em Entrar
- [ ] **11.** ✅ CONSEGUI ENTRAR!

---

## 🆘 Ainda não funciona?

Execute este script de diagnóstico completo:

```sql
-- 1. Deletar TUDO e começar do zero
DROP TABLE IF EXISTS administradores CASCADE;

-- 2. Criar tabela nova
CREATE TABLE administradores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario TEXT UNIQUE NOT NULL,
    senha_hash TEXT NOT NULL,
    nome_completo TEXT NOT NULL,
    email TEXT,
    ativo BOOLEAN DEFAULT true,
    ultimo_acesso TIMESTAMPTZ,
    criado_em TIMESTAMPTZ DEFAULT now(),
    atualizado_em TIMESTAMPTZ DEFAULT now()
);

-- 3. Inserir admin
INSERT INTO administradores (usuario, senha_hash, nome_completo, email, ativo)
VALUES (
    'admin.isiba',
    'e8eb6f5b40251795e7003e28ceb3094ff2cbe18d31f7d503503c5515351ce40e',
    'Administrador ISIBA',
    'admin@isiba.com.br',
    true
);

-- 4. Verificar
SELECT * FROM administradores;
```

Se **AINDA ASSIM** não funcionar, verifique:
1. Console do navegador (F12) para ver erros
2. Aba Network para ver requisições ao Supabase
3. Se o `supabase-config.js` tem as credenciais corretas

---

**Última atualização:** 10/02/2026  
**Hash validado:** ✅ `e8eb6f5b40251795e7003e28ceb3094ff2cbe18d31f7d503503c5515351ce40e`
