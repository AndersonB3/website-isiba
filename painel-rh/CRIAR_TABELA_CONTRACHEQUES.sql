-- ════════════════════════════════════════════════════════════════
-- SQL PARA CRIAR/ATUALIZAR TABELA CONTRACHEQUES
-- ════════════════════════════════════════════════════════════════
-- Execute este script no SQL Editor do Supabase
-- ════════════════════════════════════════════════════════════════

-- 1. Verificar se a tabela existe e criar se necessário
CREATE TABLE IF NOT EXISTS contracheques (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    colaborador_id UUID NOT NULL REFERENCES colaboradores(id) ON DELETE CASCADE,
    tipo_documento TEXT NOT NULL CHECK (tipo_documento IN ('contracheque', 'informe_ir')),
    mes TEXT,
    ano INTEGER NOT NULL,
    arquivo_url TEXT NOT NULL,
    data_envio TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    recibo_gerado BOOLEAN DEFAULT FALSE,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Se a tabela já existe mas está faltando colunas, adicionar:

-- Adicionar coluna mes se não existir
ALTER TABLE contracheques 
ADD COLUMN IF NOT EXISTS mes TEXT;

-- Adicionar coluna ano se não existir
ALTER TABLE contracheques 
ADD COLUMN IF NOT EXISTS ano INTEGER;

-- Adicionar coluna data_envio se não existir
ALTER TABLE contracheques 
ADD COLUMN IF NOT EXISTS data_envio TIMESTAMP WITH TIME ZONE DEFAULT NOW();

-- Adicionar coluna recibo_gerado se não existir
ALTER TABLE contracheques 
ADD COLUMN IF NOT EXISTS recibo_gerado BOOLEAN DEFAULT FALSE;

-- Adicionar coluna criado_em se não existir
ALTER TABLE contracheques 
ADD COLUMN IF NOT EXISTS criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW();

-- Adicionar coluna atualizado_em se não existir
ALTER TABLE contracheques 
ADD COLUMN IF NOT EXISTS atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW();

-- 3. Criar índices para melhorar performance
CREATE INDEX IF NOT EXISTS idx_contracheques_colaborador 
ON contracheques(colaborador_id);

CREATE INDEX IF NOT EXISTS idx_contracheques_tipo 
ON contracheques(tipo_documento);

CREATE INDEX IF NOT EXISTS idx_contracheques_ano 
ON contracheques(ano);

CREATE INDEX IF NOT EXISTS idx_contracheques_mes 
ON contracheques(mes);

CREATE INDEX IF NOT EXISTS idx_contracheques_data_envio 
ON contracheques(data_envio DESC);

-- 4. Criar índice composto para buscar duplicatas
CREATE UNIQUE INDEX IF NOT EXISTS idx_contracheques_unique 
ON contracheques(colaborador_id, tipo_documento, ano, COALESCE(mes, ''));

-- 5. Adicionar trigger para atualizar atualizado_em automaticamente
CREATE OR REPLACE FUNCTION update_contracheques_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.atualizado_em = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_contracheques_updated_at ON contracheques;

CREATE TRIGGER trigger_update_contracheques_updated_at
    BEFORE UPDATE ON contracheques
    FOR EACH ROW
    EXECUTE FUNCTION update_contracheques_updated_at();

-- ════════════════════════════════════════════════════════════════
-- VERIFICAÇÃO FINAL
-- ════════════════════════════════════════════════════════════════

-- Execute esta query para verificar se tudo foi criado corretamente:
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'contracheques' 
ORDER BY ordinal_position;

-- Resultado esperado deve mostrar todas as colunas:
-- id, colaborador_id, tipo_documento, mes, ano, arquivo_url, 
-- data_envio, recibo_gerado, criado_em, atualizado_em
