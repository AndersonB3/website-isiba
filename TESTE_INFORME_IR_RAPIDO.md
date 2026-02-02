# 🚀 GUIA RÁPIDO - Testar Informe de IR

## ⚠️ PASSO 1: EXECUTAR SQL (OBRIGATÓRIO!)

1. Acesse: https://supabase.com/dashboard
2. SQL Editor > + New query
3. Copie o arquivo: `EXECUTAR_AGORA_NO_SUPABASE.sql`
4. Cole e clique em **RUN**
5. Veja a confirmação da coluna `tipo_documento`

---

## ✅ PASSO 2: TESTAR NO PAINEL RH

### **Upload de Informe de IR:**

1. Abra: `admin-rh.html`
2. Faça login
3. Menu lateral → **"Enviar Documentos"**
4. Selecione um funcionário
5. **Tipo de Documento:** Informe de Imposto de Renda
6. ✨ **Campo "Mês" deve DESAPARECER**
7. Selecione o ano: 2025
8. Faça upload do PDF
9. Clique em **"Enviar Informe de IR"**

### **Upload de Contracheque (para comparar):**

1. Mesma tela
2. **Tipo de Documento:** Contracheque Mensal
3. ✨ **Campo "Mês" deve APARECER**
4. Selecione mês: Janeiro
5. Selecione ano: 2025
6. Upload do PDF
7. Clique em **"Enviar Contracheque"**

---

## 👤 PASSO 3: TESTAR NO PORTAL DO COLABORADOR

1. Abra: `portal-colaborador.html`
2. Login com o CPF do funcionário que recebeu os documentos
3. **Dashboard deve mostrar:**
   - 📊 Total de Contracheques: X
   - 📊 Total de Informes de IR: Y
4. **Filtro por tipo:**
   - "Contracheques" → Mostra só contracheques
   - "Informes de IR" → Mostra só informes
   - "Todos" → Mostra ambos
5. Clique em "Baixar PDF" em cada documento

---

## 🔍 VERIFICAR NO SUPABASE

### **Table Editor:**
1. Vá em: Table Editor > contracheques
2. Verifique se a coluna `tipo_documento` existe
3. Verifique se os registros têm:
   - `tipo_documento = 'contracheque'` para contracheques
   - `tipo_documento = 'informe_ir'` para informes

### **Storage:**
1. Vá em: Storage > contracheques
2. Abra a pasta do CPF do funcionário
3. Deve ter arquivos com nomes diferentes:
   - `2025-01.pdf` (contracheque de janeiro)
   - `2025-INFORME-IR.pdf` (informe de IR)

---

## 🐛 SE DER ERRO

### **Erro: "column tipo_documento does not exist"**
- ❌ Você não executou o SQL do Passo 1
- ✅ Execute: `EXECUTAR_AGORA_NO_SUPABASE.sql`

### **Campo "Mês" não desaparece**
- ❌ Código não foi atualizado corretamente
- ✅ Recarregue a página (Ctrl+Shift+R)

### **Erro ao fazer upload**
- ❌ Verifique se o tipo de documento está selecionado
- ❌ Verifique se o PDF tem menos de 10MB
- ✅ Abra o Console (F12) e veja o erro detalhado

---

## ✨ RESULTADO ESPERADO

### **No Console do Navegador (F12):**
```
✅ Supabase configurado com sucesso!
📤 Uploading informe_ir: 12345678900/2025-INFORME-IR.pdf
✅ informe_ir enviado: {id: "...", tipo_documento: "informe_ir", ...}
```

### **No Painel RH:**
```
✅ Informe de IR enviado com sucesso!
```

### **No Portal do Colaborador:**
```
📊 Total de Contracheques: 12
📊 Total de Informes de IR: 1
📊 Último Documento: Informe IR 2025
```

---

## 🎉 PRONTO!

Se tudo funcionou:
- ✅ Banco de dados atualizado
- ✅ Upload de informes funcionando
- ✅ Portal mostrando corretamente
- ✅ Download funcionando

**Sistema 100% completo!** 🚀
