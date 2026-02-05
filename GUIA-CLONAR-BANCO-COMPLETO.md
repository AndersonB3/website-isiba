# 🎯 GUIA DEFINITIVO: Clonar Banco de Produção para Desenvolvimento

## 📋 Processo em 3 Etapas

---

## ETAPA 1: Gerar Script da Estrutura (5 min)

### No Banco de PRODUÇÃO:

1. Abra: **Supabase Dashboard** → Projeto de Produção
2. Vá em: **SQL Editor**
3. Abra o arquivo: `database/GERAR-ESTRUTURA-COMPLETA.sql`
4. **Copie TODO o conteúdo** (Ctrl+A, Ctrl+C)
5. **Cole no SQL Editor** da produção
6. Clique em **Run** ▶️
7. **COPIE TODO O RESULTADO** (será um texto gigante)
8. Salve em um arquivo: `ESTRUTURA-PRODUCAO.sql`

**Resultado esperado:** Um script SQL gigante com CREATE TABLE, INDEX, TRIGGER, RLS, etc.

---

## ETAPA 2: Criar Estrutura no Desenvolvimento (3 min)

### No Banco de DESENVOLVIMENTO:

1. Abra: **Supabase Dashboard** → Projeto de Desenvolvimento
2. Vá em: **SQL Editor**
3. **Cole** o conteúdo do arquivo `ESTRUTURA-PRODUCAO.sql`
4. Clique em **Run** ▶️
5. Aguarde alguns segundos

**Resultado esperado:** Todas as tabelas, índices e políticas criadas! ✅

---

## ETAPA 3: Copiar os Dados (10 min)

### Método A: Via Supabase Dashboard (Mais Fácil)

1. Abra o banco de **PRODUÇÃO**
2. Vá em: **Table Editor**
3. Para cada tabela:
   - Clique na tabela
   - Selecione todos os registros (Ctrl+A)
   - Copie (Ctrl+C)
   - Abra o banco de **DESENVOLVIMENTO**
   - Vá na mesma tabela
   - Cole os dados (Ctrl+V)

### Método B: Via SQL (Mais Rápido para muitos dados)

Para cada tabela, execute no **PRODUÇÃO**:

```sql
-- Exemplo para tabela colaboradores
SELECT 
    'INSERT INTO colaboradores VALUES ' ||
    string_agg(
        '(' || quote_literal(id::text) || '::uuid, ' ||
        -- ... todos os campos ...
        ')',
        ',' || E'\n'
    ) || ';'
FROM colaboradores;
```

Copie o resultado e execute no **DESENVOLVIMENTO**.

### Método C: Usando pgAdmin/DBeaver (Recomendado para bancos grandes)

**Conectar ao banco de PRODUÇÃO:**
```
Host: db.kklhcmrnraroletwbbid.supabase.co
Database: postgres
Port: 5432
User: postgres
Password: [sua senha de produção]
```

**Conectar ao banco de DESENVOLVIMENTO:**
```
Host: db.[seu-projeto-dev].supabase.co
Database: postgres
Port: 5432
User: postgres
Password: [sua senha de desenvolvimento]
```

**Copiar dados:**
1. Conecte em ambos os bancos
2. No banco de PRODUÇÃO: Clique direito na tabela → **Backup**
3. Escolha formato: **Plain SQL**
4. Marque: **Data only** (somente dados)
5. Salve o arquivo
6. No banco de DESENVOLVIMENTO: **Restore** → selecione o arquivo

---

## ✅ VERIFICAÇÃO FINAL

Execute no banco de **DESENVOLVIMENTO**:

```sql
-- Verificar se as tabelas foram criadas
SELECT 
    table_name as "Tabela",
    (SELECT COUNT(*) 
     FROM information_schema.columns 
     WHERE columns.table_name = tables.table_name) as "Colunas"
FROM information_schema.tables tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- Verificar se os dados foram copiados
SELECT 'colaboradores' as tabela, COUNT(*) as registros FROM colaboradores
UNION ALL
SELECT 'contracheques', COUNT(*) FROM contracheques
UNION ALL
SELECT 'recibos_documentos', COUNT(*) FROM recibos_documentos
UNION ALL
SELECT 'admin_rh', COUNT(*) FROM admin_rh;
```

**Se os números estiverem iguais aos de produção:** ✅ **SUCESSO!**

---

## 🎯 RESUMO

| Etapa | Onde | O Que | Tempo |
|-------|------|-------|-------|
| 1 | 🔴 Produção | Executar `GERAR-ESTRUTURA-COMPLETA.sql` | 5 min |
| 2 | ✅ Desenvolvimento | Aplicar estrutura gerada | 3 min |
| 3 | 🔴 Produção → ✅ Desenvolvimento | Copiar dados | 10 min |
| 4 | ✅ Desenvolvimento | Verificar | 2 min |

**Total:** ~20 minutos

---

## 📝 Arquivos Criados

- ✅ `database/GERAR-ESTRUTURA-COMPLETA.sql` - Gera estrutura automática
- ✅ `database/COPIAR-DADOS-AUTOMATICO.sql` - Helper para copiar dados
- ✅ `database/VERIFICAR-ESTRUTURA-PRODUCAO.sql` - Ver estrutura
- ✅ `ESTRUTURA-PRODUCAO.sql` - Resultado da geração (você vai criar)

---

## 🚨 IMPORTANTE

- ✅ NÃO precisa criar tabelas manualmente
- ✅ NÃO precisa ajustar nomes de colunas
- ✅ O script detecta TUDO automaticamente
- ✅ Funciona com QUALQUER estrutura de banco
- ✅ Copia RLS, triggers, índices, foreign keys

---

## 💡 Dicas

- Use o **Método A** se tiver poucos dados (< 100 registros)
- Use o **Método C** se tiver muitos dados (> 1000 registros)
- Os PDFs no Storage devem ser copiados manualmente (opcional para dev)

---

**Pronto para começar?** Execute o **ETAPA 1** primeiro! 🚀
