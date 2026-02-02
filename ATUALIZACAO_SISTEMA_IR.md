# 🚀 ATUALIZAÇÃO DO SISTEMA - INCLUSÃO DE INFORMES DE IR

## ✅ IMPLEMENTADO

### 1. Banco de Dados
- ✅ Script SQL criado: `ATUALIZAR_BANCO_DOCUMENTOS.sql`
- ✅ Adiciona coluna `tipo_documento` na tabela `contracheques`
- ✅ Suporta dois tipos: 'contracheque' e 'informe_ir'

### 2. Portal do Colaborador
- ✅ Nova página criada: `portal-colaborador.html` (substituindo meus-contracheques.html)
- ✅ Dashboard atualizado com 3 cards:
  - Total de Contracheques
  - Total de Informes de IR  
  - Último Documento
- ✅ Filtros:
  - Por tipo de documento (Todos / Contracheques / Informes de IR)
  - Por ano
- ✅ JavaScript atualizado: `portal-colaborador.js`
- ✅ Funções novas em `supabase-colaborador.js`:
  - `buscarMeusDocumentos()` - busca contracheques + informes
  - `obterMinhasEstatisticasCompletas()` - estatísticas separadas por tipo

### 3. Redirecionamentos
- ✅ Login do colaborador atualizado para redirecionar para `portal-colaborador.html`

## 📋 PENDENTE - PAINEL RH

O painel RH precisa ser atualizado para permitir o upload de Informes de IR. As alterações necessárias são:

### Alterações no HTML do Painel RH

1. **Atualizar título da seção** (linha ~346):
```html
<h2><i class="fa-solid fa-file-arrow-up"></i> Enviar Documentos</h2>
<p class="section-description">Envie contracheques mensais ou informes de imposto de renda para os colaboradores</p>
```

2. **Adicionar campo de seleção de tipo** (após o campo de colaborador):
```html
<div class="form-group">
    <label for="tipoDocumento">
        <i class="fa-solid fa-file-lines"></i>
        Tipo de Documento *
    </label>
    <select id="tipoDocumento" required>
        <option value="">Selecione o tipo</option>
        <option value="contracheque">Contracheque Mensal</option>
        <option value="informe_ir">Informe de Imposto de Renda</option>
    </select>
</div>
```

3. **Condicionar exibição do campo Mês** (JavaScript):
- Mostrar campo "Mês" apenas quando tipo = 'contracheque'
- Para 'informe_ir', usar "Anual" como mês_referencia

### Alterações no JavaScript do Painel RH

1. **Atualizar função de upload** em `supabase-admin.js`:

