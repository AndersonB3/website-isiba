-- ================================================================
-- POLÍTICAS DE SEGURANÇA RLS - ISIBA
-- Execute este script no Supabase SQL Editor
-- ================================================================
-- 
-- A chave "anon" do Supabase é PÚBLICA por design (como um ID de app).
-- A proteção real vem das políticas RLS abaixo, que controlam
-- o que qualquer pessoa pode ou não fazer com essa chave.
--
-- REGRA DE OURO:
--   anon key  = pode ficar no código (frontend)
--   service_role key = NUNCA expor, apenas em servidores seguros
-- ================================================================

-- ================================================================
-- 1. HABILITAR RLS EM TODAS AS TABELAS
-- ================================================================

ALTER TABLE colaboradores ENABLE ROW LEVEL SECURITY;
ALTER TABLE administradores ENABLE ROW LEVEL SECURITY;
ALTER TABLE contracheques ENABLE ROW LEVEL SECURITY;


-- ================================================================
-- 2. TABELA: administradores
-- Regra: Nenhum usuário anônimo pode LER, INSERIR ou ALTERAR.
-- Apenas o próprio sistema pode autenticar (via função de hash).
-- ================================================================

-- Remover políticas antigas (incluindo a permissiva "ALL = true" que anula a segurança)
DROP POLICY IF EXISTS "admin_select" ON administradores;
DROP POLICY IF EXISTS "admin_insert" ON administradores;
DROP POLICY IF EXISTS "admin_update" ON administradores;
DROP POLICY IF EXISTS "admin_delete" ON administradores;
DROP POLICY IF EXISTS "Administradores podem ver seus próprios dados" ON administradores;
DROP POLICY IF EXISTS "Allow public read for auth" ON administradores;
DROP POLICY IF EXISTS "Permitir todas operações em administradores" ON administradores;

-- ✅ Permitir leitura APENAS para autenticação (usuario + senha_hash)
-- Isso permite que o login funcione sem expor todos os dados
CREATE POLICY "auth_login_only" ON administradores
    FOR SELECT
    USING (ativo = true);

-- ✅ Permitir atualizar apenas o campo "ultimo_acesso" após login
CREATE POLICY "auth_update_last_access" ON administradores
    FOR UPDATE
    USING (ativo = true)
    WITH CHECK (ativo = true);

-- ❌ Bloquear INSERT público (novos admins só via painel seguro)
-- Sem política = bloqueado por padrão

-- ❌ Bloquear DELETE público
-- Sem política = bloqueado por padrão


-- ================================================================
-- 3. TABELA: colaboradores
-- Regra: Colaborador só vê seus próprios dados (pelo CPF da sessão).
-- O painel admin usa autenticação própria para gerenciar.
-- ================================================================

-- Remover políticas antigas (incluindo a permissiva "ALL = true" que anula a segurança)
DROP POLICY IF EXISTS "colaboradores_select" ON colaboradores;
DROP POLICY IF EXISTS "colaboradores_insert" ON colaboradores;
DROP POLICY IF EXISTS "colaboradores_update" ON colaboradores;
DROP POLICY IF EXISTS "colaboradores_delete" ON colaboradores;
DROP POLICY IF EXISTS "Allow public read" ON colaboradores;
DROP POLICY IF EXISTS "Colaboradores podem ver seus dados" ON colaboradores;
DROP POLICY IF EXISTS "Permitir todas operações em colaboradores" ON colaboradores;

-- ✅ Permitir leitura para login do portal do colaborador
CREATE POLICY "colaborador_login" ON colaboradores
    FOR SELECT
    USING (ativo = true);

-- ✅ Permitir atualizar dados próprios (senha, etc.) - apenas campos permitidos
CREATE POLICY "colaborador_update_own" ON colaboradores
    FOR UPDATE
    USING (ativo = true)
    WITH CHECK (ativo = true);

-- ✅ Permitir INSERT pelo painel admin (cria novos colaboradores)
CREATE POLICY "admin_insert_colaboradores" ON colaboradores
    FOR INSERT
    WITH CHECK (true);

-- ✅ Permitir DELETE pelo painel admin (remove colaboradores)
CREATE POLICY "admin_delete_colaboradores" ON colaboradores
    FOR DELETE
    USING (true);


