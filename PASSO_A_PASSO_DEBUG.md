# 🔧 DIAGNÓSTICO - PASSO A PASSO

## 📍 ONDE VOCÊ ESTÁ AGORA

Console mostra:
```
✅ Supabase configurado
✅ 1 documentos encontrados  ← Tem documento!
✅ Colaborador identificado: undefined  ← Problema aqui
```

---

## 🎯 ETAPA 1: VERIFICAR NO SUPABASE

### **Execute este SQL:**

```sql
-- Ver o documento
SELECT 
    mes_referencia,
    ano,
    recibo_gerado,
    visualizado
FROM contracheques
ORDER BY enviado_em DESC
LIMIT 1;
```

### **RESULTADO ESPERADO:**

**Opção A - Se mostrar:**
```
mes_referencia | ano  | recibo_gerado | visualizado
---------------|------|---------------|------------
Janeiro        | 2026 | null          | null
```
➡️ **PROBLEMA:** Está NULL!  
➡️ **SOLUÇÃO:** Execute o UPDATE (passo 2)

**Opção B - Se mostrar:**
```
mes_referencia | ano  | recibo_gerado | visualizado
---------------|------|---------------|------------
Janeiro        | 2026 | false         | false
```
➡️ **ÓTIMO:** Já está correto!  
➡️ **SOLUÇÃO:** Vá para passo 3

---

## 🎯 ETAPA 2: ATUALIZAR PARA FALSE

### **Execute este SQL:**

```sql
UPDATE contracheques 
SET recibo_gerado = false,
    visualizado = false
WHERE recibo_gerado IS NULL;
```

### **VERIFICAR:**

```sql
SELECT 
    mes_referencia,
    recibo_gerado
FROM contracheques
LIMIT 3;
```

**Deve mostrar:**
```
mes_referencia | recibo_gerado
---------------|---------------
Janeiro        | false         ✅
```

---

## 🎯 ETAPA 3: RECARREGAR PORTAL

### **1. Limpar Cache:**
```
Ctrl + Shift + Delete
✅ Marcar: "Cache"
✅ Clicar: "Limpar"
```

### **2. Fechar navegador completamente**

### **3. Abrir novamente:**
```
http://localhost:8000/portal-colaborador.html
```

### **4. Abrir Console (F12)**

---

## 🎯 ETAPA 4: VER NOVO DEBUG

**No Console deve aparecer:**

```javascript
✅ 1 documentos encontrados
🔍 DEBUG COMPLETO - Primeiro documento:
{
  "id": "...",
  "mes_referencia": "Janeiro",
  "ano": 2026,
  "recibo_gerado": false,    ← DEVE SER FALSE!
  ...
}
🔍 Valor de recibo_gerado: false
🔍 Tipo: boolean
🔍 É NULL? false
🔍 É undefined? false
🔍 É false? true              ← DEVE SER TRUE!
🔍 É true? false

📋 Documento: { recibo_gerado: false, tipo: "boolean" }
🔍 Status: { bloqueado: true, badgeText: "Bloqueado" }
```

---

## 🎯 ETAPA 5: VER O RESULTADO

**Agora na tela DEVE aparecer:**

```
┌─────────────────────────────┐
│  🔒 (cadeado gigante)       │  ← ISSO!
│                             │
│  🔒 JANEIRO 2026            │  ← ISSO!
│     Contracheque            │
│     🔴 Bloqueado            │  ← ISSO!
│                             │
│  📅 Enviado em 03/02/2026   │
│  📄 29.5 KB                 │
│  👤 Enviado por admin.rh    │
│                             │
│  [🔒 Assinar Recibo...]     │  ← ISSO!
└─────────────────────────────┘
```

---

## ❓ E SE NÃO APARECER?

### **Me envie:**

**1. Resultado do SQL:**
```sql
SELECT recibo_gerado FROM contracheques LIMIT 1;
```

**2. Console completo** (copie e cole):
```
Procure por:
🔍 DEBUG COMPLETO - Primeiro documento:
🔍 Valor de recibo_gerado: ???
🔍 É false? ???
🔍 Status: ???
```

**3. Print da tela** do portal

---

## 📋 RESUMO RÁPIDO

```
1️⃣ SQL → Ver se recibo_gerado é NULL
2️⃣ SQL → UPDATE para false (se for NULL)
3️⃣ Limpar cache do navegador
4️⃣ Recarregar portal
5️⃣ Ver console → Deve mostrar false
6️⃣ Ver tela → Deve mostrar cadeado 🔒
```

---

**EXECUTE AGORA e me diga o resultado!** 🚀
