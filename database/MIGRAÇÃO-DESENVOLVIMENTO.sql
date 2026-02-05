-- ═══════════════════════════════════════════════════════════════════════════
-- 🚀 SCRIPT DE MIGRAÇÃO COMPLETA - AMBIENTE DE DESENVOLVIMENTO
-- ═══════════════════════════════════════════════════════════════════════════
-- 
-- INSTRUÇÕES:
-- 1. Crie um NOVO projeto no Supabase chamado "isiba-desenvolvimento"
-- 2. Acesse: SQL Editor no novo projeto
-- 3. Cole TODO este script e execute
-- 4. Configure as chaves no arquivo: assets/js/supabase-config.dev.js
--
-- ═══════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 1: TABELAS DO PORTAL INSTITUCIONAL
-- ═══════════════════════════════════════════════════════════════════════════

-- Tabela de Estatísticas do Site Principal
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

COMMENT ON TABLE statistics IS 'Estatísticas anuais do ISIBA Social para o site institucional';

-- Dados de exemplo para desenvolvimento
INSERT INTO statistics (atendimentos, unidades, profissionais, satisfacao, ano, mes, ativo) 
VALUES 
    (250000, 12, 850, 98, 2026, 'Janeiro', TRUE),
    (230000, 10, 820, 97, 2025, 'Dezembro', FALSE)
ON CONFLICT DO NOTHING;

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 2: TABELAS DO SISTEMA DE RELATÓRIOS (UPAs)
-- ═══════════════════════════════════════════════════════════════════════════

