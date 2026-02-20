# Script para remover arquivos desnecessários do repositório
# Execute: .\LIMPAR_ARQUIVOS.ps1

Write-Host "🧹 LIMPANDO ARQUIVOS DESNECESSÁRIOS" -ForegroundColor Cyan
Write-Host "=" * 70

# Arquivos SQL de desenvolvimento/teste (manter apenas os essenciais)
$sqlParaRemover = @(
    "ADD_ASSINATURA_DIGITAL.sql",
    "ADICIONAR_COLUNA_ASSINATURA.sql",
    "ADICIONAR_PRIMEIRO_ACESSO.sql",
    "ATUALIZAR_DOCUMENTOS_BLOQUEIO.sql",
    "ATUALIZAR_SENHA.sql",
    "BLOQUEAR_RAPIDO.sql",
    "BLOQUEAR_TODOS_DOCUMENTOS.sql",
    "CORRIGIR_POLITICAS_RLS.sql",
    "CRIAR_ADMIN_SEGURO.sql",
    "DEBUG-ASSINATURA-VIEW.sql",
    "DEBUG_USUARIO_TESTE.sql",
    "DIAGNOSTICO_BLOQUEIO.sql",
    "EXECUTAR-TUDO-UMA-VEZ.sql",
    "FIX-VIEW-ASSINATURA.sql",
    "FORCAR_PRIMEIRO_ACESSO_TRUE.sql",
    "LIMPAR_RAPIDO_SIMPLES.sql",
    "LIMPAR_RECIBOS_E_BLOQUEAR.sql",
    "SCRIPT-COPIAR-DADOS.sql",
    "SISTEMA_RECIBOS.sql",
    "SISTEMA_RECIBOS_LIMPO.sql",
    "SISTEMA_RECIBOS_PASSO_A_PASSO.sql",
    "VERIFICACAO_URGENTE.sql",
    "VERIFICAR_BANCO.sql",
    "VERIFICAR_POLITICA_DETALHES.sql",
    "VERIFICAR_VIEW_ASSINATURA.sql"
)

# Arquivos BAT de desenvolvimento
$batParaRemover = @(
    "BACKUP-API-REST.ps1",
    "BACKUP-AUTOMATICO.bat",
    "BACKUP-BANCOS.bat",
    "BACKUP-VIA-DASHBOARD.bat",
    "COMPARAR-BANCOS.bat",
    "COMPARAR-ESTRUTURAS-AUTO.bat",
    "COPIAR-PROD-PARA-DEV.bat",
    "EXECUTAR-LIMPEZA-ORGANIZADA.bat",
    "EXECUTAR-SIMPLIFICACAO.bat",
    "GERENCIAR-SUPABASE.bat",
    "INICIAR-AMBIENTE-LOCAL.md",
    "INICIAR-PAINEL-RH.bat",
    "INICIAR-SERVIDOR.bat",
    "INICIAR-TUDO.bat",
    "instalar-cli-auto.ps1",
    "INSTALAR-SUPABASE-AUTOMATICO.bat",
    "INSTALAR-SUPABASE-CLI.bat",
    "INSTALAR-SUPABASE-CLI.ps1",
    "INSTALAR-SUPABASE-CLI-V2.ps1",
    "LOGIN-SUPABASE.bat",
    "MENU-SUPABASE.bat",
    "SINCRONIZAR-ESTRUTURA.bat",
    "SUPABASE-CLI-POWERSHELL.ps1",
    "VER-ARQUITETURA.bat",
    "VERIFICAR-BANCO-DEVELOP.bat",
    "_ARQUIVAR_ARQUIVOS.ps1"
)

