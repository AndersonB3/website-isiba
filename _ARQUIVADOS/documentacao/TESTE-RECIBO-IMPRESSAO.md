# 🚀 TESTE RÁPIDO - RECIBO DIGITAL COM IMPRESSÃO

## ✅ PASSO A PASSO PARA TESTAR

---

## 1️⃣ **LIMPAR CACHE DO NAVEGADOR**

**IMPORTANTE:** Sempre limpe o cache antes de testar!

```
Windows/Linux: Ctrl + Shift + R
Mac: Cmd + Shift + R
```

Ou pelo navegador:
- Chrome: F12 → Network → Disable cache
- Edge: F12 → Network → Disable cache

---

## 2️⃣ **TESTAR NO PAINEL RH**

### A. Acessar o Painel:
```
http://localhost:8080/painel-rh/admin-rh.html
```

### B. Fazer Login:
- Usuário: `admin.rh`
- Senha: (sua senha)

### C. Ver Recibos:
1. No menu, clique em **"Recibos Gerados"**
2. Localize um recibo na lista
3. Clique no botão **"👁️ Ver Detalhes"**

### D. Verificar Modal:
✅ O que você deve ver:
- Cabeçalho azul/verde com "Detalhes do Recibo Digital"
- Dados do colaborador
- Dados do documento
- **ASSINATURA DIGITAL EXIBIDA** (caixa com borda azul)
- Informações técnicas
- Botões no rodapé

### E. Testar Impressão:
1. Clique em **"🖨️ Imprimir Documento"**
2. Janela de impressão deve abrir
3. ✅ Preview deve mostrar:
   - Cabeçalho: "ISIBA - Instituto de Saúde"
   - Protocolo único
   - Todos os dados organizados
   - Assinatura digital visível
   - Declaração legal no rodapé
   - Sem botões ou elementos do modal

### F. (Opcional) Baixar Assinatura:
1. Clique em **"⬇️ Baixar Assinatura"**
2. Arquivo PNG deve baixar
3. Nome: `Assinatura_Nome_Colaborador_[timestamp].png`

---

## 3️⃣ **O QUE VOCÊ DEVE VER NO CONSOLE**

Abra o Console (F12) e verifique:

```
✅ recibo-admin.js VERSÃO 3.1 - IMPRESSÃO + ASSINATURA DIGITAL carregado
🔍 Buscando detalhes do recibo: [id]
✅ [data] recibos encontrados
🖨️ Iniciando impressão do recibo...
✅ Impressão iniciada com sucesso
```

---

## 4️⃣ **VERIFICAR LAYOUT DE IMPRESSÃO**

### No Preview de Impressão:
✅ **DEVE APARECER:**
- Cabeçalho profissional
- Logo ISIBA (se houver)
- Protocolo (ex: A0C3F024)
- Todos os dados organizados
- Assinatura digital com borda preta
- Rodapé legal

❌ **NÃO DEVE APARECER:**
- Botões (Fechar, Imprimir, Baixar)
- Fundo escuro do modal
- Botão X de fechar
- Cores de fundo do modal

---

## 5️⃣ **TESTAR RESPONSIVIDADE**

### Desktop (> 900px):
- Modal: 900px largura
- 2 colunas no grid

### Tablet (600px - 900px):
- Modal: 90% da tela
- 1-2 colunas adaptáveis

### Mobile (< 600px):
- Modal: 95% da tela
- 1 coluna
- Assinatura em largura total

**Como testar:**
1. Abra DevTools (F12)
2. Clique no ícone de celular
3. Teste em diferentes tamanhos

---

## 6️⃣ **VERIFICAR NO BANCO DE DADOS**

Execute no Supabase SQL Editor:

```sql
-- Ver recibos com assinatura digital
SELECT 
    r.id as recibo_id,
    c.nome_completo,
    r.assinatura_texto,
    CASE 
        WHEN r.assinatura_canvas IS NOT NULL THEN 'SIM' 
        ELSE 'NÃO' 
    END as tem_assinatura,
    c2.assinatura_digital IS NOT NULL as salvo_em_contracheques,
    r.criado_em
FROM recibos_documentos r
JOIN colaboradores c ON r.colaborador_id = c.id
LEFT JOIN contracheques c2 ON r.documento_id = c2.id
ORDER BY r.criado_em DESC
LIMIT 5;
```

