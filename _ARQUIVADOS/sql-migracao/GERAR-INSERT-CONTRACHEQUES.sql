-- ═══════════════════════════════════════════════════════════════════════════
-- GERAR INSERTS PARA CONTRACHEQUES
-- Execute no banco de PRODUÇÃO
-- ═══════════════════════════════════════════════════════════════════════════

SELECT 
    'INSERT INTO contracheques (' ||
    'id, colaborador_id, mes_referencia, ano, arquivo_url, nome_arquivo, ' ||
    'tamanho_arquivo, enviado_por, enviado_em, tipo_documento, visualizado, ' ||
    'data_primeira_visualizacao, recibo_gerado, assinatura_digital, mes, ' ||
    'data_envio, criado_em, atualizado_em' ||
    ') VALUES (' ||
    quote_literal(id::text) || '::uuid, ' ||
    COALESCE(quote_literal(colaborador_id::text), 'NULL') || '::uuid, ' ||
    quote_literal(mes_referencia) || ', ' ||
    ano || ', ' ||
    quote_literal(arquivo_url) || ', ' ||
    quote_literal(nome_arquivo) || ', ' ||
    tamanho_arquivo || ', ' ||
    COALESCE(quote_literal(enviado_por), '''admin.rh''') || ', ' ||
    quote_literal(enviado_em::text) || '::timestamptz, ' ||
    quote_literal(tipo_documento) || ', ' ||
    visualizado || ', ' ||
    COALESCE(quote_literal(data_primeira_visualizacao::text), 'NULL') || CASE WHEN data_primeira_visualizacao IS NOT NULL THEN '::timestamptz' ELSE '' END || ', ' ||
    recibo_gerado || ', ' ||
    COALESCE(quote_literal(assinatura_digital), 'NULL') || ', ' ||
    COALESCE(quote_literal(mes), 'NULL') || ', ' ||
    quote_literal(data_envio::text) || '::timestamptz, ' ||
    quote_literal(criado_em::text) || '::timestamptz, ' ||
    quote_literal(atualizado_em::text) || '::timestamptz' ||
    ') ON CONFLICT (id) DO NOTHING;'
FROM contracheques
ORDER BY criado_em;

-- ═══════════════════════════════════════════════════════════════════════════
-- Copie TODO o resultado e execute no banco de DESENVOLVIMENTO
-- ═══════════════════════════════════════════════════════════════════════════
