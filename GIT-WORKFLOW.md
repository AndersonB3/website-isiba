# 🔀 ESTRATÉGIA DE BRANCHES - GIT WORKFLOW

## 📋 ESTRUTURA DE BRANCHES

### **🌿 Branch: `develop`**
- **Propósito:** Desenvolvimento ativo
- **Uso:** Todas as alterações e testes locais
- **Banco:** Supabase DEV
- **Deploy:** Não faz deploy automático

### **🚀 Branch: `master`**
- **Propósito:** Produção (GitHub Pages)
- **Uso:** Apenas código estável e testado
- **Banco:** Supabase PRODUÇÃO
- **Deploy:** Deploy automático para andersonb3.github.io

---

## 🔄 WORKFLOW RECOMENDADO

### **1. Trabalhar em Desenvolvimento**
```bash
# Mudar para branch develop
git checkout develop

# Verificar branch atual
git branch

# Fazer suas alterações...
# Testar localmente...
# Commit das alterações
git add .
git commit -m "feat: nova funcionalidade"
git push origin develop
```

### **2. Quando estiver pronto para Produção**
```bash
# Voltar para master
git checkout master

# Merge da develop na master
git merge develop

# Push para produção (GitHub Pages)
git push origin master
```

---

## ✅ COMANDOS RÁPIDOS

### Ver branch atual:
```bash
git branch
```

### Mudar para develop:
```bash
git checkout develop
```

### Mudar para master:
```bash
git checkout master
```

### Criar nova feature branch:
```bash
git checkout -b feature/nome-da-feature
```

---

## 🎯 BOAS PRÁTICAS

1. **NUNCA trabalhe direto na `master`**
   - Use sempre a `develop` para desenvolvimento

2. **Teste tudo na `develop` antes de fazer merge**
   - Execute testes locais
   - Verifique funcionalidades
   - Confirme que não quebrou nada

3. **Commits claros e descritivos**
   ```bash
   git commit -m "feat: adiciona upload em lote de PDFs"
   git commit -m "fix: corrige erro de login"
   git commit -m "docs: atualiza README"
   ```

4. **Sempre pull antes de push**
   ```bash
   git pull origin develop
   git push origin develop
   ```

---

## 📊 FLUXO VISUAL

```
develop (trabalho diário)
   │
   │ [desenvolver]
   │ [testar]
   │ [commit]
   │
   ├──► feature/upload-lote
   │       │
   │       └──► [merge de volta para develop]
   │
   └──► [quando estável]
        │
        ▼
     master (produção)
        │
        └──► GitHub Pages Deploy 🚀
```

---

## 🔧 SITUAÇÃO ATUAL

### Você está em: `master`
### Deve mudar para: `develop`

**Execute agora:**
```bash
git checkout develop
```

---

## 📝 VERIFICAÇÕES

Depois de mudar para develop:

```bash
# Ver branch atual (deve mostrar * develop)
git branch

# Ver status
git status

# Ver último commit
git log --oneline -5
```

---

## ⚠️ IMPORTANTE

- ✅ Alterações locais não commitadas **não são perdidas** ao trocar de branch
- ✅ Git vai avisar se houver conflitos
- ✅ Você pode fazer `git stash` se precisar salvar alterações temporariamente

---

## 🎯 PRÓXIMO PASSO

Execute no terminal:
```bash
git checkout develop
```

Depois me avise e continuamos! 🚀
