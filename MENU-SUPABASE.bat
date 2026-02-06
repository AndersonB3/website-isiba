@echo off
title ISIBA - Menu Principal Supabase
color 0B
chcp 65001 >nul

REM Adicionar Supabase ao PATH
set PATH=%PATH%;%LOCALAPPDATA%\supabase

:MENU
cls
echo.
echo ========================================================
echo   ISIBA - AUTOMACAO SUPABASE CLI
echo ========================================================
echo.
echo Status: Supabase CLI v2.75.0 - Logado
echo Projetos: PROD (kklhcmrnraroletwbbid) e DEV (ikwnemhqqkpjurdpauim)
echo.
echo ========================================================
echo   OPCOES DE AUTOMACAO:
echo ========================================================
echo.
echo  [1] Backup Automatico (PROD + DEV)
echo  [2] Sincronizar Estrutura PROD -^> DEV
echo  [3] Comparar Estruturas (PROD vs DEV)
echo.
echo  [4] Listar Projetos
echo  [5] Ver Informacoes do Projeto
echo  [6] Executar SQL Customizado
echo.
echo  [7] Abrir Dashboard Supabase
echo  [8] Ver Ajuda do CLI
echo.
echo  [0] Sair
echo.
echo ========================================================
echo.
set /p opcao="Escolha uma opcao: "

if "%opcao%"=="1" goto BACKUP
if "%opcao%"=="2" goto SINCRONIZAR
if "%opcao%"=="3" goto COMPARAR
if "%opcao%"=="4" goto LISTAR
if "%opcao%"=="5" goto INFO
if "%opcao%"=="6" goto SQL
if "%opcao%"=="7" goto DASHBOARD
if "%opcao%"=="8" goto AJUDA
if "%opcao%"=="0" goto SAIR

echo.
echo [ERRO] Opcao invalida!
timeout /t 2 /nobreak >nul
goto MENU

:BACKUP
cls
echo.
echo Iniciando backup automatico...
echo.
call BACKUP-AUTOMATICO.bat
goto MENU

:SINCRONIZAR
cls
echo.
echo Iniciando sincronizacao de estrutura...
echo.
call SINCRONIZAR-ESTRUTURA.bat
goto MENU

:COMPARAR
cls
echo.
echo Comparando estruturas dos bancos...
echo.
call COMPARAR-ESTRUTURAS-AUTO.bat
goto MENU

:LISTAR
cls
echo.
echo ========================================================
echo   PROJETOS SUPABASE
echo ========================================================
echo.
supabase projects list
echo.
echo ========================================================
echo.
pause
goto MENU

:INFO
cls
echo.
echo ========================================================
echo   INFORMACOES DO PROJETO
echo ========================================================
echo.
echo Qual projeto deseja ver?
echo  [1] PRODUCAO (kklhcmrnraroletwbbid)
echo  [2] DESENVOLVIMENTO (ikwnemhqqkpjurdpauim)
echo.
set /p proj="Escolha: "

if "%proj%"=="1" (
    echo.
    supabase link --project-ref kklhcmrnraroletwbbid 2>nul
    supabase projects api-keys --project-ref kklhcmrnraroletwbbid
) else if "%proj%"=="2" (
    echo.
    supabase link --project-ref ikwnemhqqkpjurdpauim 2>nul
    supabase projects api-keys --project-ref ikwnemhqqkpjurdpauim
) else (
    echo.
    echo Opcao invalida!
)

echo.
echo ========================================================
echo.
pause
goto MENU

:SQL
cls
echo.
echo ========================================================
echo   EXECUTAR SQL CUSTOMIZADO
echo ========================================================
echo.
echo Qual banco?
echo  [1] PRODUCAO (kklhcmrnraroletwbbid)
echo  [2] DESENVOLVIMENTO (ikwnemhqqkpjurdpauim)
echo.
set /p banco="Escolha: "

echo.
set /p arquivo="Digite o caminho do arquivo .sql: "

if not exist "%arquivo%" (
    echo.
    echo [ERRO] Arquivo nao encontrado!
    pause
    goto MENU
)

echo.
echo Executando SQL...
echo.

if "%banco%"=="1" (
    supabase link --project-ref kklhcmrnraroletwbbid 2>nul
    supabase db execute --file "%arquivo%"
) else if "%banco%"=="2" (
    supabase link --project-ref ikwnemhqqkpjurdpauim 2>nul
    supabase db execute --file "%arquivo%"
) else (
    echo Opcao invalida!
)

echo.
pause
goto MENU

:DASHBOARD
cls
echo.
echo ========================================================
echo   ABRIR DASHBOARD SUPABASE
echo ========================================================
echo.
echo Qual projeto?
echo  [1] PRODUCAO (kklhcmrnraroletwbbid)
echo  [2] DESENVOLVIMENTO (ikwnemhqqkpjurdpauim)
echo.
set /p dash="Escolha: "

if "%dash%"=="1" (
    start https://supabase.com/dashboard/project/kklhcmrnraroletwbbid
) else if "%dash%"=="2" (
    start https://supabase.com/dashboard/project/ikwnemhqqkpjurdpauim
)

timeout /t 1 /nobreak >nul
goto MENU

:AJUDA
cls
echo.
echo ========================================================
echo   SUPABASE CLI - COMANDOS UTEIS
echo ========================================================
echo.
supabase --help
echo.
echo ========================================================
echo.
pause
goto MENU

:SAIR
cls
echo.
echo ========================================================
echo   Encerrando...
echo ========================================================
echo.
timeout /t 1 /nobreak >nul
exit
