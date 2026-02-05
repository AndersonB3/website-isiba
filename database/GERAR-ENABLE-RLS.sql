-- ═══════════════════════════════════════════════════════════════════════════
-- GERAR COMANDOS PARA HABILITAR RLS NAS TABELAS
-- Execute no banco de PRODUÇÃO
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    'ALTER TABLE ' || quote_ident(tablename) || ' ENABLE ROW LEVEL SECURITY;' AS enable_rls_command
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN (
      SELECT DISTINCT tablename 
      FROM pg_policies 
      WHERE schemaname = 'public'
  )
ORDER BY tablename;

-- ═══════════════════════════════════════════════════════════════════════════
-- Copie e execute no banco de DESENVOLVIMENTO primeiro
-- Depois execute o script de políticas (GERAR-POLITICAS-RLS.sql)
-- ═══════════════════════════════════════════════════════════════════════════
