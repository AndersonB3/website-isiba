# 📝 Como Gerenciar Contracheques no Painel RH

## 🎯 Funcionalidades Disponíveis

### 1️⃣ **ENVIAR NOVO CONTRACHEQUE**
- Selecione o funcionário
- Escolha mês e ano
- Faça upload do PDF
- Clique em "Enviar Contracheque"

### 2️⃣ **SOBRESCREVER/ATUALIZAR CONTRACHEQUE**
**Cenário:** Você enviou o PDF errado e precisa corrigir.

**Como fazer:**
1. Vá para a seção "Enviar Contracheque"
2. Selecione o **mesmo funcionário**
3. Escolha o **mesmo mês e ano**
4. Faça upload do **novo PDF correto**
5. Clique em "Enviar Contracheque"

**O que acontece:**
- ✅ O sistema detecta que já existe um contracheque para aquele período
- ✅ O PDF antigo é **substituído** automaticamente
- ✅ O registro no banco é **atualizado** com:
  - Novo nome do arquivo
  - Novo tamanho
  - Nova data de envio
- ✅ O colaborador verá apenas o **PDF mais recente**

**Mensagem do sistema:**
```
✅ Contracheque atualizado com sucesso!
O contracheque anterior foi substituído.
```

---

### 3️⃣ **EXCLUIR CONTRACHEQUE**
**Cenário:** Você precisa remover completamente um contracheque.

**Como fazer:**

#### **Opção A: Pelo Histórico de Contracheques**
1. Vá para a seção "Histórico de Contracheques"
2. Encontre o contracheque que deseja excluir
3. Clique no botão **🗑️ Excluir** (vermelho)
4. Confirme a exclusão no alerta
5. O contracheque será removido do banco e do storage

#### **Opção B: Via Console do Navegador (Avançado)**
```javascript
// Abrir Console (F12)
// Encontre o ID do contracheque e a URL do arquivo
await deletarContracheque('id-do-contracheque', 'cpf/2026-01.pdf')
```

**O que acontece:**
- ✅ O PDF é **deletado** do Storage do Supabase
- ✅ O registro é **removido** da tabela `contracheques`
- ✅ O colaborador **não verá mais** aquele contracheque

---

## 🔄 Fluxo de Trabalho Recomendado

### **Envio Mensal Normal:**
```
1. Todo dia 5 do mês → Gerar contracheques no sistema de folha
2. Exportar PDFs individuais
3. Acessar Painel RH
4. Para cada funcionário:
   - Selecionar nome
   - Mês: [Mês atual]
   - Ano: [Ano atual]
   - Upload do PDF
   - Enviar
```

### **Correção de Erro (PDF Errado):**
```
1. Percebeu o erro? Não se preocupe!
2. Acesse Painel RH
3. Repita o processo com os MESMOS dados:
   - Mesmo funcionário
   - Mesmo mês
   - Mesmo ano
   - PDF CORRETO
4. Enviar → O antigo será SUBSTITUÍDO automaticamente
```

### **Remoção Completa:**
```
1. Acesse "Histórico de Contracheques"
2. Localize o registro
3. Clique em "Excluir"
4. Confirme
5. Pronto! Removido do sistema
```

---

## 🛡️ Segurança e Boas Práticas

### ✅ **PERMITIDO:**
- Sobrescrever contracheques com PDFs corrigidos
- Excluir contracheques enviados por engano
- Reenviar contracheques após correção de valores
- Atualizar PDFs com informações complementares

### ⚠️ **CUIDADO:**
- Sempre **confirme** o funcionário correto antes de enviar
- Verifique o **mês e ano** para não sobrescrever o período errado
- Ao **excluir**, não há como recuperar (sem backup)
- PDFs antigos são **permanentemente** substituídos

### 🔐 **AUDITORIA:**
O sistema registra:
- Data e hora do envio
- Quem enviou (usuário RH)
- Nome do arquivo
- Tamanho do arquivo

