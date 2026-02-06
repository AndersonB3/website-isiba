-- ═══════════════════════════════════════════════════════════════════════════
-- SCRIPT: VERIFICAR FUNÇÕES E TRIGGERS
-- Execute em PROD e DEV para comparar
-- ═══════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════
-- SEÇÃO 1: FUNÇÕES CUSTOMIZADAS
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    routine_name AS nome_funcao,
    routine_type AS tipo
FROM information_schema.routines
WHERE routine_schema = 'public'
ORDER BY routine_name;

-- ═══════════════════════════════════════════════════════════════════════════
-- SEÇÃO 2: TRIGGERS (GATILHOS)
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    trigger_name AS nome_trigger,
    event_object_table AS tabela,
    action_timing AS timing,
    event_manipulation AS evento
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY event_object_table, trigger_name;

-- ═══════════════════════════════════════════════════════════════════════════
-- SEÇÃO 3: DETALHES DAS FUNÇÕES (CÓDIGO FONTE)
-- ═══════════════════════════════════════════════════════════════════════════

-- Função: update_updated_at_column
SELECT pg_get_functiondef(oid) AS definicao
FROM pg_proc 
WHERE proname = 'update_updated_at_column';

-- Função: update_contracheques_updated_at
SELECT pg_get_functiondef(oid) AS definicao
FROM pg_proc 
WHERE proname = 'update_contracheques_updated_at';

-- Função: atualizar_recibos_updated_at
SELECT pg_get_functiondef(oid) AS definicao
FROM pg_proc 
WHERE proname = 'atualizar_recibos_updated_at';

-- ═══════════════════════════════════════════════════════════════════════════
-- ✅ RESULTADO ESPERADO:
-- ═══════════════════════════════════════════════════════════════════════════
-- 
-- SEÇÃO 1 - Deve mostrar 3 funções:
-- - atualizar_recibos_updated_at
-- - update_contracheques_updated_at  
-- - update_updated_at_column
--
-- SEÇÃO 2 - Deve mostrar triggers associados a essas funções
-- (provavelmente nas tabelas: contracheques, recibos_documentos)
--
-- SEÇÃO 3 - Mostra o código SQL de cada função para comparar
--
-- ═══════════════════════════════════════════════════════════════════════════
