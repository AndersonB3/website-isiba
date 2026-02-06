# 🔒 COPIAR POLÍTICAS RLS DE PRODUÇÃO PARA DESENVOLVIMENTO

## 📋 PROBLEMA IDENTIFICADO

O erro `❌ CPF não encontrado no banco` acontece porque:
- ✅ Os dados existem no banco
- ❌ As políticas RLS (Row Level Security) bloqueiam a leitura via API anon

**RLS ativo sem políticas corretas = API retorna 0 linhas**

---

## 🎯 SOLUÇÃO: Copiar Políticas do Banco de Produção

### **PASSO 1: Verificar Status RLS em Produção**

Execute no banco de **PRODUÇÃO**:

```sql
-- Arquivo: VERIFICAR-RLS-PRODUCAO.sql
```

Isso vai mostrar:
- Quais tabelas têm RLS habilitado
- Quantas políticas cada tabela tem

---

### **PASSO 2: Listar Políticas Detalhadas**

Execute no banco de **PRODUÇÃO**:

```sql
-- Arquivo: LISTAR-POLITICAS-PRODUCAO.sql
```

Vai mostrar todas as políticas com:
- Nome da política
- Tabela
- Comando (SELECT, INSERT, UPDATE, DELETE)
- Condições (USING e WITH CHECK)

---

### **PASSO 3: Gerar Script de ENABLE RLS**

Execute no banco de **PRODUÇÃO**:

```sql
-- Arquivo: GERAR-ENABLE-RLS.sql
```

**Copie o resultado** (será algo como):
```sql
ALTER TABLE colaboradores ENABLE ROW LEVEL SECURITY;
ALTER TABLE contracheques ENABLE ROW LEVEL SECURITY;
ALTER TABLE recibos_documentos ENABLE ROW LEVEL SECURITY;
...
```

**Execute no banco de DESENVOLVIMENTO**

---

### **PASSO 4: Gerar Script das Políticas**

Execute no banco de **PRODUÇÃO**:

```sql
-- Arquivo: GERAR-POLITICAS-RLS.sql
```

**Copie TODO o resultado** (será algo como):
```sql
CREATE POLICY "Colaboradores podem ver seus próprios dados"
    ON colaboradores
    FOR SELECT
    USING (auth.uid()::text = id::text OR auth.role() = 'authenticated');

CREATE POLICY "Colaboradores podem atualizar seus dados"
    ON colaboradores
    FOR UPDATE
    USING (auth.uid()::text = id::text);
...
```

**Execute no banco de DESENVOLVIMENTO**

---

## ⚡ ORDEM DE EXECUÇÃO

### No Banco de **PRODUÇÃO**:
1. ✅ Execute: `VERIFICAR-RLS-PRODUCAO.sql`
2. ✅ Execute: `LISTAR-POLITICAS-PRODUCAO.sql` (para ver detalhes)
3. ✅ Execute: `GERAR-ENABLE-RLS.sql` (copie resultado)
4. ✅ Execute: `GERAR-POLITICAS-RLS.sql` (copie resultado)

### No Banco de **DESENVOLVIMENTO**:
5. ✅ Execute os comandos `ALTER TABLE ... ENABLE RLS;`
6. ✅ Execute os comandos `CREATE POLICY ...;`

---

## 🧪 TESTAR DEPOIS

Depois de aplicar as políticas, teste novamente:

1. Recarregue: http://localhost:8000/portal-colaborador.html
2. Tente login com CPF: `08676044503`
3. Console deve mostrar: `✅ Login realizado com sucesso!`

---

## 🔍 SE AS POLÍTICAS BLOQUEAREM O LOGIN

**Problema:** Políticas de produção podem exigir `auth.uid()`, mas no login ainda não há sessão autenticada.

**Solução Temporária para DEV:**

```sql
-- SOMENTE NO BANCO DE DESENVOLVIMENTO
-- Permitir SELECT público para login funcionar

DROP POLICY IF EXISTS "Colaboradores podem ver seus próprios dados" ON colaboradores;

CREATE POLICY "allow_select_for_login_dev"
    ON colaboradores
    FOR SELECT
    USING (true); -- ⚠️ APENAS PARA DEV!
```

**⚠️ IMPORTANTE:** Esta política permissiva é **APENAS PARA DESENVOLVIMENTO**. Nunca use em produção!

---

## 📊 EXEMPLO DE RESULTADO ESPERADO

### Verificar RLS:
```
┌────────────────────┬──────────────┬────────────────┐
│ tabela             │ status_rls   │ qtd_politicas  │
├────────────────────┼──────────────┼────────────────┤
│ colaboradores      │ HABILITADO ✅│ 2              │
│ contracheques      │ HABILITADO ✅│ 3              │
│ recibos_documentos │ HABILITADO ✅│ 2              │
│ administradores    │ HABILITADO ✅│ 1              │
└────────────────────┴──────────────┴────────────────┘
```

### Listar Políticas:
```
┌────────────────────┬─────────────────────────────────────────┬─────────┐
│ tabela             │ nome_politica                           │ comando │
├────────────────────┼─────────────────────────────────────────┼─────────┤
│ colaboradores      │ Colaboradores podem ver próprios dados  │ SELECT  │
│ colaboradores      │ Colaboradores podem atualizar dados     │ UPDATE  │
│ contracheques      │ Colaboradores veem seus contracheques   │ SELECT  │
└────────────────────┴─────────────────────────────────────────┴─────────┘
```

---

## 📁 ARQUIVOS CRIADOS

```
database/
├── VERIFICAR-RLS-PRODUCAO.sql       ← Ver status RLS
├── LISTAR-POLITICAS-PRODUCAO.sql    ← Ver detalhes das políticas
├── GERAR-ENABLE-RLS.sql             ← Gerar comandos ENABLE RLS
└── GERAR-POLITICAS-RLS.sql          ← Gerar comandos CREATE POLICY
```

---

## 🎯 EXECUTE AGORA

1. **Abra o SQL Editor do Supabase (PRODUÇÃO)**
2. **Execute:** `VERIFICAR-RLS-PRODUCAO.sql`
3. **Me mostre o resultado** para eu ver quais tabelas têm RLS
4. **Execute:** `GERAR-POLITICAS-RLS.sql`
5. **Copie o resultado** e **execute no banco DEV**

---

## ✅ RESULTADO FINAL

Depois de copiar as políticas:
- ✅ Banco DEV com mesmas políticas de PROD
- ✅ Login funcionando localmente
- ✅ Dados protegidos por RLS
- ✅ Ambiente de desenvolvimento seguro

🚀 **Vamos fazer isso agora!**
