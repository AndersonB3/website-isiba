-- ================================================================
-- VERIFICAÇÃO URGENTE - EXECUTAR AGORA
-- ================================================================

-- 1. Ver o documento que está aparecendo
SELECT 
    id,
    mes_referencia,
    ano,
    tipo_documento,
    recibo_gerado,
    visualizado,
    nome_arquivo,
    enviado_em
FROM contracheques
ORDER BY enviado_em DESC
LIMIT 1;

-- 2. Se recibo_gerado for NULL, execute IMEDIATAMENTE:
UPDATE contracheques 
SET recibo_gerado = false,
    visualizado = false
WHERE recibo_gerado IS NULL;

-- 3. Verificar novamente:
SELECT 
    mes_referencia,
    ano,
    recibo_gerado,
    CASE 
        WHEN recibo_gerado = false THEN '✅ BLOQUEADO (correto!)'
        WHEN recibo_gerado = true THEN '❌ LIBERADO'
        WHEN recibo_gerado IS NULL THEN '❌ NULL (precisa atualizar)'
    END as status
FROM contracheques
ORDER BY enviado_em DESC;

-- ================================================================
