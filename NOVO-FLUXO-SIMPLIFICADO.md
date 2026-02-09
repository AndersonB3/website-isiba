# 🎯 NOVO FLUXO DE TRABALHO SIMPLIFICADO

**Data:** 9 de Fevereiro de 2026  
**Mudança:** Removido banco DEV, mantendo apenas PRODUÇÃO

---

## 📊 ANTES vs AGORA

### ❌ ANTES (Dual-Database):
```
develop → Banco DEV (ikwnemhqqkpjurdpauim)
master  → Banco PROD (kklhcmrnraroletwbbid)

Problemas:
- Sincronização PROD → DEV
- Comparação de estruturas
- Dois bancos para manter
- Configurações diferentes
- Complexidade desnecessária
```

### ✅ AGORA (Single-Database):
```
develop → Banco PROD (kklhcmrnraroletwbbid)
master  → Banco PROD (kklhcmrnraroletwbbid)

Benefícios:
✓ Um banco apenas
✓ Sem sincronização
✓ Configuração única
✓ Testa com dados reais
✓ Muito mais simples!
```

---

## 🚀 NOVO FLUXO DE DESENVOLVIMENTO

### 1️⃣ **Desenvolvimento Local (Branch `develop`)**

```bash
# Mudar para branch develop
git checkout develop

# Fazer suas mudanças
# editar arquivos...

# Testar localmente
# Abre navegador: http://localhost ou file://

# ⚠️ IMPORTANTE: Está testando com banco PROD!
# Tenha cuidado com mudanças que afetam dados
```

---

### 2️⃣ **Commit Local**

```bash
# Adicionar mudanças
git add .

# Fazer commit
git commit -m "feat: descrição da mudança"

# Continuar desenvolvendo se necessário
# (fica só no seu computador)
```

---

### 3️⃣ **Deploy para Produção**

Quando suas mudanças estiverem prontas e testadas:

```bash
# 1. Ir para master
git checkout master

# 2. Merge develop → master
git merge develop

# 3. Push para GitHub
git push origin master

# 4. GitHub Pages atualiza automaticamente!
# Site fica disponível em: https://andersonb3.github.io/website-isiba/
```

---

## 🔧 CONFIGURAÇÃO ÚNICA

### Arquivo: `assets/js/supabase-config.js`

```javascript
// Único banco usado em TODAS as branches
const SUPABASE_URL = 'https://kklhcmrnraroletwbbid.supabase.co';
const SUPABASE_ANON_KEY = 'eyJ...';

window.supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
```

✅ **Mesmo arquivo em develop e master**  
✅ **Sem troca de configuração**  
✅ **Sem detecção de ambiente**

---

## ⚠️ CUIDADOS IMPORTANTES

### 1. **Backup Antes de Testar**

Como você testa direto em PRODUÇÃO:

```bash
# SEMPRE fazer backup antes de testar
.\BACKUP-VIA-DASHBOARD.bat

# Ou via Dashboard:
# https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/database/backups
```

### 2. **Teste com Cuidado**

- ✅ Teste funcionalidades visuais
- ✅ Teste login/logout
- ✅ Teste navegação
- ⚠️ Cuidado ao testar exclusão de dados
- ⚠️ Cuidado ao testar mudanças em massa

### 3. **Use Dados de Teste**

Se precisar testar com dados específicos:
- Crie um usuário de teste no banco PROD
- Use CPF fictício: 000.000.000-00
- Teste com esse usuário
- Delete depois se necessário

---

## 📁 ESTRUTURA DE BRANCHES

```
website-isiba/
├── master (produção)
│   ├── Código deployado no GitHub Pages
│   ├── Usa banco PROD
│   └── URL: https://andersonb3.github.io/website-isiba/
│
└── develop (desenvolvimento)
    ├── Código em desenvolvimento local
    ├── Usa banco PROD (mesmo que master)
    └── Testa antes de fazer merge
```

---

## 🎯 COMANDOS RÁPIDOS

