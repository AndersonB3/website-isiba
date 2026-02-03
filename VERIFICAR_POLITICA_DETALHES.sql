-- ════════════════════════════════════════════════════════════════
-- 🔍 VERIFICAR DETALHES DA POLÍTICA EXISTENTE
-- ════════════════════════════════════════════════════════════════

-- Ver todos os detalhes da política "Permitir todas operações em contracheques"
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive, -- PERMISSIVE ou RESTRICTIVE
    roles, -- Quais roles podem usar
    cmd, -- ALL, SELECT, INSERT, UPDATE, DELETE
    qual, -- Condição USING (quando pode ler/atualizar)
    with_check -- Condição WITH CHECK (quando pode inserir/atualizar)
FROM pg_policies 
WHERE tablename = 'contracheques'
AND policyname = 'Permitir todas operações em contracheques';

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- VERIFICAR SE RLS ESTÁ ATIVO
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    tablename,
    rowsecurity -- true = RLS ativo
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename = 'contracheques';

-- ════════════════════════════════════════════════════════════════
-- RESULTADO ESPERADO:
-- ════════════════════════════════════════════════════════════════
-- 
-- permissive: PERMISSIVE
-- roles: {public}
-- cmd: ALL
-- qual: true  ← DEVE SER "true" (permite tudo)
-- with_check: true  ← DEVE SER "true" (permite tudo)
-- rowsecurity: true
-- 
-- Se qual ou with_check NÃO forem "true", a política está bloqueando!
-- ════════════════════════════════════════════════════════════════
