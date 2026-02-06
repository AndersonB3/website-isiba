@echo off
chcp 65001 >nul
cls
echo.
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║          🔍 VERIFICAÇÃO DE BANCO DE DADOS - BRANCH DEVELOP             ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.

REM Verificar branch atual
for /f %%i in ('git branch --show-current 2^>nul') do set CURRENT_BRANCH=%%i

if "%CURRENT_BRANCH%"=="" (
    echo ❌ ERRO: Não foi possível detectar a branch atual
    echo    Certifique-se de estar dentro do repositório Git
    goto END
)

echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  📊 INFORMAÇÕES DA BRANCH                                              │
echo └────────────────────────────────────────────────────────────────────────┘
echo.
echo   Branch atual: %CURRENT_BRANCH%

if "%CURRENT_BRANCH%"=="master" (
    echo   Status: 🟢 PRODUÇÃO
    echo   Banco: kklhcmrnraroletwbbid.supabase.co
    echo   Arquivo: assets/js/supabase-config.js
) else if "%CURRENT_BRANCH%"=="develop" (
    echo   Status: 🟡 DESENVOLVIMENTO
    echo   Banco: ikwnemhqqkpjurdpauim.supabase.co
    echo   Arquivo: assets/js/supabase-config.dev.js
) else (
    echo   Status: ⚪ Outra branch
)

echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  🔍 VERIFICANDO ARQUIVOS DE CONFIGURAÇÃO                               │
echo └────────────────────────────────────────────────────────────────────────┘
echo.

REM Verificar se o arquivo .dev.js existe
if exist "assets\js\supabase-config.dev.js" (
    echo   ✅ assets/js/supabase-config.dev.js - ENCONTRADO
) else (
    echo   ❌ assets/js/supabase-config.dev.js - NÃO ENCONTRADO
)

if exist "painel-rh\assets\js\supabase-config.dev.js" (
    echo   ✅ painel-rh/assets/js/supabase-config.dev.js - ENCONTRADO
) else (
    echo   ❌ painel-rh/assets/js/supabase-config.dev.js - NÃO ENCONTRADO
)

REM Verificar se o loader existe
if exist "assets\js\supabase-config-loader.js" (
    echo   ✅ assets/js/supabase-config-loader.js - ENCONTRADO
) else (
    echo   ❌ assets/js/supabase-config-loader.js - NÃO ENCONTRADO
)

if exist "painel-rh\assets\js\supabase-config-loader.js" (
    echo   ✅ painel-rh/assets/js/supabase-config-loader.js - ENCONTRADO
) else (
    echo   ❌ painel-rh/assets/js/supabase-config-loader.js - NÃO ENCONTRADO
)

echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  🔒 VERIFICANDO .gitignore                                             │
echo └────────────────────────────────────────────────────────────────────────┘
echo.

findstr /C:"supabase-config.dev.js" .gitignore >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Arquivos .dev.js estão protegidos pelo .gitignore
) else (
    echo   ❌ ATENÇÃO: Arquivos .dev.js não estão no .gitignore!
)

echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  📝 VERIFICANDO CREDENCIAIS DE DESENVOLVIMENTO                         │
echo └────────────────────────────────────────────────────────────────────────┘
echo.

REM Verificar se as credenciais foram configuradas
findstr /C:"ikwnemhqqkpjurdpauim" "assets\js\supabase-config.dev.js" >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Banco de DESENVOLVIMENTO configurado: ikwnemhqqkpjurdpauim
) else (
    findstr /C:"COLE_AQUI" "assets\js\supabase-config.dev.js" >nul 2>&1
    if %errorlevel% equ 0 (
        echo   ❌ Credenciais NÃO configuradas - ainda tem placeholders
        echo      Edite: assets/js/supabase-config.dev.js
    ) else (
        echo   ⚠️  Credenciais configuradas, mas banco desconhecido
    )
)

echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  🌐 COMO TESTAR A CONEXÃO                                              │
echo └────────────────────────────────────────────────────────────────────────┘
echo.
echo   1. Execute: INICIAR-TUDO.bat
echo   2. Abra: http://localhost:8000
echo   3. Pressione F12 (Console do navegador)
echo   4. Verifique:
echo      - Badge laranja: "🔧 DESENVOLVIMENTO"
echo      - Console: "🔧 AMBIENTE: DESENVOLVIMENTO"
echo      - Banco: "ikwnemhqqkpjurdpauim"
echo.
echo ════════════════════════════════════════════════════════════════════════
if "%CURRENT_BRANCH%"=="develop" (
    echo  ✅ Tudo certo! Branch develop configurada para DESENVOLVIMENTO
) else if "%CURRENT_BRANCH%"=="master" (
    echo  ⚠️  Você está na branch MASTER (Produção)
    echo     Para desenvolvimento, mude para: git checkout develop
) else (
    echo  ℹ️  Você está em outra branch: %CURRENT_BRANCH%
)
echo ════════════════════════════════════════════════════════════════════════
echo.

:END
pause
