-- ════════════════════════════════════════════════════════════════
-- 🔒 BLOQUEAR TODOS - SCRIPT RÁPIDO
-- ════════════════════════════════════════════════════════════════
-- Copie e cole este script no Supabase SQL Editor
-- ════════════════════════════════════════════════════════════════

-- BLOQUEAR TODOS OS DOCUMENTOS
UPDATE contracheques 
SET 
    recibo_gerado = false,
    visualizado = false,
    data_primeira_visualizacao = NULL;

-- VERIFICAR RESULTADO
SELECT 
    COUNT(*) as total,
    SUM(CASE WHEN recibo_gerado = false THEN 1 ELSE 0 END) as bloqueados
FROM contracheques;

-- ✅ Se "total" = "bloqueados", todos estão bloqueados!
