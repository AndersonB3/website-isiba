# 🔄 SIMPLIFICAÇÃO: Remover Banco DEV

**Data:** 9 de Fevereiro de 2026  
**Decisão:** Usar apenas banco PRODUÇÃO em ambas as branches

---

## 📋 PLANO DE SIMPLIFICAÇÃO

### 🎯 Objetivo:
Remover toda referência ao banco DEV e manter apenas PRODUÇÃO

### 📊 Novo Fluxo de Trabalho:
```
develop (local) 
    ↓ testa com banco PROD
    ↓ commit local
    ↓
master (local)
    ↓ merge develop → master  
    ↓ push
    ↓
GitHub Pages (produção)
```

---

## 🗑️ ARQUIVOS A REMOVER:

### 1. Configurações DEV:
```
✓ assets/js/supabase-config.dev.js
✓ assets/js/supabase-config-loader.js (se existir)
✓ painel-rh/assets/js/supabase-config.dev.js
```

### 2. Documentação DEV-específica:
```
✓ ARQUITETURA-BRANCHES-BANCOS.md (menciona 2 bancos)
✓ CONFIGURAR-AMBIENTES.md (setup dual)
✓ GUIA-AMBIENTES.md (guia de ambientes)
✓ QUICK-START-DEV.md (específico para DEV)
```

### 3. Scripts de sincronização:
```
✓ COPIAR-PROD-PARA-DEV.bat
✓ SINCRONIZAR-ESTRUTURA.bat
✓ COMPARAR-ESTRUTURAS-AUTO.bat
✓ GUIA-COPIAR-DADOS-PROD-DEV.md
✓ GUIA-COMPARAR-BANCOS.md
✓ SCRIPT-COPIAR-DADOS.sql
```

---

## ✅ ARQUIVOS A MANTER:

### Configuração única (PROD):
```
✓ assets/js/supabase-config.js (PROD only)
✓ painel-rh/assets/js/supabase-config.js (PROD only)
```

### Scripts úteis:
```
✓ BACKUP-VIA-DASHBOARD.bat
✓ BACKUP-AUTOMATICO.bat
✓ MENU-SUPABASE.bat
```

### Documentação geral:
```
✓ README.md
✓ GIT-WORKFLOW.md (ajustar para novo fluxo)
✓ GUIA-SUPABASE-CLI.md
✓ STATUS-FINAL-AUTOMACAO.md
```

---

## 📝 AJUSTES NECESSÁRIOS:

### 1. README.md
Atualizar para mencionar:
- Apenas 1 banco (PRODUÇÃO)
- Fluxo: develop → master → GitHub

### 2. GIT-WORKFLOW.md
Simplificar workflow:
- develop: desenvolvimento local com PROD
- master: produção no GitHub Pages

### 3. .gitignore
Remover linhas sobre config.dev.js

---

## 🚀 NOVO FLUXO SIMPLIFICADO:

### Desenvolvimento:
```bash
# 1. Trabalhar na branch develop
git checkout develop

# 2. Fazer mudanças (testa com banco PROD)
# editar arquivos...

# 3. Commit local
git add .
git commit -m "feat: nova funcionalidade"

# 4. Quando pronto para produção:
git checkout master
git merge develop
git push origin master

# 5. GitHub Pages atualiza automaticamente
```

### Não há mais:
- ❌ Troca de configuração entre ambientes
- ❌ Sincronização PROD → DEV
- ❌ Comparação de bancos
- ❌ Dois bancos diferentes

### Agora é:
- ✅ Um único banco (PRODUÇÃO)
- ✅ Testa localmente com dados reais
- ✅ Sobe direto pro GitHub
- ✅ Muito mais simples!

---

## ⚠️ CUIDADOS:

1. **Backup antes de testar:**
   - Sempre faça backup do banco PROD antes de testar
   - Use: `BACKUP-VIA-DASHBOARD.bat`

2. **Teste com cuidado:**
   - Como não tem mais banco DEV
   - Testes são feitos direto em PROD
   - Seja cauteloso com mudanças

3. **Branch develop:**
   - Continua existindo (desenvolvimento local)
   - Mas usa o mesmo banco que master
   - É só para organizar código antes do deploy

---

## 📊 VANTAGENS:

1. ✅ **Mais simples** - Um banco só
2. ✅ **Menos confusão** - Sem troca de config
3. ✅ **Menos arquivos** - Remove ~15 arquivos
4. ✅ **Dados reais** - Testa com dados de produção
5. ✅ **Menos scripts** - Sem sincronização

---

## ⏭️ PRÓXIMOS PASSOS:

1. **Remover arquivos DEV**
2. **Atualizar documentação**
3. **Simplificar .gitignore**
4. **Testar fluxo novo**
5. **Commit e push**

---

**Executar limpeza:** `EXECUTAR-SIMPLIFICACAO.bat` (criar)
