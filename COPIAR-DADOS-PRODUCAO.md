# 📦 Guia: Copiar Dados de Produção para Desenvolvimento

## 🎯 Objetivo

Copiar **todos os dados reais** do banco de produção para o banco de desenvolvimento, mantendo:
- ✅ Todos os colaboradores cadastrados
- ✅ Todos os contracheques enviados
- ✅ Todos os recibos gerados
- ✅ Todas as configurações

---

## ⚠️ IMPORTANTE: Faça Backup Primeiro!

Antes de qualquer coisa, vamos fazer backup do banco de produção.

---

## 🚀 Método 1: Via SQL (Recomendado)

### Passo 1: Exportar Dados de Produção

1. Acesse o projeto de **PRODUÇÃO** no Supabase
2. Vá em: **SQL Editor**
3. Execute este script para gerar os INSERTs:

```sql
-- ════════════════════════════════════════════════════════════════
-- SCRIPT DE EXPORTAÇÃO - EXECUTE NO BANCO DE PRODUÇÃO
-- ════════════════════════════════════════════════════════════════

-- 1. EXPORTAR COLABORADORES
SELECT 
    'INSERT INTO colaboradores (id, nome, codigo, cpf, email, senha_hash, status, primeiro_acesso, criado_em, atualizado_em) VALUES (' ||
    quote_literal(id::text) || '::uuid, ' ||
    quote_literal(nome) || ', ' ||
    quote_literal(codigo) || ', ' ||
    quote_literal(cpf) || ', ' ||
    COALESCE(quote_literal(email), 'NULL') || ', ' ||
    quote_literal(senha_hash) || ', ' ||
    quote_literal(status) || ', ' ||
    primeiro_acesso || ', ' ||
    quote_literal(criado_em::text) || '::timestamp, ' ||
    quote_literal(atualizado_em::text) || '::timestamp' ||
    ') ON CONFLICT (cpf) DO UPDATE SET nome = EXCLUDED.nome, codigo = EXCLUDED.codigo;'
FROM colaboradores
ORDER BY criado_em;

-- 2. EXPORTAR CONTRACHEQUES
SELECT 
    'INSERT INTO contracheques (id, colaborador_id, tipo_documento, mes, ano, arquivo_url, tamanho_bytes, bloqueado, data_envio, recibo_gerado, criado_em, atualizado_em) VALUES (' ||
    quote_literal(id::text) || '::uuid, ' ||
    quote_literal(colaborador_id::text) || '::uuid, ' ||
    quote_literal(tipo_documento) || ', ' ||
    COALESCE(quote_literal(mes), 'NULL') || ', ' ||
    ano || ', ' ||
    quote_literal(arquivo_url) || ', ' ||
    COALESCE(tamanho_bytes::text, 'NULL') || ', ' ||
    COALESCE(bloqueado, false) || ', ' ||
    quote_literal(data_envio::text) || '::timestamp, ' ||
    recibo_gerado || ', ' ||
    quote_literal(criado_em::text) || '::timestamp, ' ||
    quote_literal(atualizado_em::text) || '::timestamp' ||
    ') ON CONFLICT DO NOTHING;'
FROM contracheques
ORDER BY criado_em;

-- 3. EXPORTAR RECIBOS
SELECT 
    'INSERT INTO recibos_documentos (id, contracheque_id, colaborador_id, tipo_documento, mes, ano, data_recebimento, ip_address, user_agent, assinatura_digital, criado_em) VALUES (' ||
    quote_literal(id::text) || '::uuid, ' ||
    quote_literal(contracheque_id::text) || '::uuid, ' ||
    quote_literal(colaborador_id::text) || '::uuid, ' ||
    quote_literal(tipo_documento) || ', ' ||
    COALESCE(quote_literal(mes), 'NULL') || ', ' ||
    ano || ', ' ||
    quote_literal(data_recebimento::text) || '::timestamp, ' ||
    COALESCE(quote_literal(ip_address), 'NULL') || ', ' ||
    COALESCE(quote_literal(user_agent), 'NULL') || ', ' ||
    COALESCE(quote_literal(assinatura_digital), 'NULL') || ', ' ||
    quote_literal(criado_em::text) || '::timestamp' ||
    ') ON CONFLICT DO NOTHING;'
FROM recibos_documentos
ORDER BY criado_em;

-- 4. EXPORTAR ADMIN RH
SELECT 
    'INSERT INTO admin_rh (id, usuario, senha_hash, nome_completo, email, ativo, criado_em, atualizado_em) VALUES (' ||
    quote_literal(id::text) || '::uuid, ' ||
    quote_literal(usuario) || ', ' ||
    quote_literal(senha_hash) || ', ' ||
    COALESCE(quote_literal(nome_completo), 'NULL') || ', ' ||
    COALESCE(quote_literal(email), 'NULL') || ', ' ||
    ativo || ', ' ||
    quote_literal(criado_em::text) || '::timestamp, ' ||
    quote_literal(atualizado_em::text) || '::timestamp' ||
    ') ON CONFLICT (usuario) DO UPDATE SET senha_hash = EXCLUDED.senha_hash;'
FROM admin_rh
ORDER BY criado_em;
```

