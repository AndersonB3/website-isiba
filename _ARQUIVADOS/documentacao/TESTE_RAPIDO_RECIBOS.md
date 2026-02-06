# ✅ TESTE RÁPIDO - SISTEMA DE RECIBOS

## 🎯 TESTE EM 3 MINUTOS

### ✅ SERVIDORES RODANDO:
```
✅ Painel RH:  http://localhost:3001
✅ Site:       http://localhost:8000
```

---

## 📋 PASSO A PASSO

### **1️⃣ EXECUTAR SQL NO SUPABASE** (2 min)

```
1. Abra: https://supabase.com
2. Entre no projeto ISIBA
3. Clique em: "SQL Editor" (menu lateral esquerdo)
4. Copie o arquivo: SISTEMA_RECIBOS_PASSO_A_PASSO.sql
5. Cole no editor
6. Clique em: RUN (ou Ctrl+Enter)
7. Aguarde: "Success. No rows returned"
```

**✅ Pronto! Banco configurado.**

---

### **2️⃣ TESTAR PAINEL RH** (1 min)

```
1. Abra: http://localhost:3001
2. Login: admin / admin
3. Procure no menu lateral: "Recibos de Documentos"
4. Clique na aba
5. Veja se carrega os 4 cards
```

**O que você deve ver:**

```
╔════════════════════════════════════════════════════════╗
║  📝 Recibos de Documentos                              ║
╠════════════════════════════════════════════════════════╣
║                                                        ║
║  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────┐║
║  │ Total    │  │ Contra   │  │ Informes │  │ Sem    │║
║  │   0      │  │   0      │  │   0      │  │   0    │║
║  └──────────┘  └──────────┘  └──────────┘  └────────┘║
║                                                        ║
║  [Tipo ▼]  [Ano ▼]  [Filtrar]                        ║
║                                                        ║
║  ┌──────────────────────────────────────────────────┐ ║
║  │ Colaborador │ CPF │ Doc │ Período │ Data │ Ações│ ║
║  ├──────────────────────────────────────────────────┤ ║
║  │          Nenhum recibo encontrado               │ ║
║  └──────────────────────────────────────────────────┘ ║
╚════════════════════════════════════════════════════════╝
```

**✅ Funcionou? Cards apareceram?**
- **SIM** → Vá para o Passo 3
- **NÃO** → Abra Console (F12) e me envie o erro

---

### **3️⃣ VERIFICAR NO SUPABASE** (30 seg)

```
1. Vá em: Table Editor (menu lateral)
2. Procure: recibos_documentos
3. A tabela deve aparecer na lista
```

**✅ Apareceu? Banco OK!**

---

## 🐛 SE DEU ERRO

### **Erro 1: Aba "Recibos" não aparece**

**Causa:** Arquivo não foi salvo ou navegador está em cache

**Solução:**
```
1. Pressione: Ctrl+Shift+R (recarregar forçado)
2. Se não funcionar: Feche o navegador e abra novamente
3. Limpe cache: Ctrl+Shift+Delete > Limpar cache
```

### **Erro 2: Aba abre mas dá erro no console**

**Causa:** Arquivo JS não foi carregado

**Solução:**
```
1. Abra Console (F12)
2. Vá na aba "Network"
3. Recarregue a página (F5)
4. Procure: recibo-admin.js
5. Se aparecer "404" = arquivo não foi copiado
6. Me avise que eu corrijo
```

### **Erro 3: "relation recibos_documentos does not exist"**

**Causa:** SQL não foi executado no Supabase

**Solução:**
```
1. Vá no Supabase SQL Editor
2. Execute o BLOCO 2 do arquivo SISTEMA_RECIBOS_PASSO_A_PASSO.sql
3. Aguarde "Success"
4. Recarregue o painel RH (F5)
```

### **Erro 4: Cards aparecem mas todos zerados**

**Causa:** ISSO É NORMAL! Não há recibos ainda.

**Próximo passo:**
```
✅ Está funcionando corretamente!
✅ Quando enviar contracheques e gerar recibos, os números vão aparecer
```

---

## 📊 VERIFICAÇÃO FINAL

### **No Supabase SQL Editor, execute:**

```sql
-- 1. Verificar tabela
SELECT COUNT(*) FROM recibos_documentos;
-- Deve retornar: 0 (tabela vazia mas existe)

-- 2. Verificar colunas
SELECT column_name FROM information_schema.columns 
WHERE table_name = 'recibos_documentos';
-- Deve listar: 17 colunas

-- 3. Verificar view
SELECT * FROM view_recibos_completos LIMIT 1;
-- Pode retornar: 0 rows (view existe mas vazia)
```

**✅ Tudo OK? Sistema está funcionando!**

---

## 🚀 PRÓXIMA ETAPA

**Agora preciso integrar o modal no portal do colaborador!**

**Arquivos que vou editar:**
1. `meus-contracheques.html` → Adicionar CSS/JS do modal
2. `assets/js/supabase-colaborador.js` → Interceptar download
3. `portal-colaborador.html` → Adicionar modal (se necessário)

**Posso continuar?**

Digite:
- **"SIM"** → Vou integrar o modal agora
- **"DEU ERRO X"** → Vou corrigir primeiro
- **"FUNCIONOU!"** → Vou para próxima etapa

---

## 📝 RESUMO DO TESTE

| Etapa | Status | Tempo |
|-------|--------|-------|
| 1. Executar SQL | ⏳ Pendente | 2 min |
| 2. Testar Painel RH | ⏳ Pendente | 1 min |
| 3. Verificar Supabase | ⏳ Pendente | 30 seg |
| **TOTAL** | | **3:30 min** |

---

**🎯 COMECE AGORA:**

1. Vá no Supabase SQL Editor
2. Execute o SQL completo
3. Acesse http://localhost:3001
4. Veja se a aba "Recibos" aparece

**Me avise o resultado!** 🚀
