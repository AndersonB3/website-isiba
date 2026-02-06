-- ═══════════════════════════════════════════════════════════════════════════
-- ✅ SCRIPT DE VERIFICAÇÃO - EXECUTE NO BANCO DE DESENVOLVIMENTO
-- ═══════════════════════════════════════════════════════════════════════════
-- 
-- Execute este script APÓS importar os dados para verificar se tudo foi
-- copiado corretamente.
--
-- ═══════════════════════════════════════════════════════════════════════════

-- 1. CONTAGEM GERAL DE REGISTROS
SELECT 
    '📊 RESUMO GERAL' as categoria,
    '' as detalhe,
    '' as valor
UNION ALL
SELECT 
    '═══════════════════════════════════════',
    '',
    ''
UNION ALL
SELECT 
    '👥 Colaboradores',
    'Total de registros:',
    COUNT(*)::text
FROM colaboradores
UNION ALL
SELECT 
    '📄 Contracheques',
    'Total de documentos:',
    COUNT(*)::text
FROM contracheques
UNION ALL
SELECT 
    '📝 Recibos',
    'Total de recibos:',
    COUNT(*)::text
FROM recibos_documentos
UNION ALL
SELECT 
    '🔐 Admin RH',
    'Total de administradores:',
    COUNT(*)::text
FROM admin_rh;

-- ═══════════════════════════════════════════════════════════════════════════

-- 2. DETALHES DOS COLABORADORES
SELECT 
    '' as separador
UNION ALL
SELECT 
    '═══════════════════════════════════════'
UNION ALL
SELECT 
    '👥 COLABORADORES IMPORTADOS'
UNION ALL
SELECT 
    '═══════════════════════════════════════';

SELECT 
    codigo as "Código",
    nome as "Nome",
    cpf as "CPF",
    status as "Status",
    CASE WHEN primeiro_acesso THEN 'Sim' ELSE 'Não' END as "1º Acesso",
    to_char(criado_em, 'DD/MM/YYYY HH24:MI') as "Cadastrado em"
FROM colaboradores
ORDER BY criado_em;

-- ═══════════════════════════════════════════════════════════════════════════

-- 3. DETALHES DOS CONTRACHEQUES
SELECT 
    '' as separador
UNION ALL
SELECT 
    '═══════════════════════════════════════'
UNION ALL
SELECT 
    '📄 CONTRACHEQUES IMPORTADOS'
UNION ALL
SELECT 
    '═══════════════════════════════════════';

SELECT 
    c.tipo_documento as "Tipo",
    c.mes as "Mês",
    c.ano as "Ano",
    col.nome as "Colaborador",
    CASE WHEN c.recibo_gerado THEN 'Sim' ELSE 'Não' END as "Recibo?",
    CASE WHEN c.bloqueado THEN 'Sim' ELSE 'Não' END as "Bloqueado?",
    to_char(c.data_envio, 'DD/MM/YYYY') as "Data Envio"
FROM contracheques c
JOIN colaboradores col ON c.colaborador_id = col.id
ORDER BY c.ano DESC, c.data_envio DESC
LIMIT 20;

-- ═══════════════════════════════════════════════════════════════════════════

-- 4. ESTATÍSTICAS DETALHADAS
SELECT 
    '' as separador
UNION ALL
SELECT 
    '═══════════════════════════════════════'
UNION ALL
SELECT 
    '📊 ESTATÍSTICAS DETALHADAS'
UNION ALL
SELECT 
    '═══════════════════════════════════════';

-- Por tipo de documento
SELECT 
    'Contracheques por tipo:' as categoria,
    tipo_documento,
    COUNT(*)::text as quantidade
FROM contracheques
GROUP BY tipo_documento
UNION ALL
SELECT 
    '---',
    '',
    ''
UNION ALL
-- Por ano
SELECT 
    'Contracheques por ano:',
    ano::text,
    COUNT(*)::text
FROM contracheques
GROUP BY ano
ORDER BY ano DESC
UNION ALL
SELECT 
    '---',
    '',
    ''
UNION ALL
-- Status dos colaboradores
SELECT 
    'Colaboradores por status:',
    status,
    COUNT(*)::text
