-- ════════════════════════════════════════════════════════════════
-- 🔍 DEBUG - VERIFICAR ASSINATURA NA VIEW
-- ════════════════════════════════════════════════════════════════

-- 1️⃣ VER TODOS OS CAMPOS DA VIEW


-- 📋 PROCURAR POR:
-- - assinatura_canvas ✅
-- - assinatura_digital
-- - assinatura_texto ✅


-- 2️⃣ VER DADOS REAIS DO RECIBO ESPECÍFICO
SELECT 
    recibo_id,
    nome_completo,
    assinatura_texto,
    assinatura_canvas,
    assinatura_digital,
    CASE 
        WHEN assinatura_canvas IS NOT NULL THEN 'TEM CANVAS ✅'
        ELSE 'SEM CANVAS ❌'
    END as status_canvas,
    CASE 
        WHEN assinatura_digital IS NOT NULL THEN 'TEM DIGITAL ✅'
        ELSE 'SEM DIGITAL ❌'
    END as status_digital,
    LEFT(assinatura_canvas, 50) as preview_canvas,
    data_recebimento
FROM view_recibos_completos
WHERE recibo_id = 'd5fa52d4-9dd7-46c2-bf8e-f17ebd4f7bc3';  -- ← ID do console


-- 3️⃣ SE NÃO MOSTRAR O CAMPO, BUSCAR DIRETO NA TABELA
SELECT 
    id,
    documento_id,
    assinatura_texto,
    assinatura_canvas IS NOT NULL as tem_canvas,
    LEFT(assinatura_canvas, 50) as preview,
    criado_em
FROM recibos_documentos
WHERE id = 'd5fa52d4-9dd7-46c2-bf8e-f17ebd4f7bc3';


-- 4️⃣ VERIFICAR SE A VIEW ESTÁ CORRETA
-- (Se os passos anteriores mostrarem que a tabela TEM assinatura_canvas,
--  mas a view NÃO retorna, então precisamos recriar a view)

-- ✅ RESULTADO ESPERADO:
-- Passo 1: Deve listar "assinatura_canvas" entre as colunas
-- Passo 2: Deve mostrar "TEM CANVAS ✅" e preview começando com "data:image/png"
-- Passo 3: Deve mostrar "tem_canvas: true" e preview


-- 🚨 SE A VIEW NÃO TIVER O CAMPO, EXECUTE ESTE FIX:

DROP VIEW IF EXISTS view_recibos_completos CASCADE;

CREATE OR REPLACE VIEW view_recibos_completos AS
SELECT 
    -- Dados do Recibo
    r.id as recibo_id,
    r.colaborador_id,
    r.documento_id,
    r.tipo_documento,
    r.assinatura_texto,
    r.assinatura_canvas,          -- ← CAMPO CRÍTICO!
    r.declaracao_aceite,
    r.data_recebimento,
    r.ip_address,
    r.criado_em,
    
    -- Dados do Colaborador
    c.nome_completo,
    c.cpf,
    c.email,
    
    -- Dados do Documento (Contracheques)
    ct.mes_referencia,
    ct.ano,
    ct.nome_arquivo,
    ct.enviado_em,
    ct.enviado_por,
    ct.data_primeira_visualizacao as data_visualizacao,
    ct.assinatura_digital         -- ← CAMPO SECUNDÁRIO

FROM recibos_documentos r
JOIN colaboradores c ON r.colaborador_id = c.id
LEFT JOIN contracheques ct ON r.documento_id = ct.id AND r.tipo_documento = 'contracheque'
LEFT JOIN informes_ir ir ON r.documento_id = ir.id AND r.tipo_documento = 'informe_ir';


-- 5️⃣ APÓS RECRIAR A VIEW, TESTAR NOVAMENTE:
SELECT 
    recibo_id,
    nome_completo,
    assinatura_canvas IS NOT NULL as tem_canvas,
    LEFT(assinatura_canvas, 50) as preview
FROM view_recibos_completos
WHERE recibo_id = 'd5fa52d4-9dd7-46c2-bf8e-f17ebd4f7bc3';

-- ✅ DEVE RETORNAR: tem_canvas = true

-- 📝 NOTAS:
-- - Execute passo 1 primeiro para ver se o campo existe
-- - Se não existir, execute o DROP VIEW e CREATE VIEW
-- - Depois execute passo 5 para confirmar
