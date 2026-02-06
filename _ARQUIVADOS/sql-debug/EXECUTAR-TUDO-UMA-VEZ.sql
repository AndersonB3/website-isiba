-- ════════════════════════════════════════════════════════════════
-- 🔥 SCRIPT COMPLETO - EXECUTAR TUDO DE UMA VEZ
-- ════════════════════════════════════════════════════════════════
-- Este script vai:
-- 1. Remover a view antiga
-- 2. Criar view nova com assinatura_canvas
-- 3. Verificar se funcionou
-- 4. Mostrar dados de teste
-- ════════════════════════════════════════════════════════════════

-- ============================================================
-- PASSO 1: REMOVER VIEW ANTIGA
-- ============================================================
DROP VIEW IF EXISTS view_recibos_completos CASCADE;

-- ============================================================
-- PASSO 2: CRIAR VIEW NOVA COM TODOS OS CAMPOS
-- ============================================================
CREATE OR REPLACE VIEW view_recibos_completos AS
SELECT 
    -- Dados do Recibo (tabela recibos_documentos)
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
    
    -- Dados do Colaborador (tabela colaboradores)
    c.nome_completo,
    c.cpf,
    c.email,
    
    -- Dados do Documento Contracheque
    ct.mes_referencia,
    ct.ano,
    ct.nome_arquivo,
    ct.enviado_em,
    ct.enviado_por,
    ct.data_primeira_visualizacao as data_visualizacao,
    ct.assinatura_digital,        -- Campo secundário (também importante)
    ct.arquivo_url,
    ct.tamanho_arquivo

FROM recibos_documentos r
JOIN colaboradores c ON r.colaborador_id = c.id
LEFT JOIN contracheques ct ON r.documento_id = ct.id AND r.tipo_documento = 'contracheque';

-- ============================================================
-- PASSO 3: VERIFICAR ESTRUTURA DA VIEW (deve incluir assinatura_canvas)
-- ============================================================
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'view_recibos_completos'
ORDER BY ordinal_position;

-- ============================================================
-- PASSO 4: VERIFICAR DADOS REAIS (deve mostrar assinaturas)
-- ============================================================
SELECT 
    recibo_id,
    nome_completo,
    assinatura_texto,
    CASE 
        WHEN assinatura_canvas IS NOT NULL THEN '✅ TEM ASSINATURA'
        ELSE '❌ SEM ASSINATURA'
    END as status_assinatura,
    LEFT(assinatura_canvas, 50) as preview_assinatura,
    data_recebimento,
    criado_em
FROM view_recibos_completos
ORDER BY criado_em DESC
LIMIT 10;

-- ============================================================
-- PASSO 5: CONTAR RECIBOS COM E SEM ASSINATURA
-- ============================================================
SELECT 
    COUNT(*) as total_recibos,
    SUM(CASE WHEN assinatura_canvas IS NOT NULL THEN 1 ELSE 0 END) as com_assinatura,
    SUM(CASE WHEN assinatura_canvas IS NULL THEN 1 ELSE 0 END) as sem_assinatura
FROM view_recibos_completos;

-- ════════════════════════════════════════════════════════════════
-- ✅ RESULTADOS ESPERADOS:
-- ════════════════════════════════════════════════════════════════
-- 
-- PASSO 3: Deve listar "assinatura_canvas" na lista de colunas
-- PASSO 4: Deve mostrar "✅ TEM ASSINATURA" para recibos recentes
--          Preview deve começar com: data:image/png;base64,iVBORw0K...
-- PASSO 5: Deve mostrar quantos recibos têm assinatura
--
-- ════════════════════════════════════════════════════════════════
-- 🚀 PRÓXIMO PASSO:
-- ════════════════════════════════════════════════════════════════
-- Após executar este script:
-- 1. Volte ao Painel RH
-- 2. Pressione Ctrl + Shift + R (limpar cache)
-- 3. Clique em "Ver Detalhes" de um recibo
-- 4. A ASSINATURA DIGITAL VAI APARECER! 🎉
-- ════════════════════════════════════════════════════════════════
