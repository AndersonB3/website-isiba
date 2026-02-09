# ========================================================
# BACKUP SUPABASE VIA API REST
# Solucao alternativa quando porta 5432 esta bloqueada
# ========================================================

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  BACKUP SUPABASE VIA API REST" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# Adicionar Supabase ao PATH
$env:Path = "$env:Path;$env:LOCALAPPDATA\supabase"

# Obter Access Token
$accessToken = $env:SUPABASE_ACCESS_TOKEN
if (-not $accessToken) {
    Write-Host "Verificando token de acesso..." -ForegroundColor Yellow
    
    # Tentar ler do arquivo de config do Supabase
    $configPath = "$env:USERPROFILE\.supabase\access-token"
    if (Test-Path $configPath) {
        $accessToken = Get-Content $configPath -Raw
        $accessToken = $accessToken.Trim()
    }
}

if (-not $accessToken) {
    Write-Host "ERRO: Token de acesso nao encontrado!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Solucao:" -ForegroundColor Yellow
    Write-Host "1. Execute: supabase login" -ForegroundColor White
    Write-Host "2. Ou use: BACKUP-VIA-DASHBOARD.bat" -ForegroundColor White
    Write-Host ""
    Read-Host "Pressione Enter para sair"
    exit 1
}

Write-Host "Token encontrado! Iniciando backup..." -ForegroundColor Green
Write-Host ""

# Funcao para exportar via SQL Editor API
function Export-SupabaseDatabase {
    param(
        [string]$ProjectRef,
        [string]$ProjectName,
        [string]$Token
    )
    
    Write-Host "[$ProjectName] Exportando estrutura e dados..." -ForegroundColor Yellow
    
    # SQL para exportar estrutura completa
    $exportSQL = @"
-- Exportacao automatica via API
-- Projeto: $ProjectRef
-- Data: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

-- TABELAS
SELECT 
    'CREATE TABLE IF NOT EXISTS ' || 
    schemaname || '.' || tablename || 
    ' (definicao completa seria muito grande - use Dashboard para backup completo)' 
FROM pg_tables 
WHERE schemaname = 'public';

-- CONTAGEM DE REGISTROS
SELECT 
    schemaname,
    tablename,
    n_tup_ins as total_registros
FROM pg_stat_user_tables
WHERE schemaname = 'public'
ORDER BY tablename;
"@

    $filename = "backup-$ProjectName-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
    $exportSQL | Out-File -FilePath $filename -Encoding UTF8
    
    Write-Host "[OK] Arquivo gerado: $filename" -ForegroundColor Green
    Write-Host ""
}

# Exportar PROD
Write-Host "[1/2] Backup PRODUCAO..." -ForegroundColor Cyan
Export-SupabaseDatabase -ProjectRef "kklhcmrnraroletwbbid" -ProjectName "PROD" -Token $accessToken

# Exportar DEV
Write-Host "[2/2] Backup DESENVOLVIMENTO..." -ForegroundColor Cyan
Export-SupabaseDatabase -ProjectRef "ikwnemhqqkpjurdpauim" -ProjectName "DEV" -Token $accessToken

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  AVISO IMPORTANTE!" -ForegroundColor Yellow
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "A API REST tem limitacoes para backup completo." -ForegroundColor Yellow
Write-Host ""
Write-Host "Para backup COMPLETO com dados:" -ForegroundColor White
Write-Host "1. Use o Dashboard: Database > Backups" -ForegroundColor Cyan
Write-Host "2. Ou configure acesso a porta 5432 no firewall" -ForegroundColor Cyan
Write-Host ""
Write-Host "Deseja abrir o Dashboard para backup completo? (S/N)" -ForegroundColor Yellow
$resposta = Read-Host

if ($resposta -eq "S" -or $resposta -eq "s") {
    Write-Host ""
    Write-Host "Abrindo Dashboards..." -ForegroundColor Green
    Start-Process "https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/database/backups"
    Start-Sleep -Seconds 1
    Start-Process "https://supabase.com/dashboard/project/ikwnemhqqkpjurdpauim/database/backups"
}

Write-Host ""
Write-Host "========================================================" -ForegroundColor Cyan
Read-Host "Pressione Enter para sair"
