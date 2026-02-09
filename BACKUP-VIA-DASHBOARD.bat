@echo off
title ISIBA - Backup via Dashboard
color 0B
chcp 65001 >nul

cls
echo.
echo ========================================================
echo   BACKUP VIA DASHBOARD SUPABASE
echo ========================================================
echo.
echo Devido a restricoes de firewall, o CLI nao consegue
echo conectar diretamente ao banco via porta 5432.
echo.
echo SOLUCAO: Usar o Dashboard para fazer backup!
echo.
echo ========================================================
echo   PASSO A PASSO:
echo ========================================================
echo.
echo 1. O navegador vai abrir automaticamente
echo 2. Va em Database ^> Backups
echo 3. Clique em "Create backup"
echo 4. Aguarde o backup ser criado
echo 5. Clique em "Download" para baixar
echo.
echo ========================================================
echo.
pause

echo.
echo [1/2] Abrindo Dashboard PRODUCAO...
start https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/database/backups
timeout /t 2 /nobreak >nul

echo [2/2] Abrindo Dashboard DESENVOLVIMENTO...
start https://supabase.com/dashboard/project/ikwnemhqqkpjurdpauim/database/backups
timeout /t 2 /nobreak >nul

echo.
echo ========================================================
echo   DASHBOARDS ABERTOS!
echo ========================================================
echo.
echo Siga os passos em cada aba do navegador:
echo   1. Database ^> Backups
echo   2. Create backup
echo   3. Aguarde processamento
echo   4. Download
echo.
echo ========================================================
echo.
pause
