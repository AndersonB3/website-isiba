-- ════════════════════════════════════════════════════════════════
-- SISTEMA DE RECIBOS DE DOCUMENTOS - ISIBA
-- ════════════════════════════════════════════════════════════════
-- Este script cria a estrutura completa para registro de recibos
-- de contracheques, informes de IR e outros documentos futuros.
-- ════════════════════════════════════════════════════════════════

-- 1️⃣ CRIAR TABELA DE RECIBOS
CREATE TABLE IF NOT EXISTS recibos_documentos (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    
    -- Relacionamentos
    documento_id UUID NOT NULL, -- ID do contracheque/informe
    colaborador_id UUID NOT NULL REFERENCES colaboradores(id) ON DELETE CASCADE,
    
    -- Informações do documento
    tipo_documento VARCHAR(50) NOT NULL CHECK (tipo_documento IN ('contracheque', 'informe_ir', 'outro')),
    mes_referencia TEXT,
    ano INTEGER NOT NULL,
    nome_arquivo TEXT NOT NULL,
    
    -- Dados do recibo
    data_visualizacao TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    data_recebimento TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ip_address TEXT,
    user_agent TEXT,
    
    -- Assinatura Digital
    assinatura_texto TEXT, -- Nome digitado pelo colaborador
    assinatura_canvas TEXT, -- Base64 da assinatura desenhada (se implementar canvas)
    
    -- Declaração
    declaracao_aceite BOOLEAN DEFAULT true,
    texto_declaracao TEXT DEFAULT 'Declaro que recebi e tenho ciência do documento disponibilizado.',
    
    -- Metadados
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2️⃣ CRIAR ÍNDICES PARA PERFORMANCE
CREATE INDEX idx_recibos_documento ON recibos_documentos(documento_id);
CREATE INDEX idx_recibos_colaborador ON recibos_documentos(colaborador_id);
CREATE INDEX idx_recibos_tipo ON recibos_documentos(tipo_documento);
CREATE INDEX idx_recibos_periodo ON recibos_documentos(ano DESC, mes_referencia);
CREATE INDEX idx_recibos_data ON recibos_documentos(criado_em DESC);

-- 3️⃣ ADICIONAR COLUNA NA TABELA CONTRACHEQUES
-- Para rastrear se o documento já foi visualizado/recebido
ALTER TABLE contracheques 
ADD COLUMN IF NOT EXISTS visualizado BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS data_primeira_visualizacao TIMESTAMP WITH TIME ZONE,
ADD COLUMN IF NOT EXISTS recibo_gerado BOOLEAN DEFAULT false;

-- 4️⃣ COMENTÁRIOS E DOCUMENTAÇÃO
COMMENT ON TABLE recibos_documentos IS 'Registros de recibos de documentos entregues aos colaboradores';
COMMENT ON COLUMN recibos_documentos.documento_id IS 'ID do documento (contracheque, informe, etc)';
COMMENT ON COLUMN recibos_documentos.assinatura_texto IS 'Nome digitado pelo colaborador como assinatura';
COMMENT ON COLUMN recibos_documentos.assinatura_canvas IS 'Base64 da assinatura desenhada (se implementado)';
COMMENT ON COLUMN recibos_documentos.ip_address IS 'IP do colaborador no momento do recebimento';
COMMENT ON COLUMN recibos_documentos.declaracao_aceite IS 'Se o colaborador aceitou os termos';

-- 5️⃣ TRIGGER PARA ATUALIZAR updated_at
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

-- 6️⃣ HABILITAR ROW LEVEL SECURITY (RLS)
ALTER TABLE recibos_documentos ENABLE ROW LEVEL SECURITY;

-- Política: Permitir todas operações (ajuste conforme necessário)
CREATE POLICY "Permitir todas operações em recibos" 
ON recibos_documentos
FOR ALL 
USING (true)
WITH CHECK (true);

-- 7️⃣ VIEW PARA CONSULTA RÁPIDA DE RECIBOS
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
    -- Dados do colaborador
    c.nome_completo,
    c.cpf,
    c.email,
    -- Dados do documento (contracheque/informe)
    d.enviado_por,
    d.enviado_em,
    d.tamanho_arquivo
FROM recibos_documentos r
INNER JOIN colaboradores c ON r.colaborador_id = c.id
LEFT JOIN contracheques d ON r.documento_id = d.id
ORDER BY r.criado_em DESC;

-- 8️⃣ QUERY DE VERIFICAÇÃO
-- Execute após criar a tabela para confirmar:
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'recibos_documentos'
ORDER BY ordinal_position;

-- ════════════════════════════════════════════════════════════════
-- QUERIES ÚTEIS PARA O RH
-- ════════════════════════════════════════════════════════════════

-- 📊 Ver todos os recibos gerados
-- SELECT * FROM view_recibos_completos;

-- 📋 Ver documentos SEM recibo (não visualizados)
/*
SELECT 
    c.id,
    c.mes_referencia,
    c.ano,
    c.tipo_documento,
    col.nome_completo,
    col.cpf,
    c.enviado_em,
    c.recibo_gerado
FROM contracheques c
INNER JOIN colaboradores col ON c.colaborador_id = col.id
WHERE c.recibo_gerado = false
ORDER BY c.enviado_em DESC;
*/

-- 👤 Ver recibos de um colaborador específico
/*
SELECT * FROM view_recibos_completos
WHERE cpf = '12345678900'
ORDER BY ano DESC, mes_referencia DESC;
*/

-- 📈 Estatísticas de recebimento
/*
SELECT 
    tipo_documento,
    COUNT(*) as total_recibos,
    COUNT(DISTINCT colaborador_id) as colaboradores_unicos,
    DATE_TRUNC('month', criado_em) as mes
FROM recibos_documentos
GROUP BY tipo_documento, DATE_TRUNC('month', criado_em)
ORDER BY mes DESC, tipo_documento;
*/

-- ════════════════════════════════════════════════════════════════
-- FIM DO SCRIPT
-- ════════════════════════════════════════════════════════════════
