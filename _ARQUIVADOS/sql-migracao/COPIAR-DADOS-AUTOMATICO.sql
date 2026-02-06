-- ═══════════════════════════════════════════════════════════════════════════
-- 🔴 SCRIPT PARA COPIAR OS DADOS - EXECUTE NO BANCO DE PRODUÇÃO
-- ═══════════════════════════════════════════════════════════════════════════
-- 
-- Execute DEPOIS de ter criado a estrutura no banco de desenvolvimento
--
-- INSTRUÇÕES:
-- 1. Execute o script GERAR-ESTRUTURA-COMPLETA.sql primeiro
-- 2. Aplique o resultado no banco de DESENVOLVIMENTO
-- 3. DEPOIS execute este script no banco de PRODUÇÃO
-- 4. Copie o resultado
-- 5. Execute no banco de DESENVOLVIMENTO
--
-- ═══════════════════════════════════════════════════════════════════════════

DO $$
DECLARE
    v_table_name TEXT;
    v_columns TEXT;
    v_insert_sql TEXT := '';
BEGIN
    -- Loop por todas as tabelas
    FOR v_table_name IN 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
          AND table_type = 'BASE TABLE'
        ORDER BY table_name
    LOOP
        -- Pegar lista de colunas
        SELECT string_agg(column_name, ', ')
        INTO v_columns
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = v_table_name
        ORDER BY ordinal_position;
        
        -- Gerar INSERT dinâmico
        v_insert_sql := v_insert_sql || 
            '-- Dados da tabela: ' || v_table_name || E'\n' ||
            'INSERT INTO ' || v_table_name || ' (' || v_columns || ')' || E'\n' ||
            'SELECT ' || v_columns || ' FROM ' || v_table_name || ' ON CONFLICT DO NOTHING;' || E'\n\n';
    END LOOP;
    
    RAISE NOTICE '%', v_insert_sql;
END $$;

-- ═══════════════════════════════════════════════════════════════════════════
-- NOTA: O script acima não funciona bem no Supabase SQL Editor
-- Use o script alternativo abaixo:
-- ═══════════════════════════════════════════════════════════════════════════

-- Listar todas as tabelas para copiar manualmente
SELECT 
    '-- ' || table_name as "Tabelas encontradas",
    'SELECT * FROM ' || table_name || ';' as "Query para visualizar"
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
