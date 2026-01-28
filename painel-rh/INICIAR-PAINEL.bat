@echo off
title Painel RH - ISIBA Social
color 0A

echo ========================================
echo   PAINEL ADMINISTRATIVO RH
echo   ISIBA Social
echo ========================================
echo.

REM Verificar se Node.js está instalado
where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERRO] Node.js nao encontrado!
    echo.
    echo Por favor, instale o Node.js:
    echo https://nodejs.org/
    echo.
    pause
    exit
)

echo [OK] Node.js encontrado
echo.

REM Verificar se as dependências estão instaladas
if not exist "node_modules" (
    echo [INFO] Instalando dependencias...
    echo.
    call npm install
    echo.
)

echo [INFO] Iniciando servidor na porta 3001...
echo.
echo ========================================
echo   Pressione Ctrl+C para parar
echo ========================================
echo.

REM Iniciar servidor
node server.js

pause
