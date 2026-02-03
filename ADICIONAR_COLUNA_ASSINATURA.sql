-- ════════════════════════════════════════════════════════════════
-- 🔧 ADICIONAR COLUNA assinatura_digital NA TABELA contracheques
-- ════════════════════════════════════════════════════════════════

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 1: VERIFICAR SE COLUNA JÁ EXISTE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'contracheques'
AND column_name = 'assinatura_digital';

-- Se retornar vazio = Coluna não existe (é o problema!)
-- Se retornar 1 linha = Coluna já existe (não precisa criar)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 2: ADICIONAR COLUNA (SE NÃO EXISTIR)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ALTER TABLE contracheques 
ADD COLUMN IF NOT EXISTS assinatura_digital TEXT;

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 3: VERIFICAR SE FOI CRIADA
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'contracheques'
AND column_name = 'assinatura_digital';

-- Resultado esperado:
-- column_name: assinatura_digital
-- data_type: text
-- is_nullable: YES

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- PASSO 4: VER TODAS AS COLUNAS DA TABELA
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SELECT 
    column_name,
    data_type
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'contracheques'
ORDER BY ordinal_position;

-- ════════════════════════════════════════════════════════════════
-- ✅ SCRIPT CONCLUÍDO
-- ════════════════════════════════════════════════════════════════
-- 
-- Depois de executar:
-- 1. Verifique se coluna foi criada no PASSO 3
-- 2. Ctrl+Shift+R no navegador
-- 3. Preencha o recibo novamente
-- 4. Deve funcionar sem erro!
-- 
-- ════════════════════════════════════════════════════════════════
