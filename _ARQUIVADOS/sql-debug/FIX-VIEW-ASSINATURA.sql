-- ════════════════════════════════════════════════════════════════
-- 🔥 FIX DEFINITIVO - RECRIAR VIEW COM ASSINATURA_CANVAS
-- ════════════════════════════════════════════════════════════════

-- 1️⃣ REMOVER VIEW ANTIGA
DROP VIEW IF EXISTS view_recibos_completos CASCADE;

-- 2️⃣ CRIAR VIEW NOVA COM TODOS OS CAMPOS
CREATE OR REPLACE VIEW view_recibos_completos AS
SELECT 
    -- ========================================
    -- DADOS DO RECIBO (tabela recibos_documentos)
    -- ========================================
    r.id as recibo_id,
    r.colaborador_id,
    r.documento_id,
    r.tipo_documento,
    r.assinatura_texto,
    r.assinatura_canvas,          -- ← CAMPO CRÍTICO QUE ESTAVA FALTANDO!
    r.declaracao_aceite,
    r.data_recebimento,
    r.ip_address,
    r.criado_em,
    
    -- ========================================
    -- DADOS DO COLABORADOR (tabela colaboradores)
    -- ========================================
    c.nome_completo,
    c.cpf,
    c.email,
    
    -- ========================================
    -- DADOS DO DOCUMENTO CONTRACHEQUE
    -- ========================================
    ct.mes_referencia,
    ct.ano,
    ct.nome_arquivo,
    ct.enviado_em,
    ct.enviado_por,
    ct.data_primeira_visualizacao as data_visualizacao,
    ct.assinatura_digital,        -- ← Campo secundário (também importante)
    ct.arquivo_url,
    ct.tamanho_arquivo

FROM recibos_documentos r
JOIN colaboradores c ON r.colaborador_id = c.id
LEFT JOIN contracheques ct ON r.documento_id = ct.id AND r.tipo_documento = 'contracheque'
LEFT JOIN informes_ir ir ON r.documento_id = ir.id AND r.tipo_documento = 'informe_ir';

-- 3️⃣ VERIFICAR SE FUNCIONOU
SELECT 
    recibo_id,
    nome_completo,
    assinatura_texto,
    assinatura_canvas IS NOT NULL as tem_assinatura,
    LEFT(assinatura_canvas, 50) as preview,
    data_recebimento
FROM view_recibos_completos
ORDER BY criado_em DESC
LIMIT 5;

-- ✅ RESULTADO ESPERADO:
-- tem_assinatura: true
-- preview: data:image/png;base64,iVBORw0K...

-- 📝 SE DER ERRO, VERIFIQUE:
-- - Se as tabelas recibos_documentos, colaboradores e contracheques existem
-- - Se os campos existem nessas tabelas

-- ✅ PRONTO! 
-- Agora volte ao painel RH, limpe o cache (Ctrl+Shift+R) e teste!
