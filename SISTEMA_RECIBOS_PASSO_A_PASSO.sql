-- ================================================================
-- SISTEMA DE RECIBOS - ISIBA
-- EXECUTE CADA BLOCO SEPARADAMENTE (COPIE E COLE UM POR VEZ)
-- ================================================================

-- ================================================================
-- BLOCO 1: HABILITAR EXTENSAO UUID
-- ================================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


-- ================================================================
-- BLOCO 2: CRIAR TABELA DE RECIBOS
-- ================================================================
CREATE TABLE IF NOT EXISTS recibos_documentos (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    documento_id UUID NOT NULL,
    colaborador_id UUID NOT NULL REFERENCES colaboradores(id) ON DELETE CASCADE,
    tipo_documento VARCHAR(50) NOT NULL CHECK (tipo_documento IN ('contracheque', 'informe_ir', 'outro')),
    mes_referencia TEXT,
    ano INTEGER NOT NULL,
    nome_arquivo TEXT NOT NULL,
    data_visualizacao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    data_recebimento TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ip_address TEXT,
    user_agent TEXT,
    assinatura_texto TEXT,
    assinatura_canvas TEXT,
    declaracao_aceite BOOLEAN DEFAULT true,
    texto_declaracao TEXT DEFAULT 'Declaro que recebi e tenho ciencia do documento disponibilizado.',
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


-- ================================================================
-- BLOCO 3: CRIAR INDICES
-- ================================================================
CREATE INDEX IF NOT EXISTS idx_recibos_documento ON recibos_documentos(documento_id);
CREATE INDEX IF NOT EXISTS idx_recibos_colaborador ON recibos_documentos(colaborador_id);
CREATE INDEX IF NOT EXISTS idx_recibos_tipo ON recibos_documentos(tipo_documento);
CREATE INDEX IF NOT EXISTS idx_recibos_periodo ON recibos_documentos(ano DESC, mes_referencia);
CREATE INDEX IF NOT EXISTS idx_recibos_data ON recibos_documentos(criado_em DESC);


-- ================================================================
-- BLOCO 4: ADICIONAR COLUNAS NA TABELA CONTRACHEQUES
-- ================================================================
ALTER TABLE contracheques 
ADD COLUMN IF NOT EXISTS visualizado BOOLEAN DEFAULT false;

ALTER TABLE contracheques 
ADD COLUMN IF NOT EXISTS data_primeira_visualizacao TIMESTAMP WITH TIME ZONE;

ALTER TABLE contracheques 
ADD COLUMN IF NOT EXISTS recibo_gerado BOOLEAN DEFAULT false;


-- ================================================================
-- BLOCO 5: TRIGGER PARA ATUALIZAR updated_at
-- ================================================================
CREATE OR REPLACE FUNCTION atualizar_recibos_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.atualizado_em = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_recibos_updated_at
    BEFORE UPDATE ON recibos_documentos
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_recibos_updated_at();


-- ================================================================
-- BLOCO 6: HABILITAR RLS E CRIAR POLICY
-- ================================================================
ALTER TABLE recibos_documentos ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Permitir todas operacoes em recibos" ON recibos_documentos;

CREATE POLICY "Permitir todas operacoes em recibos" 
ON recibos_documentos
FOR ALL 
USING (true)
WITH CHECK (true);


-- ================================================================
-- BLOCO 7: CRIAR VIEW
-- ================================================================
CREATE OR REPLACE VIEW view_recibos_completos AS
SELECT 
    r.id as recibo_id,
    r.documento_id,
    r.tipo_documento,
    r.mes_referencia,
    r.ano,
    r.nome_arquivo,
    r.data_visualizacao,
    r.data_recebimento,
    r.assinatura_texto,
    r.declaracao_aceite,
    r.criado_em,
    c.nome_completo,
    c.cpf,
    c.email,
    d.enviado_por,
    d.enviado_em,
    d.tamanho_arquivo
FROM recibos_documentos r
INNER JOIN colaboradores c ON r.colaborador_id = c.id
LEFT JOIN contracheques d ON r.documento_id = d.id
ORDER BY r.criado_em DESC;


-- ================================================================
-- BLOCO 8: VERIFICAR SE FOI CRIADO
-- ================================================================
SELECT 
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'recibos_documentos'
ORDER BY ordinal_position;
