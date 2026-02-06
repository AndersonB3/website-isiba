-- ═══════════════════════════════════════════════════════════════════════════
-- VERIFICAR QUAIS TABELAS TÊM RLS HABILITADO
-- Execute no banco de PRODUÇÃO
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    schemaname AS schema,
    tablename AS tabela,
    CASE 
        WHEN rowsecurity THEN 'HABILITADO ✅'
        ELSE 'DESABILITADO ❌'
    END AS status_rls,
    (SELECT COUNT(*) 
     FROM pg_policies 
     WHERE pg_policies.schemaname = t.schemaname 
     AND pg_policies.tablename = t.tablename) AS qtd_politicas
FROM pg_tables t
WHERE schemaname = 'public'
ORDER BY tablename;

-- ═══════════════════════════════════════════════════════════════════════════
-- Isso mostra quais tabelas têm RLS ativo e quantas políticas cada uma tem
-- ═══════════════════════════════════════════════════════════════════════════
