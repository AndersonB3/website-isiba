-- =====================================================
-- ISIBA Social - Estrutura do Banco de Dados Supabase
-- Tabelas para o Relatório Anual de Atendimentos
-- =====================================================

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

-- Tabela de Tempo de Atendimento por Classificação
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

-- =====================================================
-- DADOS INICIAIS
-- =====================================================

-- Inserir Unidades
INSERT INTO unidades (id, nome, cidade) VALUES
    ('gleba-a', 'UPA Gleba A', 'Lucas do Rio Verde'),
    ('lucas-evangelista', 'UPA Lucas Evangelista', 'Lucas do Rio Verde')
ON CONFLICT (id) DO NOTHING;

-- Inserir Resumo Anual - UPA Gleba A
INSERT INTO resumo_anual (unidade_id, ano, total_atendimentos, satisfacao_media, maior_volume_mes, maior_volume_valor, maior_satisfacao_mes, maior_satisfacao_valor) VALUES
    ('gleba-a', 2025, 45892, 94.5, 'Março', 4521, 'Setembro', 97.2),
    ('gleba-a', 2026, 48500, 95.2, 'Abril', 4800, 'Outubro', 97.8)
ON CONFLICT (unidade_id, ano) DO UPDATE SET
    total_atendimentos = EXCLUDED.total_atendimentos,
    satisfacao_media = EXCLUDED.satisfacao_media,
    maior_volume_mes = EXCLUDED.maior_volume_mes,
    maior_volume_valor = EXCLUDED.maior_volume_valor,
    maior_satisfacao_mes = EXCLUDED.maior_satisfacao_mes,
    maior_satisfacao_valor = EXCLUDED.maior_satisfacao_valor;

-- Inserir Resumo Anual - UPA Lucas Evangelista
INSERT INTO resumo_anual (unidade_id, ano, total_atendimentos, satisfacao_media, maior_volume_mes, maior_volume_valor, maior_satisfacao_mes, maior_satisfacao_valor) VALUES
    ('lucas-evangelista', 2025, 38457, 92.8, 'Janeiro', 3876, 'Novembro', 96.5),
    ('lucas-evangelista', 2026, 41200, 93.5, 'Março', 4100, 'Dezembro', 97.0)
ON CONFLICT (unidade_id, ano) DO UPDATE SET
    total_atendimentos = EXCLUDED.total_atendimentos,
    satisfacao_media = EXCLUDED.satisfacao_media,
    maior_volume_mes = EXCLUDED.maior_volume_mes,
    maior_volume_valor = EXCLUDED.maior_volume_valor,
    maior_satisfacao_mes = EXCLUDED.maior_satisfacao_mes,
    maior_satisfacao_valor = EXCLUDED.maior_satisfacao_valor;

-- Inserir Dados Mensais - UPA Gleba A 2026
INSERT INTO dados_mensais (unidade_id, ano, mes, atendimentos, satisfacao) VALUES
    ('gleba-a', 2026, 1, 3845, 92.1),
    ('gleba-a', 2026, 2, 3654, 93.5),
    ('gleba-a', 2026, 3, 4521, 94.2),
    ('gleba-a', 2026, 4, 4800, 95.1),
    ('gleba-a', 2026, 5, 3987, 93.8),
    ('gleba-a', 2026, 6, 4234, 94.5),
    ('gleba-a', 2026, 7, 4012, 95.3),
    ('gleba-a', 2026, 8, 3876, 94.8),
    ('gleba-a', 2026, 9, 3945, 97.2),
    ('gleba-a', 2026, 10, 4587, 97.8),
    ('gleba-a', 2026, 11, 3798, 95.4),
    ('gleba-a', 2026, 12, 3831, 94.5)
ON CONFLICT (unidade_id, ano, mes) DO UPDATE SET
    atendimentos = EXCLUDED.atendimentos,
    satisfacao = EXCLUDED.satisfacao;

-- Inserir Dados Mensais - UPA Lucas Evangelista 2026
INSERT INTO dados_mensais (unidade_id, ano, mes, atendimentos, satisfacao) VALUES
    ('lucas-evangelista', 2026, 1, 3876, 91.2),
    ('lucas-evangelista', 2026, 2, 3234, 92.5),
    ('lucas-evangelista', 2026, 3, 4100, 91.8),
    ('lucas-evangelista', 2026, 4, 3102, 93.1),
    ('lucas-evangelista', 2026, 5, 3287, 92.8),
    ('lucas-evangelista', 2026, 6, 3134, 93.5),
    ('lucas-evangelista', 2026, 7, 3212, 92.3),
    ('lucas-evangelista', 2026, 8, 3076, 91.8),
    ('lucas-evangelista', 2026, 9, 3145, 94.2),
    ('lucas-evangelista', 2026, 10, 3087, 93.1),
    ('lucas-evangelista', 2026, 11, 3298, 96.5),
    ('lucas-evangelista', 2026, 12, 3650, 97.0)
