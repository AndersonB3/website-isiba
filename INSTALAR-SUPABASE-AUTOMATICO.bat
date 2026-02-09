@echo off
title Instalando Supabase CLI
color 0B
chcp 65001 >nul

cls
echo.
echo ========================================================
echo   INSTALADOR AUTOMÁTICO SUPABASE CLI
echo ========================================================
echo.
echo Este script vai:
echo   1. Baixar Supabase CLI do GitHub
echo   2. Extrair automaticamente
echo   3. Instalar em %LOCALAPPDATA%\supabase
echo   4. Adicionar ao PATH
echo.
echo AGUARDE... Não feche esta janela!
echo ========================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$ErrorActionPreference = 'Stop'; ^
Write-Host 'Baixando Supabase CLI...' -ForegroundColor Yellow; ^
$url = 'https://github.com/supabase/cli/releases/download/v2.75.0/supabase_windows_amd64.tar.gz'; ^
$tarPath = \"$env:TEMP\supabase.tar.gz\"; ^
Invoke-WebRequest -Uri $url -OutFile $tarPath -UseBasicParsing; ^
Write-Host 'Download concluido!' -ForegroundColor Green; ^
Write-Host 'Extraindo...' -ForegroundColor Yellow; ^
$extractPath = \"$env:TEMP\supabase-temp\"; ^
if (Test-Path $extractPath) { Remove-Item $extractPath -Recurse -Force }; ^
New-Item -ItemType Directory -Path $extractPath | Out-Null; ^
tar.exe -xzf $tarPath -C $extractPath; ^
Write-Host 'Instalando...' -ForegroundColor Yellow; ^
$installPath = \"$env:LOCALAPPDATA\supabase\"; ^
if (-not (Test-Path $installPath)) { New-Item -ItemType Directory -Path $installPath | Out-Null }; ^
Copy-Item \"$extractPath\supabase.exe\" -Destination \"$installPath\supabase.exe\" -Force; ^
Remove-Item $tarPath -Force; ^
Remove-Item $extractPath -Recurse -Force; ^
Write-Host 'Configurando PATH...' -ForegroundColor Yellow; ^
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User'); ^
if ($userPath -notlike \"*$installPath*\") { ^
    [Environment]::SetEnvironmentVariable('Path', \"$userPath;$installPath\", 'User'); ^
    Write-Host 'PATH atualizado!' -ForegroundColor Green; ^
} else { ^
    Write-Host 'PATH ja configurado!' -ForegroundColor Green; ^
}; ^
Write-Host ''; ^
Write-Host '========================================' -ForegroundColor Cyan; ^
Write-Host '  INSTALACAO CONCLUIDA!' -ForegroundColor Green; ^
Write-Host '========================================' -ForegroundColor Cyan; ^
Write-Host ''; ^
& \"$installPath\supabase.exe\" --version"

if %errorlevel% equ 0 (
    echo.
    echo ========================================================
    echo   SUCESSO! Supabase CLI instalado!
    echo ========================================================
    echo.
    echo IMPORTANTE: Feche e reabra o VS Code para usar!
    echo.
    echo Proximos passos:
    echo   1. Fechar o VS Code completamente
    echo   2. Reabrir o VS Code
    echo   3. Executar: supabase login
    echo.
) else (
    echo.
    echo ========================================================
    echo   ERRO NA INSTALACAO
    echo ========================================================
    echo.
    echo Por favor, tente a instalacao manual.
    echo Veja: INSTALAR-SUPABASE-CLI-MANUAL.md
    echo.
)

pause
