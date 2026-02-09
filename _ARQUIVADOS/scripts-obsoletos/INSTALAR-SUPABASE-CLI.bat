@echo off
title ISIBA - Instalar Supabase CLI
color 0B
chcp 65001 >nul

cls
echo.
echo ========================================================
echo   INSTALADOR SUPABASE CLI
echo ========================================================
echo.
echo Este script vai:
echo   1. Baixar o Supabase CLI mais recente
echo   2. Instalar em %LOCALAPPDATA%\supabase
echo   3. Adicionar ao PATH automaticamente
echo.
echo Não precisa de npm, Scoop ou outras ferramentas!
echo.
echo ========================================================
echo.
pause

echo.
echo Iniciando instalação...
echo.

powershell -ExecutionPolicy Bypass -File "INSTALAR-SUPABASE-CLI.ps1"

pause
