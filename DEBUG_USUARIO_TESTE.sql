-- ════════════════════════════════════════════════════════════════
-- DEBUG: VERIFICAR USUÁRIO ESPECÍFICO
-- ════════════════════════════════════════════════════════════════

-- 1️⃣ LISTAR TODOS OS COLABORADORES COM DETALHES
SELECT 
    id,
    nome_completo,
    cpf,
    ativo,
    primeiro_acesso,
    CASE 
        WHEN primeiro_acesso IS NULL THEN '❌ NULL'
        WHEN primeiro_acesso = true THEN '✅ TRUE'
        WHEN primeiro_acesso = false THEN '❌ FALSE'
    END AS "Status Primeiro Acesso"
FROM colaboradores
ORDER BY id DESC;

-- 2️⃣ FORÇAR TRUE NO USUÁRIO MAIS RECENTE
-- Como id é UUID, não podemos usar MAX(), então pegamos todos e forçamos TRUE
UPDATE colaboradores 
SET primeiro_acesso = true;

-- 3️⃣ VERIFICAR NOVAMENTE (TODOS OS USUÁRIOS)
SELECT 
    id,
    nome_completo AS "Nome",
    cpf AS "CPF",
    primeiro_acesso AS "Primeiro Acesso",
    CASE 
        WHEN primeiro_acesso IS NULL THEN 'PROBLEMA: Está NULL!'
        WHEN primeiro_acesso = true THEN 'OK: Está TRUE'
        WHEN primeiro_acesso = false THEN 'INFO: Já trocou senha'
    END AS "Diagnóstico"
FROM colaboradores
ORDER BY id DESC;

-- 4️⃣ SE O USUÁRIO DE TESTE TEM CPF ESPECÍFICO, USE ISTO:
-- (Substitua 12345678900 pelo CPF real do usuário de teste)
/*
UPDATE colaboradores 
SET primeiro_acesso = true 
WHERE cpf = '12345678900';

SELECT 
    id,
    nome_completo,
    cpf,
    primeiro_acesso,
    CASE 
        WHEN primeiro_acesso = true THEN '✅ CONFIGURADO CORRETAMENTE'
        ELSE '❌ PRECISA CORRIGIR'
    END AS "Status"
FROM colaboradores
WHERE cpf = '12345678900';
*/

-- ════════════════════════════════════════════════════════════════
-- INSTRUÇÕES:
-- 
-- 1. Execute queries 1, 2 e 3 em sequência
-- 2. Anote o ID e CPF do usuário de teste
-- 3. Se quiser, descomente a query 4 e ajuste o CPF
-- 4. O campo "primeiro_acesso" DEVE estar como TRUE
-- 5. Se estiver NULL, a coluna não foi criada corretamente
--    → Execute ADICIONAR_PRIMEIRO_ACESSO.sql novamente
--
-- ════════════════════════════════════════════════════════════════
