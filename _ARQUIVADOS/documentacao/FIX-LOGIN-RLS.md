# ⚡ QUICK FIX: Login Não Funciona por Causa do RLS

## ❌ PROBLEMA
```
❌ [DEBUG] CPF não encontrado no banco
```

**Causa:** RLS (Row Level Security) ativo sem políticas corretas

---

## ✅ SOLUÇÃO RÁPIDA (3 minutos)

### 1️⃣ No Supabase PRODUÇÃO

Execute: `database/GERAR-POLITICAS-RLS.sql`

**Copie TODO o resultado**

---

### 2️⃣ No Supabase DESENVOLVIMENTO

**Cole e execute** o resultado copiado

---

### 3️⃣ Teste o Login

Recarregue: http://localhost:8000/portal-colaborador.html

Login com: CPF `08676044503`

---

## 🔧 SE AINDA NÃO FUNCIONAR

Execute no banco **DESENVOLVIMENTO**:

```sql
-- Política permissiva para DEV
DROP POLICY IF EXISTS "Colaboradores podem ver seus próprios dados" ON colaboradores;

CREATE POLICY "allow_select_for_login_dev"
    ON colaboradores
    FOR SELECT
    USING (true);
```

⚠️ Esta política é **APENAS PARA DESENVOLVIMENTO** - nunca use em produção!

---

## 📁 Arquivos Criados

- `VERIFICAR-RLS-PRODUCAO.sql` - Ver status
- `LISTAR-POLITICAS-PRODUCAO.sql` - Ver detalhes
- `GERAR-ENABLE-RLS.sql` - Habilitar RLS
- `GERAR-POLITICAS-RLS.sql` - **ESTE É O PRINCIPAL**

---

**Execute agora: `GERAR-POLITICAS-RLS.sql` no banco de PRODUÇÃO!**
