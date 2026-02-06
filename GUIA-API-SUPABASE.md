# 🔌 ALTERNATIVA 2: USAR API REST DO SUPABASE

## 📋 VISÃO GERAL

Se você não quiser instalar a CLI, pode usar a **API REST** do Supabase diretamente via PowerShell, Node.js ou Python!

---

## 🎯 OPÇÃO A: PowerShell Script

### Executar SQL via API

**`executar-sql-api.ps1`:**
```powershell
# Configuração
$SUPABASE_URL = "https://ikwnemhqqkpjurdpauim.supabase.co"
$SUPABASE_SERVICE_KEY = "SUA_SERVICE_ROLE_KEY_AQUI" # ⚠️ NUNCA COMMITAR!
$SQL_FILE = "database/APLICAR-POLITICAS-DEV.sql"

# Ler arquivo SQL
$sql = Get-Content $SQL_FILE -Raw

# Fazer requisição
$headers = @{
    "apikey" = $SUPABASE_SERVICE_KEY
    "Authorization" = "Bearer $SUPABASE_SERVICE_KEY"
    "Content-Type" = "application/json"
}

$body = @{
    query = $sql
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "$SUPABASE_URL/rest/v1/rpc/exec_sql" -Method Post -Headers $headers -Body $body
    Write-Host "✅ SQL executado com sucesso!" -ForegroundColor Green
    $response
} catch {
    Write-Host "❌ Erro ao executar SQL:" -ForegroundColor Red
    Write-Host $_.Exception.Message
}
```

### Usar:
```powershell
.\executar-sql-api.ps1
```

---

## 🎯 OPÇÃO B: Node.js Script

### Instalar Supabase JS Client
```bash
npm install @supabase/supabase-js
```

### Script de Automação

**`scripts/sync-database.js`:**
```javascript
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');

// Configuração
const PROD = {
    url: 'https://kklhcmrnraroletwbbid.supabase.co',
    key: 'SUA_SERVICE_KEY_PRODUCAO' // ⚠️ Não commitar!
};

const DEV = {
    url: 'https://ikwnemhqqkpjurdpauim.supabase.co',
    key: 'SUA_SERVICE_KEY_DESENVOLVIMENTO' // ⚠️ Não commitar!
};

// Função para executar SQL
async function executarSQL(supabase, sqlFile) {
    console.log(`📝 Lendo arquivo: ${sqlFile}`);
    const sql = fs.readFileSync(sqlFile, 'utf8');
    
    console.log(`⚡ Executando SQL...`);
    const { data, error } = await supabase.rpc('exec_sql', { query: sql });
    
    if (error) {
        console.error('❌ Erro:', error);
        throw error;
    }
    
    console.log('✅ SQL executado com sucesso!');
    return data;
}

// Função para comparar estruturas
async function compararEstruturas() {
    console.log('\n🔍 Comparando estruturas...\n');
    
    const prodClient = createClient(PROD.url, PROD.key);
    const devClient = createClient(DEV.url, DEV.key);
    
    // Buscar tabelas em cada banco
    const sqlTabelas = `
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        ORDER BY table_name;
    `;
    
    const prodTables = await prodClient.rpc('exec_sql', { query: sqlTabelas });
    const devTables = await devClient.rpc('exec_sql', { query: sqlTabelas });
    
    console.log('🟢 PRODUÇÃO:', prodTables.data.length, 'tabelas');
    console.log('🟡 DESENVOLVIMENTO:', devTables.data.length, 'tabelas');
    
    if (prodTables.data.length === devTables.data.length) {
        console.log('✅ Mesmo número de tabelas!');
    } else {
        console.log('⚠️  Número de tabelas diferente!');
    }
}

// Função principal
async function main() {
    const args = process.argv.slice(2);
    const comando = args[0];
    
    if (comando === 'sync') {
        console.log('🔄 Sincronizando políticas RLS...');
        const devClient = createClient(DEV.url, DEV.key);
        await executarSQL(devClient, 'database/APLICAR-POLITICAS-DEV.sql');
    } else if (comando === 'compare') {
        await compararEstruturas();
    } else {
        console.log('Uso:');
        console.log('  node scripts/sync-database.js sync     - Sincronizar políticas');
        console.log('  node scripts/sync-database.js compare  - Comparar estruturas');
    }
}

main().catch(console.error);
```

### Usar:
```bash
# Sincronizar políticas
node scripts/sync-database.js sync

# Comparar estruturas
node scripts/sync-database.js compare
```

---

## 🎯 OPÇÃO C: Python Script

### Instalar biblioteca
```bash
pip install supabase
```

### Script de Automação

