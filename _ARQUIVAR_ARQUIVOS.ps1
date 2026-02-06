# ═══════════════════════════════════════════════════════════════════════════
# SCRIPT DE ARQUIVAMENTO SEGURO DE ARQUIVOS
# ═══════════════════════════════════════════════════════════════════════════

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  ARQUIVAMENTO SEGURO DE ARQUIVOS - WEBSITE ISIBA" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$movidos = 0
$erros = 0

# ═══════════════════════════════════════════════════════════════════════════
# 1. ARQUIVOS HTML DE TESTE/DEBUG
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "📁 Movendo HTMLs de teste/debug..." -ForegroundColor Yellow

$htmlTeste = @(
    "debug-login.html",
    "debug-senha.html",
    "demo-recibos.html",
    "portal-colaborador-NOVO.html",
    "primeiro-acesso-new.html",
    "teste-formsubmit.html",
    "teste-hash.html",
    "teste-toast.html",
    "meus-contracheques.html"
)

foreach ($arquivo in $htmlTeste) {
    if (Test-Path $arquivo) {
        try {
            Move-Item $arquivo "_ARQUIVADOS\html-teste\" -Force
            Write-Host "  ✅ $arquivo" -ForegroundColor Green
            $movidos++
        } catch {
            Write-Host "  ❌ Erro ao mover $arquivo" -ForegroundColor Red
            $erros++
        }
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# 2. SCRIPTS SQL DE DEBUG (RAIZ)
# ═══════════════════════════════════════════════════════════════════════════

Write-Host ""
Write-Host "📁 Movendo SQLs de debug..." -ForegroundColor Yellow

$sqlDebug = @(
    "ADD_ASSINATURA_DIGITAL.sql",
    "ADICIONAR_COLUNA_ASSINATURA.sql",
    "ADICIONAR_PRIMEIRO_ACESSO.sql",
    "ATUALIZAR_BANCO_DOCUMENTOS.sql",
    "ATUALIZAR_DOCUMENTOS_BLOQUEIO.sql",
    "BLOQUEAR_RAPIDO.sql",
    "BLOQUEAR_TODOS_DOCUMENTOS.sql",
    "CORRIGIR_POLITICAS_RLS.sql",
    "DEBUG-ASSINATURA-VIEW.sql",
    "DEBUG_USUARIO_TESTE.sql",
    "DIAGNOSTICO_BLOQUEIO.sql",
    "EXECUTAR-TUDO-UMA-VEZ.sql",
    "EXECUTAR_AGORA_NO_SUPABASE.sql",
    "FIX-VIEW-ASSINATURA.sql",
    "FORCAR_PRIMEIRO_ACESSO_TRUE.sql",
    "LIMPAR-BANCO-GITHUB.sql",
    "LIMPAR-DADOS-TESTE.sql",
    "LIMPAR_RAPIDO_SIMPLES.sql",
    "LIMPAR_RECIBOS_E_BLOQUEAR.sql",
    "SISTEMA_RECIBOS.sql",
    "SISTEMA_RECIBOS_LIMPO.sql",
    "SISTEMA_RECIBOS_PASSO_A_PASSO.sql",
    "SQL-ADMIN-TABLE.sql",
    "VERIFICACAO_URGENTE.sql",
    "VERIFICAR_E_CORRIGIR_TESTE.sql",
    "VERIFICAR_POLITICA_DETALHES.sql",
    "VERIFICAR_VIEW_ASSINATURA.sql"
)

foreach ($arquivo in $sqlDebug) {
    if (Test-Path $arquivo) {
        try {
            Move-Item $arquivo "_ARQUIVADOS\sql-debug\" -Force
            Write-Host "  ✅ $arquivo" -ForegroundColor Green
            $movidos++
        } catch {
            Write-Host "  ❌ Erro ao mover $arquivo" -ForegroundColor Red
            $erros++
        }
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# 3. SCRIPTS SQL DE MIGRAÇÃO (DATABASE/)
# ═══════════════════════════════════════════════════════════════════════════

Write-Host ""
Write-Host "📁 Movendo SQLs auxiliares de migração..." -ForegroundColor Yellow

$sqlMigracao = @(
    "database\CLONAR-ESTRUTURA-COMPLETA.sql",
    "database\CLONAR-INDICES.sql",
    "database\COPIAR-DADOS-AUTOMATICO.sql",
    "database\COPIAR-DADOS-MANUAL.sql",
    "database\ESTRUTURA-LIMPA.sql",
    "database\EXPORT-PRODUCAO-AUTOMATICO.sql",
    "database\EXPORT-PRODUCAO-PARA-DEV.sql",
    "database\GERAR-ENABLE-RLS.sql",
    "database\GERAR-ESTRUTURA-COMPLETA.sql",
    "database\GERAR-FOREIGN-KEYS.sql",
    "database\GERAR-INSERT-COLABORADORES.sql",
    "database\GERAR-INSERT-CONTRACHEQUES.sql",
    "database\GERAR-INSERT-RECIBOS.sql",
    "database\GERAR-POLITICAS-RLS.sql",
    "database\GERAR-PRIMARY-KEYS.sql",
    "database\GERAR-TABELAS-SIMPLES.sql",
    "database\INSERIR-7-COLABORADORES-DEV.sql",
    "database\LISTAR-POLITICAS-PRODUCAO.sql",
    "database\VERIFICAR-COLUNAS-DEV.sql",
    "database\VERIFICAR-ESTRUTURA-PRODUCAO.sql",
    "database\VERIFICAR-IMPORTACAO.sql",
    "database\VERIFICAR-RLS-PRODUCAO.sql"
)

foreach ($arquivo in $sqlMigracao) {
    if (Test-Path $arquivo) {
        try {
            Move-Item $arquivo "_ARQUIVADOS\sql-migracao\" -Force
            Write-Host "  ✅ $(Split-Path $arquivo -Leaf)" -ForegroundColor Green
            $movidos++
        } catch {
            Write-Host "  ❌ Erro ao mover $(Split-Path $arquivo -Leaf)" -ForegroundColor Red
            $erros++
        }
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# 4. DOCUMENTAÇÃO TEMPORÁRIA (MD/TXT)
# ═══════════════════════════════════════════════════════════════════════════

Write-Host ""
Write-Host "📁 Movendo documentação temporária..." -ForegroundColor Yellow

$docs = @(
    "ANALISE-POLITICAS-RLS.md",
    "APRESENTACAO_RECIBOS.md",
    "ATUALIZACAO_FILTRO_PORTAL.txt",
    "ATUALIZACAO_SISTEMA_IR.md",
    "AUTENTICACAO-ADMIN.md",
    "CHANGELOG-V3.3.md",
    "COMANDOS-GIT.md",
    "CONVERSAO-GITHUB-PAGES.md",
    "COPIAR-DADOS-PRODUCAO.md",
    "CORRECAO-ASSINATURA-V3.2.md",
    "CORRECAO-LOADER.md",
    "DIAGNOSTICO_DOWNLOAD.md",
    "DIAGNOSTICO_UPDATE_V3.6.md",
    "FIX-LOGIN-RLS.md",
    "FIX_2_PROBLEMAS_V3.5.md",
    "FIX_3_PROBLEMAS_V3.4.md",
    "GUIA-CLONAR-BANCO-COMPLETO.md",
    "GUIA-COPIAR-POLITICAS-RLS.md",
    "GUIA-DEBUG-ASSINATURA.md",
    "GUIA-RAPIDO-CLONAR.md",
    "GUIA-TESTES-COMPLETO.md",
    "GUIA_ASSINATURA_DIGITAL.md",
    "GUIA_PAINEL_RH_ASSINATURA.md",
    "GUIA_PASSO_A_PASSO.md",
    "GUIA_RAPIDO.txt",
    "GUIA_SISTEMA_RECIBOS.md",
    "GUIA_TESTE_RECIBOS.md",
    "IMPLEMENTACAO_ABA_RECIBOS.md",
    "IMPLEMENTACAO_COMPLETA.md",
    "INDICE_RECIBOS.md",
    "INFORME_IR_IMPLEMENTADO.md",
    "INSTRUCOES-INTEGRACAO.md",
    "LIMPAR-BANCO-DADOS.md",
    "LIMPAR_CACHE_NAVEGADOR.md",
    "PASSO_A_PASSO_DEBUG.md",
    "PORTAL-COLABORADOR-GUIA.md",
    "PREPARAR-GITHUB.md",
    "PRIMEIRO_ACESSO_RESUMO.md",
    "PROBLEMA_RESOLVIDO.md",
    "QUICK-START.md",
    "README_RECIBOS.md",
    "RECIBO-DIGITAL-COMPLETO.md",
    "RESUMO-ARQUIVOS-CRIADOS.md",
    "RESUMO-CONFIGURACAO.md",
    "RESUMO-IMPLEMENTACAO.md",
    "RESUMO_SISTEMA_BLOQUEIO.md",
    "SCRIPTS-SQL-SUPABASE.md",
    "SETUP-RAPIDO-LOCAL.md",
    "SISTEMA-NOTIFICACOES-TOAST.md",
    "SISTEMA_BLOQUEIO_IMPLEMENTADO.md",
    "SISTEMA_PRIMEIRO_ACESSO.md",
    "SOLUCAO_CADEADO_NAO_APARECE.md",
    "SOLUCAO_DEFINITIVA_V3.2.md",
    "SOLUCAO_DOWNLOAD_PDF.md",
    "SOLUCAO_FINAL_V3.3.md",
    "TESTAR_BLOQUEIO_V3.1.md",
    "TESTE-RECIBO-IMPRESSAO.md",
    "TESTE_INFORME_IR_RAPIDO.md",
    "TESTE_RAPIDO_BLOQUEIO.md",
    "TESTE_RAPIDO_RECIBOS.md",
    "TROUBLESHOOTING_PRIMEIRO_ACESSO.md"
)

foreach ($arquivo in $docs) {
    if (Test-Path $arquivo) {
        try {
            Move-Item $arquivo "_ARQUIVADOS\documentacao\" -Force
            Write-Host "  ✅ $arquivo" -ForegroundColor Green
            $movidos++
        } catch {
            Write-Host "  ❌ Erro ao mover $arquivo" -ForegroundColor Red
            $erros++
        }
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# RESUMO FINAL
# ═══════════════════════════════════════════════════════════════════════════

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  RESUMO DO ARQUIVAMENTO" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "  ✅ Arquivos movidos: $movidos" -ForegroundColor Green
Write-Host "  ❌ Erros: $erros" -ForegroundColor Red
Write-Host ""
Write-Host "Localizacao: _ARQUIVADOS\" -ForegroundColor Yellow
Write-Host ""
Write-Host "⚠️  IMPORTANTE:" -ForegroundColor Yellow
Write-Host "  - Teste o sistema por 1-2 dias" -ForegroundColor White
Write-Host "  - Se tudo funcionar bem, pode deletar a pasta _ARQUIVADOS" -ForegroundColor White
Write-Host "  - Para restaurar, basta mover os arquivos de volta" -ForegroundColor White
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

pause
