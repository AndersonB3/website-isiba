-- =====================================================
-- EXEMPLOS DE QUERIES SQL - ISIBA SOCIAL
-- Use no SQL Editor do Supabase
-- =====================================================

-- 📊 1. VER TODAS AS ESTATÍSTICAS
SELECT * FROM statistics ORDER BY ano DESC, created_at DESC;

-- 📊 2. VER APENAS ESTATÍSTICA ATIVA (mostrada no site)
SELECT * FROM statistics WHERE ativo = true;

-- 📊 3. VER HISTÓRICO POR ANO
SELECT ano, mes, atendimentos, unidades, profissionais, satisfacao
FROM statistics 
ORDER BY ano DESC, created_at DESC;

-- ✏️ 4. ATUALIZAR DADOS ATUAIS
UPDATE statistics 
SET 
    atendimentos = 280000,
    unidades = 13,
    profissionais = 900,
    satisfacao = 99
WHERE ativo = true;

-- ➕ 5. ADICIONAR NOVOS DADOS (Desativa o antigo)
-- Passo 1: Desativar registro atual
UPDATE statistics SET ativo = false WHERE ativo = true;

-- Passo 2: Inserir novos dados
INSERT INTO statistics (atendimentos, unidades, profissionais, satisfacao, ano, mes, ativo)
VALUES (300000, 15, 950, 99, 2026, 'Fevereiro', true);

-- 📈 6. COMPARAR ANO ATUAL VS ANTERIOR
SELECT 
    ano,
    atendimentos,
    (atendimentos - LAG(atendimentos) OVER (ORDER BY ano)) as diferenca,
    ROUND(((atendimentos::FLOAT - LAG(atendimentos) OVER (ORDER BY ano)) / 
           LAG(atendimentos) OVER (ORDER BY ano) * 100), 2) as crescimento_percentual
FROM statistics
ORDER BY ano DESC;

-- 📊 7. MÉDIA DE SATISFAÇÃO POR ANO
SELECT 
    ano,
    AVG(satisfacao) as media_satisfacao,
    COUNT(*) as total_registros
FROM statistics
GROUP BY ano
ORDER BY ano DESC;

-- 🔍 8. ESTATÍSTICAS TOTAIS (SOMA)
SELECT 
    SUM(atendimentos) as total_atendimentos,
    MAX(unidades) as max_unidades,
    MAX(profissionais) as max_profissionais,
    AVG(satisfacao) as media_satisfacao
FROM statistics;

-- 📅 9. ADICIONAR DADOS MENSAIS (2025)
INSERT INTO statistics (atendimentos, unidades, profissionais, satisfacao, ano, mes, ativo)
VALUES 
    (20000, 12, 850, 98, 2025, 'Janeiro', false),
    (22000, 12, 850, 97, 2025, 'Fevereiro', false),
    (21500, 12, 850, 99, 2025, 'Março', false),
    (23000, 12, 850, 98, 2025, 'Abril', false);

-- 📊 10. RELATÓRIO ANUAL COMPLETO
SELECT 
    ano,
    STRING_AGG(mes, ', ' ORDER BY created_at) as meses,
    SUM(atendimentos) as total_atendimentos,
    MAX(unidades) as unidades,
    MAX(profissionais) as profissionais,
    ROUND(AVG(satisfacao), 1) as media_satisfacao
FROM statistics
GROUP BY ano
ORDER BY ano DESC;

-- 🗑️ 11. DELETAR ESTATÍSTICA ESPECÍFICA (CUIDADO!)
DELETE FROM statistics WHERE id = 3; -- Substitua 3 pelo ID

-- 🗑️ 12. DELETAR TODAS AS ESTATÍSTICAS (MUITO CUIDADO!)
-- DELETE FROM statistics; -- Descomente para usar

-- 🔄 13. RESETAR SEQUÊNCIA DO ID
ALTER SEQUENCE statistics_id_seq RESTART WITH 1;

-- 📋 14. BACKUP DOS DADOS (Copiar resultado)
COPY (SELECT * FROM statistics) TO STDOUT WITH CSV HEADER;

-- ⚙️ 15. VER INFORMAÇÕES DA TABELA
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'statistics';

-- 🔍 16. BUSCAR POR PERÍODO
SELECT * 
FROM statistics 
WHERE created_at BETWEEN '2025-01-01' AND '2025-12-31'
ORDER BY created_at DESC;

-- 📊 17. RANKING DE MESES COM MAIS ATENDIMENTOS
SELECT 
    ano,
    mes,
    atendimentos,
    RANK() OVER (PARTITION BY ano ORDER BY atendimentos DESC) as ranking
FROM statistics
WHERE mes IS NOT NULL
ORDER BY ano DESC, ranking;

-- ✅ 18. VERIFICAR INTEGRIDADE DOS DADOS
SELECT 
    COUNT(*) as total_registros,
    COUNT(CASE WHEN ativo = true THEN 1 END) as registros_ativos,
    MIN(ano) as ano_mais_antigo,
    MAX(ano) as ano_mais_recente
FROM statistics;

-- 🎯 19. ATUALIZAR MÚLTIPLOS REGISTROS
UPDATE statistics 
SET satisfacao = 99 
WHERE ano = 2025 AND satisfacao < 98;

-- 📊 20. CRIAR RELATÓRIO PARA EXPORTAR
SELECT 
    'RELATÓRIO ANUAL - ISIBA SOCIAL' as titulo,
    ano,
    TO_CHAR(atendimentos, '999,999,999') as atendimentos_formatado,
    unidades as "Unidades Geridas",
    profissionais as "Profissionais de Saúde",
    satisfacao || '%' as "Satisfação dos Usuários",
    CASE 
        WHEN ativo THEN 'Exibindo no Site'
        ELSE 'Histórico'
    END as status
FROM statistics
ORDER BY ano DESC, created_at DESC;

-- =====================================================
-- DICAS ÚTEIS
-- =====================================================

-- 💡 Para executar uma query:
--    1. Selecione o texto da query
--    2. Pressione Ctrl+Enter ou clique em "Run"

-- 💡 Para ver resultados formatados:
--    Use a aba "Results" no SQL Editor

-- 💡 Para exportar dados:
--    Clique em "Download CSV" nos resultados

-- =====================================================
