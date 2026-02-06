-- ============================================
-- ATUALIZAÇÃO DO BANCO DE DADOS
-- Adicionar suporte para Informes de Imposto de Renda
-- ============================================
-- Execute este script no SQL Editor do Supabase

-- ============================================
-- PASSO 1: Renomear tabela (opcional - manter compatibilidade)
-- ============================================
-- Vamos manter a tabela 'contracheques' mas adicionar um campo 'tipo_documento'

-- ============================================
-- PASSO 2: Adicionar coluna 'tipo_documento'
-- ============================================
ALTER TABLE contracheques 
ADD COLUMN IF NOT EXISTS tipo_documento VARCHAR(50) DEFAULT 'contracheque';

-- Valores possíveis: 'contracheque' ou 'informe_ir'

-- ============================================
-- PASSO 3: Atualizar registros existentes
-- ============================================
UPDATE contracheques 
SET tipo_documento = 'contracheque' 
WHERE tipo_documento IS NULL;

-- ============================================
-- PASSO 4: Adicionar constraint para validar tipo
-- ============================================
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'contracheques_tipo_documento_check'
    ) THEN
        ALTER TABLE contracheques 
        ADD CONSTRAINT contracheques_tipo_documento_check 
        CHECK (tipo_documento IN ('contracheque', 'informe_ir'));
    END IF;
END $$;

-- ============================================
-- PASSO 5: Criar índice para melhor performance
-- ============================================
CREATE INDEX IF NOT EXISTS idx_contracheques_tipo_documento 
ON contracheques(tipo_documento);

-- ============================================
-- PASSO 6: Verificar estrutura atualizada
-- ============================================
SELECT 
    column_name,
    data_type,
    column_default,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'contracheques'
ORDER BY ordinal_position;

-- ============================================
-- PASSO 7: Verificar constraint criada
-- ============================================
SELECT 
    conname AS constraint_name,
    pg_get_constraintdef(oid) AS constraint_definition
FROM pg_constraint
WHERE conrelid = 'contracheques'::regclass
AND conname LIKE '%tipo_documento%';

-- ============================================
-- PASSO 8: Exemplo de inserção de Informe IR
-- ============================================
-- INSERT INTO contracheques (
--     colaborador_id,
--     mes_referencia,
--     ano,
--     arquivo_url,
--     nome_arquivo,
--     tamanho_arquivo,
--     enviado_por,
--     tipo_documento
-- ) VALUES (
--     1,  -- ID do colaborador
--     'Anual',  -- Para informe IR, usar 'Anual'
--     2025,
--     '08676044503/2025-INFORME-IR.pdf',
--     'Informe_Rendimentos_2025.pdf',
--     150000,
--     'admin.rh',
--     'informe_ir'
-- );

-- ============================================
-- PASSO 9: Consulta para ver todos os documentos
-- ============================================
SELECT 
    c.id,
    col.nome_completo,
    c.tipo_documento,
    c.mes_referencia,
    c.ano,
    c.arquivo_url,
    c.enviado_em
FROM contracheques c
JOIN colaboradores col ON c.colaborador_id = col.id
ORDER BY c.ano DESC, c.tipo_documento, c.mes_referencia;
