@echo off
title ISIBA - Gerenciar Supabase
color 0B
chcp 65001 >nul

:MENU
cls
echo.
echo ========================================================
echo   ISIBA - GERENCIAMENTO SUPABASE
echo ========================================================
echo.
echo OPÇÕES DE AUTOMAÇÃO:
echo.
echo  [1] Exportar estrutura PRODUÇÃO
echo  [2] Exportar estrutura DESENVOLVIMENTO  
echo  [3] Sincronizar PROD ^-^> DEV (estrutura)
echo  [4] Backup completo PRODUÇÃO
echo  [5] Backup completo DESENVOLVIMENTO
echo  [6] Comparar estruturas dos bancos
echo  [7] Abrir Dashboard Supabase (navegador)
echo.
echo  [9] PowerShell CLI Completo
echo  [0] Sair
echo.
echo ========================================================
echo.
set /p opcao="Escolha uma opção: "

if "%opcao%"=="1" goto EXPORTAR_PROD
if "%opcao%"=="2" goto EXPORTAR_DEV
if "%opcao%"=="3" goto SINCRONIZAR
if "%opcao%"=="4" goto BACKUP_PROD
if "%opcao%"=="5" goto BACKUP_DEV
if "%opcao%"=="6" goto COMPARAR
if "%opcao%"=="7" goto DASHBOARD
if "%opcao%"=="9" goto POWERSHELL_CLI
if "%opcao%"=="0" goto SAIR

echo.
echo [ERRO] Opção inválida!
timeout /t 2 /nobreak >nul
goto MENU

:EXPORTAR_PROD
cls
echo.
echo ========================================================
echo   EXPORTAR ESTRUTURA - PRODUÇÃO
echo ========================================================
echo.
echo Executando script SQL de comparação...
echo Acesse o Supabase Dashboard e execute o arquivo:
echo.
echo    database\COMPARAR-BANCOS.sql
echo.
echo No banco: kklhcmrnraroletwbbid (PRODUÇÃO)
echo.
echo Salve o resultado como: ESTRUTURA-PROD.txt
echo.
pause
start https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/sql/new
goto MENU

:EXPORTAR_DEV
cls
echo.
echo ========================================================
echo   EXPORTAR ESTRUTURA - DESENVOLVIMENTO
echo ========================================================
echo.
echo Executando script SQL de comparação...
echo Acesse o Supabase Dashboard e execute o arquivo:
echo.
echo    database\COMPARAR-BANCOS.sql
echo.
echo No banco: ikwnemhqqkpjurdpauim (DESENVOLVIMENTO)
echo.
echo Salve o resultado como: ESTRUTURA-DEV.txt
echo.
pause
start https://supabase.com/dashboard/project/ikwnemhqqkpjurdpauim/sql/new
goto MENU

:SINCRONIZAR
cls
echo.
echo ========================================================
echo   SINCRONIZAR ESTRUTURA PROD ^-^> DEV
echo ========================================================
echo.
echo Este processo vai:
echo   1. Abrir o banco PRODUÇÃO
echo   2. Abrir o banco DESENVOLVIMENTO
echo   3. Você copiará a estrutura manualmente
echo.
echo ATENÇÃO: Apenas a ESTRUTURA será copiada, não os dados!
echo.
pause

echo.
echo [1/2] Abrindo banco PRODUÇÃO...
start https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/editor
timeout /t 2 /nobreak >nul

echo [2/2] Abrindo banco DESENVOLVIMENTO...
start https://supabase.com/dashboard/project/ikwnemhqqkpjurdpauim/editor
timeout /t 2 /nobreak >nul

echo.
echo ========================================================
echo   PRÓXIMOS PASSOS:
echo ========================================================
echo.
echo 1. No PRODUÇÃO: Table Editor ^> Selecione tabela
echo 2. Clique em "..." ^> "Export as SQL"
echo 3. Copie o SQL CREATE TABLE
echo 4. No DESENVOLVIMENTO: SQL Editor ^> Cole o SQL
echo 5. Execute para criar a estrutura
echo.
echo Repita para cada tabela que precisa sincronizar.
echo ========================================================
echo.
pause
goto MENU

:BACKUP_PROD
cls
echo.
echo ========================================================
echo   BACKUP COMPLETO - PRODUÇÃO
echo ========================================================
echo.
set filename=BACKUP-PROD-%date:~-4%-%date:~3,2%-%date:~0,2%-%time:~0,2%%time:~3,2%%time:~6,2%.sql
echo Arquivo será salvo como: %filename%
echo.
echo Executando script de backup...
echo.
echo Acesse o Dashboard e execute:
echo   1. Vá em Database ^> Backups
echo   2. Clique em "Create backup"
echo   3. Ou use: Settings ^> Database ^> Connection string
echo.
pause
start https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/database/backups
goto MENU

:BACKUP_DEV
cls
echo.
echo ========================================================
echo   BACKUP COMPLETO - DESENVOLVIMENTO
echo ========================================================
echo.
set filename=BACKUP-DEV-%date:~-4%-%date:~3,2%-%date:~0,2%-%time:~0,2%%time:~3,2%%time:~6,2%.sql
echo Arquivo será salvo como: %filename%
echo.
echo Executando script de backup...
echo.
echo Acesse o Dashboard e execute:
echo   1. Vá em Database ^> Backups
echo   2. Clique em "Create backup"
echo   3. Ou use: Settings ^> Database ^> Connection string
echo.
pause
start https://supabase.com/dashboard/project/ikwnemhqqkpjurdpauim/database/backups
goto MENU

:COMPARAR
cls
echo.
echo ========================================================
echo   COMPARAR ESTRUTURAS DOS BANCOS
echo ========================================================
echo.
echo Iniciando comparação...
echo.
pause
call COMPARAR-BANCOS.bat
goto MENU

:DASHBOARD
cls
echo.
echo ========================================================
echo   ABRIR DASHBOARD SUPABASE
echo ========================================================
echo.
echo Qual banco deseja acessar?
echo.
echo  [1] PRODUÇÃO (kklhcmrnraroletwbbid)
echo  [2] DESENVOLVIMENTO (ikwnemhqqkpjurdpauim)
echo  [0] Voltar
echo.
set /p db="Escolha: "

if "%db%"=="1" (
    echo Abrindo Dashboard PRODUÇÃO...
    start https://supabase.com/dashboard/project/kklhcmrnraroletwbbid
)
if "%db%"=="2" (
    echo Abrindo Dashboard DESENVOLVIMENTO...
    start https://supabase.com/dashboard/project/ikwnemhqqkpjurdpauim
)

timeout /t 1 /nobreak >nul
goto MENU

:POWERSHELL_CLI
cls
echo.
echo ========================================================
echo   POWERSHELL CLI COMPLETO
echo ========================================================
echo.
echo Iniciando interface PowerShell avançada...
echo.
pause
powershell -ExecutionPolicy Bypass -File "SUPABASE-CLI-POWERSHELL.ps1"
goto MENU

:SAIR
cls
echo.
echo ========================================================
echo   Saindo...
echo ========================================================
echo.
timeout /t 1 /nobreak >nul
exit
