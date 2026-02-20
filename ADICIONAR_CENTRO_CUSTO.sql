-- =====================================================
-- ADICIONAR CAMPO CENTRO DE CUSTO
-- Execute este script no Supabase SQL Editor
-- =====================================================

-- 1. Adicionar coluna centro_custo na tabela colaboradores
ALTER TABLE colaboradores 
ADD COLUMN IF NOT EXISTS centro_custo VARCHAR(50) DEFAULT NULL;

-- 2. Adicionar centro_custo na tabela contracheques (para filtrar por unidade)
ALTER TABLE contracheques 
ADD COLUMN IF NOT EXISTS centro_custo VARCHAR(50) DEFAULT NULL;

-- 3. Criar índice para melhorar performance de buscas por centro de custo
CREATE INDEX IF NOT EXISTS idx_colaboradores_centro_custo 
    ON colaboradores(centro_custo);

CREATE INDEX IF NOT EXISTS idx_contracheques_centro_custo 
    ON contracheques(centro_custo);

-- 4. Comentários para documentar os valores permitidos
COMMENT ON COLUMN colaboradores.centro_custo IS 
    'Unidade empresarial: UPA GLEBA-A, UPA LUCAS EVANGELISTA, AMEX, LAMAC';

COMMENT ON COLUMN contracheques.centro_custo IS 
    'Unidade empresarial do contracheque: UPA GLEBA-A, UPA LUCAS EVANGELISTA, AMEX, LAMAC';

-- 5. Verificar se as colunas foram adicionadas
SELECT 
    column_name, 
    data_type, 
    column_default,
    is_nullable
FROM information_schema.columns
WHERE table_name IN ('colaboradores', 'contracheques')
  AND column_name = 'centro_custo'
ORDER BY table_name;
