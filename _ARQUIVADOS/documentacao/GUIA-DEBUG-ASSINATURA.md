# 🔍 DEBUG - ASSINATURA NÃO APARECE

## 🎯 PASSO A PASSO PARA RESOLVER

---

## 1️⃣ LIMPAR CACHE (SEMPRE PRIMEIRO!)

```
Ctrl + Shift + R
```

---

## 2️⃣ VERIFICAR CONSOLE DO NAVEGADOR

Abra o painel RH e o console (F12), depois clique em "Ver Detalhes" de um recibo.

### ✅ Você DEVE ver estas mensagens:

```javascript
✅ recibo-admin.js VERSÃO 3.2 - FIX ASSINATURA_CANVAS carregado
🔍 Buscando detalhes do recibo: d5fa52d4-...

// LOGS DE DEBUG NOVOS:
📋 DADOS COMPLETOS DO RECIBO: { ... }
🔍 assinatura_canvas: EXISTE ✅  (ou NÃO EXISTE ❌)
🔍 assinatura_digital: EXISTE ✅ (ou NÃO EXISTE ❌)
🔍 assinatura_texto: João Silva

// Se existir:
✅ Preview da assinatura: data:image/png;base64,iVBORw0K...

// No modal:
🔍 DEBUG MODAL - Dados recebidos: { ... }
🔍 assinatura_canvas: TEM ✅ (ou NÃO TEM ❌)
```

---

## 3️⃣ ANALISAR O RESULTADO

### ❌ CASO 1: Console mostra "NÃO EXISTE ❌"

**Problema:** A view não tem o campo `assinatura_canvas`

**Solução:** Execute o arquivo `DEBUG-ASSINATURA-VIEW.sql` no Supabase

Passo a passo:
1. Abra Supabase SQL Editor
2. Execute **PASSO 1** do SQL (ver colunas da view)
3. Procure por `assinatura_canvas` na lista
4. Se não aparecer, execute o **DROP VIEW e CREATE VIEW**
5. Execute **PASSO 5** para confirmar

---

### ❌ CASO 2: Console mostra "EXISTE ✅" mas modal mostra "NÃO TEM ❌"

**Problema:** Dados não estão chegando no modal

**Solução:** Verifique se há erro entre os logs

---

### ✅ CASO 3: Console mostra "TEM ✅" mas não aparece na tela

**Problema:** CSS ou HTML com problema

**Solução:** 
1. Inspecione elemento (botão direito → Inspecionar)
2. Procure por `.assinatura-digital-box`
3. Veja se está oculto (display: none)

---

## 4️⃣ EXECUTAR SQL DE DEBUG

Cole o ID do recibo que aparece no console:

```sql
-- Substitua pelo ID do console
SELECT 
    recibo_id,
    nome_completo,
    assinatura_canvas IS NOT NULL as tem_canvas,
    LEFT(assinatura_canvas, 50) as preview
FROM view_recibos_completos
WHERE recibo_id = 'd5fa52d4-9dd7-46c2-bf8e-f17ebd4f7bc3';
```

### ✅ Resultado esperado:
```
tem_canvas: true
preview: data:image/png;base64,iVBORw0K...
```

### ❌ Se retornar NULL:
O recibo foi gerado **antes** do sistema de canvas. 
Precisa gerar um novo recibo para ter assinatura.

---

## 5️⃣ VERIFICAR TABELA DIRETA

```sql
SELECT 
    id,
    assinatura_texto,
    assinatura_canvas IS NOT NULL as tem_assinatura,
    LEFT(assinatura_canvas, 50) as preview,
    criado_em
FROM recibos_documentos
WHERE id = 'd5fa52d4-9dd7-46c2-bf8e-f17ebd4f7bc3';
```

### Se TEM assinatura na tabela, mas NÃO aparece na view:
❌ **A view está desatualizada!**

**Solução:** Recriar a view com o SQL do arquivo `DEBUG-ASSINATURA-VIEW.sql`

---

## 6️⃣ TESTAR COM NOVO RECIBO

Se o recibo atual é antigo (antes do canvas):

1. Vá no Portal do Colaborador
2. Execute o SQL: `LIMPAR_RAPIDO_SIMPLES.sql` (bloquear documentos)
3. Ctrl+Shift+R no portal
4. Assine o recibo novamente (desenhando no canvas)
5. Vá no Painel RH
6. Ctrl+Shift+R
7. Veja detalhes do novo recibo

---

## 🎯 RESUMO DO DIAGNÓSTICO

```
┌─────────────────────────────────────────────┐
│  CHECKLIST DE DEBUG                         │
├─────────────────────────────────────────────┤
│  [ ] Cache limpo (Ctrl+Shift+R)            │
│  [ ] Console mostra v3.2                   │
│  [ ] Log "📋 DADOS COMPLETOS" aparece      │
│  [ ] Log "assinatura_canvas:" aparece      │
│  [ ] Status: EXISTE ✅ ou NÃO EXISTE ❌    │
│                                             │
│  SE NÃO EXISTE:                             │
│  [ ] Executar SQL passo 1 (ver colunas)    │
│  [ ] Campo assinatura_canvas na lista?     │
│  [ ] Se não: Recriar view (DROP/CREATE)    │
│  [ ] Testar novamente                      │
│                                             │
│  SE EXISTE mas não aparece:                 │
│  [ ] Verificar log "DEBUG MODAL"           │
│  [ ] Ver se chegou: TEM ✅ ou NÃO TEM ❌   │
│  [ ] Inspecionar elemento HTML             │
│  [ ] Procurar .assinatura-digital-box      │
└─────────────────────────────────────────────┘
```

---

## 📋 COMANDOS RÁPIDOS

### Ver estrutura da view:
```sql
SELECT column_name 
FROM information_schema.columns
WHERE table_name = 'view_recibos_completos'
ORDER BY ordinal_position;
```

### Ver dados do recibo:
```sql
SELECT recibo_id, assinatura_canvas IS NOT NULL as tem
FROM view_recibos_completos
ORDER BY criado_em DESC
LIMIT 5;
```

### Recriar view (SE NECESSÁRIO):
```sql
-- Copie do arquivo: DEBUG-ASSINATURA-VIEW.sql
-- Seção "🚨 SE A VIEW NÃO TIVER O CAMPO"
```

---

## 🆘 AINDA NÃO FUNCIONOU?

### Me envie estes dados:

1. **Console completo** após clicar em "Ver Detalhes"
2. **Resultado do SQL:**
   ```sql
   SELECT recibo_id, assinatura_canvas IS NOT NULL, assinatura_texto
   FROM view_recibos_completos
   WHERE recibo_id = 'SEU_ID_AQUI';
   ```
3. **Screenshot** do modal aberto

---

**Com esses dados consigo identificar o problema exato!** 🔍
