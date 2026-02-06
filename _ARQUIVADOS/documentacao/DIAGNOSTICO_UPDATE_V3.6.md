# 🔍 DIAGNÓSTICO - VERSÃO 3.6 (UPDATE não funciona)

## 🚨 PROBLEMA IDENTIFICADO

O console mostra:
```
✅ Documento atualizado com assinatura digital!
🔄 Recarregando documentos para atualizar status...
```

**MAS** o documento continua com:
```json
"recibo_gerado": false  ← PROBLEMA!
```

### 💡 CAUSA RAIZ:
O **UPDATE no banco de dados está falhando silenciosamente!**

Possíveis causas:
1. ❌ **Política RLS faltando** para UPDATE na tabela `contracheques`
2. ❌ Permissões insuficientes
3. ❌ WHERE clause não encontra o registro

---

## ✅ CORREÇÕES APLICADAS (VERSÃO 3.6)

### 1️⃣ **Verificação de erro no UPDATE**
```javascript
// Linha 545 - recibo-modal.js
const { data: dataUpdate, error: errorUpdate } = await window.supabaseClient
    .from('contracheques')
    .update({ 
        recibo_gerado: true,
        visualizado: true,
        data_primeira_visualizacao: new Date().toISOString(),
        assinatura_digital: assinaturaDigital
    })
    .eq('id', documentoAtual.id)
    .select(); // ← RETORNA OS DADOS ATUALIZADOS

if (errorUpdate) {
    console.error('❌ ERRO ao atualizar contracheque:', errorUpdate);
    throw new Error('Falha ao atualizar documento: ' + errorUpdate.message);
}

console.log('✅ Documento atualizado com sucesso:', dataUpdate);
console.log('✅ recibo_gerado agora é:', dataUpdate?.[0]?.recibo_gerado);
```

### 2️⃣ **Script SQL para corrigir políticas RLS**
Arquivo: `CORRIGIR_POLITICAS_RLS.sql`

---

## 🧪 TESTE PASSO A PASSO

### **PASSO 1: Limpe o cache**
```
Ctrl + Shift + R
```

### **PASSO 2: Verifique versão no console (F12)**
```
🔥 Recibo Modal VERSÃO 3.6 - FIX UPDATE + DEBUG RLS carregado!
```

### **PASSO 3: Preencha o recibo**
1. Clique no documento bloqueado
2. Digite seu nome
3. Assine no canvas
4. Marque "Li e concordo"
5. Clique em "Confirmar"

### **PASSO 4: VERIFIQUE O CONSOLE**

**✅ SE FUNCIONAR, você verá:**
```
💾 Salvando recibo: {...}
✅ Recibo salvo com sucesso: [...]
📝 Atualizando documento ID: a0c3f024-409e-4576-b5ac-173e2efb353b
✅ Documento atualizado com sucesso: [...]
✅ recibo_gerado agora é: true  ← DEVE SER TRUE!
🔄 Recarregando documentos para atualizar status...
```

**❌ SE FALHAR, você verá:**
```
❌ ERRO ao atualizar contracheque: {
  code: "42501",
  message: "new row violates row-level security policy"
}
```

OU

```
✅ Documento atualizado com sucesso: []  ← ARRAY VAZIO = NÃO ATUALIZOU!
✅ recibo_gerado agora é: undefined
```

---

## 🔧 SOLUÇÃO: Corrigir Políticas RLS

### **Execute no Supabase SQL Editor:**

Abra: `CORRIGIR_POLITICAS_RLS.sql`

### **PASSO A: Verificar políticas existentes**
```sql
SELECT 
    policyname,
    cmd
FROM pg_policies 
WHERE tablename = 'contracheques'
ORDER BY cmd;
```

**Resultado esperado:**
```
policyname                           | cmd
-------------------------------------+--------
Colaboradores podem ver seus docs    | SELECT
Colaboradores podem atualizar docs   | UPDATE  ← ESSA LINHA DEVE EXISTIR!
```

**❌ Se não aparecer linha com UPDATE = PROBLEMA!**

---

### **PASSO B: Criar política de UPDATE**

Execute este comando:
```sql
CREATE POLICY "Permitir UPDATE em contracheques"
ON contracheques
FOR UPDATE
TO authenticated, anon
USING (true)
WITH CHECK (true);
```

---

### **PASSO C: Verificar se criou**
```sql
SELECT 
    policyname,
    cmd
FROM pg_policies 
WHERE tablename = 'contracheques' AND cmd = 'UPDATE';
```

**Deve retornar:** `Permitir UPDATE em contracheques | UPDATE`

---

