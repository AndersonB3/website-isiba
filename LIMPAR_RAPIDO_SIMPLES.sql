-- ════════════════════════════════════════════════════════════════
-- 🔥 SCRIPT RÁPIDO - LIMPAR E BLOQUEAR
-- ════════════════════════════════════════════════════════════════

-- 1️⃣ VER QUANTOS RECIBOS EXISTEM
SELECT COUNT(*) as total_recibos FROM recibos_documentos;

-- 2️⃣ DELETAR TODOS OS RECIBOS
DELETE FROM recibos_documentos;

-- 3️⃣ CONFIRMAR QUE DELETOU (deve retornar 0)
SELECT COUNT(*) as recibos_restantes FROM recibos_documentos;

-- 4️⃣ BLOQUEAR TODOS OS DOCUMENTOS
UPDATE contracheques 
SET recibo_gerado = false, 
    visualizado = false, 
    data_primeira_visualizacao = NULL
WHERE recibo_gerado IS NOT NULL;

-- 5️⃣ VERIFICAR ESTADO FINAL
SELECT 
    COUNT(*) as total_documentos,
    SUM(CASE WHEN recibo_gerado = false THEN 1 ELSE 0 END) as bloqueados,
    SUM(CASE WHEN recibo_gerado = true THEN 1 ELSE 0 END) as liberados
FROM contracheques;

-- ✅ PRONTO! 
-- Agora: Ctrl+Shift+R no navegador e teste!