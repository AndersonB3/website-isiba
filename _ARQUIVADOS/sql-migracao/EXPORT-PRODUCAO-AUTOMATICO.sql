-- ═══════════════════════════════════════════════════════════════════════════
-- 🔴 LISTAR TODAS AS TABELAS DO BANCO DE PRODUÇÃO
-- ═══════════════════════════════════════════════════════════════════════════
-- 
-- Execute este script para ver TODAS as tabelas que existem no seu banco
--
-- ═══════════════════════════════════════════════════════════════════════════

-- 1. LISTAR TODAS AS TABELAS
SELECT 
    table_name as "Nome da Tabela",
    (SELECT COUNT(*) 
     FROM information_schema.columns c 
     WHERE c.table_name = t.table_name) as "Qtd Colunas"
FROM information_schema.tables t
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- ═══════════════════════════════════════════════════════════════════════════

-- 2. CONTAR REGISTROS EM CADA TABELA
SELECT 'colaboradores' as tabela, COUNT(*) as total FROM colaboradores
UNION ALL
SELECT 'contracheques', COUNT(*) FROM contracheques
UNION ALL
SELECT 'recibos_documentos', COUNT(*) FROM recibos_documentos
UNION ALL
SELECT 'admin_rh', COUNT(*) FROM admin_rh;

-- ═══════════════════════════════════════════════════════════════════════════
-- RESULTADO ESPERADO:
-- Você verá a lista de todas as tabelas e quantos registros cada uma tem
-- Com isso, posso criar o script de exportação correto!
-- ═══════════════════════════════════════════════════════════════════════════
