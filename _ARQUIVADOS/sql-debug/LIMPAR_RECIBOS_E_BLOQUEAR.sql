-- ════════════════════════════════════════════════════════════════
-- 🔥 LIMPAR RECIBOS ANTIGOS E BLOQUEAR DOCUMENTOS
-- ════════════════════════════════════════════════════════════════
-- Este é o problema: existem recibos antigos na tabela que estão
-- fazendo o sistema liberar o download mesmo com recibo_gerado=false
-- ════════════════════════════════════════════════════════════════

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 1: VERIFICAR QUANTOS RECIBOS EXISTEM
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    COUNT(*) as total_recibos,
    COUNT(DISTINCT documento_id) as documentos_com_recibo,
    COUNT(DISTINCT colaborador_id) as colaboradores_com_recibo
FROM recibos_documentos;

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 2: VER DETALHES DOS RECIBOS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    rd.id,
    rd.colaborador_id,
    col.nome_completo,
    rd.documento_id,
    c.mes_referencia,
    c.ano,
    c.recibo_gerado,
    rd.data_recebimento,
    rd.assinatura_canvas IS NOT NULL as tem_assinatura_canvas,
    c.assinatura_digital IS NOT NULL as tem_assinatura_digital
FROM recibos_documentos rd
LEFT JOIN colaboradores col ON rd.colaborador_id = col.id
LEFT JOIN contracheques c ON rd.documento_id = c.id
ORDER BY rd.data_recebimento DESC;

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 3: ⚠️ DELETAR TODOS OS RECIBOS ANTIGOS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- ATENÇÃO: Isso apagará TODOS os recibos!
-- Execute apenas se tem certeza!

DELETE FROM recibos_documentos;

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 4: VERIFICAR SE TODOS FORAM DELETADOS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT COUNT(*) as recibos_restantes FROM recibos_documentos;
-- Resultado esperado: 0

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 5: BLOQUEAR TODOS OS DOCUMENTOS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

UPDATE contracheques 
SET 
    recibo_gerado = false,
    visualizado = false,
    data_primeira_visualizacao = NULL
WHERE recibo_gerado IS NOT NULL;

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 6: VERIFICAR ESTADO FINAL
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    'contracheques' as tabela,
    COUNT(*) as total,
    SUM(CASE WHEN recibo_gerado = false THEN 1 ELSE 0 END) as bloqueados,
    SUM(CASE WHEN recibo_gerado = true THEN 1 ELSE 0 END) as liberados
FROM contracheques

UNION ALL

SELECT 
    'recibos_documentos' as tabela,
    COUNT(*) as total,
    0 as bloqueados,
    0 as liberados
FROM recibos_documentos;

-- Resultado esperado:
-- contracheques: total=X, bloqueados=X, liberados=0
-- recibos_documentos: total=0

-- ════════════════════════════════════════════════════════════════
-- ✅ SCRIPT CONCLUÍDO
-- ════════════════════════════════════════════════════════════════
-- 
-- O que foi feito:
-- 1. ✅ Deletou TODOS os recibos antigos da tabela recibos_documentos
-- 2. ✅ Bloqueou TODOS os documentos (recibo_gerado = false)
-- 3. ✅ Resetou visualizações
-- 
-- Agora teste:
-- 1. Limpe o cache: Ctrl + Shift + R
-- 2. Faça login no portal
-- 3. Clique no documento bloqueado
-- 4. DEVE aparecer o modal de assinatura
-- 5. Assine e confirme
-- 6. Documento será liberado
-- 
-- ════════════════════════════════════════════════════════════════
