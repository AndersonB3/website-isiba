-- ═══════════════════════════════════════════════════════════════════════════
-- 📊 COPIAR DADOS DE PRODUÇÃO PARA DESENVOLVIMENTO
-- ═══════════════════════════════════════════════════════════════════════════
-- 
-- INSTRUÇÕES:
-- 1. Execute CADA SELECT abaixo no banco de PRODUÇÃO
-- 2. Para cada resultado, use o método de cópia manual via Table Editor
-- 3. Ou exporte e importe via pgAdmin/DBeaver
--
-- ═══════════════════════════════════════════════════════════════════════════

-- ORDEM IMPORTANTE: Copiar nesta sequência para respeitar Foreign Keys

-- 1. PRIMEIRO: Tabelas independentes (sem FK)
SELECT * FROM administradores;
SELECT * FROM unidades;
SELECT * FROM statistics;

-- 2. DEPOIS: Colaboradores (referenciado por outras tabelas)
SELECT * FROM colaboradores;

-- 3. EM SEGUIDA: Contracheques (depende de colaboradores)
SELECT * FROM contracheques;

-- 4. POR ÚLTIMO: Recibos (depende de contracheques e colaboradores)
SELECT * FROM recibos_documentos;

-- 5. OPCIONAIS: Tabelas de relatórios
SELECT * FROM resumo_anual;
SELECT * FROM dados_mensais;
SELECT * FROM faixa_etaria;
SELECT * FROM tempo_atendimento;

-- ═══════════════════════════════════════════════════════════════════════════
-- MÉTODO RÁPIDO: Via Table Editor do Supabase
-- ═══════════════════════════════════════════════════════════════════════════
-- 
-- Para cada tabela:
-- 1. Abra o banco de PRODUÇÃO → Table Editor
-- 2. Clique na tabela
-- 3. Selecione todas as linhas (Ctrl+A)
-- 4. Copie (Ctrl+C)
-- 5. Abra o banco de DESENVOLVIMENTO → Table Editor
-- 6. Clique na mesma tabela
-- 7. Cole (Ctrl+V)
-- 8. Confirme
--
-- ═══════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════
-- VERIFICAR APÓS COPIAR
-- ═══════════════════════════════════════════════════════════════════════════

-- Execute no DESENVOLVIMENTO para verificar:
SELECT 
    'administradores' as tabela, 
    COUNT(*) as registros,
    'Admin do sistema' as descricao
FROM administradores

UNION ALL

SELECT 
    'colaboradores', 
    COUNT(*),
    'Funcionários cadastrados'
FROM colaboradores

UNION ALL

SELECT 
    'contracheques', 
    COUNT(*),
    'Documentos enviados'
FROM contracheques

UNION ALL

SELECT 
    'recibos_documentos', 
    COUNT(*),
    'Recibos gerados'
FROM recibos_documentos

UNION ALL

SELECT 
    'unidades', 
    COUNT(*),
    'UPAs cadastradas'
FROM unidades

UNION ALL

SELECT 
    'statistics', 
    COUNT(*),
    'Estatísticas anuais'
FROM statistics;

-- ═══════════════════════════════════════════════════════════════════════════
-- Se os números estiverem iguais à produção: ✅ SUCESSO TOTAL!
-- ═══════════════════════════════════════════════════════════════════════════
