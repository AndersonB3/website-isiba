@echo off
chcp 65001 >nul
cls
echo.
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║                  ARQUITETURA: BRANCHES E BANCOS DE DADOS               ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  🌳 GIT BRANCHES                                                        │
echo └────────────────────────────────────────────────────────────────────────┘
echo.
echo   ┌─────────────────────────────────────────────────────────────────────┐
echo   │  BRANCH: master                                                     │
echo   │  ├─ Deploy: GitHub Pages (automático)                               │
echo   │  ├─ URL: https://andersonb3.github.io/website-isiba/                │
echo   │  ├─ Banco: PRODUÇÃO (kklhcmrnraroletwbbid)                          │
echo   │  └─ Status: ✅ PRODUÇÃO ATIVA                                       │
echo   └─────────────────────────────────────────────────────────────────────┘
echo.
echo   ┌─────────────────────────────────────────────────────────────────────┐
echo   │  BRANCH: develop                                                    │
echo   │  ├─ Deploy: Localhost apenas                                        │
echo   │  ├─ URL: http://localhost:8000                                      │
echo   │  ├─ Banco: DESENVOLVIMENTO (ikwnemhqqkpjurdpauim)                   │
echo   │  └─ Status: ✅ DESENVOLVIMENTO ATIVO                                │
echo   └─────────────────────────────────────────────────────────────────────┘
echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  💾 BANCOS DE DADOS SUPABASE                                           │
echo └────────────────────────────────────────────────────────────────────────┘
echo.
echo   🟢 BANCO DE PRODUÇÃO
echo   ├─ URL: https://kklhcmrnraroletwbbid.supabase.co
echo   ├─ Usado por: GitHub Pages (branch master)
echo   ├─ Arquivo: assets/js/supabase-config.js
echo   ├─ Dados: REAIS (colaboradores, contracheques, etc)
echo   └─ Versionado: SIM (vai pro GitHub)
echo.
echo   🟡 BANCO DE DESENVOLVIMENTO
echo   ├─ URL: https://ikwnemhqqkpjurdpauim.supabase.co
echo   ├─ Usado por: Localhost (branch develop)
echo   ├─ Arquivo: assets/js/supabase-config.dev.js
echo   ├─ Dados: TESTE (dados falsos para desenvolvimento)
echo   └─ Versionado: NÃO (gitignore - não vai pro GitHub)
echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  🔄 FLUXO DE TRABALHO                                                  │
echo └────────────────────────────────────────────────────────────────────────┘
echo.
echo   📝 DESENVOLVIMENTO (Dia a Dia)
echo   ───────────────────────────────
echo   1. git checkout develop
echo   2. (fazer alterações no código)
echo   3. INICIAR-TUDO.bat
echo   4. Testar em http://localhost:8000
echo   5. git add . ^&^& git commit -m "feat: nova funcionalidade"
echo.
echo   🚀 PRODUÇÃO (Deploy)
echo   ────────────────────
echo   1. git checkout master
echo   2. git merge develop
echo   3. git push origin master
echo   4. ✅ Deploy automático no GitHub Pages!
echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  ⚠️  REGRAS IMPORTANTES                                                │
echo └────────────────────────────────────────────────────────────────────────┘
echo.
echo   ✅ O QUE FAZER:
echo   • Desenvolver SEMPRE na branch develop
echo   • Testar localmente (localhost:8000)
echo   • Usar banco de DESENVOLVIMENTO
echo   • Subir para master só quando pronto
echo.
echo   ❌ O QUE NÃO FAZER:
echo   • Não trabalhar direto na master
echo   • Não testar com banco de produção localmente
echo   • Não commitar supabase-config.dev.js
echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  📊 VERIFICAR BRANCH ATUAL                                             │
echo └────────────────────────────────────────────────────────────────────────┘
echo.
git branch --show-current 2>nul
if errorlevel 1 (
    echo   ❌ Não foi possível detectar a branch atual
    echo   Certifique-se de estar dentro do repositório Git
) else (
    for /f %%i in ('git branch --show-current') do set CURRENT_BRANCH=%%i
    echo   Branch atual: !CURRENT_BRANCH!
    if "!CURRENT_BRANCH!"=="master" (
        echo   Status: 🟢 PRODUÇÃO - Cuidado ao fazer push!
    ) else if "!CURRENT_BRANCH!"=="develop" (
        echo   Status: 🟡 DESENVOLVIMENTO - Pode trabalhar à vontade!
    ) else (
        echo   Status: ⚪ Outra branch
    )
)
echo.
echo ════════════════════════════════════════════════════════════════════════
echo  Documentação completa: ARQUITETURA-BRANCHES-BANCOS.md
echo ════════════════════════════════════════════════════════════════════════
echo.
pause
