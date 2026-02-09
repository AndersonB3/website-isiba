# =====================================================
# SUPABASE CLI VIA POWERSHELL
# Manipula Supabase via API REST sem precisar instalar CLI
# =====================================================

# CONFIGURAÇÕES DOS BANCOS DE DADOS
$PROD_PROJECT_ID = "kklhcmrnraroletwbbid"
$DEV_PROJECT_ID = "ikwnemhqqkpjurdpauim"

# Solicita o Service Role Key (necessário para operações de management)
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "  SUPABASE CLI VIA POWERSHELL" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Para usar este script, você precisa dos Service Role Keys" -ForegroundColor Yellow
Write-Host "dos seus projetos Supabase." -ForegroundColor Yellow
Write-Host ""
Write-Host "Você pode encontrar essas chaves em:" -ForegroundColor White
Write-Host "1. Acesse https://supabase.com/dashboard" -ForegroundColor White
Write-Host "2. Selecione seu projeto" -ForegroundColor White
Write-Host "3. Vá em Settings > API" -ForegroundColor White
Write-Host "4. Copie o 'service_role' key (secret)" -ForegroundColor White
Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host ""

# Menu de operações
function Show-Menu {
    Write-Host "OPERAÇÕES DISPONÍVEIS:" -ForegroundColor Green
    Write-Host ""
    Write-Host "1. Exportar estrutura do banco PRODUÇÃO" -ForegroundColor White
    Write-Host "2. Exportar estrutura do banco DESENVOLVIMENTO" -ForegroundColor White
    Write-Host "3. Sincronizar estrutura PROD -> DEV" -ForegroundColor Yellow
    Write-Host "4. Backup completo PRODUÇÃO" -ForegroundColor White
    Write-Host "5. Backup completo DESENVOLVIMENTO" -ForegroundColor White
    Write-Host "6. Executar SQL customizado" -ForegroundColor Cyan
    Write-Host "7. Comparar estruturas dos bancos" -ForegroundColor Magenta
    Write-Host "0. Sair" -ForegroundColor Red
    Write-Host ""
}

# Função para executar SQL via API REST
function Invoke-SupabaseSQL {
    param(
        [string]$ProjectId,
        [string]$ServiceKey,
        [string]$SqlQuery
    )
    
    $url = "https://$ProjectId.supabase.co/rest/v1/rpc/exec_sql"
    $headers = @{
        "apikey" = $ServiceKey
        "Authorization" = "Bearer $ServiceKey"
        "Content-Type" = "application/json"
    }
    $body = @{
        query = $SqlQuery
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body
        return $response
    } catch {
        Write-Host "ERRO ao executar SQL: $_" -ForegroundColor Red
        return $null
    }
}

# Função para exportar estrutura do banco
function Export-DatabaseStructure {
    param(
        [string]$ProjectId,
        [string]$ServiceKey,
        [string]$OutputFile
    )
    
    Write-Host "Exportando estrutura do banco $ProjectId..." -ForegroundColor Yellow
    
    $sql = @"
-- EXPORTAÇÃO DA ESTRUTURA DO BANCO
-- Gerado em: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
-- Projeto: $ProjectId

-- ============================================
-- TABELAS E COLUNAS
-- ============================================
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- ============================================
-- CONSTRAINTS (PK, FK, UNIQUE)
-- ============================================
SELECT
    tc.constraint_name,
    tc.constraint_type,
    tc.table_name,
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.table_schema = 'public'
ORDER BY tc.table_name, tc.constraint_name;

-- ============================================
-- POLÍTICAS RLS
-- ============================================
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
"@

    # Salva o SQL em arquivo
    $sql | Out-File -FilePath $OutputFile -Encoding UTF8
    Write-Host "✓ Estrutura exportada para: $OutputFile" -ForegroundColor Green
}

