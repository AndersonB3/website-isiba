# 📦 GUIA RÁPIDO: Backup via Dashboard

## 🚀 INÍCIO RÁPIDO (2 minutos):

```batch
# Execute este comando:
.\BACKUP-VIA-DASHBOARD.bat
```

O script vai abrir automaticamente as páginas de backup dos dois projetos!

---

## 📋 PASSO A PASSO DETALHADO:

### **PRODUÇÃO (kklhcmrnraroletwbbid):**

#### 1️⃣ Abrir Dashboard
```
https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/database/backups
```

#### 2️⃣ Criar Backup
- Clique no botão **"Create backup"** (canto superior direito)
- Aguarde processamento (15-60 segundos)

#### 3️⃣ Download
- Quando aparecer na lista, clique em **"Download"**
- Salve como: `backup-producao-YYYY-MM-DD.sql`

---

### **DESENVOLVIMENTO (ikwnemhqqkpjurdpauim):**

#### 1️⃣ Abrir Dashboard
```
https://supabase.com/dashboard/project/ikwnemhqqkpjurdpauim/database/backups
```

#### 2️⃣ Criar Backup
- Clique no botão **"Create backup"**
- Aguarde processamento

#### 3️⃣ Download
- Clique em **"Download"**
- Salve como: `backup-desenvolvimento-YYYY-MM-DD.sql`

---

## 📁 ORGANIZAÇÃO DOS BACKUPS:

### Estrutura recomendada:
```
WEBSITE ISIBA/
├── backups/
│   ├── producao/
│   │   ├── backup-producao-2024-01-15.sql
│   │   ├── backup-producao-2024-01-22.sql
│   │   └── backup-producao-2024-01-29.sql
│   └── desenvolvimento/
│       ├── backup-desenvolvimento-2024-01-15.sql
│       └── backup-desenvolvimento-2024-01-29.sql
```

### Criar pastas:
```batch
mkdir backups
mkdir backups\producao
mkdir backups\desenvolvimento
```

---

## ⏱️ TEMPO ESTIMADO:

| Tarefa | Tempo |
|--------|-------|
| Script abre páginas | 5 seg |
| Criar backup (cada) | 30 seg |
| Download (cada) | 10 seg |
| **TOTAL** | **~2 min** |

---

## 💾 CONTEÚDO DO BACKUP:

O backup inclui:
- ✅ Estrutura completa (tabelas, views, functions)
- ✅ Todos os dados (INSERT statements)
- ✅ Políticas RLS
- ✅ Triggers e constraints
- ✅ Índices

---

## 🔄 CRONOGRAMA RECOMENDADO:

### **PRODUÇÃO:**
- 📅 **Diário:** Automático (Supabase faz backup diário)
- 📅 **Semanal:** Manual via Dashboard (toda segunda-feira)
- 📅 **Antes de mudanças:** Sempre!

### **DESENVOLVIMENTO:**
- 📅 **Semanal:** Manual via Dashboard (toda sexta-feira)
- 📅 **Antes de testes:** Recomendado

---

## 🔧 USANDO OS BACKUPS:

### Restaurar via Dashboard:
1. Abra o Dashboard do projeto
2. Database → Backups
3. Clique no backup → "Restore"

### Restaurar via SQL Editor:
1. Abra SQL Editor no Dashboard
2. Cole o conteúdo do `.sql`
3. Execute

### Restaurar via CLI (se firewall for liberado):
```bash
supabase link --project-ref kklhcmrnraroletwbbid
supabase db execute < backup-producao.sql
```

---

## ⚠️ BACKUP ANTES DE:

- 🔴 Deploy para produção
- 🟡 Mudanças na estrutura do banco
- 🟡 Testes com dados reais
- 🟢 Updates semanais

---

## 🆘 TROUBLESHOOTING:

### "Backup demorou muito"
- Normal para bancos grandes (>100MB)
- Aguarde até 2-3 minutos

### "Download falhou"
- Tente novamente
- Verifique espaço em disco
- Use navegador diferente

### "Backup não aparece na lista"
- Aguarde 30 segundos
- Recarregue a página (F5)
- Verifique se tem permissão

---

## 📊 TAMANHO DOS BACKUPS:

Estimativa:
```
PRODUÇÃO: ~5-20 MB (depende dos dados)
DESENVOLVIMENTO: ~1-5 MB (dados de teste)
```

---

## 🎯 CHECKLIST RÁPIDO:

**Antes do backup:**
- [ ] Executar `BACKUP-VIA-DASHBOARD.bat`
- [ ] Aguardar páginas abrirem

**Durante o backup:**
- [ ] PRODUÇÃO: Create backup → Download
- [ ] DESENVOLVIMENTO: Create backup → Download

**Depois do backup:**
- [ ] Salvar arquivos com data
- [ ] Verificar tamanho (se >100KB está ok)
- [ ] Mover para pasta `backups/`

---

## 🔐 SEGURANÇA:

### ⚠️ IMPORTANTE:
- Backups contêm **dados sensíveis**
- **NÃO** commit no Git
- **NÃO** compartilhe publicamente

### ✅ Já configurado no `.gitignore`:
```gitignore
backups/
*.sql
```

---

## 💡 DICAS:

1. **Nomeie com data:** `backup-prod-2024-01-15.sql`
2. **Mantenha 3-4 backups recentes** (delete antigos)
3. **Teste restauração** de vez em quando
4. **Backup antes de cada deploy**

---

## 🚀 SCRIPTS DISPONÍVEIS:

```batch
# Abre Dashboard para backup
.\BACKUP-VIA-DASHBOARD.bat

# (Alternativa, mas limitada)
.\BACKUP-API-REST.ps1
```

---

## ✅ RESULTADO ESPERADO:

Após executar, você terá:
```
✅ 2 páginas abertas no navegador
✅ 2 backups criados (PROD + DEV)
✅ 2 arquivos .sql baixados
✅ Dados seguros e recuperáveis
```

---

## 📞 PRÓXIMOS PASSOS:

1. Execute agora: `.\BACKUP-VIA-DASHBOARD.bat`
2. Siga os passos na tela
3. Salve os backups na pasta `backups/`
4. Pronto! Seus dados estão seguros ✅

---

**Tempo total:** ~2 minutos  
**Frequência:** Semanal (ou antes de mudanças)  
**Dificuldade:** ⭐⭐⭐⭐⭐ Muito fácil!
