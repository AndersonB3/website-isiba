# ⚡ GUIA RÁPIDO: CONFIGURAR AMBIENTE LOCAL

## 📝 PASSO 1: Cole suas credenciais de DEV

Abra: `assets/js/supabase-config.dev.js`

Cole suas credenciais do projeto de **DESENVOLVIMENTO**:

```javascript
const SUPABASE_URL_DEV = 'https://SEU_PROJETO_DEV.supabase.co';
const SUPABASE_ANON_KEY_DEV = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

## 🚀 PASSO 2: Inicie o servidor local

```powershell
cd "C:\Users\Usuario\Desktop\WEBSITE ISIBA"
python -m http.server 8000
```

## ✅ PASSO 3: Teste

Abra: http://localhost:8000

Você verá:
- **Badge laranja**: `🔧 DESENVOLVIMENTO`
- **Console (F12)**: `🗄️ Banco: https://SEU_DEV.supabase.co`

## 🌐 PRODUÇÃO (GitHub Pages)

Quando acessar: https://andersonb3.github.io/website-isiba/

Verá:
- **Sem badge**
- **Console**: `🗄️ Banco: https://kklhcmrnraroletwbbid.supabase.co`

---

## 📊 TABELA RESUMO

| Local | URL | Banco | Badge |
|-------|-----|-------|-------|
| **Seu PC** | localhost:8000 | DEV | 🔧 Laranja |
| **Painel RH** | localhost:8000/painel-rh/ | DEV | 🔧 Laranja |
| **GitHub Pages** | andersonb3.github.io | PRODUÇÃO | Sem badge |

---

## 🔧 ARQUIVOS ATUALIZADOS

✅ **7 arquivos HTML** agora usam o loader automático:
- index.html
- relatorio.html
- portal-colaborador.html
- colaborador.html
- admin-rh.html
- painel-rh/admin-rh.html
- primeiro-acesso.html

**Todos detectam automaticamente** qual banco usar! 🎯

---

## 📁 ARQUIVOS IMPORTANTES

```
assets/js/
├── supabase-config-loader.js       ← Detecta ambiente
├── supabase-config.dev.js          ← VOCÊ CONFIGURA AQUI
└── supabase-config.js              ← Produção (já configurado)
```

---

## 🎉 PRONTO!

Agora você pode:
- ✅ Testar localmente sem medo (banco DEV)
- ✅ Produção continua funcionando (banco PROD)
- ✅ Nenhuma alteração local afeta produção
- ✅ Código detecta ambiente automaticamente
