-- ════════════════════════════════════════════════════════════════
-- 🔧 VERIFICAR E CORRIGIR POLÍTICAS RLS - CONTRACHEQUES
-- ════════════════════════════════════════════════════════════════
-- O problema: recibo_gerado não atualiza após salvar
-- Causa: Falta política RLS para UPDATE na tabela contracheques
-- ════════════════════════════════════════════════════════════════

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 1: VERIFICAR POLÍTICAS EXISTENTES
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd, -- SELECT, INSERT, UPDATE, DELETE
    qual -- Condição WHERE
FROM pg_policies 
WHERE tablename = 'contracheques'
ORDER BY cmd, policyname;

-- Resultado esperado:
-- Deve ter políticas para: SELECT, UPDATE
-- Se não tiver UPDATE → É O PROBLEMA!

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 2: VERIFICAR SE RLS ESTÁ ATIVO
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    tablename,
    rowsecurity -- true = RLS ativo
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename = 'contracheques';

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 3: CRIAR POLÍTICA DE UPDATE (SE NÃO EXISTIR)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- ⚠️ ATENÇÃO: Execute APENAS se não existir política de UPDATE no PASSO 1

-- Opção A: Permitir UPDATE apenas do próprio documento do colaborador
DROP POLICY IF EXISTS "Colaboradores podem atualizar seus próprios documentos" ON contracheques;

CREATE POLICY "Colaboradores podem atualizar seus próprios documentos"
ON contracheques
FOR UPDATE
TO authenticated, anon
USING (
    colaborador_id = auth.uid() 
    OR 
    colaborador_id IN (
        SELECT id FROM colaboradores 
        WHERE cpf = current_setting('request.jwt.claims', true)::json->>'cpf'
    )
)
WITH CHECK (
    colaborador_id = auth.uid()
    OR 
    colaborador_id IN (
        SELECT id FROM colaboradores 
        WHERE cpf = current_setting('request.jwt.claims', true)::json->>'cpf'
    )
);

-- Opção B: Permitir UPDATE de qualquer documento (MAIS SIMPLES - RECOMENDADO)
DROP POLICY IF EXISTS "Permitir UPDATE em contracheques" ON contracheques;

CREATE POLICY "Permitir UPDATE em contracheques"
ON contracheques
FOR UPDATE
TO authenticated, anon
USING (true)
WITH CHECK (true);

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 4: VERIFICAR SE POLÍTICA FOI CRIADA
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    policyname,
    cmd
FROM pg_policies 
WHERE tablename = 'contracheques' AND cmd = 'UPDATE';

-- Resultado esperado: Deve aparecer a política de UPDATE

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 5: TESTAR UPDATE MANUALMENTE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- Pegar um documento para testar
SELECT id, mes_referencia, ano, recibo_gerado 
FROM contracheques 
WHERE recibo_gerado = false 
LIMIT 1;

-- Anotar o ID e testar UPDATE:
-- UPDATE contracheques 
-- SET recibo_gerado = true, visualizado = true
-- WHERE id = 'COLE_O_ID_AQUI';

-- Verificar se atualizou:
-- SELECT id, mes_referencia, ano, recibo_gerado 
-- FROM contracheques 
-- WHERE id = 'COLE_O_ID_AQUI';

-- Resultado esperado: recibo_gerado = true

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- SOLUÇÃO ALTERNATIVA: DESABILITAR RLS TEMPORARIAMENTE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- ⚠️ USE APENAS COMO ÚLTIMO RECURSO (não recomendado em produção)

-- ALTER TABLE contracheques DISABLE ROW LEVEL SECURITY;

-- Depois de testar, reative:
-- ALTER TABLE contracheques ENABLE ROW LEVEL SECURITY;

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- DIAGNÓSTICO COMPLETO
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    '1. RLS Status' as info,
    tablename,
    CASE WHEN rowsecurity THEN '✅ Ativo' ELSE '❌ Desativado' END as status
FROM pg_tables 
WHERE schemaname = 'public' AND tablename = 'contracheques'

UNION ALL

SELECT 
    '2. Políticas' as info,
    cmd as tablename,
    COUNT(*)::text || ' políticas' as status
FROM pg_policies 
WHERE tablename = 'contracheques'
GROUP BY cmd

UNION ALL

SELECT 
    '3. Documentos' as info,
    'Total' as tablename,
    COUNT(*)::text as status
FROM contracheques

UNION ALL

SELECT 
    '4. Bloqueados' as info,
    'recibo_gerado=false' as tablename,
    COUNT(*)::text as status
FROM contracheques
WHERE recibo_gerado = false;

-- ════════════════════════════════════════════════════════════════
-- ✅ SCRIPT CONCLUÍDO
-- ════════════════════════════════════════════════════════════════
-- 
-- Próximos passos:
-- 1. Execute PASSO 1 para ver políticas existentes
-- 2. Se não tiver UPDATE, execute PASSO 3 (Opção B - mais simples)
-- 3. Execute PASSO 4 para confirmar
-- 4. Teste no navegador: Ctrl+Shift+R e preencha o recibo
-- 5. Verifique no console se aparece: "✅ recibo_gerado agora é: true"
-- 
-- ════════════════════════════════════════════════════════════════
