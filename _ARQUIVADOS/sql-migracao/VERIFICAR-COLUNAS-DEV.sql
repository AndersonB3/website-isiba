-- ═══════════════════════════════════════════════════════════════════════════
-- VERIFICAR COLUNAS DA TABELA COLABORADORES NO DESENVOLVIMENTO
-- Execute no banco de DESENVOLVIMENTO
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'colaboradores'
ORDER BY ordinal_position;

-- ═══════════════════════════════════════════════════════════════════════════
-- Compare com a estrutura de PRODUÇÃO
-- ═══════════════════════════════════════════════════════════════════════════
