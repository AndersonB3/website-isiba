-- ═══════════════════════════════════════════════════════════════════════════
-- POLÍTICAS DE SEGURANÇA PARA STORAGE (BUCKET: contracheques)
-- ═══════════════════════════════════════════════════════════════════════════
--
-- Execute este script APÓS criar o bucket "contracheques" manualmente
--
-- ═══════════════════════════════════════════════════════════════════════════

-- 1. POLÍTICA: Colaboradores podem VISUALIZAR apenas seus próprios documentos
CREATE POLICY "Colaboradores podem visualizar seus documentos"
ON storage.objects
FOR SELECT
USING (
    bucket_id = 'contracheques' 
    AND auth.uid()::text = (storage.foldername(name))[1]
);

-- 2. POLÍTICA: Colaboradores podem BAIXAR apenas seus próprios documentos
CREATE POLICY "Colaboradores podem baixar seus documentos"
ON storage.objects
FOR SELECT
USING (
    bucket_id = 'contracheques' 
    AND auth.uid()::text = (storage.foldername(name))[1]
);

-- 3. POLÍTICA: Admin RH pode fazer UPLOAD em qualquer pasta
CREATE POLICY "Admin RH pode fazer upload"
ON storage.objects
FOR INSERT
WITH CHECK (
    bucket_id = 'contracheques'
    AND auth.role() = 'authenticated'
);

-- 4. POLÍTICA: Admin RH pode ATUALIZAR/SUBSTITUIR arquivos
CREATE POLICY "Admin RH pode atualizar arquivos"
ON storage.objects
FOR UPDATE
USING (
    bucket_id = 'contracheques'
    AND auth.role() = 'authenticated'
);

-- 5. POLÍTICA: Admin RH pode DELETAR arquivos
CREATE POLICY "Admin RH pode deletar arquivos"
ON storage.objects
FOR DELETE
USING (
    bucket_id = 'contracheques'
    AND auth.role() = 'authenticated'
);

-- ═══════════════════════════════════════════════════════════════════════════
-- VERIFICAÇÃO: Políticas Aplicadas
-- ═══════════════════════════════════════════════════════════════════════════

-- Execute esta query para ver as políticas criadas:
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE schemaname = 'storage'
AND tablename = 'objects'
AND policyname LIKE '%colaborador%' OR policyname LIKE '%Admin RH%'
ORDER BY policyname;

-- ═══════════════════════════════════════════════════════════════════════════
-- RESULTADO ESPERADO:
-- ═══════════════════════════════════════════════════════════════════════════
-- Você deve ver 5 políticas criadas:
-- 1. Colaboradores podem visualizar seus documentos (SELECT)
-- 2. Colaboradores podem baixar seus documentos (SELECT)
-- 3. Admin RH pode fazer upload (INSERT)
-- 4. Admin RH pode atualizar arquivos (UPDATE)
-- 5. Admin RH pode deletar arquivos (DELETE)
-- ═══════════════════════════════════════════════════════════════════════════