### **PASSO D: Testar UPDATE manual**
```sql
-- Pegar ID de um documento
SELECT id, mes_referencia, recibo_gerado 
FROM contracheques 
WHERE recibo_gerado = false 
LIMIT 1;

-- Anotar o ID e testar:
UPDATE contracheques 
SET recibo_gerado = true
WHERE id = 'COLE_O_ID_AQUI';

-- Verificar:
SELECT id, mes_referencia, recibo_gerado 
FROM contracheques 
WHERE id = 'COLE_O_ID_AQUI';
```

**Resultado esperado:** `recibo_gerado: true`

---

## 📊 DIAGNÓSTICO COMPLETO

Execute no Supabase:
```sql
SELECT 
    '1. RLS Status' as info,
    tablename,
    CASE WHEN rowsecurity THEN '✅ Ativo' ELSE '❌ Desativado' END as status
FROM pg_tables 
WHERE schemaname = 'public' AND tablename = 'contracheques'

UNION ALL

SELECT 
    '2. Políticas' as info,
    cmd as tablename,
    COUNT(*)::text || ' políticas' as status
FROM pg_policies 
WHERE tablename = 'contracheques'
GROUP BY cmd

UNION ALL

SELECT 
    '3. Documentos' as info,
    'Total' as tablename,
    COUNT(*)::text as status
FROM contracheques;
```

**Resultado esperado:**
```
info          | tablename | status
--------------+-----------+------------------
1. RLS Status | contracheques | ✅ Ativo
2. Políticas  | SELECT    | 1 políticas
2. Políticas  | UPDATE    | 1 políticas  ← DEVE EXISTIR!
3. Documentos | Total     | 1
```

---

## 🎯 FLUXO DE DEBUG

```
1. Usuário preenche recibo
   ↓
2. JavaScript tenta UPDATE
   ↓
3. Supabase verifica RLS
   ├─ ✅ Tem política UPDATE? → Atualiza
   └─ ❌ Não tem política? → BLOQUEIA (erro silencioso)
   ↓
4. JavaScript verifica erro
   ├─ ✅ Sem erro? → "recibo_gerado agora é: true"
   └─ ❌ Com erro? → Mostra mensagem de erro
```

---

## 🔥 SOLUÇÃO RÁPIDA (Se tiver pressa)

### Opção 1: Criar política UPDATE (RECOMENDADO)
```sql
CREATE POLICY "Permitir UPDATE em contracheques"
ON contracheques FOR UPDATE TO authenticated, anon
USING (true) WITH CHECK (true);
```

### Opção 2: Desabilitar RLS temporariamente (NÃO RECOMENDADO)
```sql
ALTER TABLE contracheques DISABLE ROW LEVEL SECURITY;
```

---

## 📝 CHECKLIST

### ✅ Antes de testar no navegador:
- [ ] Executei `CORRIGIR_POLITICAS_RLS.sql` - PASSO 1
- [ ] Verifiquei que política UPDATE existe
- [ ] Se não existia, criei com PASSO B
- [ ] Testei UPDATE manual no Supabase (PASSO D)
- [ ] UPDATE manual funcionou (recibo_gerado virou true)

### ✅ Teste no navegador:
- [ ] Limpei cache (Ctrl+Shift+R)
- [ ] Console mostra versão 3.6
- [ ] Preenchir recibo
- [ ] **Console mostra:** `✅ recibo_gerado agora é: true`
- [ ] **Console NÃO mostra:** `❌ ERRO ao atualizar contracheque`
- [ ] Página recarrega
- [ ] Card muda para "Liberado"
- [ ] Cadeado desaparece

---

## 🚨 SE AINDA NÃO FUNCIONAR

Envie print de:

1. ✅ Console completo ao preencher recibo
2. ✅ Resultado da query:
   ```sql
   SELECT * FROM pg_policies WHERE tablename = 'contracheques';
   ```
3. ✅ Resultado do teste manual de UPDATE
4. ✅ Inspeção do card (botão direito → Inspecionar)

---

## 📞 MENSAGENS DE ERRO COMUNS

### Erro 42501:
```
code: "42501"
message: "new row violates row-level security policy"
```
**Solução:** Criar política UPDATE (PASSO B)

### Erro: dataUpdate é array vazio `[]`:
```
✅ Documento atualizado com sucesso: []
```
**Causa:** WHERE clause não encontrou o documento OU política bloqueou
**Solução:** Verificar se `documentoAtual.id` está correto

### Erro: recibo_gerado continua false:
```
recibo_gerado: false
```
**Causa:** UPDATE não executou por falta de política
**Solução:** Executar script `CORRIGIR_POLITICAS_RLS.sql`

---

🎯 **VERSÃO 3.6 - DEBUG COMPLETO IMPLEMENTADO!** 🎯