FROM colaboradores
GROUP BY status
UNION ALL
SELECT 
    '---',
    '',
    ''
UNION ALL
-- Recibos gerados
SELECT 
    'Documentos com recibo:',
    CASE WHEN recibo_gerado THEN 'Sim' ELSE 'Não' END,
    COUNT(*)::text
FROM contracheques
GROUP BY recibo_gerado;

-- ═══════════════════════════════════════════════════════════════════════════

-- 5. VERIFICAÇÃO DE INTEGRIDADE
SELECT 
    '' as separador
UNION ALL
SELECT 
    '═══════════════════════════════════════'
UNION ALL
SELECT 
    '🔍 VERIFICAÇÃO DE INTEGRIDADE'
UNION ALL
SELECT 
    '═══════════════════════════════════════';

-- Contracheques sem colaborador (NÃO DEVE HAVER!)
SELECT 
    '❌ Contracheques órfãos (sem colaborador):' as teste,
    COUNT(*)::text as resultado
FROM contracheques c
LEFT JOIN colaboradores col ON c.colaborador_id = col.id
WHERE col.id IS NULL

UNION ALL

-- Recibos sem contracheque (NÃO DEVE HAVER!)
SELECT 
    '❌ Recibos órfãos (sem contracheque):',
    COUNT(*)::text
FROM recibos_documentos r
LEFT JOIN contracheques c ON r.contracheque_id = c.id
WHERE c.id IS NULL

UNION ALL

-- Recibos sem colaborador (NÃO DEVE HAVER!)
SELECT 
    '❌ Recibos sem colaborador:',
    COUNT(*)::text
FROM recibos_documentos r
LEFT JOIN colaboradores col ON r.colaborador_id = col.id
WHERE col.id IS NULL

UNION ALL

-- Colaboradores sem documentos (PODE HAVER)
SELECT 
    '⚠️ Colaboradores sem documentos:',
    COUNT(*)::text
FROM colaboradores col
LEFT JOIN contracheques c ON col.id = c.colaborador_id
WHERE c.id IS NULL;

-- ═══════════════════════════════════════════════════════════════════════════

-- 6. ÚLTIMAS ATIVIDADES
SELECT 
    '' as separador
UNION ALL
SELECT 
    '═══════════════════════════════════════'
UNION ALL
SELECT 
    '📅 ÚLTIMAS ATIVIDADES'
UNION ALL
SELECT 
    '═══════════════════════════════════════';

SELECT 
    'Colaborador cadastrado' as atividade,
    nome as detalhe,
    to_char(criado_em, 'DD/MM/YYYY HH24:MI:SS') as data_hora
FROM colaboradores
ORDER BY criado_em DESC
LIMIT 5

UNION ALL

SELECT 
    'Documento enviado',
    col.nome || ' - ' || c.tipo_documento || ' ' || COALESCE(c.mes, '') || '/' || c.ano::text,
    to_char(c.data_envio, 'DD/MM/YYYY HH24:MI:SS')
FROM contracheques c
JOIN colaboradores col ON c.colaborador_id = col.id
ORDER BY c.data_envio DESC
LIMIT 5

UNION ALL

SELECT 
    'Recibo gerado',
    col.nome || ' - ' || r.tipo_documento,
    to_char(r.data_recebimento, 'DD/MM/YYYY HH24:MI:SS')
FROM recibos_documentos r
JOIN colaboradores col ON r.colaborador_id = col.id
ORDER BY r.data_recebimento DESC
LIMIT 5;

-- ═══════════════════════════════════════════════════════════════════════════
-- ✅ RESULTADO ESPERADO:
-- ═══════════════════════════════════════════════════════════════════════════
-- 
-- 1. Contagens de registros iguais à produção
-- 2. Lista de colaboradores, contracheques e recibos
-- 3. Estatísticas detalhadas
-- 4. ZERO registros órfãos (integridade OK)
-- 5. Últimas atividades listadas
--
-- Se tudo estiver OK, você está pronto para desenvolver! 🎉
--
-- ═══════════════════════════════════════════════════════════════════════════
