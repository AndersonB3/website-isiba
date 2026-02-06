-- ═══════════════════════════════════════════════════════════════════════════
-- 🔴 EXECUTE ESTE SCRIPT NO BANCO DE PRODUÇÃO
-- ═══════════════════════════════════════════════════════════════════════════
-- 
-- Este script gera automaticamente todos os INSERTs necessários para
-- copiar os dados de produção para desenvolvimento.
--
-- INSTRUÇÕES:
-- 1. Acesse o projeto de PRODUÇÃO no Supabase
-- 2. Vá em: SQL Editor
-- 3. Cole e execute TODO este script
-- 4. COPIE todo o resultado (pode ser grande)
-- 5. Salve em: DADOS-PRODUCAO-EXPORT.sql
-- 6. Execute o arquivo no banco de DESENVOLVIMENTO
--
-- ═══════════════════════════════════════════════════════════════════════════

-- Gerar script completo de exportação
SELECT string_agg(sql, E'\n\n' ORDER BY ordem)
FROM (
    -- 1. COLABORADORES (primeiro, pois outros dependem)
    SELECT 
        1 as ordem,
        'INSERT INTO colaboradores (id, nome, codigo, cpf, email, senha_hash, status, primeiro_acesso, criado_em, atualizado_em) VALUES (' ||
        quote_literal(id::text) || '::uuid, ' ||
        quote_literal(nome) || ', ' ||
        quote_literal(codigo) || ', ' ||
        quote_literal(cpf) || ', ' ||
        COALESCE(quote_literal(email), 'NULL') || ', ' ||
        quote_literal(senha_hash) || ', ' ||
        quote_literal(status) || ', ' ||
        primeiro_acesso || ', ' ||
        quote_literal(criado_em::text) || '::timestamp, ' ||
        quote_literal(atualizado_em::text) || '::timestamp' ||
        ') ON CONFLICT (cpf) DO UPDATE SET ' ||
        'nome = EXCLUDED.nome, ' ||
        'codigo = EXCLUDED.codigo, ' ||
        'email = EXCLUDED.email, ' ||
        'senha_hash = EXCLUDED.senha_hash, ' ||
        'status = EXCLUDED.status, ' ||
        'primeiro_acesso = EXCLUDED.primeiro_acesso;' as sql
    FROM colaboradores
    
    UNION ALL
    
    -- 2. CONTRACHEQUES (dependem de colaboradores)
    SELECT 
        2 as ordem,
        'INSERT INTO contracheques (id, colaborador_id, tipo_documento, mes, ano, arquivo_url, tamanho_bytes, bloqueado, data_envio, recibo_gerado, criado_em, atualizado_em) VALUES (' ||
        quote_literal(id::text) || '::uuid, ' ||
        quote_literal(colaborador_id::text) || '::uuid, ' ||
        quote_literal(tipo_documento) || ', ' ||
        COALESCE(quote_literal(mes), 'NULL') || ', ' ||
        ano || ', ' ||
        quote_literal(arquivo_url) || ', ' ||
        COALESCE(tamanho_bytes::text, 'NULL') || ', ' ||
        COALESCE(bloqueado, false) || ', ' ||
        quote_literal(data_envio::text) || '::timestamp, ' ||
        recibo_gerado || ', ' ||
        quote_literal(criado_em::text) || '::timestamp, ' ||
        quote_literal(atualizado_em::text) || '::timestamp' ||
        ') ON CONFLICT DO NOTHING;'
    FROM contracheques
    
    UNION ALL
    
    -- 3. RECIBOS (dependem de contracheques e colaboradores)
    SELECT 
        3 as ordem,
        'INSERT INTO recibos_documentos (id, contracheque_id, colaborador_id, tipo_documento, mes, ano, data_recebimento, ip_address, user_agent, assinatura_digital, criado_em) VALUES (' ||
        quote_literal(id::text) || '::uuid, ' ||
        quote_literal(contracheque_id::text) || '::uuid, ' ||
        quote_literal(colaborador_id::text) || '::uuid, ' ||
        quote_literal(tipo_documento) || ', ' ||
        COALESCE(quote_literal(mes), 'NULL') || ', ' ||
        ano || ', ' ||
        quote_literal(data_recebimento::text) || '::timestamp, ' ||
        COALESCE(quote_literal(ip_address), 'NULL') || ', ' ||
        COALESCE(quote_literal(user_agent), 'NULL') || ', ' ||
        COALESCE(quote_literal(assinatura_digital), 'NULL') || ', ' ||
        quote_literal(criado_em::text) || '::timestamp' ||
        ') ON CONFLICT DO NOTHING;'
    FROM recibos_documentos
    
    UNION ALL
    
    -- 4. ADMIN RH (independente)
    SELECT 
        4 as ordem,
        'INSERT INTO admin_rh (id, usuario, senha_hash, nome_completo, email, ativo, criado_em, atualizado_em) VALUES (' ||
        quote_literal(id::text) || '::uuid, ' ||
        quote_literal(usuario) || ', ' ||
        quote_literal(senha_hash) || ', ' ||
        COALESCE(quote_literal(nome_completo), 'NULL') || ', ' ||
        COALESCE(quote_literal(email), 'NULL') || ', ' ||
        ativo || ', ' ||
        quote_literal(criado_em::text) || '::timestamp, ' ||
        quote_literal(atualizado_em::text) || '::timestamp' ||
        ') ON CONFLICT (usuario) DO UPDATE SET ' ||
        'senha_hash = EXCLUDED.senha_hash, ' ||
        'nome_completo = EXCLUDED.nome_completo, ' ||
        'email = EXCLUDED.email, ' ||
        'ativo = EXCLUDED.ativo;'
    FROM admin_rh
) exports;

-- ═══════════════════════════════════════════════════════════════════════════
-- RESULTADO:
-- Você verá UMA ÚNICA célula com MUITO texto (todos os INSERTs)
-- 
-- PRÓXIMO PASSO:
-- 1. Clique na célula do resultado
-- 2. Copie TODO o texto (Ctrl+A, Ctrl+C)
-- 3. Cole em um arquivo de texto: DADOS-PRODUCAO-EXPORT.sql
-- 4. Abra o projeto de DESENVOLVIMENTO no Supabase
-- 5. Vá em SQL Editor
-- 6. Cole e execute o arquivo DADOS-PRODUCAO-EXPORT.sql
-- 7. ✅ Pronto! Dados copiados com sucesso!
-- ═══════════════════════════════════════════════════════════════════════════
