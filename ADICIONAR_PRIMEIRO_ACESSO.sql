-- ════════════════════════════════════════════════════════════════
-- ADICIONAR CAMPO PRIMEIRO_ACESSO - Sistema de Troca de Senha
-- ════════════════════════════════════════════════════════════════
-- 
-- INSTRUÇÕES:
-- 1. Vá em: https://supabase.com/dashboard
-- 2. Clique em "SQL Editor" no menu lateral
-- 3. Clique em "+ New query"
-- 4. Copie TUDO deste arquivo (Ctrl+A, Ctrl+C)
-- 5. Cole no editor (Ctrl+V)
-- 6. Clique em "RUN" (botão verde)
-- 7. Aguarde 2 segundos
-- 8. Pronto! ✅
--
-- ════════════════════════════════════════════════════════════════

-- Adicionar coluna primeiro_acesso
ALTER TABLE colaboradores 
ADD COLUMN IF NOT EXISTS primeiro_acesso BOOLEAN DEFAULT true;

-- Atualizar todos os registros existentes para TRUE (precisam trocar senha)
UPDATE colaboradores 
SET primeiro_acesso = true 
WHERE primeiro_acesso IS NULL;

-- Adicionar comentário na coluna
COMMENT ON COLUMN colaboradores.primeiro_acesso IS 
'Indica se o colaborador precisa trocar a senha no primeiro acesso';

-- Criar índice para melhor performance
CREATE INDEX IF NOT EXISTS idx_colaboradores_primeiro_acesso 
ON colaboradores(primeiro_acesso);

-- ════════════════════════════════════════════════════════════════
-- VERIFICAÇÃO (mostra se a coluna foi criada corretamente)
-- ════════════════════════════════════════════════════════════════

SELECT 
    column_name AS "Coluna",
    data_type AS "Tipo",
    column_default AS "Valor Padrão",
    is_nullable AS "Permite NULL"
FROM information_schema.columns
WHERE table_name = 'colaboradores' 
  AND column_name = 'primeiro_acesso';

-- ════════════════════════════════════════════════════════════════
-- RESULTADO ESPERADO:
-- 
-- ┌──────────────────┬─────────┬───────────────┬──────────────┐
-- │ Coluna           │ Tipo    │ Valor Padrão  │ Permite NULL │
-- ├──────────────────┼─────────┼───────────────┼──────────────┤
-- │ primeiro_acesso  │ boolean │ true          │ YES          │
-- └──────────────────┴─────────┴───────────────┴──────────────┘
--
-- Se você ver esta tabela → SUCESSO! ✅
--
-- ════════════════════════════════════════════════════════════════
