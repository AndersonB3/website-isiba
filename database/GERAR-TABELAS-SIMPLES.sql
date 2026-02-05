-- ═══════════════════════════════════════════════════════════════════════════
-- SCRIPT SIMPLES - GERAR ESTRUTURA (PARTE 1: TABELAS)
-- Execute no banco de PRODUÇÃO
-- ═══════════════════════════════════════════════════════════════════════════

SELECT string_agg(
    'CREATE TABLE ' || t.table_name || ' (' || E'\n' ||
    (
        SELECT string_agg(
            '    ' || c.column_name || ' ' || 
            CASE 
                WHEN c.data_type = 'character varying' THEN 'VARCHAR'
                WHEN c.data_type = 'timestamp with time zone' THEN 'TIMESTAMP WITH TIME ZONE'
                ELSE UPPER(c.data_type)
            END ||
            CASE WHEN c.character_maximum_length IS NOT NULL 
                 THEN '(' || c.character_maximum_length || ')' 
                 ELSE '' 
            END ||
            CASE WHEN c.is_nullable = 'NO' THEN ' NOT NULL' ELSE '' END ||
            CASE WHEN c.column_default IS NOT NULL 
                 THEN ' DEFAULT ' || c.column_default 
                 ELSE '' 
            END,
            ',' || E'\n'
        ORDER BY c.ordinal_position)
        FROM information_schema.columns c
        WHERE c.table_name = t.table_name
          AND c.table_schema = 'public'
    ) || E'\n' ||
    ');' || E'\n\n',
    '' ORDER BY t.table_name
)
FROM information_schema.tables t
WHERE t.table_schema = 'public'
  AND t.table_type = 'BASE TABLE';

-- ═══════════════════════════════════════════════════════════════════════════
-- Copie o resultado e execute no banco de DESENVOLVIMENTO
-- ═══════════════════════════════════════════════════════════════════════════
