# 🔒 TESTE RÁPIDO - SISTEMA DE BLOQUEIO

## ⚡ TESTAR EM 5 MINUTOS

---

## 1️⃣ EXECUTAR SQL (2 min)

### **No Supabase SQL Editor:**

**Copie e execute:**
```sql
-- Bloquear todos os documentos existentes
UPDATE contracheques 
SET recibo_gerado = false
WHERE recibo_gerado IS NULL;

-- Verificar
SELECT COUNT(*) as total_bloqueados
FROM contracheques
WHERE recibo_gerado = false;
```

✅ **Resultado:** Número de documentos bloqueados

---

## 2️⃣ ACESSAR PORTAL (1 min)

```
http://localhost:8000/portal-colaborador.html
```

**Login:**
- CPF de um colaborador existente
- Senha cadastrada

---

## 3️⃣ VER DOCUMENTOS BLOQUEADOS (30 seg)

**Você deve ver:**

```
┌────────────────────────┐
│  🔒                    │ ← Cadeado gigante
│                        │
│  🔒 JANEIRO 2026       │
│     Contracheque       │
│     🔴 Bloqueado       │ ← Badge vermelho
│                        │
│  [ 🔒 Assinar Recibo ] │ ← Botão vermelho
└────────────────────────┘
```

---

## 4️⃣ CLICAR NO DOCUMENTO (1 min)

**Clique no botão vermelho** "Assinar Recibo para Desbloquear"

**Modal deve abrir:**
```
╔════════════════════════════╗
║ 📝 Recibo de Documento     ║
╠════════════════════════════╣
║ Tipo: Contracheque         ║
║ Período: Janeiro 2026      ║
║                            ║
║ [_____________________]    ║ ← Digite seu nome
║ [✓] Concordo              ║
║                            ║
║ [ ✅ Confirmar ]          ║
╚════════════════════════════╝
```

---

## 5️⃣ ASSINAR RECIBO (30 seg)

1. **Digite seu nome completo**
2. **Marque a checkbox**
3. **Clique em "Confirmar Recebimento"**

---

## 6️⃣ VER DESBLOQUEIO (30 seg)

**Automaticamente:**

✅ Mensagem verde aparece:
```
┌─────────────────────────────────┐
│ ✅ Recibo assinado com sucesso! │
│    O documento foi desbloqueado │
└─────────────────────────────────┘
```

✅ Documento muda para:
```
┌────────────────────────┐
│  📄 JANEIRO 2026       │
│     Contracheque       │
│     ✅ Liberado        │ ← Badge verde
│                        │
│  [ ⬇️  Baixar PDF ]    │ ← Botão azul
└────────────────────────┘
```

✅ Download começa automaticamente

---

## 7️⃣ TESTAR DOWNLOAD LIVRE (10 seg)

**Clique novamente no mesmo documento**

✅ Baixa direto, **SEM** modal!  
✅ Documento liberado permanentemente!

---

## ✅ FUNCIONOU?

### **SIM! 🎉**
- Sistema está perfeito!
- Todos os novos documentos virão bloqueados
- Colaborador precisa assinar recibo para desbloquear
- RH pode ver todos os recibos no painel

### **NÃO? 😕**
- Abra Console (F12)
- Procure erros vermelhos
- Me envie a mensagem de erro
- Vou corrigir!

---

## 📊 VER RECIBOS NO PAINEL RH

```
1. Acesse: http://localhost:3001
2. Login: admin / admin
3. Clique em "Recibos de Documentos"
4. Veja o recibo que acabou de gerar!
```

---

## 🎯 RESUMO DO TESTE

| Etapa | O que ver | Tempo |
|-------|-----------|-------|
| 1. SQL | Documentos bloqueados | 2 min |
| 2. Login | Portal do colaborador | 1 min |
| 3. Ver | Cadeados vermelhos | 30 seg |
| 4. Clicar | Modal abre | 1 min |
| 5. Assinar | Preencher recibo | 30 seg |
| 6. Ver | Documento verde | 30 seg |
| 7. Testar | Download direto | 10 seg |
| **TOTAL** | | **5:40 min** |

---

**🚀 COMECE AGORA!**

Execute o SQL e acesse o portal!