-- Tabela de Unidades (UPAs)
CREATE TABLE IF NOT EXISTS unidades (
    id TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    endereco TEXT,
    cidade TEXT,
    estado TEXT DEFAULT 'MT',
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de Resumo Anual por Unidade
CREATE TABLE IF NOT EXISTS resumo_anual (
    id SERIAL PRIMARY KEY,
    unidade_id TEXT REFERENCES unidades(id) ON DELETE CASCADE,
    ano INTEGER NOT NULL,
    total_atendimentos INTEGER DEFAULT 0,
    satisfacao_media DECIMAL(5,2) DEFAULT 0,
    maior_volume_mes TEXT,
    maior_volume_valor INTEGER DEFAULT 0,
    maior_satisfacao_mes TEXT,
    maior_satisfacao_valor DECIMAL(5,2) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(unidade_id, ano)
);

-- Tabela de Dados Mensais
CREATE TABLE IF NOT EXISTS dados_mensais (
    id SERIAL PRIMARY KEY,
    unidade_id TEXT REFERENCES unidades(id) ON DELETE CASCADE,
    ano INTEGER NOT NULL,
    mes INTEGER NOT NULL CHECK (mes >= 1 AND mes <= 12),
    atendimentos INTEGER DEFAULT 0,
    satisfacao DECIMAL(5,2) DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(unidade_id, ano, mes)
);

-- Tabela de Faixa Etária
CREATE TABLE IF NOT EXISTS faixa_etaria (
    id SERIAL PRIMARY KEY,
    unidade_id TEXT REFERENCES unidades(id) ON DELETE CASCADE,
    ano INTEGER NOT NULL,
    faixa TEXT NOT NULL,
    quantidade INTEGER DEFAULT 0,
    ordem INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(unidade_id, ano, faixa)
);

-- Tabela de Tempo de Atendimento
CREATE TABLE IF NOT EXISTS tempo_atendimento (
    id SERIAL PRIMARY KEY,
    unidade_id TEXT REFERENCES unidades(id) ON DELETE CASCADE,
    ano INTEGER NOT NULL,
    classificacao TEXT NOT NULL,
    tempo_minutos INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(unidade_id, ano, classificacao)
);

-- Inserir dados de exemplo das UPAs
INSERT INTO unidades (id, nome, cidade) VALUES
    ('gleba-a', 'UPA Gleba A', 'Lucas do Rio Verde'),
    ('lucas-evangelista', 'UPA Lucas Evangelista', 'Lucas do Rio Verde')
ON CONFLICT (id) DO NOTHING;

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 3: TABELAS DO SISTEMA RH (PORTAL COLABORADOR)
-- ═══════════════════════════════════════════════════════════════════════════

-- Tabela de Colaboradores/Funcionários
CREATE TABLE IF NOT EXISTS colaboradores (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nome TEXT NOT NULL,
    codigo TEXT NOT NULL UNIQUE,
    cpf TEXT NOT NULL UNIQUE,
    email TEXT,
    senha_hash TEXT NOT NULL,
    status TEXT DEFAULT 'ativo' CHECK (status IN ('ativo', 'inativo')),
    primeiro_acesso BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE colaboradores IS 'Cadastro de colaboradores que acessam o portal';
COMMENT ON COLUMN colaboradores.codigo IS 'Código único do funcionário (aparece no contracheque)';
COMMENT ON COLUMN colaboradores.cpf IS 'CPF do funcionário (usado para login)';
COMMENT ON COLUMN colaboradores.primeiro_acesso IS 'Se TRUE, força redefinir senha no primeiro login';

-- Tabela de Contracheques e Documentos
CREATE TABLE IF NOT EXISTS contracheques (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    colaborador_id UUID NOT NULL REFERENCES colaboradores(id) ON DELETE CASCADE,
    tipo_documento TEXT NOT NULL CHECK (tipo_documento IN ('contracheque', 'informe_ir')),
    mes TEXT,
    ano INTEGER NOT NULL,
    arquivo_url TEXT NOT NULL,
    tamanho_bytes INTEGER,
    bloqueado BOOLEAN DEFAULT FALSE,
    data_envio TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    recibo_gerado BOOLEAN DEFAULT FALSE,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE contracheques IS 'Armazena contracheques mensais e informes de IR dos colaboradores';
COMMENT ON COLUMN contracheques.bloqueado IS 'Se TRUE, colaborador não pode baixar (apenas visualizar)';
COMMENT ON COLUMN contracheques.recibo_gerado IS 'Marca se o colaborador já gerou recibo de recebimento';

-- Tabela de Recibos Digitais
CREATE TABLE IF NOT EXISTS recibos_documentos (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    contracheque_id UUID NOT NULL REFERENCES contracheques(id) ON DELETE CASCADE,
    colaborador_id UUID NOT NULL REFERENCES colaboradores(id) ON DELETE CASCADE,
    tipo_documento TEXT NOT NULL,
    mes TEXT,
    ano INTEGER NOT NULL,
    data_recebimento TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ip_address TEXT,
    user_agent TEXT,
    assinatura_digital TEXT,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE recibos_documentos IS 'Recibos digitais gerados quando colaborador baixa documento';
COMMENT ON COLUMN recibos_documentos.assinatura_digital IS 'Hash único do recibo para validação';

-- Tabela de Administradores RH
CREATE TABLE IF NOT EXISTS admin_rh (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    usuario TEXT NOT NULL UNIQUE,
    senha_hash TEXT NOT NULL,
    nome_completo TEXT,
    email TEXT,
    ativo BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

COMMENT ON TABLE admin_rh IS 'Usuários administrativos do RH com acesso ao painel';

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 4: ÍNDICES PARA PERFORMANCE
-- ═══════════════════════════════════════════════════════════════════════════

-- Índices de Colaboradores
CREATE INDEX IF NOT EXISTS idx_colaboradores_cpf ON colaboradores(cpf);
CREATE INDEX IF NOT EXISTS idx_colaboradores_codigo ON colaboradores(codigo);
CREATE INDEX IF NOT EXISTS idx_colaboradores_status ON colaboradores(status);

-- Índices de Contracheques
CREATE INDEX IF NOT EXISTS idx_contracheques_colaborador ON contracheques(colaborador_id);
CREATE INDEX IF NOT EXISTS idx_contracheques_tipo ON contracheques(tipo_documento);
CREATE INDEX IF NOT EXISTS idx_contracheques_ano ON contracheques(ano);
CREATE INDEX IF NOT EXISTS idx_contracheques_mes ON contracheques(mes);
CREATE INDEX IF NOT EXISTS idx_contracheques_data_envio ON contracheques(data_envio DESC);

-- Índice único para evitar duplicatas
CREATE UNIQUE INDEX IF NOT EXISTS idx_contracheques_unique 
ON contracheques(colaborador_id, tipo_documento, ano, COALESCE(mes, ''));

-- Índices de Recibos
CREATE INDEX IF NOT EXISTS idx_recibos_contracheque ON recibos_documentos(contracheque_id);
CREATE INDEX IF NOT EXISTS idx_recibos_colaborador ON recibos_documentos(colaborador_id);
CREATE INDEX IF NOT EXISTS idx_recibos_data ON recibos_documentos(data_recebimento DESC);

-- Índices do Sistema de Relatórios
CREATE INDEX IF NOT EXISTS idx_resumo_anual_unidade_ano ON resumo_anual(unidade_id, ano);
CREATE INDEX IF NOT EXISTS idx_dados_mensais_unidade_ano ON dados_mensais(unidade_id, ano);
CREATE INDEX IF NOT EXISTS idx_faixa_etaria_unidade_ano ON faixa_etaria(unidade_id, ano);
CREATE INDEX IF NOT EXISTS idx_tempo_atendimento_unidade_ano ON tempo_atendimento(unidade_id, ano);

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 5: TRIGGERS E FUNÇÕES
-- ═══════════════════════════════════════════════════════════════════════════

-- Função para atualizar campo updated_at/atualizado_em
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE OR REPLACE FUNCTION update_atualizado_em_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.atualizado_em = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Aplicar triggers nas tabelas
DROP TRIGGER IF EXISTS update_statistics_updated_at ON statistics;
CREATE TRIGGER update_statistics_updated_at 
    BEFORE UPDATE ON statistics
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_colaboradores_updated_at ON colaboradores;
CREATE TRIGGER update_colaboradores_updated_at 
    BEFORE UPDATE ON colaboradores
    FOR EACH ROW
    EXECUTE FUNCTION update_atualizado_em_column();

DROP TRIGGER IF EXISTS update_contracheques_updated_at ON contracheques;
CREATE TRIGGER update_contracheques_updated_at 
    BEFORE UPDATE ON contracheques
    FOR EACH ROW
    EXECUTE FUNCTION update_atualizado_em_column();

DROP TRIGGER IF EXISTS update_admin_rh_updated_at ON admin_rh;
CREATE TRIGGER update_admin_rh_updated_at 
    BEFORE UPDATE ON admin_rh
    FOR EACH ROW
    EXECUTE FUNCTION update_atualizado_em_column();

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 6: ROW LEVEL SECURITY (RLS) - SEGURANÇA
-- ═══════════════════════════════════════════════════════════════════════════

-- Habilitar RLS em todas as tabelas
ALTER TABLE statistics ENABLE ROW LEVEL SECURITY;
ALTER TABLE unidades ENABLE ROW LEVEL SECURITY;
ALTER TABLE resumo_anual ENABLE ROW LEVEL SECURITY;
ALTER TABLE dados_mensais ENABLE ROW LEVEL SECURITY;
ALTER TABLE faixa_etaria ENABLE ROW LEVEL SECURITY;
ALTER TABLE tempo_atendimento ENABLE ROW LEVEL SECURITY;
ALTER TABLE colaboradores ENABLE ROW LEVEL SECURITY;
ALTER TABLE contracheques ENABLE ROW LEVEL SECURITY;
ALTER TABLE recibos_documentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_rh ENABLE ROW LEVEL SECURITY;

-- Políticas de leitura pública (para site institucional e relatórios)
CREATE POLICY "Permitir leitura pública de statistics" ON statistics 
    FOR SELECT USING (ativo = TRUE);

CREATE POLICY "Permitir leitura pública de unidades" ON unidades 
    FOR SELECT USING (true);

CREATE POLICY "Permitir leitura pública de resumo_anual" ON resumo_anual 
    FOR SELECT USING (true);

CREATE POLICY "Permitir leitura pública de dados_mensais" ON dados_mensais 
    FOR SELECT USING (true);

CREATE POLICY "Permitir leitura pública de faixa_etaria" ON faixa_etaria 
    FOR SELECT USING (true);

CREATE POLICY "Permitir leitura pública de tempo_atendimento" ON tempo_atendimento 
    FOR SELECT USING (true);

-- Políticas do Sistema RH (autenticados podem acessar)
CREATE POLICY "Colaboradores podem ver seus próprios dados" ON colaboradores
    FOR SELECT
    USING (auth.uid()::text = id::text);

CREATE POLICY "Colaboradores podem ver seus próprios contracheques" ON contracheques
    FOR SELECT
    USING (auth.uid()::text = colaborador_id::text);

CREATE POLICY "Colaboradores podem criar recibos" ON recibos_documentos
    FOR INSERT
    WITH CHECK (auth.uid()::text = colaborador_id::text);

CREATE POLICY "Colaboradores podem ver seus próprios recibos" ON recibos_documentos
    FOR SELECT
    USING (auth.uid()::text = colaborador_id::text);

-- Política de administradores (permite tudo para autenticados)
CREATE POLICY "Administradores podem gerenciar tudo" ON colaboradores
    FOR ALL
    USING (auth.role() = 'authenticated');

CREATE POLICY "Administradores podem gerenciar contracheques" ON contracheques
    FOR ALL
    USING (auth.role() = 'authenticated');

CREATE POLICY "Administradores podem ver todos os recibos" ON recibos_documentos
    FOR SELECT
    USING (auth.role() = 'authenticated');

CREATE POLICY "Admin RH pode gerenciar tudo" ON admin_rh
    FOR ALL
    USING (auth.role() = 'authenticated');

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 7: VIEWS ÚTEIS
-- ═══════════════════════════════════════════════════════════════════════════

-- View de estatísticas ativas
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

-- View de documentos com recibos
CREATE OR REPLACE VIEW contracheques_com_recibos AS
SELECT 
    c.id,
    c.colaborador_id,
    col.nome as colaborador_nome,
    col.cpf as colaborador_cpf,
    c.tipo_documento,
    c.mes,
    c.ano,
    c.arquivo_url,
    c.bloqueado,
    c.data_envio,
    c.recibo_gerado,
    r.data_recebimento,
    r.ip_address,
    r.assinatura_digital
FROM contracheques c
LEFT JOIN colaboradores col ON c.colaborador_id = col.id
LEFT JOIN recibos_documentos r ON c.id = r.contracheque_id
ORDER BY c.data_envio DESC;

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 8: DADOS INICIAIS
-- ═══════════════════════════════════════════════════════════════════════════

-- ATENÇÃO: Os dados REAIS serão importados separadamente!
-- 
-- Após executar este script de migração:
-- 1. Execute EXPORT-PRODUCAO-PARA-DEV.sql no banco de PRODUÇÃO
-- 2. Copie o resultado
-- 3. Execute aqui no banco de DESENVOLVIMENTO
--
-- Isso copiará todos os colaboradores, contracheques e recibos reais!

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 9: STORAGE BUCKETS (CONFIGURAR MANUALMENTE)
-- ═══════════════════════════════════════════════════════════════════════════

-- ATENÇÃO: Buckets de Storage NÃO podem ser criados via SQL!
-- Você DEVE criar manualmente no painel do Supabase:
--
-- 1. Acesse: Storage > Create Bucket
-- 2. Nome: "contracheques"
-- 3. Public: ❌ NÃO (Private)
-- 4. File size limit: 10MB
-- 5. Allowed MIME types: application/pdf
--
-- Depois, configure as políticas de storage:
-- Execute o script: POLITICAS_STORAGE.sql
--
-- ═══════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════
-- ✅ MIGRAÇÃO COMPLETA!
-- ═══════════════════════════════════════════════════════════════════════════
--
-- PRÓXIMOS PASSOS:
-- 1. ✅ Criar bucket "contracheques" manualmente
-- 2. ✅ Configurar arquivo: assets/js/supabase-config.dev.js
-- 3. ✅ Testar localmente com http://localhost:8000
-- 4. ✅ Verificar se sistema detecta ambiente automaticamente
--
-- ═══════════════════════════════════════════════════════════════════════════
