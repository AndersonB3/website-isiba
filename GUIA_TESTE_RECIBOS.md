# 🧪 GUIA DE TESTES - SISTEMA DE RECIBOS

## ✅ PASSO 1: VERIFICAR SE O SQL FOI EXECUTADO

### No Supabase:

1. **Vá em: Table Editor**
2. **Procure a tabela:** `recibos_documentos`
3. **Se aparecer a tabela = SQL executado com sucesso! ✅**

### Verificar colunas criadas:

Execute no SQL Editor:
```sql
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'recibos_documentos'
ORDER BY ordinal_position;
```

**Resultado esperado:** 17 colunas listadas (id, documento_id, colaborador_id, etc.)

---

## 🖥️ PASSO 2: TESTAR O PAINEL RH

### 1. Acesse o Painel RH:
```
http://localhost:3001
```

### 2. Faça Login:
- **Usuário:** `admin`
- **Senha:** `admin`

### 3. Clique na aba "Recibos de Documentos"
- Deve aparecer após "Histórico de Envios"
- Ícone: 📝 (assinatura)

### 4. Verifique se carrega:
✅ **4 Cards de Estatísticas:**
```
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│ Total Recibos   │  │ Contracheques   │  │ Informes IR     │  │ Sem Recibo      │
│      0          │  │      0          │  │      0          │  │      0          │
└─────────────────┘  └─────────────────┘  └─────────────────┘  └─────────────────┘
```
*É normal estar zerado se não houver recibos ainda*

✅ **Filtros:**
```
[Todos os Tipos ▼]  [Todos os Anos ▼]  [🔍 Filtrar]
```

✅ **Tabela:**
```
┌──────────────┬─────────────┬────────────┬──────────┬──────────────┬──────────┬────────┐
│ Colaborador  │ CPF         │ Documento  │ Período  │ Data Receb.  │ IP       │ Ações  │
└──────────────┴─────────────┴────────────┴──────────┴──────────────┴──────────┴────────┘
  Nenhum recibo encontrado
```

✅ **Alerta (se houver docs sem recibo):**
```
⚠️ Documentos Sem Recibo
X documento(s) aguardando recibo
```

### 5. Abra o Console (F12):
- **Não deve ter erros vermelhos**
- Pode ter logs azuis (console.log) - isso é normal
- Se tiver erro: anote e me envie

---

## 👤 PASSO 3: TESTAR NO PORTAL DO COLABORADOR

### 1. Preparar um Contracheque de Teste:

**No Painel RH (localhost:3001):**
1. Vá na aba "Gerenciar Documentos"
2. Clique em "Enviar Novo Contracheque"
3. Preencha:
   - **Colaborador:** Escolha um colaborador existente
   - **Mês:** Janeiro
   - **Ano:** 2026
   - **Tipo:** Contracheque
   - **Arquivo PDF:** Escolha qualquer PDF
4. Clique em "Enviar"
5. Aguarde confirmação

### 2. Acessar Portal do Colaborador:

```
http://localhost:8000/meus-contracheques.html
```

### 3. Fazer Login:
- Use CPF e senha de um colaborador que tenha contracheque

### 4. IMPORTANTE - INTEGRAR O MODAL:

**O modal ainda NÃO está integrado no portal!**

Preciso fazer isso agora. Vou criar os arquivos necessários.

---

## 🔧 PASSO 4: INTEGRAR MODAL NO PORTAL

Antes de testar o recibo no portal do colaborador, preciso integrar o sistema.

**Arquivos que precisam ser editados:**
1. `meus-contracheques.html` - Adicionar links CSS/JS
2. `assets/js/supabase-colaborador.js` - Modificar função de download

**Você quer que eu faça isso agora?**

---

## 🐛 TROUBLESHOOTING

### **Problema 1: Aba "Recibos" não aparece**

**Solução:**
```
1. Pressione Ctrl+Shift+R (recarregar forçado)
2. Verifique se está na porta correta (3001)
3. Abra Console (F12) e veja se há erros
```

### **Problema 2: Aba carrega mas mostra erro**

**Verifique no Console (F12):**
```javascript
// Se aparecer: "buscarEstatisticasRecibos is not defined"
// Solução: Verificar se recibo-admin.js está carregando
```

**Execute no Console:**
```javascript
console.log(typeof buscarEstatisticasRecibos);
// Deve retornar: "function"
// Se retornar: "undefined" = arquivo não foi carregado
```

### **Problema 3: Erro "relation recibos_documentos does not exist"**

**Significa que o SQL não foi executado!**

