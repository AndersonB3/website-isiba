-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 2: GERAR PRIMARY KEYS
-- Execute no banco de PRODUÇÃO após criar as tabelas
-- ═══════════════════════════════════════════════════════════════════════════

SELECT string_agg(
    'ALTER TABLE ' || tc.table_name || 
    ' ADD CONSTRAINT ' || tc.constraint_name || 
    ' PRIMARY KEY (' || kcu.column_name || ');',
    E'\n'
)
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'PRIMARY KEY'
  AND tc.table_schema = 'public';

-- ═══════════════════════════════════════════════════════════════════════════
