-- ═══════════════════════════════════════════════════════════════════════════
-- LISTAR TODAS AS POLÍTICAS RLS DO BANCO DE PRODUÇÃO
-- Execute no banco de PRODUÇÃO
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    schemaname AS schema,
    tablename AS tabela,
    policyname AS nome_politica,
    permissive AS permissivo,
    roles AS roles,
    cmd AS comando,
    qual AS condicao_using,
    with_check AS condicao_check
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- ═══════════════════════════════════════════════════════════════════════════
-- Este script vai mostrar todas as políticas RLS aplicadas nas tabelas
-- Copie o resultado e me mostre para gerar o script de criação
-- ═══════════════════════════════════════════════════════════════════════════
