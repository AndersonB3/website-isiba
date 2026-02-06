-- ═══════════════════════════════════════════════════════════════════════════
-- SCRIPT: COMPARAR BANCOS DE DADOS (PRODUÇÃO vs DESENVOLVIMENTO)
-- Execute este script em cada banco para comparar a estrutura
-- ═══════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 1: LISTAR TODAS AS TABELAS
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    schemaname AS schema,
    tablename AS tabela,
    'TABLE' AS tipo
FROM pg_tables 
WHERE schemaname = 'public'
ORDER BY tablename;

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 2: LISTAR TODAS AS COLUNAS DE CADA TABELA
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    table_name AS tabela,
    column_name AS coluna,
    data_type AS tipo_dados,
    is_nullable AS permite_null,
    column_default AS valor_padrao
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 3: LISTAR TODAS AS CHAVES PRIMÁRIAS
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    tc.table_name AS tabela,
    kcu.column_name AS coluna_pk
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'PRIMARY KEY'
    AND tc.table_schema = 'public'
ORDER BY tc.table_name;

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 4: LISTAR TODAS AS CHAVES ESTRANGEIRAS
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    tc.table_name AS tabela,
    kcu.column_name AS coluna,
    ccu.table_name AS tabela_referenciada,
    ccu.column_name AS coluna_referenciada
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage ccu 
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_schema = 'public'
ORDER BY tc.table_name;

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 5: LISTAR TODAS AS POLÍTICAS RLS
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    schemaname AS schema,
    tablename AS tabela,
    policyname AS politica,
    permissive AS permissivo,
    roles AS funcoes,
    cmd AS comando,
    qual AS condicao_using,
    with_check AS condicao_check
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 6: VERIFICAR RLS HABILITADO
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    schemaname AS schema,
    tablename AS tabela,
    rowsecurity AS rls_habilitado
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 7: CONTAR REGISTROS EM CADA TABELA
-- ═══════════════════════════════════════════════════════════════════════════

-- administradores
SELECT 'administradores' AS tabela, COUNT(*) AS total_registros FROM administradores
UNION ALL
-- colaboradores
SELECT 'colaboradores', COUNT(*) FROM colaboradores
UNION ALL
-- contracheques
SELECT 'contracheques', COUNT(*) FROM contracheques
UNION ALL
-- dados_mensais
SELECT 'dados_mensais', COUNT(*) FROM dados_mensais
UNION ALL
-- faixa_etaria
SELECT 'faixa_etaria', COUNT(*) FROM faixa_etaria
UNION ALL
-- recibos_documentos
SELECT 'recibos_documentos', COUNT(*) FROM recibos_documentos
UNION ALL
-- resumo_anual
SELECT 'resumo_anual', COUNT(*) FROM resumo_anual
UNION ALL
-- statistics
SELECT 'statistics', COUNT(*) FROM statistics
UNION ALL
-- tempo_atendimento
SELECT 'tempo_atendimento', COUNT(*) FROM tempo_atendimento
UNION ALL
-- unidades
SELECT 'unidades', COUNT(*) FROM unidades
ORDER BY tabela;

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 8: LISTAR BUCKETS DE STORAGE
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    id,
    name AS bucket_name,
    public AS publico,
    created_at AS criado_em
FROM storage.buckets
ORDER BY name;

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 9: LISTAR POLÍTICAS DE STORAGE
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    name AS nome_politica,
    bucket_id,
    definition AS definicao
FROM storage.policies
ORDER BY bucket_id, name;

-- ═══════════════════════════════════════════════════════════════════════════
-- ✅ INSTRUÇÕES DE USO:
-- ═══════════════════════════════════════════════════════════════════════════
-- 
-- 1. Execute este script no banco de PRODUÇÃO (kklhcmrnraroletwbbid)
-- 2. Salve os resultados em um arquivo: resultados-producao.txt
-- 
-- 3. Execute o mesmo script no banco de DESENVOLVIMENTO (ikwnemhqqkpjurdpauim)
-- 4. Salve os resultados em: resultados-desenvolvimento.txt
-- 
-- 5. Compare os dois arquivos lado a lado
-- 
-- DIFERENÇAS ESPERADAS (OK):
-- - Total de registros diferente (desenvolvimento tem dados de teste)
-- - Dados específicos diferentes (CPFs, nomes, etc)
-- 
-- DEVE SER IGUAL:
-- - Número de tabelas
-- - Estrutura das tabelas (colunas, tipos)
-- - Chaves primárias e estrangeiras
-- - Políticas RLS
-- - RLS habilitado nas mesmas tabelas
-- - Buckets de storage
-- - Políticas de storage
-- 
-- ═══════════════════════════════════════════════════════════════════════════
