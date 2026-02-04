# ════════════════════════════════════════════════════════════════
# 🧹 SCRIPT DE LIMPEZA DO PROJETO - REMOVER ARQUIVOS DESNECESSÁRIOS
# ════════════════════════════════════════════════════════════════
# Execute no PowerShell: .\LIMPAR_PROJETO.ps1
# ════════════════════════════════════════════════════════════════

Write-Host "🧹 Iniciando limpeza do projeto..." -ForegroundColor Cyan

# Arquivos SQL antigos/de teste (mantém apenas os essenciais)
$arquivos_sql_deletar = @(
    "ADD_ASSINATURA_DIGITAL.sql",
    "ADICIONAR_CAMPO_CODIGO.sql",
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
    "LIMPAR_TESTES_ANTES_SEGURANCA.sql",
    "POLITICAS_STORAGE.sql",
    "SISTEMA_RECIBOS.sql",
    "SISTEMA_RECIBOS_LIMPO.sql",
    "SISTEMA_RECIBOS_PASSO_A_PASSO.sql",
    "SQL-ADMIN-TABLE.sql",
    "VERIFICACAO_URGENTE.sql",
    "VERIFICAR_E_CORRIGIR_TESTE.sql",
    "VERIFICAR_PERMISSOES_STORAGE.sql",
    "VERIFICAR_POLITICA_DETALHES.sql",
    "VERIFICAR_VIEW_ASSINATURA.sql"
)

