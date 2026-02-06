-- ════════════════════════════════════════════════════════════════
-- 🔍 VERIFICAR VIEW RECIBOS_COMPLETOS
-- ════════════════════════════════════════════════════════════════
-- Execute este script para verificar se a view está completa

-- 1️⃣ VER ESTRUTURA DA VIEW
SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name = 'view_recibos_completos'
ORDER BY ordinal_position;

-- ✅ Deve incluir:
-- - assinatura_canvas (da tabela recibos_documentos)
-- - assinatura_digital (da tabela contracheques)
-- - assinatura_texto
-- - declaracao_aceite
-- - data_recebimento


-- 2️⃣ TESTAR VIEW COM DADOS REAIS
SELECT 
    recibo_id,
    nome_completo,
    tipo_documento,
    mes_referencia,
    ano,
    assinatura_texto,
    CASE 
        WHEN assinatura_canvas IS NOT NULL THEN 'TEM ASSINATURA ✅'
        ELSE 'SEM ASSINATURA ❌'
    END as status_assinatura,
    LEFT(assinatura_canvas, 50) as preview_assinatura,
    data_recebimento,
    criado_em
FROM view_recibos_completos
ORDER BY criado_em DESC
LIMIT 5;


-- 3️⃣ SE A VIEW NÃO TIVER O CAMPO, RECRIE:
-- (APENAS SE NECESSÁRIO)

DROP VIEW IF EXISTS view_recibos_completos;

CREATE OR REPLACE VIEW view_recibos_completos AS
SELECT 
    -- Dados do Recibo
    r.id as recibo_id,
    r.colaborador_id,
    r.documento_id,
    r.tipo_documento,
    r.assinatura_texto,
    r.assinatura_canvas,          -- ← ASSINATURA DIGITAL (CANVAS)
    r.declaracao_aceite,
    r.data_recebimento,
    r.ip_address,
    r.criado_em,
    
    -- Dados do Colaborador
    c.nome_completo,
    c.cpf,
    c.email,
    
    -- Dados do Documento
    CASE 
        WHEN r.tipo_documento = 'contracheque' THEN ct.mes_referencia
        ELSE NULL
    END as mes_referencia,
    
    CASE 
        WHEN r.tipo_documento = 'contracheque' THEN ct.ano
        WHEN r.tipo_documento = 'informe_ir' THEN ir.ano
        ELSE NULL
    END as ano,
    
    CASE 
        WHEN r.tipo_documento = 'contracheque' THEN ct.nome_arquivo
        WHEN r.tipo_documento = 'informe_ir' THEN ir.nome_arquivo
        ELSE NULL
    END as nome_arquivo,
    
    CASE 
        WHEN r.tipo_documento = 'contracheque' THEN ct.enviado_em
        WHEN r.tipo_documento = 'informe_ir' THEN ir.enviado_em
        ELSE NULL
    END as enviado_em,
    
    CASE 
        WHEN r.tipo_documento = 'contracheque' THEN ct.enviado_por
        WHEN r.tipo_documento = 'informe_ir' THEN ir.enviado_por
        ELSE NULL
    END as enviado_por,
    
    CASE 
        WHEN r.tipo_documento = 'contracheque' THEN ct.data_primeira_visualizacao
        WHEN r.tipo_documento = 'informe_ir' THEN ir.data_visualizacao
        ELSE NULL
    END as data_visualizacao,
    
    -- Assinatura Digital dos Contracheques (nova coluna)
    ct.assinatura_digital         -- ← ASSINATURA SALVA EM CONTRACHEQUES

FROM recibos_documentos r
JOIN colaboradores c ON r.colaborador_id = c.id
LEFT JOIN contracheques ct ON r.documento_id = ct.id AND r.tipo_documento = 'contracheque'
LEFT JOIN informes_ir ir ON r.documento_id = ir.id AND r.tipo_documento = 'informe_ir';


-- 4️⃣ VERIFICAR SE FUNCIONOU
SELECT 
    recibo_id,
    nome_completo,
    assinatura_texto,
    CASE 
        WHEN assinatura_canvas IS NOT NULL THEN '✅ TEM'
        ELSE '❌ SEM'
    END as tem_assinatura_canvas,
    CASE 
        WHEN assinatura_digital IS NOT NULL THEN '✅ TEM'
        ELSE '❌ SEM'
    END as tem_assinatura_digital,
    data_recebimento
FROM view_recibos_completos
ORDER BY criado_em DESC
LIMIT 5;


-- ✅ RESULTADO ESPERADO:
-- tem_assinatura_canvas: ✅ TEM
-- tem_assinatura_digital: ✅ TEM (se for contracheque recente)


-- 5️⃣ SE NÃO APARECER ASSINATURA, VERIFICAR DADOS:
SELECT 
    r.id as recibo_id,
    r.assinatura_canvas IS NOT NULL as recibo_tem_assinatura,
    c.assinatura_digital IS NOT NULL as contracheque_tem_assinatura,
    r.criado_em
FROM recibos_documentos r
LEFT JOIN contracheques c ON r.documento_id = c.id
WHERE r.tipo_documento = 'contracheque'
ORDER BY r.criado_em DESC
LIMIT 5;


-- 📋 NOTAS:
-- - assinatura_canvas: Vem da tabela recibos_documentos
-- - assinatura_digital: Vem da tabela contracheques
-- - Ambos devem estar na view_recibos_completos
-- - Se faltando, execute a criação da view acima (passo 3)

-- ✅ PRONTO!
-- Após executar, teste novamente no painel RH
