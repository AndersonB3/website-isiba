# 📄 Sistema de Divisão Automática de PDF Compilado

## 🎯 Objetivo

Substituir o sistema antigo de "Upload em Lote (IA)" por um novo processo que:
- Recebe **1 PDF compilado** com todos os contracheques
- Divide automaticamente página por página
- Identifica código e nome em cada página
- Cria PDFs individuais para cada colaborador
- Vincula automaticamente ao banco de dados

---

## 🔄 Como Funciona

### **Fluxo Completo:**

```
1. RH recebe PDF compilado (ex: 100 páginas)
   ↓
2. Upload no painel RH (http://localhost:3001/)
   ↓
3. Sistema lê TODO o PDF
   ↓
4. Para cada página:
   - Extrai o texto
   - Identifica "Código" (ex: 222)
   - Identifica "Nome do Funcionário" (ex: ADALBERTO BATISTA DOS SANTOS)
   - Busca colaborador no banco
   - Extrai essa página do PDF
   - Cria PDF individual
   - Upload para Supabase Storage
   - Registra no banco de dados
   ↓
5. Relatório final com sucessos/avisos/erros
```

---

## 📋 Padrão dos Dados

### **Estrutura do PDF:**
Cada página deve conter:

```
Código          Nome do Funcionário
222             ADALBERTO BATISTA DOS SANTOS
```

### **Requisitos:**
- ✅ Label "Código" sempre presente
- ✅ Label "Nome do Funcionário" sempre presente
- ✅ Código = apenas números
- ✅ Nome = texto em MAIÚSCULAS
- ✅ 1 página = 1 contracheque

---

## 🛠️ Tecnologias Utilizadas

### **1. PDF.js (leitura)**
- Biblioteca: `pdfjs-dist@3.11.174`
- Função: Extrair texto de cada página
- CDN: https://cdn.jsdelivr.net/npm/pdfjs-dist@3.11.174/build/pdf.min.js

### **2. PDF-lib (manipulação)**
- Biblioteca: `pdf-lib@1.17.1`
- Função: Dividir PDF, extrair páginas individuais
- CDN: https://cdn.jsdelivr.net/npm/pdf-lib@1.17.1/dist/pdf-lib.min.js

### **3. Supabase**
- Storage: Armazenamento dos PDFs individuais
- Database: Registro dos documentos e vínculos

---

## 📁 Arquivos Modificados

### **1. HTML - Interface**
**Arquivo:** `painel-rh/admin-rh.html`

**Alterações:**
- Linha 113-116: Mudou nome do botão de navegação
  - Antes: "Upload em Lote (IA)"
  - Depois: "Divisão de PDF Compilado"
  
- Linha 479-620: Reformulou seção completa
  - Removeu: Upload múltiplo de arquivos
  - Adicionou: Upload de 1 único PDF
  - Adicionou: Campo de mês de referência
  - Atualizou: Instruções e alertas

### **2. JavaScript - Lógica**
**Arquivo:** `painel-rh/assets/js/divisao-pdf.js` (NOVO)

**Funções Principais:**

```javascript
// Carregar e validar PDF
handleArquivoSelecionado(arquivo)
  → Valida tamanho (máx 50MB)
  → Conta páginas
  → Mostra informações

// Processar PDF completo
processarPDFCompilado()
  → Loop em todas as páginas
  → Chama extrairTextoPagina()
  → Chama identificarColaborador()
  → Chama extrairPaginaIndividual()
  → Chama buscarColaboradorNoBanco()
  → Chama uploadContracheque()

// Extrair texto de uma página
extrairTextoPagina(numeroPagina)
  → Usa PDF.js
  → Retorna texto completo

// Identificar dados do colaborador
identificarColaborador(texto)
  → Regex para "Código"
  → Regex para "Nome do Funcionário"
  → Retorna {codigo, nome}

// Extrair página individual
extrairPaginaIndividual(numeroPagina)
  → Usa PDF-lib
  → Cria novo PDF com 1 página
  → Retorna Uint8Array

// Buscar no banco
buscarColaboradorNoBanco(codigo, nome)
  → Busca por código
  → Se não achar, busca por nome
  → Retorna dados do colaborador

// Upload para Supabase
uploadContracheque(pdfBytes, colaborador, tipo, ano, mes)
  → Upload para Storage
  → Registra em documentos table
  → Retorna resultado
```

---

## 🔍 Padrões de Regex

### **Identificar Código:**
```javascript
const regexCodigo = /C[óo]digo[\s:]*(\d+)/i;
// Exemplos que funciona:
// "Código 222"
// "Codigo: 345"
// "CÓDIGO    567"
```

### **Identificar Nome:**
```javascript
const regexNome = /Nome\s+do\s+Funcion[áa]rio[\s:]*([A-Z\s]+?)(?=\s{2,}|$|Empresa|Cargo)/i;
// Exemplos que funciona:
// "Nome do Funcionário ADALBERTO BATISTA DOS SANTOS"
// "Nome do Funcionario: MARIA SILVA OLIVEIRA"
```

---

## 📊 Estrutura do Banco de Dados

### **Tabela: `colaboradores`**
```sql
- codigo (text) - Código do funcionário
- cpf (text, PK) - CPF formatado
- nome_completo (text) - Nome completo
- email (text)
- ... outros campos
```

