# ✅ CHECKLIST RÁPIDO DE DEPLOY

## 📋 Antes de Começar

Tenha em mãos:
- [ ] Login do Supabase
- [ ] Login do GitHub
- [ ] 10-15 minutos de tempo

---

## 🚀 DEPLOY EM 5 PASSOS

### 1️⃣ CONFIGURAR SUPABASE (5 min)

**Acesse:** https://supabase.com/dashboard

```sql
-- Cole e execute TUDO de uma vez:

-- Criar tabelas
CREATE TABLE IF NOT EXISTS administradores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario TEXT UNIQUE NOT NULL,
    senha_hash TEXT NOT NULL,
    nome_completo TEXT NOT NULL,
    email TEXT,
    ativo BOOLEAN DEFAULT true,
    ultimo_acesso TIMESTAMPTZ,
    criado_em TIMESTAMPTZ DEFAULT now(),
    atualizado_em TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS colaboradores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nome_completo TEXT NOT NULL,
    cpf TEXT UNIQUE NOT NULL,
    cpf_hash TEXT NOT NULL,
    senha_hash TEXT NOT NULL,
    email TEXT,
    ativo BOOLEAN DEFAULT true,
    criado_em TIMESTAMPTZ DEFAULT now(),
    atualizado_em TIMESTAMPTZ DEFAULT now(),
    primeiro_acesso BOOLEAN DEFAULT true,
    codigo_funcionario VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS contracheques (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    colaborador_id UUID REFERENCES colaboradores(id) ON DELETE CASCADE,
    mes_referencia TEXT NOT NULL,
    ano INTEGER NOT NULL,
    arquivo_url TEXT NOT NULL,
    nome_arquivo TEXT NOT NULL,
    tamanho_arquivo BIGINT NOT NULL,
    enviado_por TEXT DEFAULT 'admin.rh',
    enviado_em TIMESTAMPTZ DEFAULT now(),
    tipo_documento VARCHAR(50) DEFAULT 'contracheque',
    visualizado BOOLEAN DEFAULT false,
    data_primeira_visualizacao TIMESTAMPTZ,
    recibo_gerado BOOLEAN DEFAULT false,
    assinatura_digital TEXT,
    mes TEXT,
    data_envio TIMESTAMPTZ DEFAULT now(),
    criado_em TIMESTAMPTZ DEFAULT now(),
    atualizado_em TIMESTAMPTZ DEFAULT now()
);

-- Índices
CREATE INDEX IF NOT EXISTS idx_administradores_usuario ON administradores(usuario);
CREATE INDEX IF NOT EXISTS idx_colaboradores_cpf_hash ON colaboradores(cpf_hash);
CREATE INDEX IF NOT EXISTS idx_contracheques_colaborador ON contracheques(colaborador_id);

-- RLS
ALTER TABLE administradores ENABLE ROW LEVEL SECURITY;
ALTER TABLE colaboradores ENABLE ROW LEVEL SECURITY;
ALTER TABLE contracheques ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public_read_admins" ON administradores FOR SELECT USING (true);
CREATE POLICY "public_read_colaboradores" ON colaboradores FOR SELECT USING (true);
CREATE POLICY "public_read_contracheques" ON contracheques FOR SELECT USING (true);

-- Inserir admin
INSERT INTO administradores (usuario, senha_hash, nome_completo, email, ativo)
VALUES (
    'admin.isiba',
    'b02f8c57df397a87a180adad0a62c0bb461cc159c379a3677f5f517f78cfe0b9',
    'Administrador ISIBA',
    'admin@isiba.com.br',
    true
) ON CONFLICT (usuario) DO UPDATE
SET senha_hash = EXCLUDED.senha_hash, atualizado_em = now();

-- Storage
INSERT INTO storage.buckets (id, name, public)
VALUES ('contracheques', 'contracheques', true)
ON CONFLICT (id) DO NOTHING;
```

✅ **Verificar:** Execute `SELECT * FROM administradores;` - Deve aparecer 1 linha

---

### 2️⃣ COPIAR CREDENCIAIS (2 min)

**Supabase → Project Settings → API**

Copie:
- [ ] **Project URL:** `https://xxxxx.supabase.co`
- [ ] **anon public:** `eyJhbG...` (chave longa)

---

### 3️⃣ ATUALIZAR CÓDIGO (2 min)

Edite: `painel-rh/assets/js/supabase-config.js`

```javascript
const CONFIG = {
    SUPABASE_URL: 'COLE_URL_AQUI',
    SUPABASE_ANON_KEY: 'COLE_CHAVE_AQUI'
};
```

**Commit:**
```bash
git add painel-rh/assets/js/supabase-config.js
git commit -m "config: adicionar credenciais do Supabase para producao"
git push origin develop
git checkout master
git merge develop
git push origin master
git checkout develop
```

---

### 4️⃣ ATIVAR GITHUB PAGES (1 min)

**GitHub → website-isiba → Settings → Pages**

Configure:
- [ ] **Source:** Deploy from a branch
- [ ] **Branch:** master
- [ ] **Folder:** / (root)
- [ ] Clique em **Save**

⏳ **Aguarde 2-5 minutos** para o deploy

---

### 5️⃣ TESTAR (2 min)

**URL:** `https://andersonb3.github.io/website-isiba/painel-rh/admin-rh.html`

**Login:**
```
👤 admin.isiba
🔐 redeaberta@$2026
```

**Verificar:**
- [ ] Página carrega sem erros
- [ ] Console mostra "Supabase configurado"
- [ ] Login funciona
- [ ] Dashboard aparece

---

## ✅ PRONTO!

Site no ar: `https://andersonb3.github.io/website-isiba/`

**Próximos passos:**
1. Trocar senha do admin (use `trocar-senha.html`)
2. Cadastrar colaboradores de teste
3. Testar upload de contracheques

---

## 🐛 Problemas?

### ❌ "Usuário ou senha incorretos"
```sql
-- Execute no Supabase:
UPDATE administradores 
SET senha_hash = 'b02f8c57df397a87a180adad0a62c0bb461cc159c379a3677f5f517f78cfe0b9'
WHERE usuario = 'admin.isiba';
```

### ❌ "Supabase não configurado"
- Revise `supabase-config.js`
- Confirme URL e Key corretos
- Limpe cache (Ctrl+Shift+R)

### ❌ Página 404
- Aguarde 5 minutos após ativar Pages
- Confirme que branch master tem os arquivos
- Verifique se Pages está ativo

---

**Tempo total:** ~12 minutos ⏱️
