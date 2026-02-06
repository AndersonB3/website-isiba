# 🔥 GUIA DE TESTE - VERSÃO 3.1 (FIX BLOQUEIO)

## 🎯 O QUE FOI CORRIGIDO

### Problema Identificado
O `onclick` estava sendo gerado como **string dentro do template literal**, o que causava problemas com caracteres especiais e escopo de funções.

### Solução Implementada
✅ **Event Listeners dinâmicos** com `addEventListener`  
✅ **Data attributes** para passar parâmetros  
✅ **Debug logs** em cada clique  
✅ **Versão 3.1** com cache-busting  

---

## 📋 PASSO A PASSO PARA TESTAR

### 1️⃣ LIMPAR CACHE DO NAVEGADOR

**Opção A - Hard Refresh (Recomendado)**
```
Windows: Ctrl + Shift + R
ou
Ctrl + F5
```

**Opção B - Limpar Cache Manualmente**
1. Pressione `Ctrl + Shift + Delete`
2. Selecione "Imagens e arquivos em cache"
3. Clique em "Limpar dados"

---

### 2️⃣ ABRIR O CONSOLE DO NAVEGADOR

```
Windows: F12 ou Ctrl + Shift + I
```

Clique na aba **Console**

---

### 3️⃣ VERIFICAR SE A NOVA VERSÃO CARREGOU

No console, você DEVE ver:

```
🔥 Portal do Colaborador VERSÃO 3.1 - DEBUG BLOQUEIO carregado!
🔥 Recibo Modal VERSÃO 3.1 - DEBUG BLOQUEIO carregado!
```

**⚠️ Se não aparecer:** Limpe o cache novamente e atualize a página!

---

### 4️⃣ VERIFICAR OS DOCUMENTOS BLOQUEADOS

Quando a página carregar, no console você verá:

```
📋 Documento: {
  id: "uuid-123",
  mes: "Janeiro",
  bloqueado: true,
  recibo_gerado: false
}
```

**✅ Verifique:**
- `bloqueado: true` → Documento está bloqueado
- `recibo_gerado: false` → Sem recibo assinado

---

### 5️⃣ CLICAR NO BOTÃO DE DOCUMENTO BLOQUEADO

Ao clicar em um documento **bloqueado**, você DEVE ver:

```
🖱️ BOTÃO CLICADO: {
  bloqueado: true,
  id: "uuid-123",
  tipo: "contracheque",
  mes: "Janeiro",
  ano: 2024
}
🔒 Abrindo modal de recibo...
```

**✅ O que deve acontecer:**
1. ✅ Modal de assinatura aparece
2. ✅ Canvas em branco para assinar
3. ✅ Botões "Limpar" e "Confirmar Recibo"

---

### 6️⃣ CLICAR NO BOTÃO DE DOCUMENTO LIBERADO

Ao clicar em um documento **liberado**, você DEVE ver:

```
🖱️ BOTÃO CLICADO: {
  bloqueado: false,
  id: "uuid-456",
  tipo: "contracheque",
  mes: "Dezembro",
  ano: 2024
}
📥 Baixando documento...
```

**✅ O que deve acontecer:**
1. ✅ Download direto do PDF
2. ✅ Sem modal de assinatura

---

## 🐛 SE AINDA NÃO FUNCIONAR

### Teste 1: Verificar se a função existe
No console, digite:
```javascript
typeof abrirModalRecibo
```

**Resultado esperado:** `"function"`

---

### Teste 2: Inspecionar o botão bloqueado
1. Clique com **botão direito** no botão bloqueado
2. Selecione **"Inspecionar"**
3. Verifique se o HTML tem:

```html
<button 
  class="btn-download-blocked"
  data-doc-id="uuid-123"
  data-bloqueado="true"
  data-tipo="contracheque"
  data-mes="Janeiro"
  data-ano="2024"
  data-arquivo="contracheque_jan_2024.pdf"
  data-url="https://..."
>
```

**⚠️ Se não tiver os `data-*` atributos:** O cache não foi limpo!

---

### Teste 3: Chamar função manualmente
No console, digite:
```javascript
abrirModalRecibo('test-123', 'contracheque', 'Janeiro', 2024, 'teste.pdf', 'https://exemplo.com/teste.pdf')
```

**Resultado esperado:** Modal deve abrir!

---

## 📊 CHECKLIST DE VALIDAÇÃO

### ✅ Visual
- [ ] Cadeado aparece nos documentos bloqueados
- [ ] Badge vermelho "Bloqueado" aparece
- [ ] Botão vermelho "Assinar Recibo para Desbloquear"

### ✅ Funcional
- [ ] Clicar em documento bloqueado abre o modal
- [ ] Canvas de assinatura aparece
- [ ] Pode desenhar no canvas
- [ ] Botão "Limpar" funciona
- [ ] Após assinar e confirmar, documento é liberado
- [ ] Clicar em documento liberado baixa o PDF

### ✅ Console (F12)
- [ ] "VERSÃO 3.1" aparece no console
- [ ] Log de documentos bloqueados aparece
- [ ] Log de clique no botão aparece
- [ ] Sem erros em vermelho no console

---

## 🔄 SE NADA FUNCIONAR

Execute os comandos SQL novamente:

```sql
-- Verificar status dos documentos
SELECT 
    id,
    mes_referencia,
    ano,
    tipo_documento,
    recibo_gerado,
    assinatura_digital IS NOT NULL as tem_assinatura
FROM contracheques
ORDER BY ano DESC, 
    CASE mes_referencia
        WHEN 'Janeiro' THEN 1 WHEN 'Fevereiro' THEN 2
        WHEN 'Março' THEN 3 WHEN 'Abril' THEN 4
        WHEN 'Maio' THEN 5 WHEN 'Junho' THEN 6
        WHEN 'Julho' THEN 7 WHEN 'Agosto' THEN 8
        WHEN 'Setembro' THEN 9 WHEN 'Outubro' THEN 10
        WHEN 'Novembro' THEN 11 WHEN 'Dezembro' THEN 12
    END DESC;

-- Se necessário, bloquear novamente
UPDATE contracheques 
SET recibo_gerado = false,
    assinatura_digital = NULL
WHERE recibo_gerado = true;
```

---

## 📞 RELATAR PROBLEMA

Se o problema persistir, envie:

1. ✅ Screenshot do console (F12)
2. ✅ Screenshot do botão inspecionado (botão direito → Inspecionar)
3. ✅ Resultado do teste `typeof abrirModalRecibo` no console
4. ✅ Resultado da query SQL de verificação

---

## 🎯 RESUMO DAS MUDANÇAS

| Arquivo | Mudança | Motivo |
|---------|---------|--------|
| `portal-colaborador.html` | v=3.0 → v=3.1 | Forçar atualização de cache |
| `portal-colaborador.js` | onclick → addEventListener | Fix escopo e caracteres especiais |
| `portal-colaborador.js` | Versão 3.1 + logs | Debug detalhado |
| `recibo-modal.js` | Versão 3.1 + log | Confirmar carregamento |

---

✅ **A solução está implementada!**  
Agora é só testar seguindo o passo a passo acima! 🚀
