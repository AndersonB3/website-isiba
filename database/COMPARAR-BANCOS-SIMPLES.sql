-- ═══════════════════════════════════════════════════════════════════════════
-- SCRIPT: COMPARAR BANCOS - VERSÃO SIMPLIFICADA
-- Execute cada seção separadamente para evitar erros
-- ═══════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════
-- SEÇÃO 1: TABELAS
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    tablename AS tabela
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY tablename;

-- ═══════════════════════════════════════════════════════════════════════════
-- SEÇÃO 2: COLUNAS (execute por tabela se necessário)
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    table_name AS tabela,
    column_name AS coluna,
    data_type AS tipo,
    is_nullable AS null_permitido
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- ═══════════════════════════════════════════════════════════════════════════
-- SEÇÃO 3: CHAVES PRIMÁRIAS
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    tc.table_name AS tabela,
    kcu.column_name AS coluna_pk
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'PRIMARY KEY'
    AND tc.table_schema = 'public'
ORDER BY tc.table_name;

-- ═══════════════════════════════════════════════════════════════════════════
-- SEÇÃO 4: RLS (Row Level Security)
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    tablename AS tabela,
    policyname AS politica,
    cmd AS comando
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- ═══════════════════════════════════════════════════════════════════════════
-- SEÇÃO 5: CONTAGEM DE REGISTROS
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 'administradores' AS tabela, COUNT(*) AS total FROM administradores
UNION ALL
SELECT 'colaboradores', COUNT(*) FROM colaboradores
UNION ALL
SELECT 'contracheques', COUNT(*) FROM contracheques
UNION ALL
SELECT 'dados_mensais', COUNT(*) FROM dados_mensais
UNION ALL
SELECT 'faixa_etaria', COUNT(*) FROM faixa_etaria
UNION ALL
SELECT 'recibos_documentos', COUNT(*) FROM recibos_documentos
UNION ALL
SELECT 'resumo_anual', COUNT(*) FROM resumo_anual
UNION ALL
SELECT 'statistics', COUNT(*) FROM statistics
UNION ALL
SELECT 'tempo_atendimento', COUNT(*) FROM tempo_atendimento
UNION ALL
SELECT 'unidades', COUNT(*) FROM unidades
ORDER BY tabela;

-- ═══════════════════════════════════════════════════════════════════════════
-- SEÇÃO 6: STORAGE BUCKETS
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    name AS bucket,
    public AS publico
FROM storage.buckets
ORDER BY name;

-- ═══════════════════════════════════════════════════════════════════════════
-- SEÇÃO 7: STORAGE POLICIES (se existirem)
-- Execute apenas se não der erro
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    tablename AS tabela,
    policyname AS politica
FROM pg_policies
WHERE schemaname = 'storage'
ORDER BY tablename, policyname;

-- ═══════════════════════════════════════════════════════════════════════════
-- ✅ COMO USAR:
-- ═══════════════════════════════════════════════════════════════════════════
-- 
-- 1. Execute cada SEÇÃO separadamente (copie e cole uma por vez)
-- 2. Se alguma seção der erro, pule para a próxima
-- 3. Compare os resultados entre PROD e DEV
-- 
-- ATENÇÃO: A SEÇÃO 7 pode dar erro se não houver políticas de storage
-- Isso é normal, apenas ignore o erro nesse caso.
-- 
-- ═══════════════════════════════════════════════════════════════════════════
