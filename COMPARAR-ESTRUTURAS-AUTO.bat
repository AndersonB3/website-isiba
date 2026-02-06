@echo off
title ISIBA - Comparar Estruturas dos Bancos
color 0B
chcp 65001 >nul

REM Adicionar Supabase ao PATH
set PATH=%PATH%;%LOCALAPPDATA%\supabase

cls
echo.
echo ========================================================
echo   COMPARAR ESTRUTURAS PROD vs DEV
echo ========================================================
echo.
echo Este script vai comparar as estruturas dos bancos:
echo   - PRODUCAO (kklhcmrnraroletwbbid)
echo   - DESENVOLVIMENTO (ikwnemhqqkpjurdpauim)
echo.
echo ========================================================
echo.
pause

echo.
echo [1/3] Exportando estrutura PRODUCAO...
echo.

set PROD_SCHEMA=estrutura-PROD.sql
supabase db dump --project-ref kklhcmrnraroletwbbid --schema public --data-only=false > %PROD_SCHEMA%

if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao exportar PRODUCAO!
    pause
    exit /b 1
)

echo [OK] Exportado: %PROD_SCHEMA%
echo.

echo [2/3] Exportando estrutura DESENVOLVIMENTO...
echo.

set DEV_SCHEMA=estrutura-DEV.sql
supabase db dump --project-ref ikwnemhqqkpjurdpauim --schema public --data-only=false > %DEV_SCHEMA%

if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao exportar DEV!
    pause
    exit /b 1
)

echo [OK] Exportado: %DEV_SCHEMA%
echo.

echo [3/3] Comparando estruturas...
echo.

REM Usar FC (File Compare) do Windows
fc /N %PROD_SCHEMA% %DEV_SCHEMA% > comparacao-resultado.txt

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================================
    echo   ESTRUTURAS IDENTICAS!
    echo ========================================================
    echo.
    echo Os bancos PROD e DEV tem a mesma estrutura.
    echo.
) else (
    echo.
    echo ========================================================
    echo   DIFERENCAS ENCONTRADAS!
    echo ========================================================
    echo.
    echo As estruturas dos bancos sao diferentes.
    echo.
    echo Veja o relatorio completo em: comparacao-resultado.txt
    echo.
    echo Resumo das diferencas:
    type comparacao-resultado.txt | find "****" /c
    echo linhas diferentes encontradas.
    echo.
    echo Deseja ver o relatorio agora? (S/N)
    set /p ver=": "
    if /i "%ver%"=="S" (
        notepad comparacao-resultado.txt
    )
)

echo.
echo Arquivos gerados:
echo   - %PROD_SCHEMA%
echo   - %DEV_SCHEMA%
echo   - comparacao-resultado.txt
echo.
echo ========================================================
echo.
pause
