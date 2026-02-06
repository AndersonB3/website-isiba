-- ═══════════════════════════════════════════════════════════════════════════
-- GERAR INSERTS PARA COLABORADORES
-- Execute no banco de PRODUÇÃO
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    'INSERT INTO colaboradores (' ||
    'id, nome_completo, cpf, cpf_hash, senha_hash, email, ativo, ' ||
    'criado_em, atualizado_em, primeiro_acesso, codigo_funcionario' ||
    ') VALUES (' ||
    quote_literal(id::text) || '::uuid, ' ||
    quote_literal(nome_completo) || ', ' ||
    quote_literal(cpf) || ', ' ||
    quote_literal(cpf_hash) || ', ' ||
    quote_literal(senha_hash) || ', ' ||
    COALESCE(quote_literal(email), 'NULL') || ', ' ||
    ativo || ', ' ||
    quote_literal(criado_em::text) || '::timestamptz, ' ||
    quote_literal(atualizado_em::text) || '::timestamptz, ' ||
    primeiro_acesso || ', ' ||
    COALESCE(quote_literal(codigo_funcionario), 'NULL') ||
    ') ON CONFLICT (id) DO UPDATE SET ' ||
    'nome_completo = EXCLUDED.nome_completo, ' ||
    'cpf = EXCLUDED.cpf;'
FROM colaboradores
ORDER BY criado_em;

-- ═══════════════════════════════════════════════════════════════════════════
-- Copie TODO o resultado e execute no banco de DESENVOLVIMENTO
-- ═══════════════════════════════════════════════════════════════════════════