4. **Copie todos os resultados** (cada linha é um INSERT)
5. Salve em um arquivo: `DADOS-PRODUCAO-EXPORT.sql`

---

### Passo 2: Importar para Desenvolvimento

1. Acesse o projeto de **DESENVOLVIMENTO** no Supabase
2. Vá em: **SQL Editor**
3. Cole **TODO o conteúdo** do arquivo `DADOS-PRODUCAO-EXPORT.sql`
4. Execute
5. ✅ Pronto! Todos os dados foram copiados

---

## 🚀 Método 2: Usando pgAdmin/DBeaver (Alternativo)

Se preferir usar ferramentas gráficas:

### Configurar Conexões

**Produção:**
```
Host: db.kklhcmrnraroletwbbid.supabase.co
Database: postgres
Port: 5432
User: postgres
Password: [senha do projeto]
```

**Desenvolvimento:**
```
Host: db.[seu-projeto-dev].supabase.co
Database: postgres
Port: 5432
User: postgres
Password: [senha do projeto dev]
```

### Copiar Dados

1. Conecte-se ao banco de **produção**
2. Clique com botão direito na tabela `colaboradores`
3. **Export Data** → SQL INSERT
4. Salve o arquivo
5. Conecte-se ao banco de **desenvolvimento**
6. Execute o arquivo SQL salvo
7. Repita para: `contracheques`, `recibos_documentos`, `admin_rh`

---

## 🎯 Método 3: Script Automático (Mais Rápido)

Vou criar um script SQL que faz tudo automaticamente:

### Execute no Banco de PRODUÇÃO:

```sql
-- Gerar script completo de exportação
SELECT string_agg(sql, E'\n\n')
FROM (
    -- Colaboradores
    SELECT 
        'INSERT INTO colaboradores (id, nome, codigo, cpf, email, senha_hash, status, primeiro_acesso, criado_em, atualizado_em) VALUES (' ||
        quote_literal(id::text) || '::uuid, ' ||
        quote_literal(nome) || ', ' ||
        quote_literal(codigo) || ', ' ||
        quote_literal(cpf) || ', ' ||
        COALESCE(quote_literal(email), 'NULL') || ', ' ||
        quote_literal(senha_hash) || ', ' ||
        quote_literal(status) || ', ' ||
        primeiro_acesso || ', ' ||
        quote_literal(criado_em::text) || '::timestamp, ' ||
        quote_literal(atualizado_em::text) || '::timestamp' ||
        ') ON CONFLICT (cpf) DO UPDATE SET nome = EXCLUDED.nome;' as sql
    FROM colaboradores
    
    UNION ALL
    
    -- Contracheques
    SELECT 
        'INSERT INTO contracheques (id, colaborador_id, tipo_documento, mes, ano, arquivo_url, tamanho_bytes, bloqueado, data_envio, recibo_gerado, criado_em, atualizado_em) VALUES (' ||
        quote_literal(id::text) || '::uuid, ' ||
        quote_literal(colaborador_id::text) || '::uuid, ' ||
        quote_literal(tipo_documento) || ', ' ||
        COALESCE(quote_literal(mes), 'NULL') || ', ' ||
        ano || ', ' ||
        quote_literal(arquivo_url) || ', ' ||
        COALESCE(tamanho_bytes::text, 'NULL') || ', ' ||
        COALESCE(bloqueado, false) || ', ' ||
        quote_literal(data_envio::text) || '::timestamp, ' ||
        recibo_gerado || ', ' ||
        quote_literal(criado_em::text) || '::timestamp, ' ||
        quote_literal(atualizado_em::text) || '::timestamp' ||
        ') ON CONFLICT DO NOTHING;'
    FROM contracheques
    
    UNION ALL
    
    -- Recibos
    SELECT 
        'INSERT INTO recibos_documentos (id, contracheque_id, colaborador_id, tipo_documento, mes, ano, data_recebimento, ip_address, user_agent, assinatura_digital, criado_em) VALUES (' ||
        quote_literal(id::text) || '::uuid, ' ||
        quote_literal(contracheque_id::text) || '::uuid, ' ||
        quote_literal(colaborador_id::text) || '::uuid, ' ||
        quote_literal(tipo_documento) || ', ' ||
        COALESCE(quote_literal(mes), 'NULL') || ', ' ||
        ano || ', ' ||
        quote_literal(data_recebimento::text) || '::timestamp, ' ||
        COALESCE(quote_literal(ip_address), 'NULL') || ', ' ||
        COALESCE(quote_literal(user_agent), 'NULL') || ', ' ||
        COALESCE(quote_literal(assinatura_digital), 'NULL') || ', ' ||
        quote_literal(criado_em::text) || '::timestamp' ||
        ') ON CONFLICT DO NOTHING;'
    FROM recibos_documentos
    
    UNION ALL
    
    -- Admin
    SELECT 
        'INSERT INTO admin_rh (id, usuario, senha_hash, nome_completo, email, ativo, criado_em, atualizado_em) VALUES (' ||
        quote_literal(id::text) || '::uuid, ' ||
        quote_literal(usuario) || ', ' ||
        quote_literal(senha_hash) || ', ' ||
        COALESCE(quote_literal(nome_completo), 'NULL') || ', ' ||
        COALESCE(quote_literal(email), 'NULL') || ', ' ||
        ativo || ', ' ||
        quote_literal(criado_em::text) || '::timestamp, ' ||
        quote_literal(atualizado_em::text) || '::timestamp' ||
        ') ON CONFLICT (usuario) DO UPDATE SET senha_hash = EXCLUDED.senha_hash;'
    FROM admin_rh
) exports;
```

**Resultado:** Um único texto com TODOS os INSERTs. Copie e cole no desenvolvimento!

---

## ⚠️ ATENÇÃO: Arquivos do Storage

Os **PDFs** dos contracheques **NÃO são copiados** por esses métodos!

### Para copiar os PDFs:

#### Opção 1: Manualmente via Dashboard
1. Baixe todos os PDFs do bucket de produção
2. Faça upload no bucket de desenvolvimento

#### Opção 2: Via API (se muitos arquivos)
```javascript
// Script para copiar arquivos entre buckets
// Execute no console do navegador logado no Supabase
```

**NOTA:** Como é desenvolvimento, você pode:
- ✅ Não copiar os PDFs (apenas testar upload)
- ✅ Copiar apenas alguns PDFs de exemplo
- ✅ Usar PDFs de teste

---

## ✅ Verificação Final

Após importar, execute no banco de **DESENVOLVIMENTO**:

```sql
-- Verificar se dados foram copiados
SELECT 'Colaboradores' as tabela, COUNT(*) as total FROM colaboradores
UNION ALL
SELECT 'Contracheques', COUNT(*) FROM contracheques
UNION ALL
SELECT 'Recibos', COUNT(*) FROM recibos_documentos
UNION ALL
SELECT 'Admin RH', COUNT(*) FROM admin_rh;
```

**Resultado esperado:** Mesma quantidade de registros que produção!

---

## 🎯 Resumo do Processo

1. ✅ Executar script de export no banco de **produção**
2. ✅ Copiar todos os INSERTs gerados
3. ✅ Salvar em arquivo `DADOS-PRODUCAO-EXPORT.sql`
4. ✅ Executar no banco de **desenvolvimento**
5. ✅ Verificar contagem de registros
6. ✅ (Opcional) Copiar alguns PDFs de exemplo

---

## 📝 Notas Importantes

- ✅ Os INSERTs usam `ON CONFLICT DO UPDATE/NOTHING` (não duplica dados)
- ✅ Senhas são copiadas (hash), mantém os mesmos logins
- ✅ IDs são preservados (UUIDs)
- ✅ Timestamps são preservados
- ✅ Você pode executar múltiplas vezes sem problemas

---

**Pronto! Agora você tem uma cópia exata de produção para testar à vontade!** 🎉
