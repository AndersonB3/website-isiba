# 🚀 GUIA: INSTALAR SUPABASE CLI MANUALMENTE

## ⚠️ Por que instalação manual?

O Supabase CLI não pode ser instalado via `npm install -g` no Windows.  
A instalação automática via script teve problemas de encoding.

**Solução:** Instalação manual é rápida e simples! (5 minutos)

---

## 📦 OPÇÃO 1: Download Direto (MAIS FÁCIL)

### Passo 1: Baixar o executável

1. Acesse: https://github.com/supabase/cli/releases/latest
2. Procure por: **`supabase_windows_amd64.tar.gz`**
3. Clique para baixar (aprox. 30 MB)

### Passo 2: Extrair

Abra o PowerShell e execute:

```powershell
# Navegar até a pasta de Downloads
cd $env:USERPROFILE\Downloads

# Extrair o arquivo
tar -xzf supabase_windows_amd64.tar.gz
```

### Passo 3: Instalar

```powershell
# Criar pasta de instalação
New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\supabase" -Force

# Mover o executável
Move-Item supabase.exe "$env:LOCALAPPDATA\supabase\supabase.exe" -Force

# Adicionar ao PATH (permanente)
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$newPath = "$currentPath;$env:LOCALAPPDATA\supabase"
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")

# Adicionar ao PATH (sessão atual)
$env:Path = "$env:Path;$env:LOCALAPPDATA\supabase"
```

### Passo 4: Verificar

```powershell
supabase --version
```

Deve mostrar: `2.75.0` ou superior ✅

---

## 📦 OPÇÃO 2: Usar WinGet (Windows 11)

Se você tem Windows 11 com WinGet:

```powershell
winget install Supabase.CLI
```

**Vantagem:** Instalação automática e atualizações fáceis!

---

## 📦 OPÇÃO 3: Usar Chocolatey

Se você tem Chocolatey instalado:

```powershell
choco install supabase
```

---

## ✅ PRÓXIMOS PASSOS (Depois de Instalar)

### 1. Fechar e Reabrir VS Code

**IMPORTANTE:** Feche completamente o VS Code e reabra para carregar o novo PATH!

### 2. Fazer Login no Supabase

```powershell
supabase login
```

Isso vai:
- Abrir o navegador
- Pedir para você fazer login no Supabase
- Salvar um token localmente
- Permitir que você use os comandos CLI

### 3. Testar Conectividade

```powershell
# Listar seus projetos
supabase projects list

# Deve mostrar:
# - ikwnemhqqkpjurdpauim (DEV)
# - kklhcmrnraroletwbbid (PROD)
```

---

## 🎯 USAR SCRIPTS DE AUTOMAÇÃO

Depois de instalar e fazer login, você pode usar os scripts:

### Script 1: Sincronizar Estrutura

```batch
.\SINCRONIZAR-ESTRUTURA-AUTO.bat
```

O que faz:
- Exporta estrutura do banco PROD
- Aplica no banco DEV
- **AUTOMATICAMENTE!** Sem copiar/colar

### Script 2: Backup Automático

```batch
.\BACKUP-BANCOS-AUTO.bat
```

O que faz:
- Cria backup timestamp do PROD
- Cria backup timestamp do DEV
- Salva em arquivos `.sql`

### Script 3: Comparar Bancos

```batch
.\COMPARAR-ESTRUTURAS-AUTO.bat
```

O que faz:
- Compara estruturas PROD vs DEV
- Mostra diferenças
- Gera relatório

---

## 🛠️ SOLUÇÃO DE PROBLEMAS

### Erro: "supabase não é reconhecido"

**Solução:** Você precisa fechar e reabrir o terminal/VS Code para carregar o novo PATH!

```powershell
# Ou adicione manualmente ao PATH da sessão atual:
$env:Path = "$env:Path;$env:LOCALAPPDATA\supabase"
```

### Erro: "tar: comando não encontrado"

**Problema:** Windows 7/8 não tem tar nativo.

**Solução 1:** Usar 7-Zip ou WinRAR para extrair `.tar.gz`

**Solução 2:** Atualizar para Windows 10+

### Erro no Login: "Failed to open browser"

**Problema:** Navegador padrão não configurado

**Solução:**
```powershell
# Login manual com token
supabase login --token seu_token_aqui
```

Pegue o token em: https://app.supabase.com/account/tokens

---

## 📊 COMPARAÇÃO

| Método | Tempo | Dificuldade |  |
|--------|-------|-------------|-------|
| Download Direto | 5 min | Fácil | ⭐⭐⭐⭐⭐ |
| WinGet | 2 min | Muito Fácil | ⭐⭐⭐⭐⭐ |
| Chocolatey | 3 min | Fácil | ⭐⭐⭐⭐ |
| Script Auto | ❌ | Problemas encoding | ❌ |

**Recomendação:** Download Direto (funciona sempre!)

---

## 🎓 COMANDOS ÚTEIS

Depois de instalado, você pode usar:

```powershell
# Ver ajuda
supabase --help

# Ver comandos de database
supabase db --help

# Executar SQL
supabase db execute --db-url "postgresql://..." --file script.sql

# Dump (backup) do banco
supabase db dump --db-url "postgresql://..." > backup.sql

# Ver diferenças entre bancos
supabase db diff --linked --schema public
```

---

## ✅ CHECKLIST DE INSTALAÇÃO

- [ ] Baixou `supabase_windows_amd64.tar.gz`
- [ ] Extraiu com `tar -xzf`
- [ ] Moveu para `%LOCALAPPDATA%\supabase`
- [ ] Adicionou ao PATH
- [ ] Fechou e reabriu VS Code
- [ ] Testou: `supabase --version`
- [ ] Fez login: `supabase login`
- [ ] Listou projetos: `supabase projects list`

---

## 🚀 RESULTADO ESPERADO

Após instalação completa, você terá:

```powershell
PS> supabase --version
2.75.0

PS> supabase projects list
┌──────────────────────────────────┬─────────────┬────────────┐
│ ID                               │ Name        │ Region     │
├──────────────────────────────────┼─────────────┼────────────┤
│ ikwnemhqqkpjurdpauim            │ ISIBA-DEV   │ us-east-1  │
│ kklhcmrnraroletwbbid            │ ISIBA-PROD  │ us-east-1  │
└──────────────────────────────────┴─────────────┴────────────┘
```

---

## 💡 DICA PRO

Crie um alias para facilitar:

```powershell
# Adicione ao seu $PROFILE
function sp { supabase projects list }
function sl { supabase login }
function sb { supabase db backup }
```

Agora você pode usar: `sp`, `sl`, `sb` 🚀

---

**Pronto para começar? Baixe agora:** https://github.com/supabase/cli/releases/latest
