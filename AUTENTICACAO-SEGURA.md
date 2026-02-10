# 🔐 Configuração de Autenticação Segura - Painel Admin ISIBA

## 📋 Visão Geral

O sistema de autenticação do Painel RH está **totalmente integrado com o Supabase**, usando criptografia SHA-256 para senhas e validação no banco de dados.

---

## 🚀 Passo a Passo - Configuração Inicial

### 1️⃣ Executar Script SQL no Supabase

1. Acesse o **Supabase Dashboard**
2. Vá em **SQL Editor**
3. Abra o arquivo `CRIAR_ADMIN_SEGURO.sql`
4. Copie todo o conteúdo
5. Cole no SQL Editor
6. Clique em **RUN** (Executar)

### 2️⃣ Credenciais Iniciais

Após executar o script, use estas credenciais para o primeiro acesso:

```
👤 Usuário: admin.isiba
🔐 Senha: Isiba@2026Seguro!
```

⚠️ **IMPORTANTE:** Altere a senha imediatamente após o primeiro login!

### 3️⃣ Alterar Senha (Obrigatório)

**Opção 1 - Interface Web (Recomendado):**
1. Acesse: `painel-rh/trocar-senha.html`
2. Preencha:
   - Usuário: `admin.isiba`
   - Senha Atual: `Isiba@2026Seguro!`
   - Nova Senha: *sua senha segura*
   - Confirmar: *mesma senha*
3. Clique em **Alterar Senha**

**Opção 2 - SQL Manual:**
```sql
-- 1. Gere o hash da sua nova senha no console do navegador:
async function gerarHash(senha) {
    const encoder = new TextEncoder();
    const data = encoder.encode(senha);
    const hashBuffer = await crypto.subtle.digest('SHA-256', data);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}

const hash = await gerarHash('MinhaNovaSenh@Segura123');
console.log('Hash:', hash);

-- 2. Execute no Supabase SQL Editor:
UPDATE administradores 
SET senha_hash = 'hash_gerado_acima',
    atualizado_em = now()
WHERE usuario = 'admin.isiba';
```

---

## 👥 Criar Novos Administradores

### Via Console do Navegador (Após Login)

1. Abra o **Console** do navegador (F12)
2. Execute:

```javascript
// Gerar hash da senha
async function gerarHash(senha) {
    const encoder = new TextEncoder();
    const data = encoder.encode(senha);
    const hashBuffer = await crypto.subtle.digest('SHA-256', data);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}

// Exemplo de uso
const hash = await gerarHash('SenhaDoNovoAdmin123');
console.log('Hash gerado:', hash);
```

3. Copie o hash gerado
4. Execute no **Supabase SQL Editor**:

```sql
INSERT INTO administradores (
    usuario,
    senha_hash,
    nome_completo,
    email,
    ativo
) VALUES (
    'maria.silva',
    'hash_gerado_aqui',
    'Maria Silva',
    'maria.silva@isiba.com.br',
    true
);
```

---

## 🔒 Segurança Implementada

### ✅ Recursos de Segurança

- **Hash SHA-256**: Senhas nunca armazenadas em texto puro
- **Validação no Banco**: Autenticação via Supabase (seguro e escalável)
- **Usuários Únicos**: Constraint UNIQUE no campo `usuario`
- **Controle de Acesso**: Campo `ativo` para desativar usuários
- **Auditoria**: Campos `ultimo_acesso`, `criado_em`, `atualizado_em`
- **Timeout de Sessão**: SessionStorage (limpa ao fechar navegador)

### 🛡️ Boas Práticas

✅ **FAÇA:**
- Use senhas com mínimo 8 caracteres
- Combine letras maiúsculas, minúsculas, números e símbolos
- Altere senhas periodicamente
- Use senhas diferentes para cada administrador
- Desative usuários inativos (não delete)

❌ **NÃO FAÇA:**
- Compartilhar credenciais entre usuários
- Usar senhas simples (123456, admin, isiba)
- Armazenar senhas em arquivos de texto
- Deixar sessão aberta em computadores compartilhados

---

## 📊 Queries Úteis

### Listar Todos os Administradores