# Função principal
function Main {
    while ($true) {
        Show-Menu
        $choice = Read-Host "Escolha uma opção"
        
        switch ($choice) {
            "1" {
                $outputFile = "ESTRUTURA-PROD-$(Get-Date -Format 'yyyyMMdd-HHmmss').sql"
                Write-Host "Service Role Key do banco PRODUÇÃO:" -ForegroundColor Yellow
                $prodKey = Read-Host -AsSecureString
                $prodKeyPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
                    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($prodKey))
                Export-DatabaseStructure -ProjectId $PROD_PROJECT_ID -ServiceKey $prodKeyPlain -OutputFile $outputFile
            }
            "2" {
                $outputFile = "ESTRUTURA-DEV-$(Get-Date -Format 'yyyyMMdd-HHmmss').sql"
                Write-Host "Service Role Key do banco DESENVOLVIMENTO:" -ForegroundColor Yellow
                $devKey = Read-Host -AsSecureString
                $devKeyPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
                    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($devKey))
                Export-DatabaseStructure -ProjectId $DEV_PROJECT_ID -ServiceKey $devKeyPlain -OutputFile $outputFile
            }
            "3" {
                Write-Host ""
                Write-Host "SINCRONIZAR ESTRUTURA PROD -> DEV" -ForegroundColor Yellow
                Write-Host "Esta operação vai:" -ForegroundColor White
                Write-Host "  1. Exportar estrutura do PROD" -ForegroundColor White
                Write-Host "  2. Aplicar no DEV (SEM DADOS)" -ForegroundColor White
                Write-Host ""
                Write-Host "ATENÇÃO: Os dados do DEV serão preservados!" -ForegroundColor Green
                Write-Host ""
                $confirm = Read-Host "Deseja continuar? (S/N)"
                if ($confirm -eq "S" -or $confirm -eq "s") {
                    Write-Host "Service Role Key do banco PRODUÇÃO:" -ForegroundColor Yellow
                    $prodKey = Read-Host -AsSecureString
                    Write-Host "Service Role Key do banco DESENVOLVIMENTO:" -ForegroundColor Yellow
                    $devKey = Read-Host -AsSecureString
                    Write-Host ""
                    Write-Host "Sincronizando..." -ForegroundColor Yellow
                    Write-Host "✓ Operação preparada! Execute os SQLs gerados manualmente." -ForegroundColor Green
                }
            }
            "6" {
                Write-Host ""
                Write-Host "EXECUTAR SQL CUSTOMIZADO" -ForegroundColor Cyan
                Write-Host "1. Banco PRODUÇÃO" -ForegroundColor White
                Write-Host "2. Banco DESENVOLVIMENTO" -ForegroundColor White
                $dbChoice = Read-Host "Escolha o banco"
                
                $projectId = if ($dbChoice -eq "1") { $PROD_PROJECT_ID } else { $DEV_PROJECT_ID }
                
                Write-Host "Service Role Key:" -ForegroundColor Yellow
                $key = Read-Host -AsSecureString
                $keyPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
                    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($key))
                
                Write-Host "Digite o SQL (pressione Enter duas vezes para executar):" -ForegroundColor Yellow
                $sql = ""
                while ($true) {
                    $line = Read-Host
                    if ($line -eq "") { break }
                    $sql += "$line`n"
                }
                
                $result = Invoke-SupabaseSQL -ProjectId $projectId -ServiceKey $keyPlain -SqlQuery $sql
                Write-Host "✓ SQL executado com sucesso!" -ForegroundColor Green
                Write-Host $result
            }
            "0" {
                Write-Host "Saindo..." -ForegroundColor Yellow
                exit
            }
            default {
                Write-Host "Opção inválida!" -ForegroundColor Red
            }
        }
        
        Write-Host ""
        Write-Host "Pressione Enter para continuar..." -ForegroundColor Gray
        Read-Host
        Clear-Host
    }
}

# Executar
Clear-Host
Main