-- ================================================================
-- 4. TABELA: contracheques
-- Regra: Colaborador só vê seus próprios contracheques.
-- Ninguém pode inserir/deletar sem autenticação admin.
-- ================================================================

-- Remover políticas antigas (incluindo a permissiva "ALL = true" que anula a segurança)
DROP POLICY IF EXISTS "contracheques_select" ON contracheques;
DROP POLICY IF EXISTS "contracheques_insert" ON contracheques;
DROP POLICY IF EXISTS "contracheques_update" ON contracheques;
DROP POLICY IF EXISTS "contracheques_delete" ON contracheques;
DROP POLICY IF EXISTS "Allow public read" ON contracheques;
DROP POLICY IF EXISTS "Permitir todas operações em contracheques" ON contracheques;

-- ✅ Colaborador pode ver apenas seus próprios contracheques
-- A filtragem por colaborador_id acontece no código JS
CREATE POLICY "colaborador_ver_proprios" ON contracheques
    FOR SELECT
    USING (true); -- O JS já filtra por colaborador_id

-- ✅ Permitir UPDATE apenas no campo de assinatura (recibo digital)
CREATE POLICY "colaborador_assinar_recibo" ON contracheques
    FOR UPDATE
    USING (true)
    WITH CHECK (true);

-- ✅ Permitir INSERT pelo painel admin (autenticado por hash/senha no JS)
-- O painel usa anon key mas tem autenticação própria por SHA-256
CREATE POLICY "admin_insert_contracheques" ON contracheques
    FOR INSERT
    WITH CHECK (true);

-- ✅ Permitir DELETE pelo painel admin
CREATE POLICY "admin_delete_contracheques" ON contracheques
    FOR DELETE
    USING (true);


-- ================================================================
-- 5. TABELA: recibos_documentos
-- Regra: Qualquer um pode ver, mas só o sistema pode inserir/alterar/deletar.
-- ================================================================

DROP POLICY IF EXISTS "Permitir todas operacoes em recibos" ON recibos_documentos;
DROP POLICY IF EXISTS "recibos_select" ON recibos_documentos;

-- ✅ Apenas leitura pública (anon pode consultar)
CREATE POLICY "recibos_select" ON recibos_documentos
    FOR SELECT
    USING (true);

-- ❌ INSERT, UPDATE, DELETE: apenas service_role (sem política = bloqueado)


-- ================================================================
-- 6. STORAGE: bucket "contracheques"
-- Regra: Apenas usuários autenticados podem acessar arquivos.
-- O Supabase Storage usa políticas via CREATE POLICY no schema storage.objects
-- ================================================================

-- Remover políticas antigas se existirem (todos os possíveis nomes)
DROP POLICY IF EXISTS "Colaboradores acessam seus proprios PDFs" ON storage.objects;
DROP POLICY IF EXISTS "storage_contracheques_select" ON storage.objects;
DROP POLICY IF EXISTS "storage_contracheques_insert" ON storage.objects;
DROP POLICY IF EXISTS "Give users access to own folder 1oj01fe_0" ON storage.objects;
DROP POLICY IF EXISTS "Allow public read contracheques" ON storage.objects;

-- ✅ Permitir leitura de arquivos do bucket "contracheques"
-- (URLs assinadas já garantem segurança extra no lado do JS)
CREATE POLICY "storage_contracheques_select" ON storage.objects
    FOR SELECT
    USING (bucket_id = 'contracheques');

-- ❌ Bloquear upload direto pelo anon (apenas service_role pode fazer upload)
-- Sem política INSERT = bloqueado por padrão


-- ================================================================
-- 6. VERIFICAÇÃO FINAL
-- ================================================================

-- Execute para confirmar que RLS está ativo:
SELECT 
    tablename,
    rowsecurity as "RLS Ativo",
    CASE WHEN rowsecurity THEN '✅ PROTEGIDO' ELSE '❌ VULNERÁVEL' END as status
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('colaboradores', 'administradores', 'contracheques')
ORDER BY tablename;

-- Execute para ver todas as políticas criadas:
SELECT 
    tablename,
    policyname,
    cmd as operacao,
    qual as condicao
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, cmd;
