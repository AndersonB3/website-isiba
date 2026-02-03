# 🔧 SOLUÇÃO - CADEADO NÃO APARECE

## ❌ PROBLEMA
Documentos não mostram cadeado, badge vermelho nem botão vermelho.

---

## 🔍 DIAGNÓSTICO RÁPIDO

### **1. Abra o Console do navegador (F12)**

Procure por mensagens como:
```javascript
📋 Documento: { id: "...", mes: "Janeiro", ano: 2026, recibo_gerado: null }
🔍 Status: { bloqueado: true, badgeText: "Bloqueado" }
```

**Se aparecer `recibo_gerado: null`** → Problema encontrado!

---

## ✅ SOLUÇÃO

### **PASSO 1: Execute no Supabase SQL Editor**

```sql
-- Ver estado atual
SELECT 
    mes_referencia,
    ano,
    recibo_gerado,
    visualizado
FROM contracheques
LIMIT 5;
```

**Resultado esperado:**
- Se mostrar `NULL` → Precisa atualizar!
- Se mostrar `false` → Já está certo

### **PASSO 2: Se estiver NULL, execute:**

```sql
-- Atualizar todos para FALSE (bloqueado)
UPDATE contracheques 
SET recibo_gerado = false,
    visualizado = false
WHERE recibo_gerado IS NULL;
```

### **PASSO 3: Verificar:**

```sql
-- Todos devem estar FALSE agora
SELECT recibo_gerado, COUNT(*) 
FROM contracheques 
GROUP BY recibo_gerado;
```

**Deve mostrar:**
```
recibo_gerado | count
--------------|------
false         | 5
```

### **PASSO 4: Recarregar o Portal**

```
1. Volte no portal: http://localhost:8000/portal-colaborador.html
2. Pressione Ctrl+Shift+R (recarregar forçado)
3. Faça login novamente
4. AGORA deve aparecer os cadeados! 🔒
```

---

## 🐛 OUTROS PROBLEMAS POSSÍVEIS

### **Problema 1: CSS não carregou**

**Verificar no Console (F12 > Network):**
```
Procure: recibo-modal.css
Status: 200 OK ✅
Status: 404 ❌ (arquivo não encontrado)
```

**Solução se 404:**
```powershell
# No terminal (pasta raiz do projeto):
Copy-Item assets/css/recibo-modal.css assets/css/recibo-modal.css -Force
```

### **Problema 2: JS não carregou**

**Verificar no Console (F12):**
```
Procure: "✅ recibo-modal.js carregado"
Se NÃO aparecer → arquivo não foi carregado
```

**Solução:**
1. Verifique se o arquivo existe: `assets/js/recibo-modal.js`
2. Verifique no HTML se está importado:
   ```html
   <script src="assets/js/recibo-modal.js"></script>
   ```

### **Problema 3: Servidor na porta errada**

**Você está em:**
```
http://localhost:8000/portal-colaborador.html ✅
```

**NÃO:**
```
http://localhost:3001 ❌ (essa é do painel RH)
```

---

## 🧪 TESTE COMPLETO

### **1. Execute o Diagnóstico:**

**Arquivo:** `DIAGNOSTICO_BLOQUEIO.sql`

Copie TODO o conteúdo e execute no Supabase SQL Editor.

### **2. Veja os resultados:**

```sql
-- Deve mostrar:
total_documentos | bloqueados | liberados | nulls
-----------------|------------|-----------|------
5                | 5          | 0         | 0
```

**Se `nulls` for maior que 0:**
```sql
UPDATE contracheques 
SET recibo_gerado = false
WHERE recibo_gerado IS NULL;
```

### **3. Limpe o cache do navegador:**

```
1. Ctrl+Shift+Delete
2. Marque: "Cache" e "Cookies"
3. Clique em "Limpar"
4. Feche o navegador
5. Abra novamente
```

### **4. Teste novamente:**

```
1. http://localhost:8000/portal-colaborador.html
2. Login
3. Veja os documentos
4. Abra Console (F12)
5. Procure as mensagens de debug
```

---

## 📸 COMO DEVE FICAR

### **No Console (F12):**
```javascript
✅ recibo-modal.js carregado
📝 Inicializando sistema de recibos...
✅ 5 contracheques encontrados
📋 Documento: { recibo_gerado: false }  ← FALSE, não NULL!
🔍 Status: { bloqueado: true }
```

### **Na Tela:**
```
┌─────────────────────────┐
│  🔒 (cadeado gigante)   │  ← Deve aparecer!
│                         │
│  🔒 JANEIRO 2026        │  ← Ícone cadeado
│     Contracheque        │
│     🔴 Bloqueado        │  ← Badge vermelho
│                         │
│  [🔒 Assinar Recibo...] │  ← Botão vermelho
└─────────────────────────┘
```

---

## 📞 AINDA NÃO FUNCIONOU?

### **Me envie:**

1. **Print da tela** do portal (mostrando os documentos)
2. **Console do navegador** (F12 > Console)
3. **Resultado deste SQL:**
```sql
SELECT id, mes_referencia, ano, recibo_gerado 
FROM contracheques 
LIMIT 3;
```

---

## 🎯 CHECKLIST RÁPIDO

- [ ] SQL do sistema foi executado?
- [ ] Coluna `recibo_gerado` existe?
- [ ] Valores estão em `false` (não NULL)?
- [ ] Portal está em localhost:8000?
- [ ] Console não mostra erros?
- [ ] Arquivos CSS/JS foram carregados?
- [ ] Cache do navegador foi limpo?
- [ ] Recarregou com Ctrl+Shift+R?

---

**Execute o diagnóstico e me avise o resultado!** 🔍
