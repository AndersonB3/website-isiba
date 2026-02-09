@echo off
chcp 65001 >nul
cls
echo.
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║                  💾 BACKUP AUTOMÁTICO DOS BANCOS                       ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.

REM Verificar se Supabase CLI está instalada
where supabase >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ ERRO: Supabase CLI não está instalada!
    echo.
    echo Para instalar: npm install -g supabase
    echo Ou leia: GUIA-SUPABASE-CLI.md
    pause
    exit /b 1
)

REM Criar pasta de backups se não existir
if not exist "backups" mkdir backups

REM Obter data/hora atual
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set DATA=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%
set HORA=%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%

echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  BACKUP 1/2: Banco de PRODUÇÃO                                        │
echo └────────────────────────────────────────────────────────────────────────┘
echo.
echo Exportando banco de PRODUÇÃO...
supabase db dump --project-ref kklhcmrnraroletwbbid > "backups\backup-PROD-%DATA%_%HORA%.sql"

if %errorlevel% neq 0 (
    echo ❌ Erro ao fazer backup de PRODUÇÃO!
    pause
    exit /b 1
)
echo ✅ Backup de PRODUÇÃO criado!

echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  BACKUP 2/2: Banco de DESENVOLVIMENTO                                 │
echo └────────────────────────────────────────────────────────────────────────┘
echo.
echo Exportando banco de DESENVOLVIMENTO...
supabase db dump --project-ref ikwnemhqqkpjurdpauim > "backups\backup-DEV-%DATA%_%HORA%.sql"

if %errorlevel% neq 0 (
    echo ❌ Erro ao fazer backup de DESENVOLVIMENTO!
    pause
    exit /b 1
)
echo ✅ Backup de DESENVOLVIMENTO criado!

echo.
echo ═══════════════════════════════════════════════════════════════════════
echo  ✅ BACKUPS CRIADOS COM SUCESSO!
echo ═══════════════════════════════════════════════════════════════════════
echo.
echo  Arquivos salvos em: backups\
echo.
dir /b "backups\backup-*-%DATA%_*.sql"
echo.
echo  Para restaurar um backup:
echo    supabase db execute -f backups\arquivo.sql --project-ref [REF]
echo.
echo ═══════════════════════════════════════════════════════════════════════
pause
