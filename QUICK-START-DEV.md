# 🚀 Quick Start: Configurar Ambiente de Desenvolvimento

## ✅ Checklist Rápido (15 minutos)

### 1. Criar Projeto no Supabase
- Acesse: https://supabase.com/dashboard
- Clique: **New Project**
- Nome: `isiba-desenvolvimento`
- Senha: anote em local seguro
- Region: **South America (São Paulo)**
- Aguarde 2-3 minutos

### 2. Executar Script SQL
- Abra: **SQL Editor** no novo projeto
- Cole o script: `database/MIGRAÇÃO-DESENVOLVIMENTO.sql`
- Clique: **Run**
- ✅ Deve aparecer: "Success. No rows returned"

### 3. Criar Bucket de Storage
- Vá em: **Storage**
- Clique: **Create bucket**
- Nome: `contracheques`
- Public: **NÃO** ❌
- File size: `10 MB`
- MIME: `application/pdf`

### 4. Aplicar Políticas de Storage
- Cole o script: `database/POLITICAS-STORAGE.sql`
- Execute no SQL Editor
- ✅ Deve criar 5 políticas

### 5. Configurar Credenciais
- Vá em: **Settings > API**
- Copie: **Project URL** e **anon public key**
- Abra: `assets/js/supabase-config.dev.js`
- Cole as credenciais
- **Salve o arquivo**

### 6. Testar
```bash
python -m http.server 8000
```
- Acesse: http://localhost:8000
- ✅ Deve ver badge laranja: "🔧 DESENVOLVIMENTO"
- ✅ Console deve mostrar: "🔧 AMBIENTE: DESENVOLVIMENTO"

---

## 🔐 Usuários de Teste

### Admin RH
- **Usuário:** `admin.rh`
- **Senha:** `admin123`

### Colaboradores
- **CPF:** `12345678901` | **Senha:** `123456` | **Nome:** João da Silva
- **CPF:** `98765432101` | **Senha:** `123456` | **Nome:** Maria Santos
- **CPF:** `11122233344` | **Senha:** `123456` | **Nome:** Pedro Oliveira

---

## ⚠️ Importante

- ❌ **NUNCA** commite o arquivo `supabase-config.dev.js`
- ✅ Ele já está no `.gitignore`
- ✅ Produção continua funcionando normalmente
- ✅ Dados de produção estão 100% seguros

---

## 📚 Documentação Completa

Leia: `GUIA-AMBIENTES.md` para detalhes completos

---

**Pronto! Agora você pode desenvolver localmente sem medo!** 🎉