```sql
SELECT 
    id,
    usuario,
    nome_completo,
    email,
    ativo,
    ultimo_acesso,
    criado_em
FROM administradores
ORDER BY criado_em DESC;
```

### Desativar um Administrador

```sql
UPDATE administradores 
SET ativo = false,
    atualizado_em = now()
WHERE usuario = 'nome.usuario';
```

### Reativar um Administrador

```sql
UPDATE administradores 
SET ativo = true,
    atualizado_em = now()
WHERE usuario = 'nome.usuario';
```

### Ver Últimos Acessos

```sql
SELECT 
    usuario,
    nome_completo,
    ultimo_acesso,
    CASE 
        WHEN ultimo_acesso > now() - interval '1 day' THEN 'Hoje'
        WHEN ultimo_acesso > now() - interval '7 days' THEN 'Esta semana'
        WHEN ultimo_acesso > now() - interval '30 days' THEN 'Este mês'
        ELSE 'Mais de 30 dias'
    END as atividade
FROM administradores
WHERE ativo = true
ORDER BY ultimo_acesso DESC NULLS LAST;
```

### Redefinir Senha de Emergência

```sql
-- Senha temporária: ResetTemp@2026
-- Hash SHA-256 da senha acima
UPDATE administradores 
SET senha_hash = '8e35c2cd3bf6641bdb0e2050b76932cbb2e6034a0ddacc1d9bea82a6ba57f7cf',
    atualizado_em = now()
WHERE usuario = 'admin.isiba';
```

---

## 🔧 Estrutura da Tabela

```sql
CREATE TABLE administradores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario TEXT NOT NULL UNIQUE,        -- Login único
    senha_hash TEXT NOT NULL,            -- SHA-256 da senha
    nome_completo TEXT NOT NULL,         -- Nome para exibição
    email TEXT,                          -- E-mail (opcional)
    ativo BOOLEAN DEFAULT true,          -- Controle de acesso
    ultimo_acesso TIMESTAMP WITH TIME ZONE,  -- Última vez que logou
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT now()
);
```

---

## 📱 Arquivos Criados

1. **`CRIAR_ADMIN_SEGURO.sql`** - Script SQL para configuração inicial
2. **`trocar-senha.html`** - Interface web para alteração de senha
3. **`AUTENTICACAO-SEGURA.md`** - Este documento (manual completo)

---

## 🆘 Solução de Problemas

### Problema: "Usuário ou senha incorretos"

**Causas:**
- Usuário não existe no banco
- Senha incorreta
- Administrador desativado (`ativo = false`)
- Script SQL não foi executado

**Solução:**
1. Verificar se tabela existe:
   ```sql
   SELECT * FROM administradores LIMIT 1;
   ```

2. Se tabela não existe, execute `CRIAR_ADMIN_SEGURO.sql`

3. Se tabela existe mas está vazia, execute apenas o INSERT do script

### Problema: "Erro ao conectar com banco de dados"

**Causas:**
- Supabase não configurado
- Arquivo `supabase-config.js` incorreto

**Solução:**
1. Verifique se `painel-rh/assets/js/supabase-config.js` existe
2. Confirme se as credenciais estão corretas:
   ```javascript
   const CONFIG = {
       SUPABASE_URL: 'sua_url_aqui',
       SUPABASE_ANON_KEY: 'sua_chave_aqui'
   };
   ```

### Problema: Esqueci minha senha

**Solução:**
Execute a query de reset (senha temporária):
```sql
UPDATE administradores 
SET senha_hash = '8e35c2cd3bf6641bdb0e2050b76932cbb2e6034a0ddacc1d9bea82a6ba57f7cf'
WHERE usuario = 'seu.usuario';
```

Senha temporária: `ResetTemp@2026`

---

## 📞 Suporte

Para mais informações ou problemas:
1. Verifique os logs do console do navegador (F12)
2. Consulte a documentação do Supabase
3. Revise os arquivos:
   - `painel-rh/assets/js/supabase-admin.js`
   - `painel-rh/assets/js/admin-rh.js`

---

**Última atualização:** 10 de fevereiro de 2026
**Versão:** 1.0
