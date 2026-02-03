# 📝 SISTEMA DE RECIBOS DIGITAIS - GUIA COMPLETO DE IMPLEMENTAÇÃO

## 🎯 VISÃO GERAL

Sistema completo para registro de recibos digitais de documentos (contracheques, informes de IR, etc.) entregues aos colaboradores através do portal.

---

## 📋 FUNCIONALIDADES

### ✅ Portal do Colaborador:
- **Modal automático** ao visualizar documento pela primeira vez
- **Assinatura digital** (nome completo)
- **Declaração de recebimento** com aceite obrigatório
- **Registro de IP e User Agent** para auditoria
- **Bloqueio temporário** até confirmação do recebimento
- **Download automático** após confirmar recibo

### ✅ Painel RH:
- **Aba "Recibos"** com lista completa
- **Estatísticas em cards**:
  - Total de recibos gerados
  - Por tipo de documento
  - Documentos sem recibo
- **Filtros avançados**:
  - Por colaborador
  - Por tipo de documento
  - Por período (mês/ano)
- **Detalhes completos** de cada recibo
- **Relatórios e exportação** (futura implementação)

---

## 🗄️ ESTRUTURA DO BANCO DE DADOS

### Tabela: `recibos_documentos`

```sql
CREATE TABLE recibos_documentos (
    id UUID PRIMARY KEY,
    documento_id UUID NOT NULL,
    colaborador_id UUID REFERENCES colaboradores(id),
    tipo_documento VARCHAR(50),
    mes_referencia TEXT,
    ano INTEGER,
    nome_arquivo TEXT,
    data_visualizacao TIMESTAMP,
    data_recebimento TIMESTAMP,
    ip_address TEXT,
    user_agent TEXT,
    assinatura_texto TEXT,
    assinatura_canvas TEXT,
    declaracao_aceite BOOLEAN,
    texto_declaracao TEXT,
    criado_em TIMESTAMP,
    atualizado_em TIMESTAMP
);
```

### Alterações em `contracheques`:

```sql
ALTER TABLE contracheques 
ADD COLUMN visualizado BOOLEAN DEFAULT false,
ADD COLUMN data_primeira_visualizacao TIMESTAMP,
ADD COLUMN recibo_gerado BOOLEAN DEFAULT false;
```

---

## 🚀 PASSO A PASSO DE IMPLEMENTAÇÃO

### **PASSO 1: Executar SQL no Supabase**

1. Acesse seu projeto no Supabase
2. Vá em **SQL Editor**
3. Cole todo o conteúdo do arquivo `SISTEMA_RECIBOS.sql`
4. Clique em **RUN**
5. Aguarde a confirmação de sucesso

**Verificação:**
```sql
SELECT * FROM recibos_documentos LIMIT 1;
```

---

### **PASSO 2: Adicionar Scripts no Portal do Colaborador**

Edite o arquivo `meus-contracheques.html` (ou portal-colaborador.html):

**Adicione antes do `</head>`:**

```html
<!-- CSS do Sistema de Recibos -->
<link rel="stylesheet" href="assets/css/recibo-modal.css">
```

**Adicione antes do `</body>`:**

```html
<!-- JavaScript do Sistema de Recibos -->
<script src="assets/js/recibo-modal.js"></script>
```

---

### **PASSO 3: Modificar Função de Download**

No arquivo `assets/js/colaborador-dashboard.js`, localize a função `baixarContracheque`:

**ANTES:**
```javascript
async function baixarContracheque(arquivoUrl, nomeArquivo) {
    // ... código de download direto
}
```

**DEPOIS:**
```javascript
async function baixarContracheque(arquivoUrl, nomeArquivo) {
    // Buscar dados do documento
    const documento = contracheques.find(c => c.arquivo_url === arquivoUrl);
    
    if (!documento) {
        console.error('❌ Documento não encontrado');
        return;
    }

    // Verificar se precisa de recibo e abrir modal
    await verificarEAbrirRecibo(documento, () => {
        // Callback: executar download após confirmar recibo
        realizarDownloadPDF(arquivoUrl, nomeArquivo);
    });
}

// Função auxiliar para download real
async function realizarDownloadPDF(arquivoUrl, nomeArquivo) {
    // ... código de download original aqui
}
```