### Desenvolvimento Diário:

```bash
# Começar o dia
git checkout develop
git pull origin master  # Atualizar com últimas mudanças

# Fazer mudanças
# ... editar arquivos ...

# Testar localmente
# ... abrir no navegador ...

# Commit
git add .
git commit -m "feat: nova funcionalidade"
```

### Deploy Semanal/Quando Pronto:

```bash
# Subir para produção
git checkout master
git merge develop
git push origin master

# Voltar para develop
git checkout develop
```

---

## 📋 CHECKLIST DE DEPLOY

Antes de fazer `git push origin master`:

- [ ] ✅ Testei localmente na branch develop
- [ ] ✅ Fiz backup do banco PROD
- [ ] ✅ Todas as funcionalidades funcionam
- [ ] ✅ Não tem erros no console
- [ ] ✅ Commit message está claro
- [ ] ✅ Estou na branch master
- [ ] ✅ Fiz merge develop → master
- [ ] 🚀 Posso fazer push!

---

## 🛠️ SCRIPTS DISPONÍVEIS

### Backup:
```bash
.\BACKUP-VIA-DASHBOARD.bat     # Backup via Dashboard (recomendado)
.\BACKUP-AUTOMATICO.bat         # Backup via CLI (se firewall liberado)
```

### Gerenciamento:
```bash
.\MENU-SUPABASE.bat             # Menu interativo
```

---

## 📚 DOCUMENTAÇÃO

### Guias Essenciais:
- `README.md` - Documentação principal
- `GIT-WORKFLOW.md` - Workflow Git detalhado
- `GUIA-BACKUP-DASHBOARD.md` - Como fazer backup
- `GUIA-SUPABASE-CLI.md` - Referência CLI

### Removidos (não necessários mais):
- ~~ARQUITETURA-BRANCHES-BANCOS.md~~ (dual-banco)
- ~~CONFIGURAR-AMBIENTES.md~~ (setup dual)
- ~~GUIA-AMBIENTES.md~~ (ambientes)
- ~~COPIAR-PROD-PARA-DEV.bat~~ (sincronização)
- ~~SINCRONIZAR-ESTRUTURA.bat~~ (sincronização)

Todos movidos para: `_ARQUIVADOS/banco-dev-removido/`

---

## 🎉 BENEFÍCIOS DA SIMPLIFICAÇÃO

1. ✅ **70% menos arquivos** de configuração
2. ✅ **Zero sincronização** necessária
3. ✅ **Workflow mais simples** de entender
4. ✅ **Menos erros** de configuração
5. ✅ **Testa com dados reais** (mais realista)
6. ✅ **Deploy mais rápido** (sem verificações de ambiente)

---

## 🔄 EXEMPLO COMPLETO

### Cenário: Adicionar nova funcionalidade

```bash
# 1. Começar desenvolvimento
git checkout develop

# 2. Fazer mudanças
# editar colaborador.html, adicionar novo botão...

# 3. Testar localmente
# abrir no navegador, verificar se funciona

# 4. Commit
git add colaborador.html
git commit -m "feat: adicionar botão de ajuda no portal"

# 5. Continuar desenvolvendo...
# fazer mais mudanças, mais commits...

# 6. Quando tudo estiver pronto:
git checkout master
git merge develop
git push origin master

# 7. Aguardar GitHub Pages deployar (~1 minuto)
# 8. Verificar: https://andersonb3.github.io/website-isiba/

# 9. Voltar para develop para continuar
git checkout develop
```

---

## 📞 SUPORTE

**Dúvidas?** Consulte:
- `README.md` - Visão geral do projeto
- `GIT-WORKFLOW.md` - Workflow detalhado
- `PLANO-SIMPLIFICACAO.md` - Por que mudamos

---

**Status:** ✅ Simplificação concluída  
**Data:** 9 de Fevereiro de 2026  
**Banco único:** PRODUÇÃO (kklhcmrnraroletwbbid)  
**Fluxo:** develop → master → GitHub Pages
