@echo off
title ISIBA - Limpeza Organizada de Arquivos
color 0E
chcp 65001 >nul

cls
echo.
echo ========================================================
echo   LIMPEZA ORGANIZADA - WEBSITE ISIBA
echo ========================================================
echo.
echo Este script vai:
echo   - Mover 63 arquivos para _ARQUIVADOS/
echo   - Organizar backups SQL
echo   - Manter apenas arquivos essenciais na raiz
echo.
echo ========================================================
echo   CATEGORIAS A ARQUIVAR:
echo ========================================================
echo.
echo [1] 3 backups SQL antigos
echo [2] 25 scripts SQL de debug
echo [3] 14 documentacoes temporarias
echo [4] 8 scripts PowerShell obsoletos
echo [5] 11 scripts BAT redundantes
echo [6] 2 arquivos HTML de teste
echo.
echo Total: 63 arquivos
echo.
echo ========================================================
echo.
echo IMPORTANTE: Esta acao NAO apaga arquivos!
echo Apenas move para _ARQUIVADOS/ (pode reverter depois)
echo.
echo ========================================================
pause

cls
echo.
echo ========================================================
echo   INICIANDO LIMPEZA...
echo ========================================================
echo.

REM ========================================================
REM CATEGORIA 1: BACKUPS SQL
REM ========================================================
echo.
echo [1/6] Movendo backups SQL antigos...

if exist "backup-PROD-2026-02-06_16-30-17.sql" (
    move "backup-PROD-2026-02-06_16-30-17.sql" "backups\producao\" >nul
    echo   ✓ backup-PROD-2026-02-06_16-30-17.sql
)

if exist "backup-PROD-2026-02-06_16-30-39.sql" (
    move "backup-PROD-2026-02-06_16-30-39.sql" "backups\producao\" >nul
    echo   ✓ backup-PROD-2026-02-06_16-30-39.sql
)

if exist "backup-PROD-2026-02-09_10-37-30.sql" (
    move "backup-PROD-2026-02-09_10-37-30.sql" "backups\producao\" >nul
    echo   ✓ backup-PROD-2026-02-09_10-37-30.sql
)

if exist "estrutura-PROD.sql" (
    move "estrutura-PROD.sql" "backups\" >nul
    echo   ✓ estrutura-PROD.sql
)

REM ========================================================
REM CATEGORIA 2: SCRIPTS SQL DE DEBUG
REM ========================================================
echo.
echo [2/6] Movendo scripts SQL de debug...

for %%f in (
    "ADD_ASSINATURA_DIGITAL.sql"
    "ADICIONAR_CAMPO_CODIGO.sql"
    "ADICIONAR_COLUNA_ASSINATURA.sql"
    "ADICIONAR_PRIMEIRO_ACESSO.sql"
    "ATUALIZAR_DOCUMENTOS_BLOQUEIO.sql"
    "BLOQUEAR_RAPIDO.sql"
    "BLOQUEAR_TODOS_DOCUMENTOS.sql"
    "CORRIGIR_POLITICAS_RLS.sql"
    "DEBUG-ASSINATURA-VIEW.sql"
    "DEBUG_USUARIO_TESTE.sql"
    "DIAGNOSTICO_BLOQUEIO.sql"
    "EXECUTAR-TUDO-UMA-VEZ.sql"
    "FIX-VIEW-ASSINATURA.sql"
    "FORCAR_PRIMEIRO_ACESSO_TRUE.sql"
    "LIMPAR_RAPIDO_SIMPLES.sql"
    "LIMPAR_RECIBOS_E_BLOQUEAR.sql"
    "LIMPAR_TESTES_ANTES_SEGURANCA.sql"
    "SISTEMA_RECIBOS.sql"
    "SISTEMA_RECIBOS_LIMPO.sql"
    "SISTEMA_RECIBOS_PASSO_A_PASSO.sql"
    "URGENTE_SEGURANCA_RLS_STORAGE.sql"
    "VERIFICACAO_URGENTE.sql"
    "VERIFICAR_PERMISSOES_STORAGE.sql"
    "VERIFICAR_POLITICA_DETALHES.sql"
    "VERIFICAR_VIEW_ASSINATURA.sql"
) do (
    if exist %%f (
        move %%f "_ARQUIVADOS\sql-debug\" >nul 2>&1
        echo   ✓ %%~nxf
    )
)

REM ========================================================
REM CATEGORIA 3: DOCUMENTACAO TEMPORARIA
REM ========================================================
echo.
echo [3/6] Movendo documentacao temporaria...

