-- ═══════════════════════════════════════════════════════════════════════════
-- RECRIAR TABELA COLABORADORES NO DESENVOLVIMENTO
-- Execute no banco de DESENVOLVIMENTO
-- ═══════════════════════════════════════════════════════════════════════════

-- 1. Remover a tabela antiga (se existir)
DROP TABLE IF EXISTS colaboradores CASCADE;

-- 2. Criar com a estrutura CORRETA da produção
CREATE TABLE colaboradores (
    id uuid DEFAULT gen_random_uuid() NOT NULL PRIMARY KEY,
    nome_completo character varying(255) NOT NULL,
    cpf character varying(11) NOT NULL UNIQUE,
    cpf_hash character varying(64),
    senha_hash character varying(64) NOT NULL,
    email character varying(255),
    ativo boolean DEFAULT true,
    criado_em timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    atualizado_em timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    primeiro_acesso boolean DEFAULT true,
    codigo_funcionario character varying(50)
);

-- 3. Criar índices
CREATE INDEX IF NOT EXISTS idx_colaboradores_cpf ON colaboradores(cpf);
CREATE INDEX IF NOT EXISTS idx_colaboradores_codigo ON colaboradores(codigo_funcionario);
CREATE INDEX IF NOT EXISTS idx_colaboradores_ativo ON colaboradores(ativo);

-- 4. Habilitar RLS
ALTER TABLE colaboradores ENABLE ROW LEVEL SECURITY;

-- 5. Criar política de SELECT (todos podem ver seus próprios dados)
CREATE POLICY "Colaboradores podem ver seus próprios dados"
    ON colaboradores
    FOR SELECT
    USING (auth.uid()::text = id::text OR auth.role() = 'authenticated');

-- 6. Criar política de UPDATE (colaboradores podem atualizar seus dados)
CREATE POLICY "Colaboradores podem atualizar seus dados"
    ON colaboradores
    FOR UPDATE
    USING (auth.uid()::text = id::text);

-- ═══════════════════════════════════════════════════════════════════════════
-- PRONTO! Agora a tabela está com a estrutura correta
-- Execute o script GERAR-INSERT-COLABORADORES.sql na PRODUÇÃO
-- e depois execute os INSERTs aqui no DESENVOLVIMENTO
-- ═══════════════════════════════════════════════════════════════════════════