```javascript
async function uploadDocumento(colaboradorId, mes, ano, arquivo, tipoDocumento) {
    try {
        // Buscar dados do colaborador
        const { data: colaborador, error: errorColab } = await window.supabaseClient
            .from('colaboradores')
            .select('cpf, nome_completo')
            .eq('id', colaboradorId)
            .single();
        
        if (errorColab) throw errorColab;
        
        // Gerar nome do arquivo
        let fileName;
        if (tipoDocumento === 'informe_ir') {
            fileName = `${colaborador.cpf}/${ano}-INFORME-IR.pdf`;
        } else {
            const mesNumero = obterNumeroMes(mes);
            fileName = `${colaborador.cpf}/${ano}-${mesNumero}.pdf`;
        }
        
        // Upload do arquivo para o Storage
        const { data: uploadData, error: uploadError } = await window.supabaseClient
            .storage
            .from(window.CONFIG.bucket)
            .upload(fileName, arquivo, {
                cacheControl: '3600',
                upsert: true
            });
        
        if (uploadError) throw uploadError;
        
        // Verificar se já existe
        const mesRef = tipoDocumento === 'informe_ir' ? 'Anual' : mes;
        const { data: existente } = await window.supabaseClient
            .from('contracheques')
            .select('id')
            .eq('colaborador_id', colaboradorId)
            .eq('mes_referencia', mesRef)
            .eq('ano', parseInt(ano))
            .eq('tipo_documento', tipoDocumento)
            .single();
        
        let dbData;
        
        if (existente) {
            // Atualizar existente
            const { data, error: dbError } = await window.supabaseClient
                .from('contracheques')
                .update({
                    arquivo_url: fileName,
                    nome_arquivo: arquivo.name,
                    tamanho_arquivo: arquivo.size,
                    enviado_por: window.CONFIG.adminUser,
                    enviado_em: new Date().toISOString(),
                    tipo_documento: tipoDocumento
                })
                .eq('id', existente.id)
                .select();
            
            if (dbError) throw dbError;
            dbData = data[0];
        } else {
            // Inserir novo
            const { data, error: dbError } = await window.supabaseClient
                .from('contracheques')
                .insert([{
                    colaborador_id: colaboradorId,
                    mes_referencia: mesRef,
                    ano: parseInt(ano),
                    arquivo_url: fileName,
                    nome_arquivo: arquivo.name,
                    tamanho_arquivo: arquivo.size,
                    enviado_por: window.CONFIG.adminUser,
                    tipo_documento: tipoDocumento
                }])
                .select();
            
            if (dbError) throw dbError;
            dbData = data[0];
        }
        
        const tipoTexto = tipoDocumento === 'informe_ir' ? 'Informe de IR' : 'Contracheque';
        console.log(`✅ ${tipoTexto} ${existente ? 'atualizado' : 'enviado'}:`, dbData);
        
        return { 
            success: true, 
            data: dbData, 
            updated: !!existente
        };
        
    } catch (error) {
        console.error('❌ Erro ao enviar documento:', error);
        return { success: false, error: error.message };
    }
}
```

2. **Atualizar formulário** para mostrar/ocultar campo mês:

```javascript
document.getElementById('tipoDocumento').addEventListener('change', function() {
    const mesGroup = document.querySelector('[for="mesReferencia"]').parentElement;
    if (this.value === 'informe_ir') {
        mesGroup.style.display = 'none';
        document.getElementById('mesReferencia').removeAttribute('required');
    } else {
        mesGroup.style.display = 'block';
        document.getElementById('mesReferencia').setAttribute('required', 'required');
    }
});
```

3. **Atualizar histórico** para mostrar tipo de documento:

```javascript
async function listarHistorico(filtroMes = '') {
    // ... código existente ...
    
    // Adicionar coluna de tipo na renderização
    const tipoTexto = item.tipo_documento === 'informe_ir' ? 
        '<span class="badge badge-success">Informe IR</span>' : 
        '<span class="badge badge-primary">Contracheque</span>';
    
    // Incluir no HTML da tabela
}
```

## 🔄 PRÓXIMOS PASSOS

1. Execute o script SQL: `ATUALIZAR_BANCO_DOCUMENTOS.sql` no Supabase
2. Implemente as alterações no Painel RH conforme descrito acima
3. Teste o upload de Informe de IR
4. Teste a visualização no Portal do Colaborador
5. Commit e push das alterações

## 📝 ARQUIVOS CRIADOS/MODIFICADOS

### Criados:
- `ATUALIZAR_BANCO_DOCUMENTOS.sql` - Script de atualização do banco
- `portal-colaborador.html` - Nova página do portal
- `assets/js/portal-colaborador.js` - JavaScript do portal atualizado

### Modificados:
- `assets/js/supabase-colaborador.js` - Novas funções para documentos
- `assets/js/colaborador.js` - Redirecionamento atualizado

### A modificar:
- `painel-rh/admin-rh.html` - Adicionar campo tipo documento
- `painel-rh/assets/js/supabase-admin.js` - Atualizar função de upload
- `painel-rh/assets/js/admin-dashboard.js` - Atualizar formulário e histórico

## 🎯 RESULTADO ESPERADO

- ✅ Colaboradores podem ver contracheques E informes de IR no portal
- ✅ Estatísticas separadas por tipo de documento
- ✅ Filtros por tipo e ano
- ✅ RH pode enviar ambos os tipos de documentos
- ✅ Sistema diferencia visualmente cada tipo (cores e ícones)