# Arquivos MD de documentação antiga
$arquivos_md_deletar = @(
    "APRESENTACAO_RECIBOS.md",
    "AUTENTICACAO-ADMIN.md",
    "CHANGELOG-V3.3.md",
    "COMANDOS-GIT.md",
    "COMO-FUNCIONA-UPLOAD-LOTE.md",
    "CONVERSAO-GITHUB-PAGES.md",
    "CORRECAO-ASSINATURA-V3.2.md",
    "DEPLOY_GITHUB_PAGES_COMPLETO.md",
    "DIAGNOSTICO_DOWNLOAD.md",
    "DIAGNOSTICO_UPDATE_V3.6.md",
    "FIX_2_PROBLEMAS_V3.5.md",
    "FIX_3_PROBLEMAS_V3.4.md",
    "FIX_CARROSSEL_GITHUB_PAGES.md",
    "GUIA-DEBUG-ASSINATURA.md",
    "GUIA_ASSINATURA_DIGITAL.md",
    "GUIA_ATUALIZACAO_HOSTINGER.md",
    "GUIA_HOSPEDAGEM_HOSTINGER.md",
    "GUIA_PAINEL_RH_ASSINATURA.md",
    "GUIA_PASSO_A_PASSO.md",
    "GUIA_RAPIDO_TESTE_LOCAL.md",
    "GUIA_SISTEMA_RECIBOS.md",
    "GUIA_TESTE_RECIBOS.md",
    "GUIA_TESTE_UPLOAD_LOTE.md",
    "GUIA_UPLOAD_INTELIGENTE.md",
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
    "RESUMO-IMPLEMENTACAO.md",
    "RESUMO_SISTEMA_BLOQUEIO.md",
    "SCRIPTS-SQL-SUPABASE.md",
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

# Arquivos TXT/outros antigos
$arquivos_outros_deletar = @(
    "ATUALIZACAO_FILTRO_PORTAL.txt",
    "ATUALIZACAO_SISTEMA_IR.md",
    "GUIA_RAPIDO.txt"
)

# HTML de teste/debug
$arquivos_html_deletar = @(
    "debug-login.html",
    "debug-senha.html",
    "demo-recibos.html",
    "GERAR-PDF-TESTE-2.html",
    "GERAR-PDF-TESTE.html",
    "portal-colaborador-NOVO.html",
    "primeiro-acesso.html",
    "teste-formsubmit.html",
    "teste-hash.html",
    "teste-toast.html",
    "upload-inteligente-teste.html"
)

# Scripts PowerShell antigos
$arquivos_ps1_deletar = @(
    "ATUALIZAR-HOSTINGER.ps1",
    "PREPARAR-DEPLOY-HOSTINGER.ps1"
)

# Contadores
$total_deletados = 0
$total_erros = 0

# Função para deletar arquivo com verificação
function Deletar-Arquivo {
    param($arquivo)
    
    $caminho = Join-Path $PSScriptRoot $arquivo
    
    if (Test-Path $caminho) {
        try {
            Remove-Item $caminho -Force
            Write-Host "  ✅ Deletado: $arquivo" -ForegroundColor Green
            return $true
        } catch {
            Write-Host "  ❌ Erro ao deletar: $arquivo" -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "  ⚠️  Não encontrado: $arquivo" -ForegroundColor Yellow
        return $null
    }
}

# Deletar arquivos SQL
Write-Host "`n📁 Deletando arquivos SQL antigos..." -ForegroundColor Cyan
foreach ($arquivo in $arquivos_sql_deletar) {
    $resultado = Deletar-Arquivo $arquivo
    if ($resultado -eq $true) { $total_deletados++ }
    elseif ($resultado -eq $false) { $total_erros++ }
}

# Deletar arquivos MD
Write-Host "`n📁 Deletando arquivos MD de documentação antiga..." -ForegroundColor Cyan
foreach ($arquivo in $arquivos_md_deletar) {
    $resultado = Deletar-Arquivo $arquivo
    if ($resultado -eq $true) { $total_deletados++ }
    elseif ($resultado -eq $false) { $total_erros++ }
}

# Deletar arquivos outros
Write-Host "`n📁 Deletando outros arquivos antigos..." -ForegroundColor Cyan
foreach ($arquivo in $arquivos_outros_deletar) {
    $resultado = Deletar-Arquivo $arquivo
    if ($resultado -eq $true) { $total_deletados++ }
    elseif ($resultado -eq $false) { $total_erros++ }
}

# Deletar HTML de teste
Write-Host "`n📁 Deletando arquivos HTML de teste..." -ForegroundColor Cyan
foreach ($arquivo in $arquivos_html_deletar) {
    $resultado = Deletar-Arquivo $arquivo
    if ($resultado -eq $true) { $total_deletados++ }
    elseif ($resultado -eq $false) { $total_erros++ }
}

# Deletar scripts PowerShell antigos
Write-Host "`n📁 Deletando scripts PowerShell antigos..." -ForegroundColor Cyan
foreach ($arquivo in $arquivos_ps1_deletar) {
    $resultado = Deletar-Arquivo $arquivo
    if ($resultado -eq $true) { $total_deletados++ }
    elseif ($resultado -eq $false) { $total_erros++ }
}

# Limpar pasta painel-rh (arquivos duplicados)
Write-Host "`n📁 Limpando pasta painel-rh..." -ForegroundColor Cyan
$painel_rh_deletar = @(
    "painel-rh\COMO-VERIFICAR-BANCO.md",
    "painel-rh\CRIAR-PDF-TESTE.md",
    "painel-rh\FUNCIONALIDADE-EDICAO.md",
    "painel-rh\GERENCIAR-CONTRACHEQUES.md",
    "painel-rh\GUIA-DE-TESTES.md",
    "painel-rh\GUIA-RAPIDO-CORRIGIR-PDF.md",
    "painel-rh\GUIA-RAPIDO.md",
    "painel-rh\INICIAR-PAINEL.bat"
)

foreach ($arquivo in $painel_rh_deletar) {
    $resultado = Deletar-Arquivo $arquivo
    if ($resultado -eq $true) { $total_deletados++ }
    elseif ($resultado -eq $false) { $total_erros++ }
}

# Resumo final
Write-Host "`n" -NoNewline
Write-Host "════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "✅ LIMPEZA CONCLUÍDA!" -ForegroundColor Green
Write-Host "════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "📊 Total de arquivos deletados: $total_deletados" -ForegroundColor Green
Write-Host "❌ Total de erros: $total_erros" -ForegroundColor $(if ($total_erros -gt 0) { "Red" } else { "Green" })
Write-Host "════════════════════════════════════════════════════════" -ForegroundColor Cyan

Write-Host "`n📝 Arquivos MANTIDOS (essenciais):" -ForegroundColor Yellow
Write-Host "  ✅ index.html" -ForegroundColor Green
Write-Host "  ✅ portal-colaborador.html" -ForegroundColor Green
Write-Host "  ✅ admin-rh.html" -ForegroundColor Green
Write-Host "  ✅ colaborador.html" -ForegroundColor Green
Write-Host "  ✅ relatorio.html" -ForegroundColor Green
Write-Host "  ✅ trabalhe-conosco.html" -ForegroundColor Green
Write-Host "  ✅ meus-contracheques.html" -ForegroundColor Green
Write-Host "  ✅ assets/ (todos os JS, CSS, imagens)" -ForegroundColor Green
Write-Host "  ✅ database/ (schemas importantes)" -ForegroundColor Green
Write-Host "  ✅ README.md (documentação principal)" -ForegroundColor Green
Write-Host "  ✅ URGENTE_SEGURANCA_RLS_STORAGE.sql (segurança)" -ForegroundColor Green
Write-Host "  ✅ .git/ .github/ .gitignore (controle de versão)" -ForegroundColor Green

Write-Host "`n🚀 Reinicie o VS Code para aplicar as mudanças!" -ForegroundColor Cyan
Write-Host "   Comando: Feche o VS Code e abra novamente" -ForegroundColor Yellow

# Pausar para ver resultados
Write-Host "`nPressione qualquer tecla para fechar..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
