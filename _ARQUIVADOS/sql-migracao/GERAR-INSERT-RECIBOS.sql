-- ═══════════════════════════════════════════════════════════════════════════
-- GERAR INSERTS PARA RECIBOS
-- Execute no banco de PRODUÇÃO
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    'INSERT INTO recibos_documentos (' ||
    'id, documento_id, colaborador_id, tipo_documento, mes_referencia, ano, ' ||
    'nome_arquivo, data_visualizacao, data_recebimento, ip_address, user_agent, ' ||
    'assinatura_texto, assinatura_canvas, declaracao_aceite, texto_declaracao, ' ||
    'criado_em, atualizado_em' ||
    ') VALUES (' ||
    quote_literal(id::text) || '::uuid, ' ||
    quote_literal(documento_id::text) || '::uuid, ' ||
    quote_literal(colaborador_id::text) || '::uuid, ' ||
    quote_literal(tipo_documento) || ', ' ||
    COALESCE(quote_literal(mes_referencia), 'NULL') || ', ' ||
    ano || ', ' ||
    quote_literal(nome_arquivo) || ', ' ||
    COALESCE(quote_literal(data_visualizacao::text), 'NULL') || CASE WHEN data_visualizacao IS NOT NULL THEN '::timestamptz' ELSE '' END || ', ' ||
    COALESCE(quote_literal(data_recebimento::text), 'NULL') || CASE WHEN data_recebimento IS NOT NULL THEN '::timestamptz' ELSE '' END || ', ' ||
    COALESCE(quote_literal(ip_address), 'NULL') || ', ' ||
    COALESCE(quote_literal(user_agent), 'NULL') || ', ' ||
    COALESCE(quote_literal(assinatura_texto), 'NULL') || ', ' ||
    COALESCE(quote_literal(assinatura_canvas), 'NULL') || ', ' ||
    COALESCE(declaracao_aceite, true) || ', ' ||
    COALESCE(quote_literal(texto_declaracao), '''Declaro que recebi e tenho ciencia do documento disponibilizado.''') || ', ' ||
    quote_literal(criado_em::text) || '::timestamptz, ' ||
    quote_literal(atualizado_em::text) || '::timestamptz' ||
    ') ON CONFLICT (id) DO NOTHING;'
FROM recibos_documentos
ORDER BY criado_em;

-- ═══════════════════════════════════════════════════════════════════════════
-- Copie TODO o resultado e execute no banco de DESENVOLVIMENTO
-- ═══════════════════════════════════════════════════════════════════════════
