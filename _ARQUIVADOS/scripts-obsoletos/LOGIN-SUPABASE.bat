@echo off
title ISIBA - Login Supabase CLI
color 0B
chcp 65001 >nul

cls
echo.
echo ========================================================
echo   SUPABASE CLI - LOGIN
echo ========================================================
echo.
echo O Supabase CLI JA ESTA INSTALADO! (v2.75.0)
echo.
echo Para usar os comandos CLI, voce precisa fazer login.
echo.
echo ========================================================
echo   OPCAO 1: Login via Navegador (RECOMENDADO)
echo ========================================================
echo.
echo 1. O navegador vai abrir automaticamente
echo 2. Faca login na sua conta Supabase
echo 3. Clique em "Autorizar CLI"
echo 4. Volte aqui e pressione Enter
echo.
pause
echo.
echo Abrindo navegador...
start https://supabase.com/dashboard/account/tokens
echo.
echo ========================================================
echo   INSTRUCOES:
echo ========================================================
echo.
echo 1. No navegador que abriu:
echo    - Clique em "Generate new token"
echo    - Nome: "CLI Local Windows"
echo    - Copie o token gerado
echo.
echo 2. Volte aqui e cole o token abaixo
echo.
echo ========================================================
echo.
set /p token="Cole o token aqui: "

echo.
echo Configurando token...
setx SUPABASE_ACCESS_TOKEN "%token%" >nul
set SUPABASE_ACCESS_TOKEN=%token%

echo.
echo ========================================================
echo   TESTANDO CONEXAO...
echo ========================================================
echo.

REM Adicionar supabase ao PATH da sessao
set PATH=%PATH%;%LOCALAPPDATA%\supabase

supabase projects list

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================================
    echo   LOGIN REALIZADO COM SUCESSO!
    echo ========================================================
    echo.
    echo Agora voce pode usar todos os comandos CLI!
    echo.
    echo Exemplos:
    echo   supabase projects list
    echo   supabase db dump --db-url "..." ^> backup.sql
    echo.
) else (
    echo.
    echo ========================================================
    echo   ERRO NO LOGIN
    echo ========================================================
    echo.
    echo Token invalido ou expirado.
    echo Tente novamente ou use: supabase login
    echo.
)

pause
