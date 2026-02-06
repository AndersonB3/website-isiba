# 🚀 GUIA RÁPIDO: Clonar Banco de Produção (SIMPLIFICADO)

## ⚡ Processo em 5 Passos Simples

---

## 📝 PASSO 1: Gerar CREATE TABLE (2 min)

### No Banco de PRODUÇÃO:

1. Abra: **SQL Editor**
2. Execute o arquivo: **`database/GERAR-TABELAS-SIMPLES.sql`**
3. **Copie TODO o resultado**
4. Salve em um arquivo de texto: `estrutura-tabelas.sql`

---

## 📝 PASSO 2: Criar Tabelas no Desenvolvimento (1 min)

### No Banco de DESENVOLVIMENTO:

1. Abra: **SQL Editor**
2. Cole o conteúdo de `estrutura-tabelas.sql`
3. Execute
4. ✅ Tabelas criadas!

---

## 📝 PASSO 3: Gerar PRIMARY KEYS (1 min)

### No Banco de PRODUÇÃO:

1. Execute o arquivo: **`database/GERAR-PRIMARY-KEYS.sql`**
2. Copie o resultado
3. No banco de DESENVOLVIMENTO: Cole e execute

---

## 📝 PASSO 4: Gerar FOREIGN KEYS (1 min)

### No Banco de PRODUÇÃO:

1. Execute o arquivo: **`database/GERAR-FOREIGN-KEYS.sql`**
2. Copie o resultado
3. No banco de DESENVOLVIMENTO: Cole e execute

---

## 📝 PASSO 5: Copiar os DADOS (5 min)

### Método Mais Simples:

Execute no **PRODUÇÃO**, depois no **DESENVOLVIMENTO**:

```sql
-- Para cada tabela, execute:
SELECT * FROM colaboradores;  -- Copie os dados visualmente
SELECT * FROM contracheques;
SELECT * FROM recibos_documentos;
SELECT * FROM admin_rh;
```

Ou use o **Table Editor** do Supabase:
1. Abra a tabela na PRODUÇÃO
2. Selecione todos (Ctrl+A)
3. Copie (Ctrl+C)
4. Abra a mesma tabela no DESENVOLVIMENTO
5. Cole (Ctrl+V)

---

## ✅ VERIFICAR

Execute no DESENVOLVIMENTO:

```sql
SELECT table_name, 
       (SELECT COUNT(*) FROM information_schema.columns c 
        WHERE c.table_name = t.table_name) as colunas
FROM information_schema.tables t
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE';
```

---

## 📁 Arquivos Criados:

✅ `database/GERAR-TABELAS-SIMPLES.sql` - Gera CREATE TABLE  
✅ `database/GERAR-PRIMARY-KEYS.sql` - Gera ALTER TABLE ADD PRIMARY KEY  
✅ `database/GERAR-FOREIGN-KEYS.sql` - Gera ALTER TABLE ADD FOREIGN KEY  

---

## 🎯 Ordem de Execução:

| # | Onde | Arquivo | Ação |
|---|------|---------|------|
| 1 | 🔴 Produção | GERAR-TABELAS-SIMPLES.sql | Executar e copiar resultado |
| 2 | ✅ Desenvolvimento | Resultado do #1 | Colar e executar |
| 3 | 🔴 Produção | GERAR-PRIMARY-KEYS.sql | Executar e copiar resultado |
| 4 | ✅ Desenvolvimento | Resultado do #3 | Colar e executar |
| 5 | 🔴 Produção | GERAR-FOREIGN-KEYS.sql | Executar e copiar resultado |
| 6 | ✅ Desenvolvimento | Resultado do #5 | Colar e executar |
| 7 | 🔴→✅ | Via Table Editor | Copiar dados manualmente |

**Total: 10 minutos**

---

## 💡 Dica

Se algum script der erro, não tem problema! Execute os próximos. O importante é ter as tabelas criadas primeiro.

---

**Pronto!** Comece pelo PASSO 1 agora! 🚀
