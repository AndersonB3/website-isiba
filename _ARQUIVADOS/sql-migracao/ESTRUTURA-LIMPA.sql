-- ═══════════════════════════════════════════════════════════════════════════
-- ESTRUTURA DO BANCO DE PRODUÇÃO - EXECUTE NO DESENVOLVIMENTO
-- ═══════════════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS administradores (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    usuario TEXT NOT NULL,
    senha_hash TEXT NOT NULL,
    nome_completo TEXT NOT NULL,
    email TEXT,
    ativo BOOLEAN DEFAULT true,
    ultimo_acesso TIMESTAMP WITH TIME ZONE,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE IF NOT EXISTS colaboradores (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    nome_completo TEXT NOT NULL,
    cpf TEXT NOT NULL,
    cpf_hash TEXT NOT NULL,
    senha_hash TEXT NOT NULL,
    email TEXT,
    ativo BOOLEAN DEFAULT true,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
    primeiro_acesso BOOLEAN DEFAULT true,
    codigo_funcionario VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS contracheques (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    colaborador_id UUID,
    mes_referencia TEXT NOT NULL,
    ano INTEGER NOT NULL,
    arquivo_url TEXT NOT NULL,
    nome_arquivo TEXT NOT NULL,
    tamanho_arquivo BIGINT NOT NULL,
    enviado_por TEXT DEFAULT 'admin.rh'::text,
    enviado_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
    tipo_documento VARCHAR(50) DEFAULT 'contracheque'::character varying,
    visualizado BOOLEAN DEFAULT false,
    data_primeira_visualizacao TIMESTAMP WITH TIME ZONE,
    recibo_gerado BOOLEAN DEFAULT false,
    assinatura_digital TEXT,
    mes TEXT,
    data_envio TIMESTAMP WITH TIME ZONE DEFAULT now(),
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE IF NOT EXISTS dados_mensais (
    id INTEGER NOT NULL DEFAULT nextval('dados_mensais_id_seq'::regclass),
    unidade_id TEXT,
    ano INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    atendimentos INTEGER DEFAULT 0,
    satisfacao NUMERIC DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE IF NOT EXISTS faixa_etaria (
    id INTEGER NOT NULL DEFAULT nextval('faixa_etaria_id_seq'::regclass),
    unidade_id TEXT,
    ano INTEGER NOT NULL,
    faixa TEXT NOT NULL,
    quantidade INTEGER DEFAULT 0,
    ordem INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE IF NOT EXISTS recibos_documentos (
    id UUID NOT NULL DEFAULT uuid_generate_v4(),
    documento_id UUID NOT NULL,
    colaborador_id UUID NOT NULL,
    tipo_documento VARCHAR(50) NOT NULL,
    mes_referencia TEXT,
    ano INTEGER NOT NULL,
    nome_arquivo TEXT NOT NULL,
    data_visualizacao TIMESTAMP WITH TIME ZONE DEFAULT now(),
    data_recebimento TIMESTAMP WITH TIME ZONE DEFAULT now(),
    ip_address TEXT,
    user_agent TEXT,
    assinatura_texto TEXT,
    assinatura_canvas TEXT,
    declaracao_aceite BOOLEAN DEFAULT true,
    texto_declaracao TEXT DEFAULT 'Declaro que recebi e tenho ciencia do documento disponibilizado.'::text,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE IF NOT EXISTS resumo_anual (
    id INTEGER NOT NULL DEFAULT nextval('resumo_anual_id_seq'::regclass),
    unidade_id TEXT,
    ano INTEGER NOT NULL,
    total_atendimentos INTEGER DEFAULT 0,
    satisfacao_media NUMERIC DEFAULT 0,
    maior_volume_mes TEXT,
    maior_volume_valor INTEGER DEFAULT 0,
    maior_satisfacao_mes TEXT,
    maior_satisfacao_valor NUMERIC DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE IF NOT EXISTS statistics (
    id INTEGER NOT NULL DEFAULT nextval('statistics_id_seq'::regclass),
    atendimentos INTEGER NOT NULL DEFAULT 0,
    unidades INTEGER NOT NULL DEFAULT 0,
    profissionais INTEGER NOT NULL DEFAULT 0,
    satisfacao INTEGER NOT NULL DEFAULT 0,
    ano INTEGER NOT NULL,
    mes VARCHAR(20),
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tempo_atendimento (
    id INTEGER NOT NULL DEFAULT nextval('tempo_atendimento_id_seq'::regclass),
    unidade_id TEXT,
    ano INTEGER NOT NULL,
    classificacao TEXT NOT NULL,
    tempo_minutos INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE IF NOT EXISTS unidades (
    id TEXT NOT NULL,
    nome TEXT NOT NULL,
    endereco TEXT,
    cidade TEXT,
    estado TEXT DEFAULT 'MT'::text,
    ativo BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- ═══════════════════════════════════════════════════════════════════════════
-- ✅ TABELAS CRIADAS COM SUCESSO!
-- Próximos passos:
-- 1. Execute GERAR-PRIMARY-KEYS.sql no banco de PRODUÇÃO
-- 2. Execute GERAR-FOREIGN-KEYS.sql no banco de PRODUÇÃO
-- ═══════════════════════════════════════════════════════════════════════════
