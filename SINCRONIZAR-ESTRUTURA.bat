@echo off
chcp 65001 >nul
cls
echo.
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║           🚀 SINCRONIZAR ESTRUTURA: PRODUÇÃO → DESENVOLVIMENTO        ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.
echo Este script irá:
echo   1. Exportar a estrutura do banco de PRODUÇÃO
echo   2. Aplicar no banco de DESENVOLVIMENTO
echo.
echo ⚠️  ATENÇÃO: Os DADOS não serão copiados, apenas a ESTRUTURA!
echo.
pause

REM Verificar se Supabase CLI está instalada
where supabase >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ❌ ERRO: Supabase CLI não está instalada!
    echo.
    echo Para instalar:
    echo   npm install -g supabase
    echo.
    echo Ou leia: GUIA-SUPABASE-CLI.md
    echo.
    pause
    exit /b 1
)

echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  PASSO 1: Exportar estrutura do banco de PRODUÇÃO                     │
echo └────────────────────────────────────────────────────────────────────────┘
echo.
echo Exportando...
supabase db dump --project-ref kklhcmrnraroletwbbid --schema-only > estrutura-producao-temp.sql

if %errorlevel% neq 0 (
    echo ❌ Erro ao exportar! Verifique:
    echo    1. Se você fez login: supabase login
    echo    2. Se o projeto está linkado
    pause
    exit /b 1
)

echo ✅ Estrutura exportada!

echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  PASSO 2: Aplicar estrutura no banco de DESENVOLVIMENTO               │
echo └────────────────────────────────────────────────────────────────────────┘
echo.
echo ⚠️  Isso irá atualizar a estrutura do banco DEV!
echo.
set /p CONFIRMA="   Confirma? (S/N): "
if /i not "%CONFIRMA%"=="S" (
    echo Operação cancelada.
    del estrutura-producao-temp.sql
    pause
    exit /b 0
)

echo.
echo Aplicando estrutura...
supabase db execute -f estrutura-producao-temp.sql --project-ref ikwnemhqqkpjurdpauim

if %errorlevel% neq 0 (
    echo ❌ Erro ao aplicar estrutura!
    echo O arquivo foi salvo em: estrutura-producao-temp.sql
    echo Você pode verificar e aplicar manualmente.
    pause
    exit /b 1
)

echo ✅ Estrutura aplicada com sucesso!

REM Limpar arquivo temporário
del estrutura-producao-temp.sql

echo.
echo ═══════════════════════════════════════════════════════════════════════
echo  ✅ SINCRONIZAÇÃO CONCLUÍDA!
echo.
echo  O banco de DESENVOLVIMENTO agora tem a mesma estrutura de PRODUÇÃO.
echo.
echo  Próximo passo: Testar localmente
echo    INICIAR-TUDO.bat
echo ═══════════════════════════════════════════════════════════════════════
echo.
pause