ON CONFLICT (unidade_id, ano, mes) DO UPDATE SET
    atendimentos = EXCLUDED.atendimentos,
    satisfacao = EXCLUDED.satisfacao;

-- Inserir Faixa Etária - UPA Gleba A 2026
INSERT INTO faixa_etaria (unidade_id, ano, faixa, quantidade, ordem) VALUES
    ('gleba-a', 2026, '0-12 anos', 8234, 1),
    ('gleba-a', 2026, '13-17 anos', 3102, 2),
    ('gleba-a', 2026, '18-29 anos', 12456, 3),
    ('gleba-a', 2026, '30-44 anos', 10234, 4),
    ('gleba-a', 2026, '45-59 anos', 7654, 5),
    ('gleba-a', 2026, '60+ anos', 6820, 6)
ON CONFLICT (unidade_id, ano, faixa) DO UPDATE SET
    quantidade = EXCLUDED.quantidade,
    ordem = EXCLUDED.ordem;

-- Inserir Faixa Etária - UPA Lucas Evangelista 2026
INSERT INTO faixa_etaria (unidade_id, ano, faixa, quantidade, ordem) VALUES
    ('lucas-evangelista', 2026, '0-12 anos', 6890, 1),
    ('lucas-evangelista', 2026, '13-17 anos', 2654, 2),
    ('lucas-evangelista', 2026, '18-29 anos', 10234, 3),
    ('lucas-evangelista', 2026, '30-44 anos', 8765, 4),
    ('lucas-evangelista', 2026, '45-59 anos', 6432, 5),
    ('lucas-evangelista', 2026, '60+ anos', 6225, 6)
ON CONFLICT (unidade_id, ano, faixa) DO UPDATE SET
    quantidade = EXCLUDED.quantidade,
    ordem = EXCLUDED.ordem;

-- Inserir Tempo de Atendimento - UPA Gleba A 2026
INSERT INTO tempo_atendimento (unidade_id, ano, classificacao, tempo_minutos) VALUES
    ('gleba-a', 2026, 'Pouco Urgente', 15),
    ('gleba-a', 2026, 'Não Urgente', 28),
    ('gleba-a', 2026, 'Eletivo', 45)
ON CONFLICT (unidade_id, ano, classificacao) DO UPDATE SET
    tempo_minutos = EXCLUDED.tempo_minutos;

-- Inserir Tempo de Atendimento - UPA Lucas Evangelista 2026
INSERT INTO tempo_atendimento (unidade_id, ano, classificacao, tempo_minutos) VALUES
    ('lucas-evangelista', 2026, 'Pouco Urgente', 18),
    ('lucas-evangelista', 2026, 'Não Urgente', 32),
    ('lucas-evangelista', 2026, 'Eletivo', 52)
ON CONFLICT (unidade_id, ano, classificacao) DO UPDATE SET
    tempo_minutos = EXCLUDED.tempo_minutos;

-- =====================================================
-- POLÍTICAS DE SEGURANÇA (RLS)
-- =====================================================

-- Habilitar RLS em todas as tabelas
ALTER TABLE unidades ENABLE ROW LEVEL SECURITY;
ALTER TABLE resumo_anual ENABLE ROW LEVEL SECURITY;
ALTER TABLE dados_mensais ENABLE ROW LEVEL SECURITY;
ALTER TABLE faixa_etaria ENABLE ROW LEVEL SECURITY;
ALTER TABLE tempo_atendimento ENABLE ROW LEVEL SECURITY;

-- Políticas de leitura pública (anon pode ler)
CREATE POLICY "Permitir leitura pública de unidades" ON unidades FOR SELECT USING (true);
CREATE POLICY "Permitir leitura pública de resumo_anual" ON resumo_anual FOR SELECT USING (true);
CREATE POLICY "Permitir leitura pública de dados_mensais" ON dados_mensais FOR SELECT USING (true);
CREATE POLICY "Permitir leitura pública de faixa_etaria" ON faixa_etaria FOR SELECT USING (true);
CREATE POLICY "Permitir leitura pública de tempo_atendimento" ON tempo_atendimento FOR SELECT USING (true);

-- =====================================================
-- ÍNDICES PARA PERFORMANCE
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_resumo_anual_unidade_ano ON resumo_anual(unidade_id, ano);
CREATE INDEX IF NOT EXISTS idx_dados_mensais_unidade_ano ON dados_mensais(unidade_id, ano);
CREATE INDEX IF NOT EXISTS idx_faixa_etaria_unidade_ano ON faixa_etaria(unidade_id, ano);
CREATE INDEX IF NOT EXISTS idx_tempo_atendimento_unidade_ano ON tempo_atendimento(unidade_id, ano);
