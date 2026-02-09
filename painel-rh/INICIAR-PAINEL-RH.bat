@echo off
title Painel RH - Servidor Node.js (Porta 3000)
echo.
echo ========================================
echo   PAINEL RH - SERVIDOR NODE.JS
echo ========================================
echo.
cd painel-rh
echo Verificando dependencias...
echo.

if not exist "node_modules\" (
    echo Instalando dependencias do Node.js...
    call npm install
    echo.
)

echo Iniciando servidor Node.js na porta 3000...
echo.
echo URL: http://localhost:3000
echo.
echo Pressione Ctrl+C para parar o servidor
echo ========================================
echo.

node server.js

pause