✅ **Resultado esperado:**
- `tem_assinatura`: SIM
- `salvo_em_contracheques`: true

---

## 7️⃣ **POSSÍVEIS PROBLEMAS E SOLUÇÕES**

### ❌ Assinatura não aparece:
```
Solução:
1. Verificar se campo assinatura_digital existe na view
2. Verificar se recibo tem assinatura (pode ser recibo antigo)
3. Verificar console por erros
```

### ❌ Botão Imprimir não funciona:
```
Solução:
1. Verificar console por erros JavaScript
2. Verificar se função imprimirRecibo() existe
3. Limpar cache (Ctrl+Shift+R)
4. Recarregar página
```

### ❌ Layout de impressão quebrado:
```
Solução:
1. Verificar se CSS @media print está carregado
2. Verificar se admin-rh.css está atualizado
3. Testar em navegador diferente (Chrome recomendado)
```

### ❌ Modal não abre:
```
Solução:
1. Verificar console por erros
2. Verificar se recibo-admin.js v3.1 está carregado
3. Verificar se view_recibos_completos retorna dados
```

---

## 8️⃣ **COMANDOS ÚTEIS**

### Verificar versão carregada:
```javascript
// Cole no console do navegador
console.log('Verificando versões...');
```

Deve aparecer:
```
✅ recibo-admin.js VERSÃO 3.1 - IMPRESSÃO + ASSINATURA DIGITAL carregado
```

### Forçar reload sem cache:
```
Ctrl + Shift + R (Windows)
Cmd + Shift + R (Mac)
```

### Abrir DevTools:
```
F12 ou Ctrl + Shift + I
```

---

## 9️⃣ **CENÁRIOS DE TESTE**

### ✅ Cenário 1: Recibo Novo (com assinatura)
1. Colaborador assinou recibo digital
2. Painel RH mostra assinatura
3. Impressão inclui assinatura
4. Download da assinatura funciona

### ✅ Cenário 2: Recibo Antigo (sem assinatura)
1. Recibo foi gerado antes do sistema
2. Modal mostra mensagem: "Assinatura digital não disponível"
3. Impressão funciona normalmente
4. Não tem botão de download

### ✅ Cenário 3: Impressão
1. Modal abre com todos os dados
2. Clica em "Imprimir"
3. Preview mostra layout profissional
4. Botões ficam ocultos
5. Assinatura aparece com borda preta

---

## 🎯 CHECKLIST DE TESTE

```
VISUAL:
[ ] Modal abre sem erros
[ ] Assinatura digital aparece na caixa azul
[ ] Layout está organizado e profissional
[ ] Botões aparecem no rodapé

FUNCIONAL:
[ ] Botão "Imprimir" abre preview
[ ] Preview mostra layout correto
[ ] Botão "Baixar Assinatura" funciona
[ ] Modal fecha corretamente

IMPRESSÃO:
[ ] Cabeçalho ISIBA aparece
[ ] Protocolo está visível
[ ] Assinatura digital com borda preta
[ ] Rodapé legal aparece
[ ] Botões NÃO aparecem
[ ] Layout cabe em A4

CONSOLE:
[ ] Sem erros no console
[ ] Versão 3.1 carregada
[ ] Logs de sucesso aparecem

BANCO:
[ ] Assinatura salva em base64
[ ] Campo assinatura_digital preenchido
[ ] View retorna dados completos
```

---

## 🆘 EM CASO DE ERRO

1. **Abra o Console** (F12)
2. **Copie a mensagem de erro**
3. **Verifique:**
   - Supabase está conectado?
   - Arquivos estão carregados?
   - Cache foi limpo?
4. **Tente:**
   - Recarregar página (Ctrl+Shift+R)
   - Fechar e abrir navegador
   - Testar em modo anônimo

---

## ✅ TESTE PASSOU?

Se todos os checkboxes estão marcados:

🎉 **SISTEMA FUNCIONANDO PERFEITAMENTE!**

Agora você tem:
- ✅ Assinatura digital exibida
- ✅ Impressão profissional
- ✅ Documento com validade jurídica
- ✅ Layout responsivo

---

**Pronto para produção!** 🚀