---

### **PASSO 4: Adicionar Aba "Recibos" no Painel RH**

Edite `admin-rh.html` (ou painel-rh/admin-rh.html):

**1. Adicionar no Menu de Navegação:**

```html
<nav class="admin-nav">
    <!-- ...itens existentes... -->
    
    <a href="#section-recibos" data-section="section-recibos">
        <i class="fa-solid fa-file-signature"></i>
        Recibos
    </a>
</nav>
```

**2. Adicionar Seção de Recibos:**

```html
<!-- Seção: Recibos -->
<section id="section-recibos" class="content-section" style="display: none;">
    <div class="section-header">
        <h2><i class="fa-solid fa-file-signature"></i> Recibos de Documentos</h2>
        <p>Visualize todos os recibos digitais gerados pelos colaboradores</p>
    </div>

    <!-- Estatísticas -->
    <div id="statsRecibos"></div>

    <!-- Filtros -->
    <div class="filter-bar">
        <select id="filtroTipoRecibo" class="form-input">
            <option value="">Todos os tipos</option>
            <option value="contracheque">Contracheques</option>
            <option value="informe_ir">Informes de IR</option>
        </select>

        <select id="filtroAnoRecibo" class="form-input">
            <option value="">Todos os anos</option>
        </select>

        <button class="btn btn-primary" onclick="carregarRecibos()">
            <i class="fa-solid fa-filter"></i>
            Filtrar
        </button>
    </div>

    <!-- Tabela de Recibos -->
    <div class="table-container">
        <div id="tabelaRecibos"></div>
    </div>

    <!-- Documentos Sem Recibo -->
    <div class="alert alert-warning">
        <h3><i class="fa-solid fa-exclamation-triangle"></i> Documentos Sem Recibo</h3>
        <div id="docsSemRecibo"></div>
    </div>
</section>
```

**3. Adicionar Scripts:**

```html
<!-- Antes do </body> -->
<script src="assets/js/recibo-admin.js"></script>

<script>
// Inicializar na função init() existente
async function carregarRecibos() {
    // Buscar estatísticas
    const stats = await buscarEstatisticasRecibos();
    if (stats.success) {
        renderizarEstatisticasRecibos(stats.data);
    }

    // Buscar recibos
    const filtros = {
        tipoDocumento: document.getElementById('filtroTipoRecibo').value,
        ano: document.getElementById('filtroAnoRecibo').value
    };

    const recibos = await buscarTodosRecibos(filtros);
    if (recibos.success) {
        renderizarTabelaRecibos(recibos.data);
    }

    // Buscar documentos sem recibo
    const semRecibo = await buscarDocumentosSemRecibo();
    if (semRecibo.success) {
        renderizarDocsSemRecibo(semRecibo.data);
    }
}

// Chamar ao carregar a seção
document.querySelector('[data-section="section-recibos"]')
    .addEventListener('click', carregarRecibos);
</script>
```

---

## 🎨 CUSTOMIZAÇÃO DO MODAL

O modal pode ser customizado editando `assets/css/recibo-modal.css`:

- **Cores:** Ajuste as variáveis de cor no `:root`
- **Animações:** Modifique os `@keyframes`
- **Tamanho:** Altere `max-width` do `.modal-recibo-content`
- **Responsividade:** Ajuste os `@media queries`

---

## 🔧 CONFIGURAÇÕES AVANÇADAS

### Desabilitar Modal (Modo de Teste)

No arquivo `recibo-modal.js`, comente a linha:

```javascript
// abrirModalRecibo(documento, callbackSucesso);
// Em vez disso, execute direto:
if (callbackSucesso) callbackSucesso();
```

