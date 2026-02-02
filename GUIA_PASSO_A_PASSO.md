# 🔧 GUIA PASSO A PASSO - Configurar Download de PDFs

## ⚠️ IMPORTANTE
Execute **cada comando separadamente** no SQL Editor do Supabase.
Não copie e cole tudo de uma vez!

---

## PASSO 1: Verificar se o bucket existe

```sql
SELECT id, name, public, created_at 
FROM storage.buckets 
WHERE name = 'contracheques';
```

**Resultado esperado:** Deve retornar 1 linha com o bucket 'contracheques'

**Se NÃO retornar nada:**
1. Vá em Storage > Create bucket
2. Nome: `contracheques`
3. Marque como **Privado** (IMPORTANTE!)
4. Clique em Create

---

## PASSO 2: Verificar políticas existentes

```sql
SELECT 
    policyname,
    cmd,
    roles
FROM pg_policies 
WHERE schemaname = 'storage' 
  AND tablename = 'objects';
```

**Anote quais políticas já existem para não criar duplicadas.**

---

## PASSO 3: Criar política de LEITURA (obrigatória!)

```sql
CREATE POLICY "Permitir leitura de contracheques"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'contracheques');
```

**Se der erro dizendo que já existe:** OK, pule para o próximo passo.

---

## PASSO 4: Criar política de UPLOAD (obrigatória!)

```sql
CREATE POLICY "Permitir upload de contracheques"
ON storage.objects
FOR INSERT
TO public
WITH CHECK (bucket_id = 'contracheques');
```

**Se der erro dizendo que já existe:** OK, pule para o próximo passo.

---

## PASSO 5: Criar política de ATUALIZAÇÃO (recomendada)

```sql
CREATE POLICY "Permitir atualização de contracheques"
ON storage.objects
FOR UPDATE
TO public
USING (bucket_id = 'contracheques')
WITH CHECK (bucket_id = 'contracheques');
```

---

## PASSO 6: Verificar se as políticas foram criadas

```sql
SELECT 
    policyname,
    cmd,
    roles
FROM pg_policies 
WHERE schemaname = 'storage' 
  AND tablename = 'objects'
  AND policyname LIKE '%contracheques%';
```

**Resultado esperado:** Deve mostrar pelo menos 3 políticas:
- Permitir leitura de contracheques (SELECT)
- Permitir upload de contracheques (INSERT)
- Permitir atualização de contracheques (UPDATE)

---

## PASSO 7: Verificar se há arquivos no bucket

```sql
SELECT 
    name,
    bucket_id,
    created_at
FROM storage.objects 
WHERE bucket_id = 'contracheques'
ORDER BY created_at DESC;
```

**Resultado esperado:** Deve mostrar os arquivos PDFs, exemplo:
- `08676044503/2026-01.pdf`

**Se NÃO mostrar arquivos:**
1. Acesse o painel RH: http://localhost:8000/painel-rh/admin-rh.html
2. Faça login
3. Envie um contracheque de teste

---

## PASSO 8: TESTAR O DOWNLOAD

1. Recarregue a página do portal (Ctrl + Shift + R)
2. Faça login como colaborador
3. Tente baixar um contracheque
4. Abra o Console (F12) e copie TODOS os logs

---

## ❓ PROBLEMAS COMUNS

### Erro: "policy already exists"
- **Solução:** Ignore, a política já existe e está OK.

### Erro: "permission denied"
- **Solução:** Você precisa estar logado como owner do projeto no Supabase.

### Erro: "bucket_id does not exist"
- **Solução:** O bucket não foi criado. Volte ao PASSO 1.

### Download não funciona após criar as políticas
- **Solução:** 
  1. Verifique se o bucket é PRIVADO (não público)
  2. Verifique se o arquivo existe (PASSO 7)
  3. Recarregue a página com Ctrl+Shift+R
  4. Envie os logs do console

---

## 📝 CHECKLIST FINAL

Antes de testar, confirme:
- [ ] Bucket `contracheques` existe
- [ ] Bucket é PRIVADO (não público)
- [ ] Política de leitura foi criada
- [ ] Política de upload foi criada
- [ ] Arquivo existe no bucket
- [ ] Página foi recarregada (Ctrl+Shift+R)

---

## 🆘 PRECISA DE AJUDA?

Envie:
1. Screenshot do resultado do PASSO 6 (políticas criadas)
2. Screenshot do resultado do PASSO 7 (arquivos no bucket)
3. Todos os logs do console ao tentar baixar
