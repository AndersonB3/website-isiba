# 🗑️ LIMPAR BANCO DE DADOS - ISIBA

## ⚠️ ATENÇÃO: Scripts para Resetar o Banco

**USE COM CUIDADO!** Estes scripts deletam TODOS os dados, mantendo apenas a estrutura.

---

## 📋 OPÇÃO 1: Limpar TUDO (Dados + Arquivos)

### **Passo 1: Limpar Tabelas**
Execute no SQL Editor do Supabase:

```sql
-- ======================================
-- LIMPAR BANCO DE DADOS COMPLETO
-- ⚠️ ATENÇÃO: Isso deleta TODOS os dados!
-- ======================================

-- 1. Deletar todos os contracheques
DELETE FROM contracheques;

-- 2. Deletar todos os colaboradores
DELETE FROM colaboradores;

-- 3. Deletar todos os administradores (CUIDADO!)
-- DELETE FROM administradores; -- Descomente se quiser deletar admins também

-- Resetar sequências (se houver auto-increment)
-- ALTER SEQUENCE contracheques_id_seq RESTART WITH 1;
-- ALTER SEQUENCE colaboradores_id_seq RESTART WITH 1;

-- Verificar limpeza
SELECT 'contracheques' as tabela, COUNT(*) as registros FROM contracheques
UNION ALL
SELECT 'colaboradores', COUNT(*) FROM colaboradores
UNION ALL
SELECT 'administradores', COUNT(*) FROM administradores;
```

### **Passo 2: Limpar Storage (PDFs)**

**Opção A: Via Interface do Supabase**
1. Acesse: https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/storage/buckets/contracheques
2. Selecione todos os arquivos
3. Clique em "Delete"
4. Confirme

**Opção B: Via SQL**
```sql
-- ⚠️ Isso remove TODOS os arquivos do bucket
SELECT storage.delete_bucket('contracheques');

-- Recriar o bucket vazio
INSERT INTO storage.buckets (id, name, public) 
VALUES ('contracheques', 'contracheques', false);
```

---

## 📋 OPÇÃO 2: Limpar APENAS Dados de Teste

### **Manter estrutura e admin, remover apenas colaboradores e contracheques de teste:**

```sql
-- ======================================
-- LIMPAR DADOS DE TESTE
-- Mantém admins e estrutura
-- ======================================

-- Deletar contracheques
DELETE FROM contracheques;

-- Deletar colaboradores de teste
DELETE FROM colaboradores 
WHERE email LIKE '%@test.com' 
   OR email LIKE '%@teste.com'
   OR nome_completo LIKE '%Teste%'
   OR nome_completo LIKE '%Test%';

-- Verificar o que sobrou
SELECT * FROM colaboradores;
```

---

## 📋 OPÇÃO 3: Limpar Tudo e Criar Admin Padrão

```sql
-- ======================================
-- RESETAR BANCO COMPLETO + CRIAR ADMIN
-- ======================================

-- 1. Limpar tudo
DELETE FROM contracheques;
DELETE FROM colaboradores;
DELETE FROM administradores;

-- 2. Criar administrador padrão
-- Usuário: admin
-- Senha: admin123
-- Hashes gerados com SHA-256

INSERT INTO administradores (
    usuario, 
    senha_hash, 
    nome_completo, 
    ativo
) VALUES (
    'admin',
    '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', -- Hash de "admin123"
    'Administrador',
    true
);

-- Verificar
SELECT * FROM administradores;
```

---

## 🔐 Hashes para Senhas Comuns

Se você quiser criar usuários com senhas específicas, use estes hashes:

| Senha | Hash SHA-256 |
|-------|--------------|
| `admin123` | `240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9` |
| `123456` | `8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92` |
| `teste123` | `ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae` |
| `senha123` | `c758a9fd11ef5c77d08bb3d5d4e865f93b2c6bbfa93c3e0d26e0c6e6bc90b8a9` |

---

## 📦 OPÇÃO 4: Backup Antes de Limpar

### **Sempre faça backup antes de deletar!**

```sql
-- ======================================
-- BACKUP DAS TABELAS
-- ======================================

-- Criar tabelas temporárias de backup
CREATE TABLE backup_contracheques AS 
SELECT * FROM contracheques;

CREATE TABLE backup_colaboradores AS 
SELECT * FROM colaboradores;

CREATE TABLE backup_administradores AS 
SELECT * FROM administradores;

-- Verificar backups
SELECT COUNT(*) FROM backup_contracheques;
SELECT COUNT(*) FROM backup_colaboradores;
SELECT COUNT(*) FROM backup_administradores;

-- Depois de verificar que está tudo OK, você pode deletar:
-- DELETE FROM contracheques;
-- DELETE FROM colaboradores;

-- Para restaurar (se precisar):
-- INSERT INTO contracheques SELECT * FROM backup_contracheques;
-- INSERT INTO colaboradores SELECT * FROM backup_colaboradores;

-- Deletar backups quando não precisar mais:
-- DROP TABLE backup_contracheques;
-- DROP TABLE backup_colaboradores;
-- DROP TABLE backup_administradores;
```

---

## 🚀 Para Subir no GitHub

### **Checklist de Limpeza:**

