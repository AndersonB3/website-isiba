-- ═══════════════════════════════════════════════════════════════════════════
-- 🔍 DESCOBRIR ESTRUTURA DO BANCO DE PRODUÇÃO
-- ═══════════════════════════════════════════════════════════════════════════
-- 
-- Execute este script no banco de PRODUÇÃO para ver a estrutura real das tabelas
--
-- ═══════════════════════════════════════════════════════════════════════════

-- 1. VERIFICAR ESTRUTURA DA TABELA COLABORADORES
SELECT 
    column_name as "Coluna",
    data_type as "Tipo",
    is_nullable as "Permite NULL",
    column_default as "Valor Padrão"
FROM information_schema.columns
WHERE table_name = 'colaboradores'
ORDER BY ordinal_position;

-- ═══════════════════════════════════════════════════════════════════════════

-- 2. VERIFICAR ESTRUTURA DA TABELA CONTRACHEQUES
SELECT 
    column_name as "Coluna",
    data_type as "Tipo",
    is_nullable as "Permite NULL",
    column_default as "Valor Padrão"
FROM information_schema.columns
WHERE table_name = 'contracheques'
ORDER BY ordinal_position;

-- ═══════════════════════════════════════════════════════════════════════════

-- 3. VERIFICAR ESTRUTURA DA TABELA RECIBOS_DOCUMENTOS
SELECT 
    column_name as "Coluna",
    data_type as "Tipo",
    is_nullable as "Permite NULL",
    column_default as "Valor Padrão"
FROM information_schema.columns
WHERE table_name = 'recibos_documentos'
ORDER BY ordinal_position;

-- ═══════════════════════════════════════════════════════════════════════════

-- 4. VERIFICAR ESTRUTURA DA TABELA ADMIN_RH
SELECT 
    column_name as "Coluna",
    data_type as "Tipo",
    is_nullable as "Permite NULL",
    column_default as "Valor Padrão"
FROM information_schema.columns
WHERE table_name = 'admin_rh'
ORDER BY ordinal_position;

-- ═══════════════════════════════════════════════════════════════════════════

-- 5. VER UM EXEMPLO DE REGISTRO (para confirmar os dados)
SELECT * FROM colaboradores LIMIT 1;

-- ═══════════════════════════════════════════════════════════════════════════
-- RESULTADO ESPERADO:
-- Você verá todas as colunas que realmente existem no seu banco de produção
-- Com isso, vou ajustar o script de exportação para usar os nomes corretos!
-- ═══════════════════════════════════════════════════════════════════════════
