-- ════════════════════════════════════════════════════════════════
-- SOLUÇÃO RÁPIDA: FORÇAR PRIMEIRO_ACESSO = TRUE EM TODOS
-- ════════════════════════════════════════════════════════════════

-- ⚠️ Este SQL vai forçar primeiro_acesso = TRUE em TODOS os colaboradores
-- Use isso se você quiser que todos tenham que trocar senha no próximo login

-- 1️⃣ VER SITUAÇÃO ATUAL
SELECT 
    nome_completo AS "Nome",
    cpf AS "CPF",
    primeiro_acesso AS "Primeiro Acesso Atual"
FROM colaboradores
ORDER BY nome_completo;

-- 2️⃣ FORÇAR TRUE EM TODOS
UPDATE colaboradores 
SET primeiro_acesso = true;

-- 3️⃣ CONFIRMAR QUE DEU CERTO
SELECT 
    nome_completo AS "Nome",
    cpf AS "CPF",
    primeiro_acesso AS "Primeiro Acesso Agora",
    CASE 
        WHEN primeiro_acesso = true THEN '✅ OK - Vai pedir troca de senha'
        WHEN primeiro_acesso = false THEN '❌ FALSE - Não vai pedir'
        WHEN primeiro_acesso IS NULL THEN '❌ NULL - Coluna não existe!'
    END AS "Status"
FROM colaboradores
ORDER BY nome_completo;

-- ════════════════════════════════════════════════════════════════
-- ALTERNATIVA: Forçar apenas em um CPF específico
-- ════════════════════════════════════════════════════════════════

-- Descomente e ajuste o CPF:
/*
UPDATE colaboradores 
SET primeiro_acesso = true 
WHERE cpf = '12345678900';  -- ← SUBSTITUA PELO CPF DO USUÁRIO DE TESTE

SELECT 
    nome_completo,
    cpf,
    primeiro_acesso,
    'PRONTO! Agora faça login com este usuário.' AS "Próximo passo"
FROM colaboradores
WHERE cpf = '12345678900';  -- ← SUBSTITUA PELO CPF DO USUÁRIO DE TESTE
*/

-- ════════════════════════════════════════════════════════════════
-- RESULTADO ESPERADO DA QUERY 3:
-- Todos devem mostrar: primeiro_acesso = TRUE ✅
-- ════════════════════════════════════════════════════════════════
