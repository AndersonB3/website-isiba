-- ════════════════════════════════════════════════════════════════
-- BLOQUEAR TODOS OS DOCUMENTOS NOVAMENTE
-- ════════════════════════════════════════════════════════════════
-- Execute este script no Supabase SQL Editor para bloquear
-- todos os documentos e permitir que os colaboradores assinem
-- novamente com a nova funcionalidade de assinatura digital
-- ════════════════════════════════════════════════════════════════

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 1: VERIFICAR ESTADO ATUAL DOS DOCUMENTOS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    COUNT(*) as total_documentos,
    SUM(CASE WHEN recibo_gerado = true THEN 1 ELSE 0 END) as liberados,
    SUM(CASE WHEN recibo_gerado = false THEN 1 ELSE 0 END) as bloqueados,
    SUM(CASE WHEN recibo_gerado IS NULL THEN 1 ELSE 0 END) as nulos
FROM contracheques;

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 2: BLOQUEAR TODOS OS DOCUMENTOS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- ATENÇÃO: Isso bloqueará TODOS os documentos!
-- Colaboradores precisarão assinar novamente para acessar

UPDATE contracheques 
SET 
    recibo_gerado = false,
    visualizado = false,
    data_primeira_visualizacao = NULL
WHERE recibo_gerado IS NOT NULL;

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 3: VERIFICAR SE TODOS FORAM BLOQUEADOS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    COUNT(*) as total_documentos,
    SUM(CASE WHEN recibo_gerado = false THEN 1 ELSE 0 END) as bloqueados,
    SUM(CASE WHEN recibo_gerado = true THEN 1 ELSE 0 END) as liberados
FROM contracheques;

-- Resultado esperado:
-- total_documentos: X
-- bloqueados: X  (deve ser igual ao total)
-- liberados: 0   (deve ser ZERO)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 4: VER LISTA COMPLETA DE DOCUMENTOS BLOQUEADOS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    c.id,
    c.mes_referencia,
    c.ano,
    c.tipo_documento,
    c.nome_arquivo,
    c.recibo_gerado,
    col.nome_completo as colaborador,
    col.cpf,
    c.enviado_em
FROM contracheques c
LEFT JOIN colaboradores col ON c.colaborador_id = col.id
WHERE c.recibo_gerado = false
ORDER BY c.ano DESC, c.mes_referencia DESC, col.nome_completo;

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 5 (OPCIONAL): DELETAR RECIBOS ANTIGOS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- ATENÇÃO: Isso apagará TODOS os recibos antigos!
-- Use apenas se quiser começar do zero

-- DELETE FROM recibos_documentos;

-- Verificar se todos foram deletados:
-- SELECT COUNT(*) FROM recibos_documentos;
-- Resultado esperado: 0

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 6 (OPCIONAL): BLOQUEAR APENAS DOCUMENTOS ESPECÍFICOS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- Opção A: Bloquear apenas documentos de 2026
-- UPDATE contracheques 
-- SET recibo_gerado = false, visualizado = false
-- WHERE ano = 2026;

-- Opção B: Bloquear apenas contracheques (não informes)
-- UPDATE contracheques 
-- SET recibo_gerado = false, visualizado = false
-- WHERE tipo_documento = 'contracheque';

-- Opção C: Bloquear apenas de um colaborador específico
-- UPDATE contracheques 
-- SET recibo_gerado = false, visualizado = false
-- WHERE colaborador_id = 'UUID_DO_COLABORADOR';

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- ESTATÍSTICAS FINAIS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- Documentos por status
SELECT 
    CASE 
        WHEN recibo_gerado = true THEN '✅ Liberado'
        WHEN recibo_gerado = false THEN '🔒 Bloqueado'
        ELSE '⚠️ NULL'
    END as status,
    COUNT(*) as quantidade,
    tipo_documento
FROM contracheques
GROUP BY recibo_gerado, tipo_documento
ORDER BY tipo_documento, recibo_gerado;

-- Documentos por ano
SELECT 
    ano,
    COUNT(*) as total_documentos,
    SUM(CASE WHEN recibo_gerado = false THEN 1 ELSE 0 END) as bloqueados,
    SUM(CASE WHEN recibo_gerado = true THEN 1 ELSE 0 END) as liberados
FROM contracheques
GROUP BY ano
ORDER BY ano DESC;

-- ════════════════════════════════════════════════════════════════
-- ✅ SCRIPT CONCLUÍDO
-- ════════════════════════════════════════════════════════════════
-- 
-- Próximos passos:
-- 1. ✅ Todos os documentos estão bloqueados
-- 2. 🔒 Colaboradores verão cadeados nos documentos
-- 3. ✍️ Precisarão assinar no canvas para desbloquear
-- 4. 📥 Após assinatura, poderão baixar o PDF
-- 
-- Para verificar no Portal do Colaborador:
-- - Faça login
-- - Veja os documentos com cadeado 🔒
-- - Clique para assinar
-- - Documento desbloqueia automaticamente
-- 
-- ════════════════════════════════════════════════════════════════
