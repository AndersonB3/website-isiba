-- ═══════════════════════════════════════════════════════════════════════════
-- POLÍTICAS RLS COPIADAS DO BANCO DE PRODUÇÃO
-- Execute no banco de DESENVOLVIMENTO
-- ═══════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 1: REMOVER POLÍTICAS ANTIGAS (se existirem)
-- ═══════════════════════════════════════════════════════════════════════════

DROP POLICY IF EXISTS "Permitir todas operações em administradores" ON administradores;
DROP POLICY IF EXISTS "Permitir todas operações em colaboradores" ON colaboradores;
DROP POLICY IF EXISTS "Permitir todas operações em contracheques" ON contracheques;
DROP POLICY IF EXISTS "Permitir leitura pública de dados_mensais" ON dados_mensais;
DROP POLICY IF EXISTS "Permitir leitura pública de faixa_etaria" ON faixa_etaria;
DROP POLICY IF EXISTS "Permitir todas operacoes em recibos" ON recibos_documentos;
DROP POLICY IF EXISTS "Permitir leitura pública de resumo_anual" ON resumo_anual;
DROP POLICY IF EXISTS "Apenas autenticados podem modificar" ON statistics;
DROP POLICY IF EXISTS "Permitir leitura pública de estatísticas ativas" ON statistics;
DROP POLICY IF EXISTS "Permitir leitura pública de tempo_atendimento" ON tempo_atendimento;
DROP POLICY IF EXISTS "Permitir leitura pública de unidades" ON unidades;

-- Remover também políticas antigas do RECRIAR-COLABORADORES-DEV.sql
DROP POLICY IF EXISTS "Colaboradores podem ver seus próprios dados" ON colaboradores;
DROP POLICY IF EXISTS "Colaboradores podem atualizar seus dados" ON colaboradores;

-- ═══════════════════════════════════════════════════════════════════════════
-- PARTE 2: CRIAR NOVAS POLÍTICAS
-- ═══════════════════════════════════════════════════════════════════════════

-- 1. Administradores
CREATE POLICY "Permitir todas operações em administradores" 
    ON administradores FOR ALL
    USING (true)
    WITH CHECK (true);

-- 2. Colaboradores
CREATE POLICY "Permitir todas operações em colaboradores" 
    ON colaboradores FOR ALL
    USING (true)
    WITH CHECK (true);

-- 3. Contracheques
CREATE POLICY "Permitir todas operações em contracheques" 
    ON contracheques FOR ALL
    USING (true)
    WITH CHECK (true);

-- 4. Dados Mensais
CREATE POLICY "Permitir leitura pública de dados_mensais" 
    ON dados_mensais FOR SELECT
    USING (true);

-- 5. Faixa Etária
CREATE POLICY "Permitir leitura pública de faixa_etaria" 
    ON faixa_etaria FOR SELECT
    USING (true);

-- 6. Recibos Documentos
CREATE POLICY "Permitir todas operacoes em recibos" 
    ON recibos_documentos FOR ALL
    USING (true)
    WITH CHECK (true);

-- 7. Resumo Anual
CREATE POLICY "Permitir leitura pública de resumo_anual" 
    ON resumo_anual FOR SELECT
    USING (true);

-- 8. Statistics (2 políticas)
CREATE POLICY "Apenas autenticados podem modificar" 
    ON statistics FOR ALL
    USING ((auth.role() = 'authenticated'::text));

CREATE POLICY "Permitir leitura pública de estatísticas ativas" 
    ON statistics FOR SELECT
    USING ((ativo = true));

-- 9. Tempo de Atendimento
CREATE POLICY "Permitir leitura pública de tempo_atendimento" 
    ON tempo_atendimento FOR SELECT
    USING (true);

-- 10. Unidades
CREATE POLICY "Permitir leitura pública de unidades" 
    ON unidades FOR SELECT
    USING (true);

-- ═══════════════════════════════════════════════════════════════════════════
-- ✅ PRONTO! Políticas RLS configuradas no banco de DESENVOLVIMENTO
-- Agora teste o login em: http://localhost:8000/portal-colaborador.html
-- ═══════════════════════════════════════════════════════════════════════════
