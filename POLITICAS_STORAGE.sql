-- ============================================
-- POLÍTICAS DE ACESSO PARA O BUCKET DE CONTRACHEQUES
-- ============================================
-- Execute este script no SQL Editor do Supabase
-- IMPORTANTE: Execute cada bloco separadamente
-- ATENÇÃO: O bucket real é 'cOntracheques' (com O maiúsculo)

-- ============================================
-- PASSO 1: Verificar se o bucket existe
-- ============================================
SELECT id, name, public, created_at 
FROM storage.buckets 
WHERE name = 'cOntracheques';

-- ============================================
-- PASSO 2: Verificar políticas existentes
-- ============================================
-- Listar todas as políticas da tabela storage.objects


-- ============================================
-- PASSO 3: REMOVER políticas antigas (se necessário)
-- ============================================
-- Descomente as linhas abaixo se precisar remover políticas antigas
-- DROP POLICY IF EXISTS "Permitir leitura de contracheques" ON storage.objects;
-- DROP POLICY IF EXISTS "Permitir upload de contracheques" ON storage.objects;
-- DROP POLICY IF EXISTS "Permitir atualização de contracheques" ON storage.objects;

-- ============================================
-- PASSO 4: CRIAR política para permitir leitura
-- (necessário para signed URLs funcionar)
-- ============================================
CREATE POLICY "Permitir leitura de contracheques"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'cOntracheques');

-- ============================================
-- PASSO 5: CRIAR política para permitir upload
-- (necessário para o painel RH fazer upload)
-- ============================================
CREATE POLICY "Permitir upload de contracheques"
ON storage.objects
FOR INSERT
TO public
WITH CHECK (bucket_id = 'cOntracheques');

-- ============================================
-- PASSO 6: CRIAR política para permitir atualização
-- (necessário para sobrescrever arquivos)
-- ============================================
CREATE POLICY "Permitir atualização de contracheques"
ON storage.objects
FOR UPDATE
TO public
USING (bucket_id = 'cOntracheques')
WITH CHECK (bucket_id = 'cOntracheques');

-- ============================================
-- PASSO 7: CRIAR política para permitir deleção
-- (opcional, se precisar deletar arquivos)
-- ============================================
CREATE POLICY "Permitir deleção de contracheques"
ON storage.objects
FOR DELETE
TO public
USING (bucket_id = 'cOntracheques');

-- ============================================
-- PASSO 8: Verificar se as políticas foram criadas
-- ============================================
SELECT 
    policyname,
    cmd,
    roles
FROM pg_policies 
WHERE schemaname = 'storage' 
  AND tablename = 'objects'
  AND policyname LIKE '%contracheques%';

-- ============================================
-- PASSO 9: Listar todos os arquivos no bucket
-- ============================================
SELECT 
    name,
    bucket_id,
    created_at,
    updated_at,
    metadata
FROM storage.objects 
WHERE bucket_id = 'cOntracheques'
ORDER BY created_at DESC;

-- ============================================
-- PASSO 10: Verificar configuração do bucket
-- ============================================
SELECT 
    id,
    name,
    public,
    file_size_limit,
    allowed_mime_types
FROM storage.buckets 
WHERE name = 'cOntracheques';
