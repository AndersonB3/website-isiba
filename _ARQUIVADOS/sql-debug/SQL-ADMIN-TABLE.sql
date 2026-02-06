-- ========================================
-- TABELA DE ADMINISTRADORES RH
-- Sistema Profissional de Autenticação
-- ========================================

-- 1. Criar tabela de administradores
CREATE TABLE IF NOT EXISTS administradores (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    usuario TEXT UNIQUE NOT NULL,
    senha_hash TEXT NOT NULL,
    nome_completo TEXT NOT NULL,
    email TEXT,
    ativo BOOLEAN DEFAULT true,
    ultimo_acesso TIMESTAMP WITH TIME ZONE,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Índices para busca rápida
CREATE INDEX idx_admin_usuario ON administradores(usuario);
CREATE INDEX idx_admin_ativo ON administradores(ativo);

-- 3. Comentários
COMMENT ON TABLE administradores IS 'Tabela de administradores do sistema RH';
COMMENT ON COLUMN administradores.usuario IS 'Nome de usuário para login';
COMMENT ON COLUMN administradores.senha_hash IS 'Hash SHA-256 da senha';
COMMENT ON COLUMN administradores.ultimo_acesso IS 'Data/hora do último login';

-- 4. Trigger para atualizar data de modificação
CREATE TRIGGER update_administradores_updated_at 
    BEFORE UPDATE ON administradores 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- 5. Habilitar RLS
ALTER TABLE administradores ENABLE ROW LEVEL SECURITY;

-- 6. Política de acesso
CREATE POLICY "Permitir todas operações em administradores" ON administradores
    FOR ALL 
    USING (true)
    WITH CHECK (true);

-- 7. Inserir administrador padrão
-- Usuário: admin
-- Senha: admin
-- Senha Hash: 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918 (SHA-256 de "admin")

INSERT INTO administradores (usuario, senha_hash, nome_completo, email, ativo)
VALUES (
    'admin',
    '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918',
    'Administrador RH',
    'rh.isiba@gmail.com',
    true
)
ON CONFLICT (usuario) DO NOTHING;

-- 8. Verificar criação
SELECT * FROM administradores;
