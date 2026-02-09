@echo off
title ISIBA - Copiar Producao para Desenvolvimento
color 0E
chcp 65001 >nul

cls
echo.
echo ========================================================
echo   COPIAR PRODUCAO -^> DESENVOLVIMENTO (GRATUITO)
echo ========================================================
echo.
echo Metodo: Export CSV + Import CSV via Dashboard
echo Tempo estimado: 10-15 minutos
echo.
echo ========================================================
echo   PROCESSO SIMPLES (3 ETAPAS):
echo ========================================================
echo.
echo [ETAPA 1] EXPORTAR da PRODUCAO (SQL Editor)
echo   - SELECT * FROM tabela; 
echo   - Clicar em "Download" (CSV)
echo   - Repetir para cada tabela
echo.
echo [ETAPA 2] LIMPAR DESENVOLVIMENTO (SQL Editor)
echo   - TRUNCATE TABLE tabela CASCADE;
echo   - Repetir para cada tabela
echo.
echo [ETAPA 3] IMPORTAR para DESENVOLVIMENTO (Table Editor)
echo   - Insert -^> Import CSV
echo   - Selecionar arquivo
echo   - Repetir para cada tabela
echo.
echo ========================================================
echo.
echo Escolha uma opcao:
echo.
echo [1] ABRIR DASHBOARDS (SQL Editor + Table Editor)
echo [2] VER SCRIPT SQL DE EXEMPLO
echo [3] VER LISTA DE TABELAS
echo [0] Cancelar
echo.
echo ========================================================
set /p opcao="Digite sua opcao: "

if "%opcao%"=="1" goto dashboard
if "%opcao%"=="2" goto sql
if "%opcao%"=="3" goto estrutura
goto fim

:dashboard
cls
echo.
echo ========================================================
echo   ABRINDO DASHBOARDS
echo ========================================================
echo.
echo Vou abrir 4 abas no navegador:
echo.
echo [1] SQL Editor PRODUCAO (para EXPORT)
echo [2] SQL Editor DESENVOLVIMENTO (para TRUNCATE)
echo [3] Table Editor DESENVOLVIMENTO (para IMPORT)
echo [4] Script SQL de exemplo
echo.
echo ========================================================
pause

echo.
echo [1/4] SQL Editor PRODUCAO (Export CSV aqui)...
start https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/editor
timeout /t 2 /nobreak >nul

echo [2/4] SQL Editor DESENVOLVIMENTO (Truncate aqui)...
start https://supabase.com/dashboard/project/ikwnemhqqkpjurdpauim/editor
timeout /t 2 /nobreak >nul

echo [3/4] Table Editor DESENVOLVIMENTO (Import CSV aqui)...
start https://supabase.com/dashboard/project/ikwnemhqqkpjurdpauim/table-editor
timeout /t 2 /nobreak >nul

echo [4/4] Abrindo script SQL de exemplo...
if exist "SCRIPT-COPIAR-DADOS.sql" (
    start notepad "SCRIPT-COPIAR-DADOS.sql"
) else (
    echo [AVISO] Arquivo SCRIPT-COPIAR-DADOS.sql nao encontrado
)

echo.
echo ========================================================
echo   TODAS AS ABAS ABERTAS!
echo ========================================================
echo.
echo PASSO A PASSO RAPIDO:
echo.
echo 1. SQL Editor PRODUCAO:
echo    SELECT * FROM contracheques;
echo    [Clicar em Download - salvar CSV]
echo.
echo 2. SQL Editor DESENVOLVIMENTO:
echo    TRUNCATE TABLE contracheques CASCADE;
echo.
echo 3. Table Editor DESENVOLVIMENTO:
echo    Selecionar tabela -^> Insert -^> Import CSV
echo.
echo 4. Repetir para todas as tabelas!
echo.
echo ========================================================
pause
goto fim

:sql
cls
echo.
echo ========================================================
echo   SCRIPT SQL - COPIAR DADOS
echo ========================================================
echo.
echo Abrindo arquivo SCRIPT-COPIAR-DADOS.sql...
echo.
if exist "SCRIPT-COPIAR-DADOS.sql" (
    start notepad "SCRIPT-COPIAR-DADOS.sql"
    timeout /t 2 /nobreak >nul
) else (
    echo [ERRO] Arquivo nao encontrado!
    pause
    goto fim
)

echo.
echo Deseja abrir os SQL Editors tambem? (S/N)
set /p abrir="Digite: "

if /i "%abrir%"=="S" (
    start https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/editor
    timeout /t 2 /nobreak >nul
    start https://supabase.com/dashboard/project/ikwnemhqqkpjurdpauim/editor
)
goto fim

:estrutura
cls
echo.
echo ========================================================
echo   VER TABELAS DOS BANCOS
echo ========================================================
echo.
echo Abrindo Database Tables dos dois bancos...
echo.
echo Use isso para:
echo   - Ver lista de tabelas
echo   - Ver quantidade de registros
echo   - Comparar estruturas
echo.
pause

echo [1/2] Tables PRODUCAO...
start https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/database/tables
timeout /t 2 /nobreak >nul

echo [2/2] Tables DESENVOLVIMENTO...
start https://supabase.com/dashboard/project/ikwnemhqqkpjurdpauim/database/tables

echo.
echo ========================================================
echo   TABELAS ABERTAS!
echo ========================================================
echo.
echo Anote os nomes das tabelas que quer copiar.
echo.
pause
goto fim

:fim
echo.
echo ========================================================
echo   FINALIZADO!
echo ========================================================
echo.
echo Duvidas? Consulte: GUIA-COPIAR-DADOS-PROD-DEV.md
echo.
pause
