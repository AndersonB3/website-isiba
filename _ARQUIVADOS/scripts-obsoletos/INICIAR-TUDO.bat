@echo off
title ISIBA - Iniciar TODOS os Servidores
color 0A
echo.
echo ========================================
echo   ISIBA - INICIAR AMBIENTE LOCAL
echo ========================================
echo.
echo Este script vai iniciar:
echo  1. Website ISIBA (porta 8000)
echo  2. Painel RH (porta 3000)
echo.
echo ========================================
echo.
pause

echo.
echo [1/2] Iniciando Website ISIBA (porta 8000)...
start "Website ISIBA - Porta 8000" cmd /k "python -m http.server 8000"
timeout /t 2 /nobreak >nul

echo [2/2] Iniciando Painel RH (porta 3000)...
start "Painel RH - Porta 3000" cmd /k "cd painel-rh && node server.js"
timeout /t 2 /nobreak >nul

echo.
echo ========================================
echo   SERVIDORES INICIADOS!
echo ========================================
echo.
echo Website ISIBA: http://localhost:8000
echo Painel RH:     http://localhost:3000
echo.
echo Para parar os servidores, feche as janelas
echo ou pressione Ctrl+C em cada uma.
echo ========================================
echo.
pause
