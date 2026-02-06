# 🛠️ GUIA: SUPABASE CLI - AUTOMAÇÃO COMPLETA

## 📋 O QUE É A SUPABASE CLI?

A **Supabase CLI** permite executar comandos SQL, fazer migrations, comparar bancos e muito mais, **direto do terminal**, sem precisar abrir o dashboard!

---

## 📥 INSTALAÇÃO

### Windows (via npm):
```powershell
# Instalar globalmente
npm install -g supabase

# Verificar instalação
supabase --version
```

### Alternativa (via Chocolatey):
```powershell
choco install supabase
```

### Alternativa (via Scoop):
```powershell
scoop install supabase
```

---

## 🔑 CONFIGURAÇÃO INICIAL

### 1. Login no Supabase
```powershell
supabase login
```
Isso abrirá o navegador para você fazer login e gerar um token de acesso.

### 2. Inicializar Projeto
```powershell
cd "C:\Users\Usuario\Desktop\WEBSITE ISIBA"
supabase init
```

### 3. Linkar com Projeto Remoto

#### Para PRODUÇÃO:
```powershell
supabase link --project-ref kklhcmrnraroletwbbid
```

#### Para DESENVOLVIMENTO:
```powershell
supabase link --project-ref ikwnemhqqkpjurdpauim
```

---

## 🎯 COMANDOS ÚTEIS

### 1️⃣ Executar SQL no Banco
```powershell
# Executar arquivo SQL no banco de PRODUÇÃO
supabase db execute -f database/COMPARAR-BANCOS.sql --project-ref kklhcmrnraroletwbbid

# Executar arquivo SQL no banco de DESENVOLVIMENTO
supabase db execute -f database/APLICAR-POLITICAS-DEV.sql --project-ref ikwnemhqqkpjurdpauim
```

### 2️⃣ Fazer Dump do Banco (Backup)
```powershell
# Exportar estrutura do banco de PRODUÇÃO
supabase db dump --project-ref kklhcmrnraroletwbbid > backup-producao.sql

# Exportar estrutura do banco de DESENVOLVIMENTO
supabase db dump --project-ref ikwnemhqqkpjurdpauim > backup-desenvolvimento.sql
```

### 3️⃣ Comparar Bancos (Diff)
```powershell
# Ver diferenças entre os dois bancos
supabase db diff --linked --schema public
```

### 4️⃣ Aplicar Migrations
```powershell
# Criar nova migration
supabase migration new nome_da_migration

# Aplicar migrations pendentes
supabase db push
```

### 5️⃣ Resetar Banco (CUIDADO!)
```powershell
# Resetar banco de desenvolvimento para estrutura limpa
supabase db reset --project-ref ikwnemhqqkpjurdpauim
```

---

## 🤖 AUTOMAÇÃO COM SCRIPTS

### Script 1: Sincronizar Estrutura PROD → DEV

**`SINCRONIZAR-ESTRUTURA.bat`:**
```batch
@echo off
echo Exportando estrutura do banco de PRODUCAO...
supabase db dump --project-ref kklhcmrnraroletwbbid --schema-only > estrutura-producao.sql

echo Aplicando estrutura no banco de DESENVOLVIMENTO...
supabase db execute -f estrutura-producao.sql --project-ref ikwnemhqqkpjurdpauim

echo ✅ Estrutura sincronizada!
pause
```

### Script 2: Backup Automático

**`BACKUP-BANCOS.bat`:**
```batch
@echo off
set DATA=%date:~-4,4%%date:~-7,2%%date:~-10,2%

echo Fazendo backup de PRODUCAO...
supabase db dump --project-ref kklhcmrnraroletwbbid > backup-prod-%DATA%.sql

echo Fazendo backup de DESENVOLVIMENTO...
supabase db dump --project-ref ikwnemhqqkpjurdpauim > backup-dev-%DATA%.sql

echo ✅ Backups criados!
dir backup-*.sql
pause
```

### Script 3: Comparar Automaticamente

**`COMPARAR-AUTO.bat`:**
```batch
@echo off
echo Comparando estrutura dos bancos...
supabase db diff --linked --schema public > diferencas.txt

echo Resultado salvo em: diferencas.txt
notepad diferencas.txt
pause
```

---

## 📊 EXEMPLO COMPLETO DE USO

### Cenário: Aplicar Políticas RLS no DEV

**Antes (manual):**
1. Abrir Supabase Dashboard
2. Selecionar projeto DEV
3. Ir no SQL Editor
4. Copiar script
5. Executar
6. Verificar

**Depois (automático):**
```powershell
supabase db execute -f database/APLICAR-POLITICAS-DEV.sql --project-ref ikwnemhqqkpjurdpauim
```

**Um comando!** ✅

---

## 🎯 VANTAGENS

| Manual (Dashboard) | Automático (CLI) |
|-------------------|------------------|
| 10+ cliques | 1 comando |
| 2-3 minutos | 10 segundos |
| Copiar/colar | Direto do arquivo |
| Propenso a erros | Reproduzível |
| Sem histórico | Git controla tudo |

---

## 🔒 SEGURANÇA

O Supabase CLI:
- ✅ Usa OAuth para autenticação
- ✅ Token fica em `~/.supabase/access-token`
- ✅ Não expõe senhas
- ✅ Pode ser revogado a qualquer momento

---

## 📝 DOCUMENTAÇÃO OFICIAL

- **CLI Docs:** https://supabase.com/docs/guides/cli
- **CLI Reference:** https://supabase.com/docs/reference/cli
- **GitHub:** https://github.com/supabase/cli

---

## 🎉 CONCLUSÃO

Com a Supabase CLI você pode:
- ✅ Executar SQL automaticamente
- ✅ Fazer backups programados
- ✅ Comparar bancos com 1 comando
- ✅ Criar migrations versionadas
- ✅ Sincronizar estruturas
- ✅ Integrar com CI/CD

**Tudo sem sair do terminal!** 🚀
