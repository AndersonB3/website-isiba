-- =====================================================
-- ISIBA SOCIAL - DATABASE SCHEMA
-- PostgreSQL Script para Supabase
-- =====================================================

-- 1. Criar tabela de estatísticas
CREATE TABLE IF NOT EXISTS statistics (
    id SERIAL PRIMARY KEY,
    atendimentos INTEGER NOT NULL DEFAULT 0,
    unidades INTEGER NOT NULL DEFAULT 0,
    profissionais INTEGER NOT NULL DEFAULT 0,
    satisfacao INTEGER NOT NULL DEFAULT 0,
    ano INTEGER NOT NULL,
    mes VARCHAR(20),
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Comentários nas colunas
COMMENT ON TABLE statistics IS 'Armazena estatísticas anuais do ISIBA Social';
COMMENT ON COLUMN statistics.atendimentos IS 'Número total de atendimentos realizados';
COMMENT ON COLUMN statistics.unidades IS 'Número de unidades geridas';
COMMENT ON COLUMN statistics.profissionais IS 'Número de profissionais de saúde';
COMMENT ON COLUMN statistics.satisfacao IS 'Percentual de satisfação dos usuários (0-100)';
COMMENT ON COLUMN statistics.ano IS 'Ano de referência dos dados';
COMMENT ON COLUMN statistics.mes IS 'Mês de referência (opcional)';
COMMENT ON COLUMN statistics.ativo IS 'Indica se este registro está ativo (para exibição)';

-- 3. Inserir dados iniciais (exemplo)
INSERT INTO statistics (atendimentos, unidades, profissionais, satisfacao, ano, mes, ativo) 
VALUES 
    (250000, 12, 850, 98, 2025, 'Dezembro', TRUE),
    (230000, 10, 820, 97, 2024, 'Dezembro', FALSE);

-- 4. Criar função para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 5. Criar trigger para atualizar updated_at
CREATE TRIGGER update_statistics_updated_at 
    BEFORE UPDATE ON statistics
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 6. Criar view para dados ativos
CREATE OR REPLACE VIEW statistics_active AS
SELECT 
    id,
    atendimentos,
    unidades,
    profissionais,
    satisfacao,
    ano,
    mes,
    created_at,
    updated_at
FROM statistics
WHERE ativo = TRUE
ORDER BY ano DESC, created_at DESC
LIMIT 1;

-- 7. Habilitar Row Level Security (RLS) - Segurança
ALTER TABLE statistics ENABLE ROW LEVEL SECURITY;

-- 8. Política: Permitir leitura pública (para o website)
CREATE POLICY "Permitir leitura pública de estatísticas ativas"
ON statistics
FOR SELECT
USING (ativo = TRUE);

-- 9. Política: Apenas autenticados podem inserir/atualizar
CREATE POLICY "Apenas autenticados podem modificar"
ON statistics
FOR ALL
USING (auth.role() = 'authenticated');

-- =====================================================
-- FIM DO SCRIPT
-- =====================================================

-- INSTRUÇÕES DE USO:
-- 1. Acesse seu projeto no Supabase
-- 2. Vá em "SQL Editor"
-- 3. Cole este script completo
-- 4. Clique em "Run" para executar
-- 5. Verifique em "Table Editor" se a tabela foi criada
