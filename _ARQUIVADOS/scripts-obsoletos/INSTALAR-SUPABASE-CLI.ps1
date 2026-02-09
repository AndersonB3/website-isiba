# ═══════════════════════════════════════════════════════════════════════════
# INSTALADOR AUTOMÁTICO DO SUPABASE CLI
# Baixa e instala o Supabase CLI sem precisar de Scoop ou npm
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  INSTALANDO SUPABASE CLI" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# Detectar arquitetura
$arch = if ([Environment]::Is64BitOperatingSystem) { "windows-x64" } else { "windows-x86" }
Write-Host "Arquitetura detectada: $arch" -ForegroundColor Yellow

# URL do release mais recente
$latestReleaseUrl = "https://api.github.com/repos/supabase/cli/releases/latest"
Write-Host "Buscando versão mais recente..." -ForegroundColor Yellow

try {
    # Buscar informações da release
    $release = Invoke-RestMethod -Uri $latestReleaseUrl
    $version = $release.tag_name
    Write-Host "Versão encontrada: $version" -ForegroundColor Green
    
    # Encontrar o asset correto (Windows usa .tar.gz)
    $asset = $release.assets | Where-Object { 
        $_.name -eq "supabase_windows_amd64.tar.gz"
    } | Select-Object -First 1
    
    if (-not $asset) {
        Write-Host "Erro: Asset para Windows não encontrado!" -ForegroundColor Red
        Write-Host "Assets disponíveis:" -ForegroundColor Yellow
        $release.assets | ForEach-Object { Write-Host "  - $($_.name)" -ForegroundColor Gray }
        exit 1
    }
    
    $downloadUrl = $asset.browser_download_url
    $fileName = $asset.name
    
    Write-Host ""
    Write-Host "Baixando: $fileName" -ForegroundColor Yellow
    Write-Host "URL: $downloadUrl" -ForegroundColor Gray
    
    # Criar pasta temporária
    $tempDir = "$env:TEMP\supabase-cli"
    if (Test-Path $tempDir) {
        Remove-Item $tempDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $tempDir | Out-Null
    
    # Baixar arquivo
    $tarGzPath = "$tempDir\$fileName"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tarGzPath
    Write-Host "✓ Download concluído!" -ForegroundColor Green
    
    # Extrair .tar.gz (precisa de 2 passos: gz -> tar -> files)
    Write-Host ""
    Write-Host "Extraindo arquivos..." -ForegroundColor Yellow
    
    # Usar tar nativo do Windows 10+
    $tarExe = "C:\Windows\System32\tar.exe"
    if (Test-Path $tarExe) {
        & $tarExe -xzf $tarGzPath -C $tempDir
    } else {
        Write-Host "Erro: tar.exe não encontrado. Windows 10+ é necessário." -ForegroundColor Red
        exit 1
    }
    
    # Criar pasta de instalação
    $installDir = "$env:LOCALAPPDATA\supabase"
    if (-not (Test-Path $installDir)) {
        New-Item -ItemType Directory -Path $installDir | Out-Null
    }
    
    # Copiar executável
    Copy-Item "$tempDir\supabase.exe" -Destination "$installDir\supabase.exe" -Force
    Write-Host "✓ Instalado em: $installDir" -ForegroundColor Green
    
    # Adicionar ao PATH
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
    
    # Limpar temporários
    Remove-Item $tempDir -Recurse -Force
    
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host "  ✓ INSTALAÇÃO CONCLUÍDA!" -ForegroundColor Green
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Testando instalação..." -ForegroundColor Yellow
    
    & "$installDir\supabase.exe" --version
    
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host "  PRÓXIMOS PASSOS:" -ForegroundColor Cyan
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Feche e reabra o terminal (para carregar novo PATH)" -ForegroundColor White
    Write-Host "2. Execute: supabase login" -ForegroundColor Yellow
    Write-Host "3. Use os scripts de automação:" -ForegroundColor White
    Write-Host "   - SINCRONIZAR-ESTRUTURA-AUTO.bat" -ForegroundColor Cyan
    Write-Host "   - BACKUP-BANCOS-AUTO.bat" -ForegroundColor Cyan
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
    Write-Host "1. Acesse: https://github.com/supabase/cli/releases" -ForegroundColor White
    Write-Host "2. Baixe: supabase_windows-x64.zip" -ForegroundColor White
    Write-Host "3. Extraia e adicione ao PATH" -ForegroundColor White
    Write-Host ""
}

Write-Host "Pressione Enter para continuar..." -ForegroundColor Gray
Read-Host