### Adicionar Assinatura Desenhada (Canvas)

1. Adicione um `<canvas>` no modal
2. Implemente captura de assinatura
3. Salve como Base64 na coluna `assinatura_canvas`

### Enviar E-mail ao Gerar Recibo

```javascript
// No confirmarRecibo(), após salvar no banco:
await enviarEmailConfirmacaoRecibo(colaboradorAtual.email, dadosRecibo);
```

---

## 📊 RELATÓRIOS E QUERIES ÚTEIS

### Ver todos os recibos do mês atual:
```sql
SELECT * FROM view_recibos_completos
WHERE EXTRACT(MONTH FROM data_recebimento) = EXTRACT(MONTH FROM CURRENT_DATE)
  AND EXTRACT(YEAR FROM data_recebimento) = EXTRACT(YEAR FROM CURRENT_DATE)
ORDER BY data_recebimento DESC;
```

### Colaboradores que NÃO geraram recibo:
```sql
SELECT DISTINCT
    col.nome_completo,
    col.cpf,
    col.email,
    c.mes_referencia,
    c.ano,
    c.enviado_em
FROM contracheques c
INNER JOIN colaboradores col ON c.colaborador_id = col.id
WHERE c.recibo_gerado = false
  AND col.ativo = true
ORDER BY c.enviado_em DESC;
```

### Estatísticas gerais:
```sql
SELECT 
    COUNT(*) as total_recibos,
    COUNT(DISTINCT colaborador_id) as colaboradores_unicos,
    tipo_documento,
    TO_CHAR(data_recebimento, 'YYYY-MM') as mes_ano
FROM recibos_documentos
GROUP BY tipo_documento, TO_CHAR(data_recebimento, 'YYYY-MM')
ORDER BY mes_ano DESC, tipo_documento;
```

---

## 🛡️ SEGURANÇA E AUDITORIA

### Dados Registrados:
- ✅ **IP Address** - Identifica origem do acesso
- ✅ **User Agent** - Navegador e dispositivo usado
- ✅ **Timestamp** - Data e hora exatas
- ✅ **Assinatura Digital** - Nome completo do colaborador
- ✅ **Declaração de Aceite** - Confirmação obrigatória

### Recomendações:
- Manter backups regulares da tabela `recibos_documentos`
- Implementar logs de acesso ao painel RH
- Exportar relatórios mensais em PDF
- Armazenar recibos por no mínimo 5 anos (conforme legislação)

---

## ❓ TROUBLESHOOTING

### Problema: Modal não abre
**Solução:** Verifique se os scripts foram carregados na ordem correta:
1. `supabase-config.js`
2. `supabase-colaborador.js`
3. `recibo-modal.js`

### Problema: Erro ao salvar recibo
**Solução:** Verifique as políticas RLS no Supabase:
```sql
SELECT * FROM pg_policies WHERE tablename = 'recibos_documentos';
```

### Problema: Recibo não aparece no RH
**Solução:** Verifique se a view foi criada:
```sql
SELECT * FROM view_recibos_completos LIMIT 1;
```

---

## 📞 SUPORTE

Em caso de dúvidas ou problemas:
1. Verifique os logs do console (F12)
2. Teste as queries SQL diretamente no Supabase
3. Revise este guia passo a passo
4. Contate o desenvolvedor responsável

---

## ✅ CHECKLIST FINAL

- [ ] SQL executado com sucesso no Supabase
- [ ] Scripts adicionados no portal do colaborador
- [ ] CSS do modal carregando corretamente
- [ ] Função de download modificada
- [ ] Aba "Recibos" criada no painel RH
- [ ] Testado com usuário real
- [ ] Modal abrindo corretamente
- [ ] Recibo salvando no banco
- [ ] Download funcionando após recibo
- [ ] RH visualizando recibos
- [ ] Estatísticas aparecendo
- [ ] Filtros funcionando

---

**Sistema desenvolvido para ISIBA Social**  
**Versão 1.0 - Fevereiro 2026**