### **Tabela: `documentos`**
```sql
- id (uuid, PK)
- cpf_colaborador (text, FK)
- tipo_documento (text) - 'contracheque' ou 'informe_ir'
- ano (integer)
- mes (integer)
- caminho_arquivo (text) - Caminho no Storage
- data_envio (timestamp)
```

### **Storage: `contracheques`**
```
Estrutura de pastas:
/2025
  /01
    /12345678900_2025_01_contracheque.pdf
    /98765432100_2025_01_contracheque.pdf
  /02
    /12345678900_2025_02_contracheque.pdf
```

---

## ✅ Testes e Validação

### **Checklist de Testes:**

1. **Upload de Arquivo**
   - [ ] Aceita apenas PDF
   - [ ] Rejeita arquivos > 50MB
   - [ ] Mostra número de páginas correto
   - [ ] Drag and drop funciona

2. **Identificação de Dados**
   - [ ] Identifica código corretamente
   - [ ] Identifica nome corretamente
   - [ ] Lida com variações (acentos, espaços)
   - [ ] Registra avisos quando não encontra dados

3. **Divisão do PDF**
   - [ ] Extrai cada página individualmente
   - [ ] PDFs individuais abrem corretamente
   - [ ] Mantém qualidade e formatação

4. **Integração com Banco**
   - [ ] Busca colaborador por código
   - [ ] Fallback para busca por nome
   - [ ] Upload para Storage funciona
   - [ ] Registro na tabela documentos funciona

5. **Interface e UX**
   - [ ] Barra de progresso atualiza
   - [ ] Estatísticas corretas (sucessos/avisos/erros)
   - [ ] Log detalhado e claro
   - [ ] Notificações aparecem

---

## 🚀 Como Usar

### **Passo a Passo para o RH:**

1. **Acesse o Painel RH**
   ```
   http://localhost:3001/
   Login com credenciais de admin
   ```

2. **Navegue até "Divisão de PDF Compilado"**
   - Menu lateral → "Divisão de PDF Compilado"

3. **Faça Upload do PDF**
   - Arraste o PDF compilado para a área
   - OU clique e selecione o arquivo
   - Sistema mostrará número de páginas

4. **Configure o Processamento**
   - Tipo de Documento: Contracheque Mensal
   - Ano: 2025
   - Mês: (selecione o mês de referência)

5. **Processar**
   - Clique em "Dividir e Processar PDF"
   - Aguarde o processamento
   - Acompanhe o progresso em tempo real

6. **Verificar Resultados**
   - Veja estatísticas: Sucessos / Avisos / Erros
   - Confira o log detalhado
   - Colaboradores já podem acessar seus contracheques

---

## 🐛 Troubleshooting

### **Problema: "Código ou nome não identificado"**
**Causa:** Padrão do PDF diferente do esperado
**Solução:** 
- Verifique se o PDF tem os labels "Código" e "Nome do Funcionário"
- Ajuste os regex se necessário
- Teste com um PDF de exemplo

### **Problema: "Colaborador não encontrado no banco"**
**Causa:** Código ou nome não corresponde ao cadastro
**Solução:**
- Verifique se o colaborador está cadastrado
- Confira se o código está correto
- Verifique se o nome está exatamente igual

### **Problema: "Erro ao extrair página"**
**Causa:** PDF pode estar corrompido ou protegido
**Solução:**
- Verifique se o PDF não tem senha
- Tente abrir o PDF manualmente
- Gere novamente o PDF compilado

### **Problema: Upload para Storage falha**
**Causa:** Problemas de permissão ou tamanho
**Solução:**
- Verifique políticas RLS do Supabase
- Confira se o bucket 'contracheques' existe
- Verifique limites de tamanho

---

## 📝 Notas Técnicas

### **Limitações:**
- PDF máximo: 50MB
- Não suporta PDFs escaneados (somente texto editável)
- Requer padrão consistente em todas as páginas
- Processa sequencialmente (não paraleliza)

### **Performance:**
- ~1-2 segundos por página (depende do tamanho)
- 100 páginas ≈ 2-3 minutos
- Delay de 100ms entre páginas (para não sobrecarregar)

### **Segurança:**
- Apenas admin RH pode acessar
- Validação de tipo de arquivo
- Validação de tamanho
- Upload direto para Supabase (não armazena localmente)

---

## 🔮 Melhorias Futuras

### **Possíveis Implementações:**

1. **OCR para PDFs Escaneados**
   - Integrar Tesseract.js
   - Ler PDFs que são imagens

2. **Detecção Automática de Mês/Ano**
   - Extrair data do próprio contracheque
   - Reduzir configuração manual

3. **Preview das Páginas**
   - Mostrar miniatura de cada página
   - Validação visual antes de processar

4. **Processamento Paralelo**
   - Web Workers
   - Acelerar processamento

5. **Modo de Correção**
   - Permitir edição manual de código/nome
   - Para casos onde identificação falha

---

## 📞 Suporte

Para dúvidas ou problemas:
- **Email:** rh.isiba@gmail.com
- **Telefone:** (71) 8472-8416
- **Documentação:** Este arquivo

---

**Última Atualização:** 09/02/2026
**Versão:** 1.0
**Desenvolvido para:** ISIBA Social - RH
