@echo off
chcp 65001 >nul
cls
echo.
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║         🔍 COMPARAR BANCOS DE DADOS (PRODUÇÃO vs DESENVOLVIMENTO)      ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.
echo Este script irá ajudá-lo a comparar a ESTRUTURA dos dois bancos.
echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  📊 O QUE SERÁ COMPARADO                                               │
echo └────────────────────────────────────────────────────────────────────────┘
echo.
echo   ✅ DEVE SER IGUAL:
echo   • Número de tabelas
echo   • Estrutura das tabelas (colunas, tipos)
echo   • Chaves primárias e estrangeiras
echo   • Políticas RLS
echo   • Buckets de storage
echo.
echo   ⚠️  PODE SER DIFERENTE (isso é OK!):
echo   • Total de registros em cada tabela
echo   • Dados específicos (nomes, CPFs, etc)
echo   • Arquivos no storage (PDFs)
echo.
echo ════════════════════════════════════════════════════════════════════════
echo.
pause

cls
echo.
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║                        📝 INSTRUÇÕES PASSO A PASSO                     ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  PASSO 1: ABRIR SUPABASE DASHBOARD                                    │
echo └────────────────────────────────────────────────────────────────────────┘
echo.
echo   1. Abra seu navegador
echo   2. Acesse: https://supabase.com/dashboard
echo   3. Faça login
echo.
echo   Pressione qualquer tecla quando estiver no dashboard...
pause >nul

cls
echo.
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║                    🟢 BANCO DE PRODUÇÃO                                ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  PASSO 2: EXPORTAR ESTRUTURA DO BANCO DE PRODUÇÃO                     │
echo └────────────────────────────────────────────────────────────────────────┘
echo.
echo   1. No Dashboard, clique no projeto: ISIBA (Produção)
echo      URL deve conter: kklhcmrnraroletwbbid
echo.
echo   2. No menu lateral, clique em: SQL Editor
echo.
echo   3. Clique em: + New query
echo.
echo   4. Abra o arquivo: database\COMPARAR-BANCOS.sql
echo      (O arquivo será aberto agora)
echo.
echo   Abrindo o arquivo SQL...
start notepad "database\COMPARAR-BANCOS.sql"
timeout /t 2 /nobreak >nul
echo.
echo   5. Copie TODO o conteúdo do arquivo (Ctrl+A, Ctrl+C)
echo.
echo   6. Cole no SQL Editor do Supabase (Ctrl+V)
echo.
echo   7. Clique em "Run" (ou pressione F5)
echo.
echo   8. Aguarde os resultados aparecerem
echo.
echo   9. Para cada seção de resultado:
echo      • Clique nos 3 pontinhos (⋮)
echo      • Selecione: "Download as CSV" ou copie manualmente
echo.
echo   10. Salve tudo em: resultados-producao.txt
echo.
echo   Pressione qualquer tecla quando terminar de exportar PRODUÇÃO...
pause >nul

cls
echo.
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║                   🟡 BANCO DE DESENVOLVIMENTO                          ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  PASSO 3: EXPORTAR ESTRUTURA DO BANCO DE DESENVOLVIMENTO              │
echo └────────────────────────────────────────────────────────────────────────┘
echo.
echo   1. Volte ao Dashboard do Supabase
echo      (Clique no ícone do Supabase no canto superior esquerdo)
echo.
echo   2. Clique no projeto: isiba-desenvolvimento
echo      URL deve conter: ikwnemhqqkpjurdpauim
echo.
echo   3. Repita o processo:
echo      • SQL Editor → + New query
echo      • Cole o mesmo script (COMPARAR-BANCOS.sql)
echo      • Run (F5)
echo      • Salve os resultados em: resultados-desenvolvimento.txt
echo.
echo   Pressione qualquer tecla quando terminar de exportar DESENVOLVIMENTO...
pause >nul

cls
echo.
echo ╔════════════════════════════════════════════════════════════════════════╗
echo ║                      🔍 COMPARANDO RESULTADOS                          ║
echo ╚════════════════════════════════════════════════════════════════════════╝
echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  PASSO 4: COMPARAR OS ARQUIVOS                                        │
echo └────────────────────────────────────────────────────────────────────────┘
echo.
echo   Você tem 3 opções:
echo.
echo   [1] Usar WinMerge (se instalado)
echo   [2] Usar Visual Studio Code
echo   [3] Comparar manualmente
echo.
set /p OPCAO="   Escolha uma opcao (1, 2 ou 3): "

if "%OPCAO%"=="1" goto WINMERGE
if "%OPCAO%"=="2" goto VSCODE
if "%OPCAO%"=="3" goto MANUAL
goto MANUAL

:WINMERGE
echo.
echo   Tentando abrir com WinMerge...
where WinMergeU.exe >nul 2>&1
if %errorlevel% equ 0 (
    start WinMergeU.exe resultados-producao.txt resultados-desenvolvimento.txt
    echo   ✅ Arquivos abertos no WinMerge!
) else (
    echo   ❌ WinMerge não encontrado
    echo   Baixe em: https://winmerge.org/
    echo   Ou escolha outra opção
    pause
    goto MANUAL
)
goto FIM

:VSCODE
echo.
echo   Abrindo no Visual Studio Code...
where code >nul 2>&1
if %errorlevel% equ 0 (
    code --diff resultados-producao.txt resultados-desenvolvimento.txt
    echo   ✅ Arquivos abertos no VS Code!
) else (
    echo   ❌ VS Code não encontrado no PATH
    echo   Abra manualmente:
    echo   1. Abra VS Code
    echo   2. Abra os dois arquivos
    echo   3. Clique direito em um → "Select for Compare"
    echo   4. Clique direito no outro → "Compare with Selected"
    pause
)
goto FIM

:MANUAL
echo.
echo   Abrindo arquivos para comparação manual...
if exist "resultados-producao.txt" (
    start notepad "resultados-producao.txt"
) else (
    echo   ⚠️  Arquivo não encontrado: resultados-producao.txt
)
if exist "resultados-desenvolvimento.txt" (
    start notepad "resultados-desenvolvimento.txt"
) else (
    echo   ⚠️  Arquivo não encontrado: resultados-desenvolvimento.txt
)
echo.
echo   Compare os arquivos lado a lado!
goto FIM

:FIM
echo.
echo ════════════════════════════════════════════════════════════════════════
echo.
echo ┌────────────────────────────────────────────────────────────────────────┐
echo │  ✅ CHECKLIST DE VERIFICAÇÃO                                          │
echo └────────────────────────────────────────────────────────────────────────┘
echo.
echo   Verifique se são IGUAIS:
echo   [ ] Número de tabelas (deve ter 10 tabelas públicas)
echo   [ ] Colunas de cada tabela (mesmos nomes e tipos)
echo   [ ] Chaves primárias (PRIMARY KEY)
echo   [ ] Chaves estrangeiras (FOREIGN KEY)
echo   [ ] Políticas RLS (mesmas políticas)
echo   [ ] RLS habilitado (nas mesmas tabelas)
echo   [ ] Buckets de storage
echo   [ ] Políticas de storage
echo.
echo   Pode ser DIFERENTE (isso é OK!):
echo   [ ] Total de registros em cada tabela
echo   [ ] Dados específicos (nomes, CPFs, etc)
echo.
echo ════════════════════════════════════════════════════════════════════════
echo.
echo   📚 Para mais detalhes, leia: GUIA-COMPARAR-BANCOS.md
echo.
echo ════════════════════════════════════════════════════════════════════════
echo.
pause