for %%f in (
    "ANALISE-LIMPEZA-ARQUIVOS.md"
    "ANALISE-POLITICAS-RLS.md"
    "COPIAR-DADOS-PRODUCAO.md"
    "CORRECAO-LOADER.md"
    "CORRECAO-SCRIPTS.md"
    "FIX-LOGIN-RLS.md"
    "INICIAR-AMBIENTE-LOCAL.md"
    "INSTALAR-SUPABASE-CLI-MANUAL.md"
    "MERGE-MASTER-DEVELOP.md"
    "RESUMO-ARQUIVOS-CRIADOS.md"
    "RESUMO-CONFIGURACAO.md"
    "SETUP-RAPIDO-LOCAL.md"
    "TESTE-PRIMEIRO-ACESSO.md"
    "VERIFICACAO-BANCO-DEVELOP.md"
) do (
    if exist %%f (
        move %%f "_ARQUIVADOS\documentacao\" >nul 2>&1
        echo   ✓ %%~nxf
    )
)

REM ========================================================
REM CATEGORIA 4 e 5: SCRIPTS OBSOLETOS (PS1 e BAT)
REM ========================================================
echo.
echo [4/6] Criando pasta para scripts obsoletos...
if not exist "_ARQUIVADOS\scripts-obsoletos" mkdir "_ARQUIVADOS\scripts-obsoletos" >nul

echo.
echo [5/6] Movendo scripts PowerShell obsoletos...

for %%f in (
    "ATUALIZAR-HOSTINGER.ps1"
    "instalar-cli-auto.ps1"
    "INSTALAR-SUPABASE-CLI-V2.ps1"
    "INSTALAR-SUPABASE-CLI.ps1"
    "LIMPAR_PROJETO.ps1"
    "PREPARAR-DEPLOY-HOSTINGER.ps1"
    "SUPABASE-CLI-POWERSHELL.ps1"
    "_ARQUIVAR_ARQUIVOS.ps1"
) do (
    if exist %%f (
        move %%f "_ARQUIVADOS\scripts-obsoletos\" >nul 2>&1
        echo   ✓ %%~nxf
    )
)

echo.
echo Movendo scripts BAT redundantes...

for %%f in (
    "BACKUP-BANCOS.bat"
    "COMPARAR-BANCOS.bat"
    "GERENCIAR-SUPABASE.bat"
    "INICIAR-SERVIDOR.bat"
    "INICIAR-TUDO.bat"
    "INSTALAR-SUPABASE-AUTOMATICO.bat"
    "INSTALAR-SUPABASE-CLI.bat"
    "LOGIN-SUPABASE.bat"
    "VER-ARQUITETURA.bat"
    "VERIFICAR-BANCO-DEVELOP.bat"
) do (
    if exist %%f (
        move %%f "_ARQUIVADOS\scripts-obsoletos\" >nul 2>&1
        echo   ✓ %%~nxf
    )
)

REM Script especial: mover para painel-rh
if exist "INICIAR-PAINEL-RH.bat" (
    if exist "painel-rh\" (
        move "INICIAR-PAINEL-RH.bat" "painel-rh\" >nul 2>&1
        echo   ✓ INICIAR-PAINEL-RH.bat (movido para painel-rh/)
    )
)

REM ========================================================
REM CATEGORIA 6: HTML DE TESTE
REM ========================================================
echo.
echo [6/6] Movendo HTML de teste...

for %%f in (
    "admin-limpar-banco.html"
    "primeiro-acesso-new.html"
) do (
    if exist %%f (
        move %%f "_ARQUIVADOS\html-teste\" >nul 2>&1
        echo   ✓ %%~nxf
    )
)

REM ========================================================
REM CONSOLIDAR DOCUMENTACAO
REM ========================================================
echo.
echo [EXTRA] Verificando duplicacao de guias...

REM Verificar se AUTOMACAO-SUPABASE-RESUMO.md e AUTOMACAO-COMPLETA-RESUMO.md sao duplicados
if exist "AUTOMACAO-SUPABASE-RESUMO.md" (
    if exist "AUTOMACAO-COMPLETA-RESUMO.md" (
        echo   [!] Encontrados 2 guias de automacao similares:
        echo       - AUTOMACAO-SUPABASE-RESUMO.md
        echo       - AUTOMACAO-COMPLETA-RESUMO.md
        echo   [i] Recomendacao: revisar e manter apenas 1
    )
)

REM ========================================================
REM FINALIZACAO
REM ========================================================
echo.
echo ========================================================
echo   LIMPEZA CONCLUIDA!
echo ========================================================
echo.
echo Resumo:
echo   ✓ Backups movidos para backups/producao/
echo   ✓ Scripts SQL movidos para _ARQUIVADOS/sql-debug/
echo   ✓ Docs temporarias em _ARQUIVADOS/documentacao/
echo   ✓ Scripts obsoletos em _ARQUIVADOS/scripts-obsoletos/
echo   ✓ HTML de teste em _ARQUIVADOS/html-teste/
echo.
echo ========================================================
echo.
echo Proximos passos:
echo   1. Revisar arquivos em _ARQUIVADOS/
echo   2. Se tudo OK, fazer commit:
echo      git add .
echo      git commit -m "chore: limpeza e organizacao de arquivos"
echo.
echo Se precisar reverter, os arquivos estao em _ARQUIVADOS/
echo.
echo ========================================================
pause
