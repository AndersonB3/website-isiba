-- ════════════════════════════════════════════════════════════════
-- COPIE ESTE SQL COMPLETO E EXECUTE NO SUPABASE
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

-- Adicionar coluna tipo_documento
ALTER TABLE contracheques 
ADD COLUMN IF NOT EXISTS tipo_documento VARCHAR(50) DEFAULT 'contracheque';

-- Atualizar todos os registros existentes
UPDATE contracheques 
SET tipo_documento = 'contracheque' 
WHERE tipo_documento IS NULL;

-- Adicionar validação (só permite 'contracheque' ou 'informe_ir')
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'contracheques_tipo_documento_check'
    ) THEN
        ALTER TABLE contracheques 
        ADD CONSTRAINT contracheques_tipo_documento_check 
        CHECK (tipo_documento IN ('contracheque', 'informe_ir'));
    END IF;
END $$;

-- Criar índice para melhor performance
CREATE INDEX IF NOT EXISTS idx_contracheques_tipo_documento 
ON contracheques(tipo_documento);

-- ════════════════════════════════════════════════════════════════
-- VERIFICAÇÃO (mostra se a coluna foi criada corretamente)
-- ════════════════════════════════════════════════════════════════

SELECT 
    column_name AS "Coluna",
    data_type AS "Tipo",
    column_default AS "Valor Padrão",
    is_nullable AS "Permite NULL"
FROM information_schema.columns
WHERE table_name = 'contracheques' 
  AND column_name = 'tipo_documento';

-- ════════════════════════════════════════════════════════════════
-- RESULTADO ESPERADO:
-- 
-- ┌────────────────┬─────────┬──────────────────┬──────────────┐
-- │ Coluna         │ Tipo    │ Valor Padrão     │ Permite NULL │
-- ├────────────────┼─────────┼──────────────────┼──────────────┤
-- │ tipo_documento │ varchar │ 'contracheque'   │ YES          │
-- └────────────────┴─────────┴──────────────────┴──────────────┘
--
-- Se você ver esta tabela → SUCESSO! ✅
-- Volte ao Painel RH e tente enviar o Informe de IR novamente
--
-- ════════════════════════════════════════════════════════════════
