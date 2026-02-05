-- ═══════════════════════════════════════════════════════════════════════════
-- 🔴 EXECUTE NO BANCO DE PRODUÇÃO - PARTE 1: GERAR SCRIPT DE CLONAGEM
-- ═══════════════════════════════════════════════════════════════════════════
-- 
-- Este script analisa TODA a estrutura do banco de produção e gera um script
-- completo para recriar tudo no banco de desenvolvimento.
--
-- INSTRUÇÕES:
-- 1. Execute este script no banco de PRODUÇÃO
-- 2. Copie TODO o resultado
-- 3. Salve em: ESTRUTURA-PRODUCAO-COMPLETA.sql
-- 4. Execute no banco de DESENVOLVIMENTO
--
-- ═══════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 1: GERAR SCRIPT DE CRIAÇÃO DE TABELAS
-- ═══════════════════════════════════════════════════════════════════════════

SELECT string_agg(
    '-- Tabela: ' || table_name || E'\n' ||
    'CREATE TABLE IF NOT EXISTS ' || table_name || ' (' || E'\n' ||
    (
        SELECT string_agg(
            '    ' || column_name || ' ' || 
            data_type || 
            CASE 
                WHEN character_maximum_length IS NOT NULL THEN '(' || character_maximum_length || ')'
                WHEN data_type = 'numeric' AND numeric_precision IS NOT NULL THEN '(' || numeric_precision || ',' || numeric_scale || ')'
                ELSE ''
            END ||
            CASE 
                WHEN is_nullable = 'NO' THEN ' NOT NULL'
                ELSE ''
            END ||
            CASE 
                WHEN column_default IS NOT NULL THEN ' DEFAULT ' || column_default
                ELSE ''
            END,
            ',' || E'\n'
        ORDER BY ordinal_position)
        FROM information_schema.columns
        WHERE columns.table_name = tables.table_name
          AND columns.table_schema = 'public'
    ) || E'\n' ||
    ');' || E'\n',
    E'\n\n'
ORDER BY table_name)
FROM information_schema.tables tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE';

-- ═══════════════════════════════════════════════════════════════════════════
-- RESULTADO:
-- Você verá todas as definições CREATE TABLE
-- Copie este resultado e guarde, vamos adicionar mais partes!
-- ═══════════════════════════════════════════════════════════════════════════
