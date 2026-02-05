-- ═══════════════════════════════════════════════════════════════════════════
-- GERAR SCRIPT DE CRIAÇÃO DE POLÍTICAS RLS
-- Execute no banco de PRODUÇÃO
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    'CREATE POLICY ' || quote_ident(policyname) || 
    ' ON ' || quote_ident(tablename) ||
    ' FOR ' || cmd ||
    CASE 
        WHEN roles <> '{public}' THEN ' TO ' || array_to_string(roles, ', ')
        ELSE ''
    END ||
    CASE 
        WHEN qual IS NOT NULL THEN E'\n    USING (' || qual || ')'
        ELSE ''
    END ||
    CASE 
        WHEN with_check IS NOT NULL THEN E'\n    WITH CHECK (' || with_check || ')'
        ELSE ''
    END || ';' AS create_policy_statement
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- ═══════════════════════════════════════════════════════════════════════════
-- Copie TODO o resultado e execute no banco de DESENVOLVIMENTO
-- ═══════════════════════════════════════════════════════════════════════════
