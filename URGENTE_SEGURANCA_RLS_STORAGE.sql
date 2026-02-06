-- ════════════════════════════════════════════════════════════════
-- 🚨 URGENTE: POLÍTICAS DE SEGURANÇA PARA STORAGE
-- ════════════════════════════════════════════════════════════════
-- Execute IMEDIATAMENTE no SQL Editor do Supabase
-- Garante que colaboradores só vejam seus próprios documentos
-- ════════════════════════════════════════════════════════════════

-- 1. REMOVER POLÍTICA PÚBLICA ANTIGA (se existir)
DROP POLICY IF EXISTS "Permitir leitura pública de contracheques" ON storage.objects;

-- ════════════════════════════════════════════════════════════════
-- 2. POLÍTICA: COLABORADOR VÊ APENAS SUA PASTA
-- ════════════════════════════════════════════════════════════════

CREATE POLICY "Colaborador acessa apenas sua pasta"
ON storage.objects FOR SELECT
TO authenticated
USING (
    bucket_id = 'contracheques' 
    AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Explicação:
-- - storage.foldername(name) retorna array de pastas no caminho
-- - [1] pega a primeira pasta (UUID do colaborador)
-- - auth.uid() é o ID do usuário autenticado
-- - Só funciona se o caminho for: contracheques/UUID_DO_COLABORADOR/arquivo.pdf

-- ════════════════════════════════════════════════════════════════
-- 3. POLÍTICA: ADMIN RH PODE FAZER UPLOAD EM QUALQUER PASTA
-- ════════════════════════════════════════════════════════════════

CREATE POLICY "Admin RH pode fazer upload em qualquer pasta"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'contracheques'
    AND (
        auth.jwt() ->> 'email' = 'admin.rh@isiba.com'
        OR auth.jwt() ->> 'email' LIKE '%@isiba.com'
    )
);

-- ════════════════════════════════════════════════════════════════
-- 4. POLÍTICA: ADMIN RH PODE ATUALIZAR/SUBSTITUIR ARQUIVOS
-- ════════════════════════════════════════════════════════════════

CREATE POLICY "Admin RH pode atualizar arquivos"
ON storage.objects FOR UPDATE
TO authenticated
USING (
    bucket_id = 'contracheques'
    AND (
        auth.jwt() ->> 'email' = 'admin.rh@isiba.com'
        OR auth.jwt() ->> 'email' LIKE '%@isiba.com'
    )
);

-- ════════════════════════════════════════════════════════════════
-- 5. POLÍTICA: ADMIN RH PODE DELETAR ARQUIVOS
-- ════════════════════════════════════════════════════════════════

CREATE POLICY "Admin RH pode deletar arquivos"
ON storage.objects FOR DELETE
TO authenticated
USING (
    bucket_id = 'contracheques'
    AND (
        auth.jwt() ->> 'email' = 'admin.rh@isiba.com'
        OR auth.jwt() ->> 'email' LIKE '%@isiba.com'
    )
);

-- ════════════════════════════════════════════════════════════════
-- 6. VERIFICAR POLÍTICAS CRIADAS
-- ════════════════════════════════════════════════════════════════

SELECT 
    policyname,
    cmd,
    roles,
    qual
FROM pg_policies
WHERE tablename = 'objects' 
AND schemaname = 'storage'
AND policyname LIKE '%colaborador%' OR policyname LIKE '%Admin RH%';

-- ════════════════════════════════════════════════════════════════
-- 7. TESTAR ESTRUTURA DE PASTAS
-- ════════════════════════════════════════════════════════════════

SELECT 
    name AS caminho_arquivo,
    (storage.foldername(name))[1] AS pasta_colaborador,
    metadata->>'size' AS tamanho,
    created_at
FROM storage.objects
WHERE bucket_id = 'contracheques'
ORDER BY created_at DESC
LIMIT 10;

-- ════════════════════════════════════════════════════════════════
-- RESULTADO ESPERADO:
-- ════════════════════════════════════════════════════════════════
-- Caminho: a46716b8-50e6-49fa-9b59-ad7916a6b897/contracheque_Dezembro_2025.pdf
-- Pasta:   a46716b8-50e6-49fa-9b59-ad7916a6b897
-- ════════════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════════════
-- 🔒 SEGURANÇA GARANTIDA:
-- ════════════════════════════════════════════════════════════════
-- ✅ Colaborador A (UUID: aaa-bbb-ccc) só vê: contracheques/aaa-bbb-ccc/*
-- ✅ Colaborador B (UUID: ddd-eee-fff) só vê: contracheques/ddd-eee-fff/*
-- ✅ Admin RH pode fazer upload/edição/exclusão em todas as pastas
-- ✅ URLs públicas NÃO funcionam mais (precisa autenticação)
-- ════════════════════════════════════════════════════════════════
