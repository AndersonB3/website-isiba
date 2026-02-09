# ═══════════════════════════════════════════════════════════════════════════
# INSTALADOR SIMPLIFICADO DO SUPABASE CLI
# Versão 2: Download direto do executável
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  INSTALANDO SUPABASE CLI v2" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# URL direto do executável (GitHub release)
$version = "v2.75.0"
$downloadUrl = "https://github.com/supabase/cli/releases/download/$version/supabase_windows_amd64.tar.gz"

Write-Host "Versão: $version" -ForegroundColor Yellow
Write-Host "Baixando de: GitHub Releases" -ForegroundColor Gray
Write-Host ""

try {
    # Criar pasta de instalação
    $installDir = "$env:LOCALAPPDATA\supabase"
    if (-not (Test-Path $installDir)) {
        New-Item -ItemType Directory -Path $installDir | Out-Null
    }
    
    Write-Host "Baixando Supabase CLI..." -ForegroundColor Yellow
    $tarPath = "$env:TEMP\supabase.tar.gz"
    
    # Baixar com barra de progresso
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tarPath
    $ProgressPreference = 'Continue'
    
    Write-Host "✓ Download concluído! (30 MB)" -ForegroundColor Green
    Write-Host ""
    Write-Host "Extraindo..." -ForegroundColor Yellow
    
    # Extrair usando tar do Windows
    $extractDir = "$env:TEMP\supabase-extract"
    if (Test-Path $extractDir) {
        Remove-Item $extractDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $extractDir | Out-Null
    
    # Usar tar.exe nativo do Windows 10+
    & tar.exe -xzf $tarPath -C $extractDir
    
    # Procurar pelo executável
    $exePath = Get-ChildItem -Path $extractDir -Filter "supabase.exe" -Recurse | Select-Object -First 1
    
    if ($exePath) {
        # Copiar para pasta de instalação
        Copy-Item $exePath.FullName -Destination "$installDir\supabase.exe" -Force
        Write-Host "✓ Instalado em: $installDir\supabase.exe" -ForegroundColor Green
    } else {
        Write-Host "Erro: supabase.exe não encontrado no arquivo!" -ForegroundColor Red
        Write-Host "Conteúdo extraído:" -ForegroundColor Yellow
        Get-ChildItem $extractDir -Recurse | ForEach-Object { Write-Host "  - $($_.FullName)" -ForegroundColor Gray }
        exit 1
    }
    
    # Limpar
    Remove-Item $tarPath -Force
    Remove-Item $extractDir -Recurse -Force
    
    # Configurar PATH
    Write-Host ""
    Write-Host "Configurando PATH..." -ForegroundColor Yellow
    
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$installDir*") {
        $newPath = "$currentPath;$installDir"
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        Write-Host "✓ PATH atualizado!" -ForegroundColor Green
    } else {
        Write-Host "✓ PATH já configurado!" -ForegroundColor Green
    }
    
    # Adicionar ao PATH da sessão atual
    $env:Path = "$env:Path;$installDir"
    
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host "  ✓ INSTALAÇÃO CONCLUÍDA!" -ForegroundColor Green
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Testar
    Write-Host "Testando instalação..." -ForegroundColor Yellow
    & "$installDir\supabase.exe" --version
    
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host "  PRÓXIMOS PASSOS:" -ForegroundColor Cyan
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. FECHE E REABRA O VS CODE (para carregar novo PATH)" -ForegroundColor Yellow
    Write-Host "2. Execute: supabase login" -ForegroundColor White
    Write-Host "3. Use os scripts de automação criados!" -ForegroundColor White
    Write-Host ""
    Write-Host "IMPORTANTE: Você PRECISA fechar e reabrir o VS Code!" -ForegroundColor Red
    Write-Host ""
    
} catch {
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Red
    Write-Host "  ERRO NA INSTALAÇÃO" -ForegroundColor Red
    Write-Host "========================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Erro: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "INSTALAÇÃO MANUAL:" -ForegroundColor Yellow
    Write-Host "1. Acesse: https://github.com/supabase/cli/releases/tag/v2.75.0" -ForegroundColor White
    Write-Host "2. Baixe: supabase_windows_amd64.tar.gz" -ForegroundColor White
    Write-Host "3. Extraia com: tar -xzf supabase_windows_amd64.tar.gz" -ForegroundColor White
    Write-Host "4. Copie supabase.exe para C:\Users\Usuario\AppData\Local\supabase" -ForegroundColor White
    Write-Host ""
}

Write-Host "Pressione Enter para continuar..." -ForegroundColor Gray
Read-Host