**Solução:**
1. Vá no Supabase SQL Editor
2. Execute o BLOCO 1 (extensão UUID)
3. Execute o BLOCO 2 (criar tabela)
4. Recarregue o painel RH

### **Problema 4: Cards mostram "-" ou "N/A"**

**Isso é NORMAL se:**
- ✅ Ainda não há recibos gerados
- ✅ Tabela foi criada mas está vazia
- ✅ Não há contracheques enviados

**Não é erro, é falta de dados!**

---

## 📊 VERIFICAÇÕES NO SUPABASE

### 1. Verificar se tabela existe:
```sql
SELECT * FROM recibos_documentos LIMIT 5;
```

**Resultado esperado:** Tabela existe (mesmo vazia)  
**Erro esperado:** "relation does not exist" = não executou o SQL

### 2. Verificar colunas na tabela contracheques:
```sql
SELECT visualizado, data_primeira_visualizacao, recibo_gerado 
FROM contracheques 
LIMIT 5;
```

**Resultado esperado:** 3 novas colunas aparecem  
**Erro:** "column does not exist" = execute o BLOCO 4 do SQL

### 3. Verificar a VIEW:
```sql
SELECT * FROM view_recibos_completos LIMIT 5;
```

**Resultado esperado:** View existe (mesmo vazia)  
**Erro:** "relation does not exist" = execute o BLOCO 7 do SQL

### 4. Testar inserção manual (TESTE):
```sql
-- APENAS PARA TESTE - NÃO EXECUTAR EM PRODUÇÃO
INSERT INTO recibos_documentos (
    documento_id,
    colaborador_id,
    tipo_documento,
    ano,
    nome_arquivo,
    assinatura_texto
) VALUES (
    '00000000-0000-0000-0000-000000000000', -- UUID fake
    (SELECT id FROM colaboradores LIMIT 1), -- Pega primeiro colaborador
    'contracheque',
    2026,
    'teste.pdf',
    'Teste de Assinatura'
);
```

**Se funcionar:** Tabela está OK!  
**Se der erro:** Veja qual coluna está causando problema

---

## ✅ CHECKLIST DE TESTES

### **Banco de Dados:**
- [ ] Tabela `recibos_documentos` existe
- [ ] Tabela tem 17 colunas
- [ ] Índices foram criados
- [ ] Trigger `atualizar_recibos_updated_at` existe
- [ ] View `view_recibos_completos` existe
- [ ] RLS está habilitado
- [ ] Policy foi criada

### **Painel RH:**
- [ ] Servidor rodando na porta 3001
- [ ] Aba "Recibos de Documentos" aparece no menu
- [ ] Aba abre ao clicar
- [ ] 4 cards de estatísticas aparecem
- [ ] Filtros aparecem (Tipo e Ano)
- [ ] Tabela aparece (mesmo vazia)
- [ ] Console não mostra erros (F12)

### **Portal Colaborador (PENDENTE):**
- [ ] Modal de recibo foi integrado
- [ ] CSS do modal está carregando
- [ ] JS do modal está carregando
- [ ] Ao baixar contracheque, modal abre
- [ ] Pode preencher e confirmar recibo

---

## 🚀 PRÓXIMOS PASSOS

### **1. AGORA - Testar Painel RH:**
```
1. Acesse: http://localhost:3001
2. Login: admin / admin
3. Clique em "Recibos de Documentos"
4. Veja se carrega sem erros
5. Me avise o resultado!
```

### **2. DEPOIS - Integrar Modal no Portal:**
```
Preciso editar:
- meus-contracheques.html
- assets/js/supabase-colaborador.js
- portal-colaborador.html (se necessário)
```

### **3. TESTAR - Gerar Primeiro Recibo:**
```
1. Enviar contracheque no painel RH
2. Acessar portal do colaborador
3. Baixar o contracheque
4. Modal deve abrir pedindo recibo
5. Preencher e confirmar
6. Verificar no painel RH se apareceu
```

---

## 📞 PRECISA DE AJUDA?

**Me envie:**
1. Print da tela do painel RH (aba Recibos)
2. Console do navegador (F12 > Console)
3. Mensagem de erro (se houver)

**Ou me diga:**
- "Funcionou!" → Vou para próxima etapa
- "Deu erro X" → Vou corrigir
- "Não entendi Y" → Vou explicar melhor

---

**🎯 FOCO AGORA: Teste o Painel RH primeiro!**

Acesse `http://localhost:3001` e veja se a aba "Recibos" aparece e carrega corretamente.

Me avise o resultado! 🚀
