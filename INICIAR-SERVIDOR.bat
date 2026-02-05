@echo off
title Website ISIBA - Servidor Local (Porta 8000)
echo.
echo ========================================
echo   WEBSITE ISIBA - SERVIDOR LOCAL
echo ========================================
echo.
echo Iniciando servidor na porta 8000...
echo.
echo URL: http://localhost:8000
echo.
echo Pressione Ctrl+C para parar o servidor
echo ========================================
echo.

python -m http.server 8000

pause
