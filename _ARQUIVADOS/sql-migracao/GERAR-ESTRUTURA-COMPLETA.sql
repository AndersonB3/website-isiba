-- ═══════════════════════════════════════════════════════════════════════════
-- 🔴 SCRIPT MESTRE - EXECUTE NO BANCO DE PRODUÇÃO
-- ═══════════════════════════════════════════════════════════════════════════
-- 
-- Este é o script COMPLETO que gera TODA a estrutura do banco em um único lugar
--
-- INSTRUÇÕES:
-- 1. Abra o banco de PRODUÇÃO no Supabase
-- 2. Vá em: SQL Editor
-- 3. Cole e execute ESTE script completo
-- 4. Copie TODO o resultado (será um texto GIGANTE)
-- 5. Salve em um arquivo: ESTRUTURA-COMPLETA-PRODUCAO.sql
-- 6. Abra o banco de DESENVOLVIMENTO
-- 7. Execute o arquivo salvo
--
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n' ||
    '-- ESTRUTURA COMPLETA DO BANCO DE PRODUCAO' || E'\n' ||
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n\n' ||
    
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n' ||
    '-- PARTE 1: EXTENSÕES' || E'\n' ||
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n\n' ||
    
    'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";' || E'\n' ||
    'CREATE EXTENSION IF NOT EXISTS "pgcrypto";' || E'\n\n' ||
    
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n' ||
    '-- PARTE 2: TABELAS' || E'\n' ||
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n\n' ||
    
    (
        -- GERAR CREATE TABLE para cada tabela
        SELECT COALESCE(string_agg(
            '-- Tabela: ' || t.table_name || E'\n' ||
            'DROP TABLE IF EXISTS ' || t.table_name || ' CASCADE;' || E'\n' ||
            'CREATE TABLE ' || t.table_name || ' (' || E'\n' ||
            (
                SELECT string_agg(
                    '    ' || c.column_name || ' ' || 
                    CASE 
                        WHEN c.data_type = 'character varying' THEN 'VARCHAR' || COALESCE('(' || c.character_maximum_length || ')', '')
                        WHEN c.data_type = 'character' THEN 'CHAR' || COALESCE('(' || c.character_maximum_length || ')', '')
                        WHEN c.data_type = 'timestamp without time zone' THEN 'TIMESTAMP'
                        WHEN c.data_type = 'timestamp with time zone' THEN 'TIMESTAMP WITH TIME ZONE'
                        WHEN c.data_type = 'USER-DEFINED' THEN (SELECT typname FROM pg_type WHERE oid = (c.udt_schema || '.' || c.udt_name)::regtype)
                        ELSE UPPER(c.data_type)
                    END ||
                    CASE 
                        WHEN c.is_nullable = 'NO' THEN ' NOT NULL'
                        ELSE ''
                    END ||
                    CASE 
                        WHEN c.column_default IS NOT NULL THEN ' DEFAULT ' || c.column_default
                        ELSE ''
                    END,
                    ',' || E'\n'
                ORDER BY c.ordinal_position)
                FROM information_schema.columns c
                WHERE c.table_schema = 'public'
                  AND c.table_name = t.table_name
            ) || E'\n' ||
            ');' || E'\n\n',
            ''
        ORDER BY t.table_name), 'Nenhuma tabela encontrada.')
        FROM information_schema.tables t
        WHERE t.table_schema = 'public'
          AND t.table_type = 'BASE TABLE'
    ) ||
    
    E'\n' ||
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n' ||
    '-- PARTE 3: PRIMARY KEYS' || E'\n' ||
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n\n' ||
    
    (
        SELECT COALESCE(string_agg(
            'ALTER TABLE ' || tc.table_name || 
            ' ADD CONSTRAINT ' || tc.constraint_name || 
            ' PRIMARY KEY (' || string_agg(kcu.column_name, ', ') || ');',
            E'\n'
        ), 'Nenhuma PK encontrada.')
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu 
            ON tc.constraint_name = kcu.constraint_name 
            AND tc.table_schema = kcu.table_schema
        WHERE tc.constraint_type = 'PRIMARY KEY'
          AND tc.table_schema = 'public'
        GROUP BY tc.table_name, tc.constraint_name
    ) ||
    
    E'\n\n' ||
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n' ||
    '-- PARTE 4: FOREIGN KEYS' || E'\n' ||
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n\n' ||
    
    (
        SELECT COALESCE(string_agg(
            'ALTER TABLE ' || tc.table_name || 
            ' ADD CONSTRAINT ' || tc.constraint_name || 
            ' FOREIGN KEY (' || kcu.column_name || ')' ||
            ' REFERENCES ' || ccu.table_name || '(' || ccu.column_name || ')' ||
            CASE 
                WHEN rc.delete_rule = 'CASCADE' THEN ' ON DELETE CASCADE'
                WHEN rc.delete_rule = 'SET NULL' THEN ' ON DELETE SET NULL'
                ELSE ''
            END || ';',
            E'\n'
        ), 'Nenhuma FK encontrada.')
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu 
            ON tc.constraint_name = kcu.constraint_name
        JOIN information_schema.constraint_column_usage ccu 
            ON ccu.constraint_name = tc.constraint_name
        JOIN information_schema.referential_constraints rc
            ON rc.constraint_name = tc.constraint_name
        WHERE tc.constraint_type = 'FOREIGN KEY'
          AND tc.table_schema = 'public'
    ) ||
    
    E'\n\n' ||
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n' ||
    '-- PARTE 5: ÍNDICES' || E'\n' ||
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n\n' ||
    
    (
        SELECT COALESCE(string_agg(
            indexdef || ';',
            E'\n'
        ), 'Nenhum índice encontrado.')
        FROM pg_indexes
        WHERE schemaname = 'public'
          AND indexname NOT LIKE '%_pkey'
    ) ||
    
    E'\n\n' ||
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n' ||
    '-- PARTE 6: FUNÇÕES E TRIGGERS' || E'\n' ||
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n\n' ||
    
    (
        SELECT COALESCE(string_agg(
            pg_get_functiondef(p.oid) || ';',
            E'\n\n'
        ), 'Nenhuma função encontrada.')
        FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        WHERE n.nspname = 'public'
          AND p.prokind = 'f'
    ) ||
    
    E'\n\n' ||
    
    (
        SELECT COALESCE(string_agg(
            'CREATE TRIGGER ' || t.tgname || E'\n' ||
            '    ' || CASE 
                WHEN t.tgtype & 2 = 2 THEN 'BEFORE'
                WHEN t.tgtype & 64 = 64 THEN 'INSTEAD OF'
                ELSE 'AFTER'
            END || ' ' ||
            CASE 
                WHEN t.tgtype & 4 = 4 THEN 'INSERT'
                WHEN t.tgtype & 8 = 8 THEN 'DELETE'
                WHEN t.tgtype & 16 = 16 THEN 'UPDATE'
                ELSE 'UNKNOWN'
            END || E'\n' ||
            '    ON ' || c.relname || E'\n' ||
            '    FOR EACH ROW' || E'\n' ||
            '    EXECUTE FUNCTION ' || p.proname || '();',
            E'\n\n'
        ), 'Nenhum trigger encontrado.')
        FROM pg_trigger t
        JOIN pg_class c ON t.tgrelid = c.oid
        JOIN pg_proc p ON t.tgfoid = p.oid
        JOIN pg_namespace n ON c.relnamespace = n.oid
        WHERE n.nspname = 'public'
          AND NOT t.tgisinternal
    ) ||
    
    E'\n\n' ||
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n' ||
    '-- PARTE 7: ROW LEVEL SECURITY (RLS)' || E'\n' ||
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n\n' ||
    
    (
        SELECT COALESCE(string_agg(
            'ALTER TABLE ' || tablename || ' ENABLE ROW LEVEL SECURITY;',
            E'\n'
        ), 'Nenhuma tabela com RLS encontrada.')
        FROM pg_tables
        WHERE schemaname = 'public'
          AND rowsecurity = true
    ) ||
    
    E'\n\n' ||
    
    (
        SELECT COALESCE(string_agg(
            'CREATE POLICY ' || pol.polname || 
            ' ON ' || c.relname || E'\n' ||
            '    FOR ' || CASE pol.polcmd
                WHEN 'r' THEN 'SELECT'
                WHEN 'a' THEN 'INSERT'
                WHEN 'w' THEN 'UPDATE'
                WHEN 'd' THEN 'DELETE'
                ELSE 'ALL'
            END || E'\n' ||
            '    USING (' || pg_get_expr(pol.polqual, pol.polrelid) || ')' ||
            CASE 
                WHEN pol.polwithcheck IS NOT NULL THEN E'\n    WITH CHECK (' || pg_get_expr(pol.polwithcheck, pol.polrelid) || ')'
                ELSE ''
            END || ';',
            E'\n\n'
        ), 'Nenhuma política RLS encontrada.')
        FROM pg_policy pol
        JOIN pg_class c ON pol.polrelid = c.oid
        JOIN pg_namespace n ON c.relnamespace = n.oid
        WHERE n.nspname = 'public'
    ) ||
    
    E'\n\n' ||
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n' ||
    '-- FIM DA ESTRUTURA' || E'\n' ||
    '-- ════════════════════════════════════════════════════════════════════════════════' || E'\n'
    
AS script_completo;

-- ═══════════════════════════════════════════════════════════════════════════
-- RESULTADO:
-- Um script SQL GIGANTE com TUDO: tabelas, índices, FKs, triggers, RLS, etc.
-- ═══════════════════════════════════════════════════════════════════════════
