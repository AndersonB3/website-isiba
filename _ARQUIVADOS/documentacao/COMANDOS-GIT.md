# 🚀 COMANDOS PARA SUBIR NO GITHUB PAGES

Execute estes comandos na pasta do projeto:

```powershell
# 1. Ver o que será commitado
git status

# 2. Adicionar todos os arquivos
git add .

# 3. Commit com mensagem descritiva
git commit -m "feat: convert to GitHub Pages - static files only"

# 4. Push para o repositório
git push origin develop

# (Se usar master)
# git push origin master
```

---

## 📋 ATIVAR GITHUB PAGES:

1. Acesse: https://github.com/SEU-USUARIO/website-isiba/settings/pages

2. Configurar:
   - **Source:** Deploy from a branch
   - **Branch:** `develop` (ou `master`)
   - **Folder:** `/ (root)`
   - Clique em **Save**

3. Aguardar 1-5 minutos

4. Acessar: https://seu-usuario.github.io/website-isiba/

---

## 🌐 URLs APÓS DEPLOY:

- Site: `https://seu-usuario.github.io/website-isiba/`
- Admin RH: `https://seu-usuario.github.io/website-isiba/admin-rh.html`
- Portal Colaborador: `https://seu-usuario.github.io/website-isiba/colaborador.html`

---

## ✅ TUDO PRONTO PARA O GIT!

**Arquivos movidos:**
- ✅ admin-rh.html → Raiz
- ✅ CSS e JS → assets/

**Servidor Node.js:**
- ❌ Não precisa mais!
- ✅ Tudo funciona direto no navegador

**Próximo passo:**
Execute os comandos acima! 🚀
