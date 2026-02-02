# 🔧 TROUBLESHOOTING - PRIMEIRO ACESSO NÃO FUNCIONOU

## ❌ Problema
Usuário foi criado no Painel RH, mas ao fazer login foi direto para o portal sem pedir troca de senha.

---

## 🔍 CAUSAS POSSÍVEIS

### 1️⃣ **SQL não foi executado**
A coluna `primeiro_acesso` não existe no banco de dados.

**Solução:**
- Execute: `ADICIONAR_PRIMEIRO_ACESSO.sql` no Supabase SQL Editor

---

### 2️⃣ **Campo não está sendo retornado** ✅ **CORRIGIDO!**
O código não estava incluindo o campo `primeiro_acesso` nos dados do login.

**O que foi corrigido:**
```javascript
// ANTES (assets/js/supabase-colaborador.js)
data: {
    id: data.id,
    nome: data.nome_completo,
    cpf: data.cpf,
    email: data.email
    // ❌ Faltava: primeiro_acesso
}

// DEPOIS ✅
data: {
    id: data.id,
    nome: data.nome_completo,
    cpf: data.cpf,
    email: data.email,
    primeiro_acesso: data.primeiro_acesso || false  // ✅ ADICIONADO!
}
```

---

### 3️⃣ **Usuário de teste foi criado ANTES do SQL**
Se o usuário foi cadastrado antes de executar o SQL, o campo `primeiro_acesso` está `NULL` no banco.

**Solução:**
- Execute: `VERIFICAR_E_CORRIGIR_TESTE.sql` (vai forçar `primeiro_acesso = true` no último usuário)

---

## 📋 CHECKLIST DE VERIFICAÇÃO

Execute os passos na ordem:

### **PASSO 1: Verificar se o SQL foi executado**
```sql
SELECT column_name 
FROM information_schema.columns
WHERE table_name = 'colaboradores' 
  AND column_name = 'primeiro_acesso';
```

**Resultado esperado:** Deve retornar 1 linha com `primeiro_acesso`

❌ **Se não retornar nada:** Execute `ADICIONAR_PRIMEIRO_ACESSO.sql`

---

### **PASSO 2: Verificar o usuário de teste**
```sql
SELECT 
    nome_completo, 
    cpf, 
    primeiro_acesso 
FROM colaboradores
ORDER BY created_at DESC 
LIMIT 1;
```

**Resultado esperado:** Campo `primeiro_acesso` deve ser `true`

❌ **Se for NULL ou false:** Execute `VERIFICAR_E_CORRIGIR_TESTE.sql`

---

### **PASSO 3: Limpar o cache do navegador**
1. Pressione **F12** (abrir DevTools)
2. Clique com botão direito no ícone de **Atualizar**
3. Escolha: **"Limpar cache e atualização forçada"**
4. Ou use: **Ctrl + Shift + Delete** → Limpar dados de navegação

---

### **PASSO 4: Testar novamente**
1. Faça logout (ou abra aba anônima)
2. Acesse: `colaborador.html`
3. Faça login com o usuário de teste
4. Pressione **F12** e vá na aba **Console**
5. Procure por: `🔍 [DEBUG] primeiro_acesso:`

**O que deve aparecer:**
```
🔍 [DEBUG] primeiro_acesso: true
✅ Login realizado! Você precisa trocar sua senha...
```

**Se aparecer `false` ou `undefined`:**
- O banco não retornou o campo corretamente
- Execute novamente o SQL de correção

---

## 🎯 SOLUÇÃO RÁPIDA

Execute estes 3 comandos SQL em sequência:

```sql
-- 1. Adicionar coluna (se não existir)
ALTER TABLE colaboradores 
ADD COLUMN IF NOT EXISTS primeiro_acesso BOOLEAN DEFAULT true;

-- 2. Forçar TRUE no usuário de teste
UPDATE colaboradores 
SET primeiro_acesso = true 
WHERE id = (SELECT id FROM colaboradores ORDER BY created_at DESC LIMIT 1);

-- 3. Verificar
SELECT nome_completo, cpf, primeiro_acesso 
FROM colaboradores 
ORDER BY created_at DESC 
LIMIT 3;
```

Depois:
1. Limpe o cache do navegador (Ctrl + Shift + Delete)
2. Faça login novamente
3. Deve redirecionar para `primeiro-acesso.html` ✅

---

## 🔬 DEBUG AVANÇADO

Abra o **Console do Navegador** (F12) ao fazer login.

### **Console deve mostrar:**
```
🔍 [DEBUG] Iniciando autenticação...
🔍 [DEBUG] CPF limpo: 12345678900
🔍 [DEBUG] Hash da senha gerado: abc123...
🔍 [DEBUG] Resposta do Supabase: { data: {...}, error: null }
🔍 [DEBUG] primeiro_acesso: true  ← DEVE SER TRUE!
✅ Colaborador autenticado: Nome do Teste
```

### **Se aparecer:**
- `primeiro_acesso: undefined` → Campo não existe no banco OU código não foi atualizado
- `primeiro_acesso: false` → Usuário já trocou a senha OU campo está NULL
- `primeiro_acesso: null` → SQL não foi executado corretamente

---

## ✅ CORREÇÃO APLICADA

**Arquivo:** `assets/js/supabase-colaborador.js`  
**Linha:** ~103  
**Status:** ✅ **CORRIGIDO!**

O campo `primeiro_acesso` agora é retornado corretamente pela função `autenticarColaborador()`.

---

## 📞 PRÓXIMOS PASSOS

1. ✅ **Execute:** `VERIFICAR_E_CORRIGIR_TESTE.sql`
2. 🧹 **Limpe o cache do navegador**
3. 🧪 **Teste novamente o login**
4. 👀 **Verifique o console (F12) durante o login**

---

## 🎊 RESULTADO ESPERADO

Ao fazer login com o usuário de teste:

1. ✅ Sistema detecta `primeiro_acesso = true`
2. ✅ Mostra mensagem: "Login realizado! Você precisa trocar sua senha..."
3. ✅ Redireciona automaticamente para: `primeiro-acesso.html`
4. ✅ Tela de troca de senha aparece
5. ✅ Após trocar, `primeiro_acesso` vira `false`
6. ✅ Próximo login vai direto para o portal

---

**Última atualização:** 02/02/2026 - Bug corrigido! 🎉