- [ ] ✅ Deletar todos os contracheques
- [ ] ✅ Deletar todos os colaboradores (ou deixar 1-2 de exemplo)
- [ ] ✅ Limpar bucket de storage (remover PDFs)
- [ ] ✅ Remover credenciais reais de `supabase-config.js`
- [ ] ✅ Criar `.env.example` com placeholders
- [ ] ✅ Adicionar `.gitignore` para proteger dados sensíveis
- [ ] ✅ Documentar processo de setup

### **Arquivos para IGNORAR no Git:**

Crie/atualize `.gitignore`:

```gitignore
# Credenciais
supabase-config.js
.env
.env.local

# Node
node_modules/
npm-debug.log*

# Backups
*.backup
*.sql.backup

# PDFs de teste
*.pdf

# Logs
*.log
```

### **Criar `supabase-config.example.js`:**

```javascript
/**
 * Configuração do Supabase - EXEMPLO
 * Copie este arquivo para supabase-config.js e preencha com suas credenciais
 */

window.CONFIG = {
    supabaseUrl: 'https://SEU-PROJETO.supabase.co',
    supabaseKey: 'SUA-CHAVE-ANONIMA-AQUI',
    bucket: 'contracheques',
    adminUser: 'admin.rh'
};

// Inicializar cliente do Supabase
if (typeof supabase !== 'undefined') {
    window.supabaseClient = supabase.createClient(
        window.CONFIG.supabaseUrl,
        window.CONFIG.supabaseKey
    );
    console.log('✅ Supabase configurado com sucesso!');
} else {
    console.error('❌ Biblioteca do Supabase não carregada!');
}
```

---

## 📝 Script Completo de Limpeza Rápida

**Para executar rapidamente antes do GitHub:**

```sql
-- ======================================
-- LIMPEZA RÁPIDA PARA GITHUB
-- ======================================

-- 1. Backup rápido
CREATE TABLE temp_backup_contracheques AS SELECT * FROM contracheques;
CREATE TABLE temp_backup_colaboradores AS SELECT * FROM colaboradores;

-- 2. Limpar dados
DELETE FROM contracheques;
DELETE FROM colaboradores;

-- 3. Manter apenas 1 admin exemplo
DELETE FROM administradores WHERE usuario != 'admin';

-- 4. Atualizar admin para credenciais exemplo
UPDATE administradores 
SET 
    senha_hash = '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', -- admin123
    nome_completo = 'Administrador Exemplo'
WHERE usuario = 'admin';

-- 5. Criar 1 colaborador de exemplo
INSERT INTO colaboradores (
    nome_completo, 
    cpf, 
    cpf_hash, 
    senha_hash, 
    email, 
    ativo
) VALUES (
    'João Silva (Exemplo)',
    '12345678900',
    '0a0b3d3b75cf7b5b87e9e4b02adcce43df0a0a8e14c1c7b05fe3e7f3a8b5c8c7', -- Hash de "12345678900"
    'ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae', -- Hash de "teste123"
    'exemplo@empresa.com',
    true
);

-- 6. Verificar resultado
SELECT 'administradores' as tabela, COUNT(*) as registros FROM administradores
UNION ALL
SELECT 'colaboradores', COUNT(*) FROM colaboradores
UNION ALL
SELECT 'contracheques', COUNT(*) FROM contracheques;

-- Para restaurar backup:
-- INSERT INTO contracheques SELECT * FROM temp_backup_contracheques;
-- INSERT INTO colaboradores SELECT * FROM temp_backup_colaboradores;
-- DROP TABLE temp_backup_contracheques;
-- DROP TABLE temp_backup_colaboradores;
```

---

## 📖 README para GitHub

Adicione isso ao README.md:

```markdown
## 🔧 Configuração Inicial

### 1. Configurar Supabase

1. Crie uma conta no [Supabase](https://supabase.com)
2. Crie um novo projeto
3. Execute os scripts SQL em `SCRIPTS-SQL-SUPABASE.md`
4. Copie `supabase-config.example.js` para `supabase-config.js`
5. Preencha com suas credenciais do Supabase

### 2. Primeiro Acesso

**Painel Administrativo:**
- URL: `http://localhost:3001/admin-rh.html`
- Usuário: `admin`
- Senha: `admin123`

**Portal do Colaborador:**
- URL: `http://localhost/colaborador.html`
- CPF: `123.456.789-00`
- Senha: `teste123`

⚠️ **IMPORTANTE:** Altere essas credenciais em produção!
```

---

## ✅ Checklist Final

Antes de fazer commit no GitHub:

```bash
# 1. Limpar banco de dados
# Execute os SQLs acima no Supabase

# 2. Remover arquivos sensíveis
git rm --cached painel-rh/assets/js/supabase-config.js
git rm --cached assets/js/supabase-config.js

# 3. Criar arquivo exemplo
cp supabase-config.js supabase-config.example.js
# Editar e remover credenciais reais

# 4. Adicionar ao .gitignore
echo "supabase-config.js" >> .gitignore

# 5. Commit
git add .
git commit -m "chore: remove sensitive data and prepare for GitHub"
git push origin develop
```

---

**Pronto! Banco limpo e seguro para GitHub!** 🎉