**`scripts/sync_database.py`:**
```python
import os
from supabase import create_client, Client

# Configuração
PROD = {
    'url': 'https://kklhcmrnraroletwbbid.supabase.co',
    'key': 'SUA_SERVICE_KEY_PRODUCAO'  # ⚠️ Não commitar!
}

DEV = {
    'url': 'https://ikwnemhqqkpjurdpauim.supabase.co',
    'key': 'SUA_SERVICE_KEY_DESENVOLVIMENTO'  # ⚠️ Não commitar!
}

def executar_sql(supabase: Client, sql_file: str):
    """Executa arquivo SQL"""
    print(f"📝 Lendo arquivo: {sql_file}")
    with open(sql_file, 'r', encoding='utf-8') as f:
        sql = f.read()
    
    print("⚡ Executando SQL...")
    result = supabase.rpc('exec_sql', {'query': sql}).execute()
    
    print("✅ SQL executado com sucesso!")
    return result

def comparar_estruturas():
    """Compara estruturas dos bancos"""
    print("\n🔍 Comparando estruturas...\n")
    
    prod_client = create_client(PROD['url'], PROD['key'])
    dev_client = create_client(DEV['url'], DEV['key'])
    
    sql = """
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public' 
        ORDER BY table_name;
    """
    
    prod_tables = prod_client.rpc('exec_sql', {'query': sql}).execute()
    dev_tables = dev_client.rpc('exec_sql', {'query': sql}).execute()
    
    print(f"🟢 PRODUÇÃO: {len(prod_tables.data)} tabelas")
    print(f"🟡 DESENVOLVIMENTO: {len(dev_tables.data)} tabelas")
    
    if len(prod_tables.data) == len(dev_tables.data):
        print("✅ Mesmo número de tabelas!")
    else:
        print("⚠️  Número de tabelas diferente!")

if __name__ == '__main__':
    import sys
    
    if len(sys.argv) < 2:
        print("Uso:")
        print("  python scripts/sync_database.py sync     - Sincronizar políticas")
        print("  python scripts/sync_database.py compare  - Comparar estruturas")
        sys.exit(1)
    
    comando = sys.argv[1]
    
    if comando == 'sync':
        print("🔄 Sincronizando políticas RLS...")
        dev_client = create_client(DEV['url'], DEV['key'])
        executar_sql(dev_client, 'database/APLICAR-POLITICAS-DEV.sql')
    elif comando == 'compare':
        comparar_estruturas()
```

### Usar:
```bash
# Sincronizar políticas
python scripts/sync_database.py sync

# Comparar estruturas
python scripts/sync_database.py compare
```

---

## 🔑 COMO OBTER A SERVICE ROLE KEY

⚠️ **ATENÇÃO:** A Service Role Key tem poderes de administrador!

1. Acesse: https://supabase.com/dashboard
2. Selecione seu projeto
3. Vá em: **Settings** → **API**
4. Role até: **Project API keys**
5. Copie: **service_role** (secret)

**⚠️ IMPORTANTE:**
- NUNCA faça commit desta chave!
- Use variáveis de ambiente
- Adicione ao `.gitignore`

---

## 🔒 USAR VARIÁVEIS DE AMBIENTE

### Criar arquivo `.env`:
```bash
# .env (NÃO COMMITAR!)
SUPABASE_PROD_URL=https://kklhcmrnraroletwbbid.supabase.co
SUPABASE_PROD_KEY=sua_service_key_producao

SUPABASE_DEV_URL=https://ikwnemhqqkpjurdpauim.supabase.co
SUPABASE_DEV_KEY=sua_service_key_desenvolvimento
```

### Adicionar ao `.gitignore`:
```
.env
.env.local
*.env
```

### Usar no código:
```javascript
require('dotenv').config();

const PROD = {
    url: process.env.SUPABASE_PROD_URL,
    key: process.env.SUPABASE_PROD_KEY
};
```

---

## 📊 COMPARAÇÃO DAS OPÇÕES

| Opção | Prós | Contras |
|-------|------|---------|
| **Supabase CLI** | ✅ Oficial<br>✅ Mais completo<br>✅ Fácil de usar | ⚠️ Precisa instalar |
| **API REST (PowerShell)** | ✅ Sem instalação<br>✅ Windows nativo | ⚠️ Mais código |
| **Node.js** | ✅ Flexível<br>✅ Fácil de integrar | ⚠️ Precisa Node.js |
| **Python** | ✅ Simples<br>✅ Poderoso | ⚠️ Precisa Python |

---

## 🎯 RECOMENDAÇÃO

**Para você:** Use a **Supabase CLI**!

Motivos:
1. ✅ É oficial do Supabase
2. ✅ Mais simples de usar
3. ✅ Comandos prontos
4. ✅ Bem documentado
5. ✅ npm install -g supabase (1 comando só!)

---

## 🎉 CONCLUSÃO

Você tem **4 opções** para manipular o Supabase automaticamente:

1. **Supabase CLI** ⭐ (Recomendada)
2. **PowerShell + API REST**
3. **Node.js + Supabase JS**
4. **Python + Supabase Client**

**Todas funcionam!** Escolha a que preferir! 🚀
