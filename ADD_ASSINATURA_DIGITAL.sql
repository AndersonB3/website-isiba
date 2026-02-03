-- ================================================================
-- ADICIONAR COLUNA DE ASSINATURA DIGITAL
-- ================================================================
-- Execute este script no Supabase SQL Editor para adicionar
-- o campo de assinatura digital na tabela recibos_documentos
-- ================================================================

-- Adicionar coluna para armazenar a imagem da assinatura (base64)
ALTER TABLE recibos_documentos 
ADD COLUMN IF NOT EXISTS assinatura_digital TEXT;

-- Comentário explicativo
COMMENT ON COLUMN recibos_documentos.assinatura_digital 
IS 'Assinatura digital do colaborador em formato base64 (PNG)';

-- Verificar se a coluna foi adicionada
SELECT column_name, data_type, character_maximum_length
FROM information_schema.columns
WHERE table_name = 'recibos_documentos'
AND column_name = 'assinatura_digital';

-- ================================================================
-- SUCESSO! A coluna foi adicionada com sucesso.
-- Agora os recibos podem armazenar a assinatura digital!
-- ================================================================
