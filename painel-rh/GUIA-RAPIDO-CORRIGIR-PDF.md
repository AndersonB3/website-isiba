# 🎯 GUIA RÁPIDO - Gerenciar Contracheques

## ✅ Como CORRIGIR um PDF enviado errado?

### É MUITO SIMPLES! Basta **reenviar** com os mesmos dados:

1. Acesse "Enviar Contracheque"
2. Selecione o **MESMO funcionário**
3. Escolha o **MESMO mês e ano**
4. Faça upload do **PDF CORRETO**
5. Clique em "Enviar Contracheque"

**💡 O sistema vai:**
- ✅ Detectar automaticamente que já existe
- ✅ Substituir o PDF antigo pelo novo
- ✅ Atualizar a data de envio
- ✅ Mostrar: "Contracheque atualizado com sucesso!"

**O colaborador verá apenas o PDF novo!** 🎉

---

## 🗑️ Como EXCLUIR um contracheque?

### Atualmente, há 2 formas:

### **Forma 1: Via Console do Navegador**
1. Abra o Console (F12)
2. Vá para a aba "Console"
3. Digite:
```javascript
await deletarContracheque('ID-DO-CONTRACHEQUE', 'cpf/2026-01.pdf')
```
4. Pressione Enter

### **Forma 2: Via SQL no Supabase**
1. Acesse: https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/sql/new
2. Execute:
```sql
-- Ver contracheques para encontrar o ID
SELECT id, mes_referencia, ano, nome_arquivo 
FROM contracheques 
WHERE colaborador_id = 'ID-DO-COLABORADOR';

-- Deletar o contracheque específico
DELETE FROM contracheques WHERE id = 'ID-DO-CONTRACHEQUE';
```

---

## 📋 Resumo Visual

```
┌─────────────────────────────────────────────────┐
│  CENÁRIO: PDF Errado                           │
├─────────────────────────────────────────────────┤
│  ❌ Enviou: Janeiro 2026 - João Silva          │
│  🔄 Ação: Reenviar com PDF correto             │
│                                                 │
│  1. Funcionário: João Silva ✓                  │
│  2. Mês: Janeiro ✓                             │
│  3. Ano: 2026 ✓                                │
│  4. PDF: [novo arquivo correto]                │
│  5. [Enviar Contracheque]                      │
│                                                 │
│  ✅ Resultado: PDF substituído!                │
└─────────────────────────────────────────────────┘
```

---

## ⚠️ IMPORTANTE

- **SOBRESCREVER** = Usar os mesmos dados (funcionário + mês + ano)
- **NÃO HÁ** botão "Editar" ou "Substituir" separado
- **O SISTEMA FAZ AUTOMATICAMENTE** quando detecta duplicidade
- **PDF ANTIGO É PERDIDO** (não há backup automático)

---

## 🎓 Exemplo Prático

**Situação Real:**
- Você enviou Janeiro/2026 para Maria Silva
- Percebeu que o desconto estava errado
- Precisa corrigir

**Solução:**
```
1. Corrige o PDF no sistema de folha de pagamento
2. Exporta o novo PDF
3. Acessa Painel RH
4. Clica em "Enviar Contracheque"
5. Funcionário: Maria Silva (mesmo)
6. Mês: Janeiro (mesmo)
7. Ano: 2026 (mesmo)
8. Upload do novo PDF
9. Enviar

✅ Sistema mostra: "Contracheque atualizado com sucesso!"
```

---

**Pronto! É isso! 🚀**

Não precisa excluir antes de reenviar. O sistema cuida de tudo automaticamente!
