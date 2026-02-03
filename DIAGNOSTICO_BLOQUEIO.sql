-- ================================================================
-- DIAGNÓSTICO - VERIFICAR ESTADO DOS DOCUMENTOS
-- ================================================================
-- Execute este script para ver o que está acontecendo
-- ================================================================

-- 1. Ver TODOS os documentos e suas colunas
SELECT 
    id,
    mes_referencia,
    ano,
    tipo_documento,
    recibo_gerado,
    visualizado,
    data_primeira_visualizacao,
    enviado_em
FROM contracheques
ORDER BY enviado_em DESC
LIMIT 10;

-- 2. Contar por status
SELECT 
    CASE 
        WHEN recibo_gerado IS NULL THEN 'NULL (precisa atualizar)'
        WHEN recibo_gerado = true THEN 'TRUE (liberado)'
        WHEN recibo_gerado = false THEN 'FALSE (bloqueado)'
    END as status,
    COUNT(*) as total
FROM contracheques
GROUP BY recibo_gerado;

-- 3. Verificar se a coluna existe
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'contracheques'
AND column_name IN ('recibo_gerado', 'visualizado', 'data_primeira_visualizacao');

-- ================================================================
-- SOLUÇÃO: Se a coluna recibo_gerado estiver NULL, execute:
-- ================================================================

UPDATE contracheques 
SET recibo_gerado = false,
    visualizado = false
WHERE recibo_gerado IS NULL;

-- ================================================================
-- VERIFICAÇÃO FINAL: Todos devem estar FALSE (bloqueados)
-- ================================================================

SELECT 
    COUNT(*) as total_documentos,
    SUM(CASE WHEN recibo_gerado = false THEN 1 ELSE 0 END) as bloqueados,
    SUM(CASE WHEN recibo_gerado = true THEN 1 ELSE 0 END) as liberados,
    SUM(CASE WHEN recibo_gerado IS NULL THEN 1 ELSE 0 END) as nulls
FROM contracheques;

-- ================================================================
-- FIM DO DIAGNÓSTICO
-- ================================================================