# Arquivos MD de desenvolvimento/análise
$mdParaRemover = @(
    "ANALISE-LIMPEZA-ARQUIVOS.md",
    "ANALISE-POLITICAS-RLS.md",
    "ARQUITETURA-BRANCHES-BANCOS.md",
    "AUTOMACAO-COMPLETA-RESUMO.md",
    "AUTOMACAO-SUPABASE-RESUMO.md",
    "CONFIGURAR-AMBIENTES.md",
    "COPIAR-DADOS-PRODUCAO.md",
    "CORRECAO-LOADER.md",
    "CORRECAO-SCRIPTS.md",
    "DIVISAO-PDF-COMPILADO.md",
    "FIX-CONEXAO-DEVELOP.md",
    "FIX-LOGIN-RLS.md",
    "GERENCIAR-SUPABASE-GUIA.md",
    "GIT-WORKFLOW.md",
    "GUIA-AMBIENTES.md",
    "GUIA-API-SUPABASE.md",
    "GUIA-BACKUP-DASHBOARD.md",
    "GUIA-CLONAR-BANCO-COMPLETO.md",
    "GUIA-COMPARAR-BANCOS.md",
    "GUIA-COPIAR-DADOS-PROD-DEV.md",
    "GUIA-COPIAR-POLITICAS-RLS.md",
    "GUIA-RAPIDO-CLONAR.md",
    "GUIA-SUPABASE-CLI.md",
    "GUIA-TESTES-COMPLETO.md",
    "INSTALAR-SUPABASE-CLI-MANUAL.md",
    "MERGE-MASTER-DEVELOP.md",
    "NOVO-FLUXO-SIMPLIFICADO.md",
    "PLANO-LIMPEZA-2026-02-09.md",
    "PLANO-SIMPLIFICACAO.md",
    "PROBLEMA-FIREWALL-5432.md",
    "QUICK-START-DEV.md",
    "RESULTADO-LIMPEZA.md",
    "RESUMO-ARQUIVOS-CRIADOS.md",
    "RESUMO-CONFIGURACAO.md",
    "SETUP-RAPIDO-LOCAL.md",
    "SIMPLIFICACAO-CONCLUIDA.md",
    "SINCRONIZACAO-CONCLUIDA.md",
    "STATUS-FINAL-AUTOMACAO.md",
    "SUPABASE-CLI-STATUS.md",
    "VERIFICACAO-BANCO-DEVELOP.md"
)

# Arquivos HTML duplicados/desnecessários
$htmlParaRemover = @(
    "admin-rh.html",
    "portal-colaborador.html",
    "primeiro-acesso-new.html",
    "primeiro-acesso.html"
)

# Outras extensões
$outrosParaRemover = @(
    "gerar-hash.js"
)

$totalRemovidos = 0
$totalErros = 0

# Função para remover arquivos
function Remove-FilesSafely {
    param($listaArquivos, $tipo)
    
    Write-Host "`n📁 Removendo arquivos $tipo..." -ForegroundColor Yellow
    
    foreach ($arquivo in $listaArquivos) {
        if (Test-Path $arquivo) {
            try {
                Remove-Item $arquivo -Force
                Write-Host "  ✅ Removido: $arquivo" -ForegroundColor Green
                $script:totalRemovidos++
            } catch {
                Write-Host "  ❌ Erro ao remover: $arquivo" -ForegroundColor Red
                $script:totalErros++
            }
        } else {
            Write-Host "  ⚠️  Não encontrado: $arquivo" -ForegroundColor Gray
        }
    }
}

# Executar remoções
Remove-FilesSafely $sqlParaRemover "SQL"
Remove-FilesSafely $batParaRemover "BAT/PS1"
Remove-FilesSafely $mdParaRemover "MD"
Remove-FilesSafely $htmlParaRemover "HTML"
Remove-FilesSafely $outrosParaRemover "OUTROS"

Write-Host "`n" + ("=" * 70)
Write-Host "📊 RESUMO:" -ForegroundColor Cyan
Write-Host "  ✅ Arquivos removidos: $totalRemovidos" -ForegroundColor Green
Write-Host "  ❌ Erros: $totalErros" -ForegroundColor Red
Write-Host "`n🎯 Arquivos mantidos (essenciais):" -ForegroundColor Cyan
Write-Host "  - README.md" -ForegroundColor White
Write-Host "  - DEPLOY-GUIA-COMPLETO.md" -ForegroundColor White
Write-Host "  - DEPLOY-CHECKLIST.md" -ForegroundColor White
Write-Host "  - AUTENTICACAO-SEGURA.md" -ForegroundColor White
Write-Host "  - SOLUCAO-RAPIDA-LOGIN.md" -ForegroundColor White
Write-Host "  - teste-hash.html" -ForegroundColor White
Write-Host "  - index.html, colaborador.html, trabalhe-conosco.html, relatorio.html" -ForegroundColor White
Write-Host "  - Diretórios: painel-rh/, assets/, database/, docs/" -ForegroundColor White

Write-Host "`n✅ Limpeza concluída!" -ForegroundColor Green
Write-Host "`n⚠️  PRÓXIMO PASSO: Execute git status para revisar" -ForegroundColor Yellow
