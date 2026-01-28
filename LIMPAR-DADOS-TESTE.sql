-- ============================================
-- SCRIPT PARA LIMPAR DADOS DE TESTE
-- ============================================
-- Este script remove apenas os dados das tabelas,
-- mantendo toda a estrutura do banco intacta.
--
-- USE ESTE SCRIPT ANTES DE SUBIR PARA O GITHUB!
-- ============================================

-- 1️⃣ BACKUP (Execute antes de deletar - OPCIONAL)
-- Copie os resultados para ter um backup caso precise restaurar

SELECT 'BACKUP - Contracheques:' as tabela;
SELECT * FROM contracheques;

SELECT 'BACKUP - Colaboradores:' as tabela;
SELECT * FROM colaboradores;

SELECT 'BACKUP - Administradores:' as tabela;
SELECT * FROM administradores;

-- ============================================
-- 2️⃣ LIMPAR DADOS
-- ============================================

-- Deletar todos os contracheques
DELETE FROM contracheques;

-- Deletar todos os colaboradores
DELETE FROM colaboradores;

-- Deletar todos os administradores (se quiser)
-- ATENÇÃO: Comente a linha abaixo se quiser manter seu usuário admin!
-- DELETE FROM administradores;

-- ============================================
-- 3️⃣ VERIFICAR LIMPEZA
-- ============================================

SELECT 'Contracheques restantes:' as info, COUNT(*) as total FROM contracheques;
SELECT 'Colaboradores restantes:' as info, COUNT(*) as total FROM colaboradores;
SELECT 'Administradores restantes:' as info, COUNT(*) as total FROM administradores;

-- ============================================
-- 4️⃣ RESETAR SEQUÊNCIAS (OPCIONAL)
-- ============================================
-- Isso faz os IDs voltarem a começar do 1

ALTER SEQUENCE contracheques_id_seq RESTART WITH 1;
ALTER SEQUENCE colaboradores_id_seq RESTART WITH 1;
-- ALTER SEQUENCE administradores_id_seq RESTART WITH 1; -- Descomente se deletou admins

-- ============================================
-- 5️⃣ CRIAR DADOS DE EXEMPLO (OPCIONAL)
-- ============================================
-- Descomente as linhas abaixo se quiser ter dados de exemplo no GitHub

/*
-- Criar um colaborador de exemplo
INSERT INTO colaboradores (
    nome_completo,
    cpf,
    cpf_hash,
    email,
    senha_hash,
    ativo
) VALUES (
    'João da Silva',
    '12345678900',
    'c775e7b757ede630cd0aa1113bd102661ab38829ca52a6422ab782862f268646', -- Hash de '12345678900'
    'joao.silva@exemplo.com',
    'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', -- Hash de 'senha123'
    true
);

-- Criar um admin de exemplo (se deletou o seu)
INSERT INTO administradores (
    usuario,
    senha_hash,
    nome_completo,
    ativo
) VALUES (
    'admin',
    '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', -- Hash de 'admin123'
    'Administrador',
    true
);
*/

-- ============================================
-- ✅ SCRIPT FINALIZADO!
-- ============================================
-- Após executar este script:
-- 1. Verifique os resultados da seção 3️⃣
-- 2. Vá para o Storage do Supabase e delete os PDFs manualmente
-- 3. Seu banco estará limpo e pronto para o GitHub!
-- ============================================
