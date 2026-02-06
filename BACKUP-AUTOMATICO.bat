@echo off
title ISIBA - Backup Automatico Supabase
color 0B
chcp 65001 >nul

REM Adicionar Supabase ao PATH
set PATH=%PATH%;%LOCALAPPDATA%\supabase

cls
echo.
echo ========================================================
echo   BACKUP AUTOMATICO DOS BANCOS SUPABASE
echo ========================================================
echo.
echo Este script vai criar backups completos de:
echo   1. Banco PRODUCAO (kklhcmrnraroletwbbid)
echo   2. Banco DESENVOLVIMENTO (ikwnemhqqkpjurdpauim)
echo.
echo Os backups serao salvos com timestamp na pasta atual.
echo.
echo ========================================================
echo.
pause

echo.
echo [1/2] Fazendo backup do banco PRODUCAO...
echo.

REM Gerar nome do arquivo com timestamp
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set TIMESTAMP=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%
set BACKUP_PROD=backup-PROD-%TIMESTAMP%.sql

echo Conectando ao banco PRODUCAO...
echo IMPORTANTE: O CLI precisa estar linkado ao projeto!
echo.

REM Link temporário ao projeto PROD
supabase link --project-ref kklhcmrnraroletwbbid 2>nul

REM Fazer dump
supabase db dump --schema public > %BACKUP_PROD%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo [OK] Backup PRODUCAO salvo em: %BACKUP_PROD%
    echo.
) else (
    echo.
    echo [ERRO] Falha ao fazer backup do PRODUCAO!
    echo Verifique se voce tem acesso ao projeto.
    echo.
    pause
    exit /b 1
)

echo.
echo [2/2] Fazendo backup do banco DESENVOLVIMENTO...
echo.

set BACKUP_DEV=backup-DEV-%TIMESTAMP%.sql

echo Conectando ao banco DESENVOLVIMENTO...
echo.

REM Link temporário ao projeto DEV
supabase link --project-ref ikwnemhqqkpjurdpauim 2>nul

REM Fazer dump
supabase db dump --schema public > %BACKUP_DEV%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo [OK] Backup DESENVOLVIMENTO salvo em: %BACKUP_DEV%
    echo.
) else (
    echo.
    echo [ERRO] Falha ao fazer backup do DEV!
    echo Verifique se voce tem acesso ao projeto.
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================================
echo   BACKUPS CONCLUIDOS COM SUCESSO!
echo ========================================================
echo.
echo Arquivos criados:
echo   - %BACKUP_PROD%
echo   - %BACKUP_DEV%
echo.
echo Tamanho dos arquivos:
dir %BACKUP_PROD% | find ".sql"
dir %BACKUP_DEV% | find ".sql"
echo.
echo ========================================================
echo.
pause
