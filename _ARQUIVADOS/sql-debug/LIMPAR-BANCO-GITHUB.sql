-- ======================================
-- LIMPAR BANCO PARA GITHUB
-- Execute este script no Supabase SQL Editor
-- ⚠️ ATENÇÃO: Isso deleta TODOS os dados!
-- ======================================

-- 1. BACKUP AUTOMÁTICO (cria tabelas temporárias)
CREATE TABLE IF NOT EXISTS backup_contracheques AS SELECT * FROM contracheques;
CREATE TABLE IF NOT EXISTS backup_colaboradores AS SELECT * FROM colaboradores;
CREATE TABLE IF NOT EXISTS backup_administradores AS SELECT * FROM administradores;

-- Verificar backups criados
SELECT 
    'backup_contracheques' as tabela, 
    COUNT(*) as registros_salvos 
FROM backup_contracheques
UNION ALL
SELECT 'backup_colaboradores', COUNT(*) FROM backup_colaboradores
UNION ALL
SELECT 'backup_administradores', COUNT(*) FROM backup_administradores;

-- ======================================
-- 2. LIMPAR DADOS
-- ======================================

-- Deletar todos os contracheques
DELETE FROM contracheques;

-- Deletar todos os colaboradores
DELETE FROM colaboradores;

-- Deletar administradores (mantém apenas o principal)
DELETE FROM administradores WHERE usuario != 'admin';

-- ======================================
-- 3. CRIAR DADOS DE EXEMPLO
-- ======================================

-- Atualizar admin principal com senha de exemplo
UPDATE administradores 
SET 
    senha_hash = '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', -- admin123
    nome_completo = 'Administrador',
    ativo = true
WHERE usuario = 'admin';

-- Se não existe admin, criar
INSERT INTO administradores (usuario, senha_hash, nome_completo, ativo)
SELECT 'admin', 
       '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 
       'Administrador', 
       true
WHERE NOT EXISTS (SELECT 1 FROM administradores WHERE usuario = 'admin');

-- Criar colaborador de exemplo
INSERT INTO colaboradores (
    nome_completo, 
    cpf, 
    cpf_hash, 
    senha_hash, 
    email, 
    ativo
) VALUES (
    'João Silva',
    '12345678900',
    '0a0b3d3b75cf7b5b87e9e4b02adcce43df0a0a8e14c1c7b05fe3e7f3a8b5c8c7', -- Hash de "12345678900"
    'ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae', -- Hash de "teste123"
    'joao.silva@exemplo.com',
    true
);

-- ======================================
-- 4. VERIFICAR RESULTADO
-- ======================================

SELECT 
    '✅ LIMPEZA CONCLUÍDA' as status,
    '' as detalhes
UNION ALL
SELECT '---', '---'
UNION ALL
SELECT 'Administradores', CAST(COUNT(*) as TEXT) FROM administradores
UNION ALL
SELECT 'Colaboradores', CAST(COUNT(*) as TEXT) FROM colaboradores
UNION ALL
SELECT 'Contracheques', CAST(COUNT(*) as TEXT) FROM contracheques;

-- ======================================
-- 5. CREDENCIAIS DE ACESSO
-- ======================================

SELECT 
    '📋 CREDENCIAIS PARA TESTES' as titulo,
    '' as valor
UNION ALL
SELECT '---', '---'
UNION ALL
SELECT 'Painel RH - Usuário:', 'admin'
UNION ALL
SELECT 'Painel RH - Senha:', 'admin123'
UNION ALL
SELECT '---', '---'
UNION ALL
SELECT 'Portal Colaborador - CPF:', '123.456.789-00'
UNION ALL
SELECT 'Portal Colaborador - Senha:', 'teste123';

-- ======================================
-- PARA RESTAURAR BACKUP (SE NECESSÁRIO)
-- ======================================
/*
-- ATENÇÃO: Use apenas se precisar desfazer a limpeza!

-- Restaurar dados
INSERT INTO contracheques SELECT * FROM backup_contracheques;
INSERT INTO colaboradores SELECT * FROM backup_colaboradores;
INSERT INTO administradores SELECT * FROM backup_administradores;

-- Deletar backups
DROP TABLE backup_contracheques;
DROP TABLE backup_colaboradores;
DROP TABLE backup_administradores;

-- Verificar restauração
SELECT 'contracheques' as tabela, COUNT(*) FROM contracheques
UNION ALL
SELECT 'colaboradores', COUNT(*) FROM colaboradores
UNION ALL
SELECT 'administradores', COUNT(*) FROM administradores;
*/

-- ======================================
-- DEPOIS DE EXECUTAR ESTE SCRIPT:
-- ======================================
-- 1. Vá para o Storage do Supabase
-- 2. Bucket: contracheques
-- 3. Delete todos os PDFs
-- 4. Verifique o .gitignore
-- 5. Faça commit no Git
-- ======================================