---

## 📊 Exemplos Práticos

### **Exemplo 1: Corrigir valor de desconto**
```
Situação: Enviou Janeiro/2026 com desconto errado
Solução:
1. Corrigir PDF no sistema de folha
2. Exportar novo PDF
3. Painel RH → Enviar Contracheque
4. Funcionário: João Silva
5. Mês: Janeiro
6. Ano: 2026
7. Upload do PDF corrigido
8. Enviar → ✅ Substituído!
```

### **Exemplo 2: Remover contracheque duplicado**
```
Situação: Enviou Janeiro/2026 duas vezes por engano
Solução:
1. Histórico de Contracheques
2. Filtrar por "Janeiro"
3. Ver os dois registros do mesmo funcionário
4. Excluir o duplicado (verificar data de envio)
5. Manter apenas o correto
```

### **Exemplo 3: Atualizar PDF com nova formatação**
```
Situação: Mudou layout do contracheque, precisa atualizar histórico
Solução:
Para cada mês:
1. Gerar novo PDF com layout atualizado
2. Enviar com mesmo funcionário + mês + ano
3. PDF antigo é substituído
4. Colaborador vê apenas o novo layout
```

---

## 🔍 Verificação no Banco de Dados

### **Ver todos os contracheques de um funcionário:**
```sql
SELECT 
    mes_referencia,
    ano,
    nome_arquivo,
    enviado_em,
    enviado_por
FROM contracheques
WHERE colaborador_id = 'id-do-colaborador'
ORDER BY ano DESC, mes_referencia DESC;
```

### **Ver contracheques duplicados (não deveria existir):**
```sql
SELECT 
    colaborador_id,
    mes_referencia,
    ano,
    COUNT(*) as quantidade
FROM contracheques
GROUP BY colaborador_id, mes_referencia, ano
HAVING COUNT(*) > 1;
```

### **Excluir contracheque específico via SQL:**
```sql
-- ⚠️ CUIDADO! Isso é permanente!
DELETE FROM contracheques 
WHERE id = 'id-do-contracheque';
```

---

## 🎯 Resumo Rápido

| Ação | Como Fazer | Resultado |
|------|-----------|-----------|
| **Enviar novo** | Funcionário + Mês + Ano + PDF → Enviar | ✅ Novo contracheque criado |
| **Corrigir/Atualizar** | MESMOS dados (funcionário + mês + ano) + PDF novo → Enviar | ✅ PDF antigo substituído |
| **Excluir** | Histórico → Botão Excluir → Confirmar | ✅ Removido completamente |
| **Baixar** | Histórico → Botão Download | ✅ Abre PDF em nova aba |

---

## 📞 Dúvidas Frequentes

**P: O colaborador ainda vê o PDF antigo?**
R: Não! Quando você sobrescreve, o PDF antigo é substituído imediatamente. O colaborador verá apenas o novo.

**P: Posso recuperar um PDF que foi sobrescrito?**
R: Não, a menos que você tenha backup. O PDF antigo é permanentemente substituído.

**P: E se eu excluir por engano?**
R: Não há desfazer. Você precisará enviar novamente o PDF correto.

**P: Posso enviar vários contracheques de uma vez?**
R: Atualmente não. Você deve enviar um por vez, selecionando o funcionário.

**P: O sistema avisa antes de sobrescrever?**
R: Sim! Aparece uma mensagem informando que o contracheque será atualizado.

---

## 🚀 Melhorias Futuras (Sugestões)

- [ ] Upload em lote (múltiplos PDFs de uma vez)
- [ ] Histórico de versões (ver PDFs anteriores)
- [ ] Confirmação visual antes de sobrescrever
- [ ] Botão "Substituir PDF" direto no histórico
- [ ] Logs de auditoria detalhados
- [ ] Exportação de relatórios

---

**✅ Sistema pronto para uso!**
Qualquer dúvida, consulte este guia ou entre em contato com o suporte técnico.
