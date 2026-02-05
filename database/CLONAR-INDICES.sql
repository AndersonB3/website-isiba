-- ═══════════════════════════════════════════════════════════════════════════
-- 🔴 EXECUTE NO BANCO DE PRODUÇÃO - PARTE 2: ÍNDICES E CONSTRAINTS
-- ═══════════════════════════════════════════════════════════════════════════

-- GERAR SCRIPT DE ÍNDICES
SELECT string_agg(
    'CREATE ' || 
    CASE WHEN indisunique THEN 'UNIQUE ' ELSE '' END ||
    'INDEX IF NOT EXISTS ' || indexname || 
    ' ON ' || tablename || 
    ' USING ' || 
    CASE 
        WHEN indexdef LIKE '%USING btree%' THEN 'btree'
        WHEN indexdef LIKE '%USING gin%' THEN 'gin'
        WHEN indexdef LIKE '%USING gist%' THEN 'gist'
        ELSE 'btree'
    END ||
    ' (' || 
    substring(indexdef from '\((.*)\)$') ||
    ');',
    E'\n'
)
FROM pg_indexes
WHERE schemaname = 'public'
  AND indexname NOT LIKE '%_pkey';

-- ═══════════════════════════════════════════════════════════════════════════
-- RESULTADO: Scripts CREATE INDEX
-- ═══════════════════════════════════════════════════════════════════════════
