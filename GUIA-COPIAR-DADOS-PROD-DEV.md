# 🔄 GUIA: Copiar Dados de PRODUÇÃO para DESENVOLVIMENTO

## 🎯 OBJETIVO:
Copiar todos os dados do banco de **PRODUÇÃO** para **DESENVOLVIMENTO** de forma fácil e prática.

---

## ✅ MÉTODO RECOMENDADO: Via SQL Editor (GRATUITO)

### 📋 PASSO 1: Exportar dados da PRODUÇÃO

```batch
# Execute este script:
.\COPIAR-PROD-PARA-DEV.bat
```

Ou abra manualmente:
- **SQL Editor PRODUÇÃO:** https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/editor

### 📝 PASSO 2: Ver as tabelas

No SQL Editor da **PRODUÇÃO**, execute:

```sql
-- Ver todas as tabelas
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';
```

### 📊 PASSO 3: Exportar dados de cada tabela

Para cada tabela, execute no SQL Editor da **PRODUÇÃO**:

```sql
-- Exemplo: tabela contracheques
SELECT * FROM contracheques;
```

Depois:
1. Clique em **"Export to CSV"** (botão no canto superior direito)
2. Salve o arquivo (ex: `contracheques.csv`)

Repita para todas as tabelas importantes:
- `contracheques`
- `colaboradores` 
- `usuarios`
- `admin`
- (outras tabelas que existirem)

---

## 📥 PASSO 4: Importar para DESENVOLVIMENTO

### Opção A: Via Table Editor (Mais Fácil)

1. Abra o **Table Editor** do DESENVOLVIMENTO:
   https://supabase.com/dashboard/project/ikwnemhqqkpjurdpauim/table-editor

2. Selecione a tabela (ex: `contracheques`)

3. Clique em **"Insert"** → **"Import data from CSV"**

4. Selecione o arquivo CSV exportado

5. Clique em **"Import"**

6. Repita para todas as tabelas

### Opção B: Via SQL Editor (Mais Controle)

1. Abra o **SQL Editor** do DESENVOLVIMENTO:
   https://supabase.com/dashboard/project/ikwnemhqqkpjurdpauim/editor

2. **LIMPE a tabela primeiro:**

```sql
-- Limpar tabela (apaga todos os dados)
TRUNCATE TABLE contracheques CASCADE;
```

3. **Insira os dados manualmente** (se for poucos registros):

```sql
INSERT INTO contracheques (coluna1, coluna2, coluna3) VALUES
  ('valor1', 'valor2', 'valor3'),
  ('valor1', 'valor2', 'valor3');
```

---

## 🚀 SCRIPT AUTOMÁTICO (SQL)

Criei um script que facilita o processo. Execute:

```batch
.\COPIAR-PROD-PARA-DEV.bat
```

**Menu de opções:**
1. **Método Rápido** - Abre SQL Editors (export CSV → import CSV)
2. **Método SQL** - Gera scripts SQL para você copiar
3. **Ver Estrutura** - Mostra todas as tabelas

---

## 📊 EXEMPLO COMPLETO: Copiar tabela `contracheques`

### No SQL Editor da PRODUÇÃO:

```sql
-- 1. Ver os dados
SELECT * FROM contracheques;

-- 2. Exportar para CSV (botão Export to CSV)
```

### No SQL Editor do DESENVOLVIMENTO:

```sql
-- 3. Limpar tabela primeiro
TRUNCATE TABLE contracheques CASCADE;

-- 4. Depois importar o CSV via Table Editor
--    ou inserir manualmente via SQL
```

---

## 🔧 MÉTODO ALTERNATIVO: Duplicar estrutura + dados

Se quiser copiar TUDO de uma vez no SQL Editor do **DESENVOLVIMENTO**:

```sql
-- ATENÇÃO: Isso apaga TODOS os dados do DEV primeiro!

-- 1. Limpar todas as tabelas
TRUNCATE TABLE contracheques CASCADE;
TRUNCATE TABLE colaboradores CASCADE;
TRUNCATE TABLE usuarios CASCADE;
TRUNCATE TABLE admin CASCADE;

-- 2. Depois você precisa:
--    - Exportar CSV de cada tabela da PRODUÇÃO
--    - Importar CSV em cada tabela do DESENVOLVIMENTO
--    (via Table Editor → Insert → Import CSV)
```

---

## ⏱️ TEMPO ESTIMADO:

| Tabela | Registros | Tempo |
|--------|-----------|-------|
| Poucos (<100) | Manual SQL | 2 min |
| Médios (100-1000) | CSV Export/Import | 5 min |
| Muitos (>1000) | CSV Export/Import | 10 min |

**Total estimado:** 15-30 minutos (dependendo do volume)

---

## 💡 DICAS:

1. **Export CSV é mais rápido** que copiar SQL manualmente
2. **Table Editor** tem interface visual (mais fácil)
3. **Sempre faça TRUNCATE antes** de importar (evita duplicados)
4. **Teste com 1 tabela primeiro** antes de copiar todas

---

## ✅ CHECKLIST:

**Preparação:**
- [ ] Identificar quais tabelas copiar
- [ ] Verificar se DEV está vazio (ou pode ser limpo)

**Exportação (PRODUÇÃO):**
- [ ] Abrir SQL Editor PRODUÇÃO
- [ ] SELECT * FROM tabela1; → Export CSV
- [ ] SELECT * FROM tabela2; → Export CSV
- [ ] (repetir para todas)

**Importação (DESENVOLVIMENTO):**
- [ ] Abrir Table Editor DESENVOLVIMENTO
- [ ] Tabela1 → Insert → Import CSV
- [ ] Tabela2 → Insert → Import CSV
- [ ] (repetir para todas)

**Validação:**
- [ ] Verificar quantidade de registros (SELECT COUNT(*))
- [ ] Testar login no sistema DEV
- [ ] Verificar se dados aparecem corretamente

---

## 🎯 COMANDO RÁPIDO:

```batch
# Executar o assistente:
.\COPIAR-PROD-PARA-DEV.bat

# Escolher opção 1 (Método Rápido)
# Seguir instruções na tela
```

---

## 🔍 VERIFICAR SE COPIOU CORRETAMENTE:

No SQL Editor do **DESENVOLVIMENTO**, execute:

```sql
-- Ver quantidade de registros em cada tabela
SELECT 'contracheques' as tabela, COUNT(*) as total FROM contracheques
UNION ALL
SELECT 'colaboradores', COUNT(*) FROM colaboradores
UNION ALL
SELECT 'usuarios', COUNT(*) FROM usuarios
UNION ALL
SELECT 'admin', COUNT(*) FROM admin;
```

Compare com os mesmos números da **PRODUÇÃO**.

---

## ⚠️ IMPORTANTE:

- ✅ **DESENVOLVIMENTO** é para testes - pode limpar à vontade
- ⚠️ **PRODUÇÃO** tem dados reais - NUNCA modifique diretamente
- 🔒 Sempre teste mudanças no DEV primeiro

---

**Próximo passo:** Execute `.\COPIAR-PROD-PARA-DEV.bat` e escolha opção 1!
