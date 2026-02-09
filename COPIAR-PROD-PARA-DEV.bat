@echo off
title ISIBA - Copiar Producao para Desenvolvimento
color 0E
chcp 65001 >nul

cls
echo.
echo ========================================================
echo   COPIAR BANCO PRODUCAO -^> DESENVOLVIMENTO
echo ========================================================
echo.
echo Este script vai ajudar voce a copiar os dados do banco
echo de PRODUCAO para o banco de DESENVOLVIMENTO.
echo.
echo ========================================================
echo   PASSO A PASSO:
echo ========================================================
echo.
echo ETAPA 1: EXPORTAR DADOS DA PRODUCAO
echo   1. Abrir SQL Editor da PRODUCAO
echo   2. Executar query SELECT para ver os dados
echo   3. Copiar os dados (ou usar script de export)
echo.
echo ETAPA 2: LIMPAR DESENVOLVIMENTO
echo   3. Abrir SQL Editor do DESENVOLVIMENTO
echo   4. Executar TRUNCATE nas tabelas
echo.
echo ETAPA 3: IMPORTAR PARA DESENVOLVIMENTO
echo   5. Executar INSERT com os dados copiados
echo.
echo ========================================================
echo.
echo Escolha uma opcao:
echo.
echo [1] METODO RAPIDO - Via Dashboard (manual mas simples)
echo [2] METODO SQL - Gerar scripts de copia automaticos
echo [3] VER ESTRUTURA DAS TABELAS
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
echo   METODO 1: VIA DASHBOARD (RECOMENDADO)
echo ========================================================
echo.
echo Vou abrir os SQL Editors dos dois bancos.
echo.
echo NO SQL EDITOR DA PRODUCAO:
echo   1. Execute: SELECT * FROM nome_da_tabela;
echo   2. Clique em "Export to CSV"
echo   3. Salve o arquivo
echo.
echo NO SQL EDITOR DO DESENVOLVIMENTO:
echo   1. Va em "Table Editor"
echo   2. Selecione a tabela
echo   3. Clique em "Insert" e use "Import CSV"
echo   4. Selecione o arquivo exportado
echo.
echo ========================================================
pause

echo.
echo [1/2] Abrindo SQL Editor PRODUCAO...
start https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/editor
timeout /t 2 /nobreak >nul

echo [2/2] Abrindo SQL Editor DESENVOLVIMENTO...
start https://supabase.com/dashboard/project/ikwnemhqqkpjurdpauim/editor
timeout /t 2 /nobreak >nul

echo.
echo ========================================================
echo   SQL EDITORS ABERTOS!
echo ========================================================
echo.
echo Siga os passos acima em cada aba.
echo.
pause
goto fim

:sql
cls
echo.
echo ========================================================
echo   METODO 2: SCRIPTS SQL AUTOMATICOS
echo ========================================================
echo.
echo Vou criar scripts SQL para copiar os dados.
echo.
echo Qual tabela voce quer copiar?
echo.
echo Tabelas comuns no sistema:
echo   - contracheques
echo   - colaboradores
echo   - usuarios
echo   - admin
echo.
set /p tabela="Digite o nome da tabela: "

echo.
echo Gerando script SQL para copiar '%tabela%'...
echo.

REM Criar arquivo SQL temporario
(
echo -- ========================================================
echo -- SCRIPT: Copiar dados de PRODUCAO para DESENVOLVIMENTO
echo -- Tabela: %tabela%
echo -- Data: %date% %time%
echo -- ========================================================
echo.
echo -- PASSO 1: Ver dados da PRODUCAO
echo -- Execute isso no SQL Editor da PRODUCAO:
echo.
echo SELECT * FROM %tabela%;
echo.
echo -- PASSO 2: Limpar tabela no DESENVOLVIMENTO
echo -- Execute isso no SQL Editor do DESENVOLVIMENTO:
echo.
echo TRUNCATE TABLE %tabela% CASCADE;
echo.
echo -- PASSO 3: Copiar dados manualmente
echo -- Depois de ver os dados da PRODUCAO acima,
echo -- crie os INSERTs apropriados aqui embaixo:
echo.
echo -- INSERT INTO %tabela% (coluna1, coluna2, ...) VALUES
echo --   ('valor1', 'valor2', ...),
echo --   ('valor1', 'valor2', ...);
echo.
echo -- ========================================================
echo -- DICA: Para muitos dados, use o metodo CSV ^(opcao 1^)
echo -- ========================================================
) > copiar_%tabela%_temp.sql

echo.
echo ========================================================
echo   SCRIPT CRIADO!
echo ========================================================
echo.
echo Arquivo: copiar_%tabela%_temp.sql
echo.
echo PROXIMOS PASSOS:
echo   1. Abra o arquivo SQL criado
echo   2. Copie o conteudo
echo   3. Execute nos SQL Editors apropriados
echo.
pause

echo.
echo Deseja abrir os SQL Editors agora? (S/N)
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
echo   ESTRUTURA DAS TABELAS
echo ========================================================
echo.
echo Abrindo Schema Visualizer dos dois bancos...
echo.
pause

echo [1/2] Abrindo PRODUCAO...
start https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/database/tables
timeout /t 2 /nobreak >nul

echo [2/2] Abrindo DESENVOLVIMENTO...
start https://supabase.com/dashboard/project/ikwnemhqqkpjurdpauim/database/tables

echo.
echo ========================================================
echo   VISUALIZADORES ABERTOS!
echo ========================================================
echo.
echo La voce pode ver:
echo   - Todas as tabelas
echo   - Estrutura de cada tabela
echo   - Quantidade de registros
echo.
pause
goto fim

:fim
echo.
echo ========================================================
echo   PROCESSO CONCLUIDO!
echo ========================================================
echo.
echo Dica: Para copiar grandes volumes de dados,
echo use o metodo CSV (opcao 1) - e mais rapido!
echo.
pause
