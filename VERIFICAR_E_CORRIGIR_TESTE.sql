-- ════════════════════════════════════════════════════════════════
-- VERIFICAR E CORRIGIR USUÁRIO DE TESTE
-- ════════════════════════════════════════════════════════════════

-- 1️⃣ VERIFICAR SE A COLUNA EXISTE
SELECT 
    column_name AS "Coluna",
    data_type AS "Tipo",
    column_default AS "Valor Padrão"
FROM information_schema.columns
WHERE table_name = 'colaboradores' 
  AND column_name = 'primeiro_acesso';

-- 2️⃣ LISTAR TODOS OS COLABORADORES E SEUS STATUS
SELECT 
    id,
    nome_completo AS "Nome",
    cpf AS "CPF",
    ativo AS "Ativo",
    primeiro_acesso AS "Primeiro Acesso?"
FROM colaboradores
ORDER BY id DESC;

-- 3️⃣ FORÇAR primeiro_acesso = TRUE para o último usuário criado (usuário de teste)
UPDATE colaboradores 
SET primeiro_acesso = true 
WHERE id = (
    SELECT id 
    FROM colaboradores 
    ORDER BY id DESC 
    LIMIT 1
);

-- 4️⃣ VERIFICAR SE DEU CERTO
SELECT 
    id,
    nome_completo AS "Nome",
    cpf AS "CPF",
    primeiro_acesso AS "Primeiro Acesso?"
FROM colaboradores
WHERE id = (
    SELECT id 
    FROM colaboradores 
    ORDER BY id DESC 
    LIMIT 1
);

-- ════════════════════════════════════════════════════════════════
-- INSTRUÇÕES:
-- 
-- 1. Execute este SQL no Supabase SQL Editor
-- 2. Veja os resultados de cada query
-- 3. Se a query 1 não retornar nada = coluna não existe
--    → Execute primeiro: ADICIONAR_PRIMEIRO_ACESSO.sql
-- 4. Se a query 4 mostrar primeiro_acesso = true → Tudo OK!
-- 5. Tente fazer login novamente no sistema
--
-- ════════════════════════════════════════════════════════════════
