# 🔍 DIAGNÓSTICO E SOLUÇÃO - DOWNLOAD DE PDFs

## Problema Identificado
O sistema não está conseguindo baixar os PDFs dos contracheques, mesmo com a URL sendo gerada.

## Possíveis Causas

### 1. **Bucket não configurado corretamente**
- ✅ Nome do bucket: `contracheques` (verificado em supabase-config.js)
- ⚠️ Verifique se o bucket existe no painel do Supabase
- ⚠️ Verifique se o bucket é PRIVADO (signed URLs só funcionam em buckets privados)

### 2. **Arquivo não existe no caminho esperado**
- O sistema busca: `08676044503/2026-01.pdf`
- Verifique no painel Storage > contracheques se o arquivo está nesse caminho exato

### 3. **Políticas de acesso (RLS) não configuradas**
- O Supabase precisa de políticas de acesso para permitir a leitura via signed URL
- Execute o script `POLITICAS_STORAGE.sql` no SQL Editor do Supabase

### 4. **Problema com a resposta do Supabase**
- Algumas versões retornam `data.signedUrl`
- Outras retornam `data.url`
- O código agora trata ambos os casos

## Passo a Passo para Resolver

### PASSO 1: Verificar o Bucket
1. Acesse: https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/storage/buckets
2. Confirme que existe um bucket chamado `contracheques`
3. Clique no bucket e verifique se ele está como **PRIVADO**
4. Se não existir, crie um bucket privado com o nome `contracheques`

### PASSO 2: Verificar os Arquivos
1. No painel do bucket `contracheques`, navegue pelos arquivos
2. Verifique se existe a pasta `08676044503`
3. Dentro dessa pasta, verifique se existe o arquivo `2026-01.pdf`
4. Se não existir, faça o upload pelo painel RH: http://localhost:8000/painel-rh/admin-rh.html

### PASSO 3: Configurar Políticas de Acesso
1. Acesse: https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/editor
2. Copie todo o conteúdo do arquivo `POLITICAS_STORAGE.sql`
3. Cole no SQL Editor e clique em RUN
4. Verifique se as políticas foram criadas com sucesso

### PASSO 4: Testar o Download
1. Recarregue a página do portal do colaborador
2. Abra o Console do Navegador (F12)
3. Tente baixar um contracheque
4. Observe os logs detalhados no console:
   - `[DEBUG]` mostra o caminho do arquivo
   - `[DEBUG]` mostra a resposta do Supabase
   - `[DEBUG]` mostra a URL gerada

### PASSO 5: Verificar Logs no Console
Após tentar baixar, você verá logs como:
```
🔎 [DEBUG] Tentando gerar URL para: 08676044503/2026-01.pdf
🔎 [DEBUG] Bucket: contracheques
🔎 [DEBUG] Resposta do createSignedUrl: {data: {...}, error: null}
🔎 [DEBUG] URL extraída: https://...
✅ URL de download gerada: https://...
```

Se aparecer erro, copie a mensagem completa e verifique:
- "Resposta vazia do Supabase Storage" → Bucket ou arquivo não existe
- "URL não encontrada na resposta" → Problema com políticas de acesso
- "Object does not exist" → Arquivo não está no caminho correto

## Comandos SQL Úteis

### Verificar arquivos no bucket:
```sql
SELECT name, bucket_id, created_at 
FROM storage.objects 
WHERE bucket_id = 'contracheques'
ORDER BY created_at DESC;
```

### Verificar políticas:
```sql
SELECT name, definition 
FROM storage.policies 
WHERE bucket_id = 'contracheques';
```

### Listar contracheques no banco:
```sql
SELECT 
    c.id,
    c.mes_referencia,
    c.ano,
    c.arquivo_url,
    col.cpf,
    col.nome_completo
FROM contracheques c
JOIN colaboradores col ON c.colaborador_id = col.id
ORDER BY c.ano DESC, c.mes_referencia DESC;
```

## Solução Implementada

### Código Atualizado
1. ✅ `supabase-colaborador.js` - Função `downloadMeuContracheque`:
   - Logs detalhados de debug
   - Tratamento de diferentes formatos de resposta
   - Validação da URL antes de retornar

2. ✅ `colaborador-dashboard.js` - Função `baixarContracheque`:
   - Logs detalhados de debug
   - Validação da URL antes de abrir
   - Mensagens de erro mais claras

3. ✅ Script SQL criado para configurar políticas de acesso

## Próximos Passos

1. Recarregue a página no navegador (Ctrl+Shift+R)
2. Tente baixar um contracheque
3. Copie TODOS os logs do console e envie para análise
4. Se o erro persistir, execute o script SQL e tente novamente

## Contato para Suporte
Se após seguir todos os passos o problema persistir, forneça:
- Screenshot do bucket no Supabase mostrando os arquivos
- Logs completos do console do navegador
- Resultado da query SQL que lista os contracheques
