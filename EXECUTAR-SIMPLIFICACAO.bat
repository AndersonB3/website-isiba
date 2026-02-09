@echo off
title ISIBA - Simplificacao: Remover Banco DEV
color 0E
chcp 65001 >nul

cls
echo.
echo ========================================================
echo   SIMPLIFICACAO: REMOVER BANCO DEV
echo ========================================================
echo.
echo Esta simplificacao vai:
echo   - Remover arquivos de configuracao DEV
echo   - Remover scripts de sincronizacao
echo   - Remover documentacao sobre dual-banco
echo   - Manter apenas banco PRODUCAO
echo.
echo NOVO FLUXO:
echo   develop (local) -^> testa com PROD -^> master -^> GitHub
echo.
echo ========================================================
echo   ARQUIVOS A REMOVER: 15+
echo ========================================================
echo.
echo [1] Configuracoes DEV (3 arquivos)
echo [2] Scripts de sincronizacao (6 arquivos)
echo [3] Documentacao dual-banco (6 arquivos)
echo.
echo Total: ~15 arquivos serao movidos para _ARQUIVADOS/
echo.
echo ========================================================
pause

cls
echo.
echo ========================================================
echo   INICIANDO SIMPLIFICACAO...
echo ========================================================
echo.

REM Criar pasta para arquivos DEV
if not exist "_ARQUIVADOS\banco-dev-removido" mkdir "_ARQUIVADOS\banco-dev-removido" >nul
echo [i] Pasta criada: _ARQUIVADOS\banco-dev-removido\
echo.

REM ========================================================
REM CATEGORIA 1: CONFIGURACOES DEV
REM ========================================================
echo [1/3] Removendo configuracoes DEV...

if exist "assets\js\supabase-config.dev.js" (
    move "assets\js\supabase-config.dev.js" "_ARQUIVADOS\banco-dev-removido\" >nul 2>&1
    echo   ✓ assets\js\supabase-config.dev.js
)

if exist "assets\js\supabase-config-loader.js" (
    move "assets\js\supabase-config-loader.js" "_ARQUIVADOS\banco-dev-removido\" >nul 2>&1
    echo   ✓ assets\js\supabase-config-loader.js
)

if exist "painel-rh\assets\js\supabase-config.dev.js" (
    move "painel-rh\assets\js\supabase-config.dev.js" "_ARQUIVADOS\banco-dev-removido\" >nul 2>&1
    echo   ✓ painel-rh\assets\js\supabase-config.dev.js
)

REM ========================================================
REM CATEGORIA 2: SCRIPTS DE SINCRONIZACAO
REM ========================================================
echo.
echo [2/3] Removendo scripts de sincronizacao...

for %%f in (
    "COPIAR-PROD-PARA-DEV.bat"
    "SINCRONIZAR-ESTRUTURA.bat"
    "COMPARAR-ESTRUTURAS-AUTO.bat"
    "GUIA-COPIAR-DADOS-PROD-DEV.md"
    "GUIA-COMPARAR-BANCOS.md"
    "SCRIPT-COPIAR-DADOS.sql"
) do (
    if exist %%f (
        move %%f "_ARQUIVADOS\banco-dev-removido\" >nul 2>&1
        echo   ✓ %%~nxf
    )
)

REM ========================================================
REM CATEGORIA 3: DOCUMENTACAO DUAL-BANCO
REM ========================================================
echo.
echo [3/3] Removendo documentacao sobre dual-banco...

for %%f in (
    "ARQUITETURA-BRANCHES-BANCOS.md"
    "CONFIGURAR-AMBIENTES.md"
    "GUIA-AMBIENTES.md"
    "QUICK-START-DEV.md"
) do (
    if exist %%f (
        move %%f "_ARQUIVADOS\banco-dev-removido\" >nul 2>&1
        echo   ✓ %%~nxf
    )
)

REM ========================================================
REM ATUALIZAR .GITIGNORE
REM ========================================================
echo.
echo [EXTRA] Limpando .gitignore...

REM Criar novo .gitignore sem referencias a DEV
(
echo # Dependencias
echo node_modules/
echo vendor/
echo.
echo # Arquivos de ambiente
echo .env
echo .env.local
echo .env.*.local
echo.
echo # Configuracoes Supabase
echo **/supabase-config.example.js
echo.
echo # Logs
echo *.log
echo npm-debug.log*
echo.
echo # Sistema operacional
echo .DS_Store
echo Thumbs.db
echo Desktop.ini
echo.
echo # IDEs e editores
echo .vscode/
echo .idea/
echo *.sublime-project
echo *.sublime-workspace
echo.
echo # Arquivos temporarios
echo *.tmp
echo *.temp
echo *.swp
echo *~
echo.
echo # Cache
echo .cache/
echo *.cache
echo.
echo # Build
echo dist/
echo build/
echo.
echo # Backups e arquivos de teste
echo backups/
echo *.backup
echo *.sql
echo *.sql.backup
echo **/teste-*.pdf
) > .gitignore.new

move /Y .gitignore.new .gitignore >nul
echo   ✓ .gitignore atualizado (removidas referencias a DEV)

REM ========================================================
REM FINALIZACAO
REM ========================================================
echo.
echo ========================================================
echo   SIMPLIFICACAO CONCLUIDA!
echo ========================================================
echo.
echo Resumo:
echo   ✓ Configuracoes DEV removidas
echo   ✓ Scripts de sincronizacao removidos
echo   ✓ Documentacao dual-banco removida
echo   ✓ .gitignore limpo
echo.
echo Agora voce tem:
echo   ✓ 1 banco apenas (PRODUCAO)
echo   ✓ Fluxo simplificado: develop -^> master -^> GitHub
echo   ✓ Menos arquivos para gerenciar
echo.
echo ========================================================
echo.
echo NOVO FLUXO DE TRABALHO:
echo.
echo 1. Trabalhe na branch develop
echo    git checkout develop
echo.
echo 2. Teste localmente (com banco PROD)
echo    [faca suas mudancas]
echo.
echo 3. Commit local
echo    git add .
echo    git commit -m "feat: nova funcionalidade"
echo.
echo 4. Quando pronto, suba para producao:
echo    git checkout master
echo    git merge develop
echo    git push origin master
echo.
echo 5. GitHub Pages atualiza automaticamente!
echo.
echo ========================================================
echo.
echo IMPORTANTE: Agora voce testa direto com banco PROD
echo Faca BACKUP antes de testar: .\BACKUP-VIA-DASHBOARD.bat
echo.
echo ========================================================
pause
