-- ================================================================
-- ATUALIZAR DOCUMENTOS EXISTENTES PARA SISTEMA DE BLOQUEIO
-- ================================================================
-- Execute este script APÓS criar a tabela recibos_documentos
-- para bloquear todos os documentos existentes
-- ================================================================

-- 1. Atualizar todos os documentos existentes como BLOQUEADOS
UPDATE contracheques 
SET 
    recibo_gerado = false,
    visualizado = false,
    data_primeira_visualizacao = NULL
WHERE recibo_gerado IS NULL;

-- 2. Verificar quantos documentos foram bloqueados
SELECT 
    COUNT(*) as total_bloqueados,
    tipo_documento
FROM contracheques
WHERE recibo_gerado = false
GROUP BY tipo_documento;

-- 3. Ver todos os documentos e seus status
SELECT 
    id,
    mes_referencia,
    ano,
    tipo_documento,
    recibo_gerado,
    visualizado,
    enviado_em
FROM contracheques
ORDER BY ano DESC, mes_referencia DESC;

-- ================================================================
-- OPCIONAL: Se quiser liberar alguns documentos específicos
-- ================================================================

-- Exemplo: Liberar todos os documentos de 2025 (ano anterior)
-- UPDATE contracheques 
-- SET recibo_gerado = true
-- WHERE ano = 2025;

-- Exemplo: Liberar documentos de um colaborador específico
-- UPDATE contracheques 
-- SET recibo_gerado = true
-- WHERE colaborador_id = 'UUID_DO_COLABORADOR';

-- ================================================================
-- FIM DO SCRIPT
-- ================================================================
