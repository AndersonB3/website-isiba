# 🔍 GUIA: COMPARAR BANCOS DE DADOS (PRODUÇÃO vs DESENVOLVIMENTO)

## 📅 Data: 06/02/2026

---

## 🎯 OBJETIVO

Verificar se os bancos de dados de **PRODUÇÃO** e **DESENVOLVIMENTO** estão com a **mesma estrutura** (tabelas, colunas, políticas RLS, etc).

**IMPORTANTE:** Os **dados** (registros) podem e devem ser diferentes!
- PRODUÇÃO = Dados reais
- DESENVOLVIMENTO = Dados de teste

Mas a **estrutura** deve ser idêntica.

---

## 📊 O QUE SERÁ COMPARADO

### ✅ DEVE SER IGUAL:
1. **Tabelas:** Mesmo número e mesmos nomes
2. **Colunas:** Mesmas colunas em cada tabela
3. **Tipos de dados:** Mesmos tipos (text, integer, timestamp, etc)
4. **Chaves primárias:** Mesmas PKs
5. **Chaves estrangeiras:** Mesmas FKs
6. **Políticas RLS:** Mesmas políticas
7. **RLS habilitado:** Nas mesmas tabelas
8. **Buckets de storage:** Mesmos buckets
9. **Políticas de storage:** Mesmas políticas

### ⚠️ PODE SER DIFERENTE:
1. **Total de registros:** Desenvolvimento tem dados de teste
2. **Dados específicos:** Nomes, CPFs, datas, etc
3. **Arquivos no storage:** PDFs diferentes

---

## 🛠️ PASSO A PASSO

### 📝 PASSO 1: Acessar o Supabase Dashboard

1. Abra: https://supabase.com/dashboard
2. Faça login

---

### 🟢 PASSO 2: Exportar Estrutura do Banco de PRODUÇÃO

#### 2.1 Selecionar Projeto
- Clique no projeto: **ISIBA** (ou nome do projeto de produção)
- URL deve conter: `kklhcmrnraroletwbbid`

#### 2.2 Abrir SQL Editor
- Menu lateral: **SQL Editor**
- Clique em: **+ New query**

#### 2.3 Executar Script de Comparação
1. Abra o arquivo: `database/COMPARAR-BANCOS.sql`
2. Copie TODO o conteúdo
3. Cole no SQL Editor do Supabase
4. Clique em **Run** (ou F5)

#### 2.4 Salvar Resultados
Para cada seção do resultado:
1. Clique nos 3 pontinhos (⋮) no canto superior direito da tabela de resultados
2. Selecione: **Download as CSV** ou **Copy as CSV**
3. Salve em: `resultados-producao.txt`

**OU** copie manualmente:
1. Selecione todos os resultados
2. Ctrl+C para copiar
3. Cole no arquivo `resultados-producao.txt`

---

### 🟡 PASSO 3: Exportar Estrutura do Banco de DESENVOLVIMENTO

#### 3.1 Voltar ao Dashboard
- Clique no ícone do Supabase (canto superior esquerdo)
- Voltar à lista de projetos

#### 3.2 Selecionar Projeto de Desenvolvimento
- Clique no projeto: **isiba-desenvolvimento** (ou nome que você deu)
- URL deve conter: `ikwnemhqqkpjurdpauim`

#### 3.3 Repetir o Processo
1. **SQL Editor** → **+ New query**
2. Cole o mesmo script: `database/COMPARAR-BANCOS.sql`
3. **Run** (F5)
4. Salve os resultados em: `resultados-desenvolvimento.txt`

---

### 🔍 PASSO 4: Comparar os Resultados

#### Opção 1: Comparação Manual

Abra os dois arquivos lado a lado:
- `resultados-producao.txt`
- `resultados-desenvolvimento.txt`

Compare seção por seção:

##### ✅ PARTE 1: Tabelas
```
Devem ter as mesmas tabelas:
- administradores
- colaboradores
- contracheques
- dados_mensais
- faixa_etaria
- recibos_documentos
- resumo_anual
- statistics
- tempo_atendimento
- unidades
```

##### ✅ PARTE 2: Colunas
Para cada tabela, verificar se têm as mesmas colunas e tipos.

Exemplo para `colaboradores`:
```
✅ Produção:
- id (uuid)
- cpf (text)
- nome (text)
- email (text)
- ...

✅ Desenvolvimento:
- id (uuid)  ← Deve ser igual
- cpf (text) ← Deve ser igual
- nome (text) ← Deve ser igual
- email (text) ← Deve ser igual
- ...
```

##### ✅ PARTE 3-6: Chaves e Políticas
Verificar se são idênticas.

##### ⚠️ PARTE 7: Total de Registros
**PODE SER DIFERENTE!** Isso é normal.

Exemplo:
```
Produção:
- colaboradores: 150 registros
- contracheques: 1200 registros

Desenvolvimento:
- colaboradores: 7 registros  ← OK ser diferente!
- contracheques: 50 registros ← OK ser diferente!
```

---

#### Opção 2: Usar Ferramenta de Comparação

##### Windows:
1. **WinMerge** (gratuito)
   - Download: https://winmerge.org/
   - Abrir os dois arquivos
   - Diferenças aparecerão destacadas

2. **Visual Studio Code**
   - Abrir ambos arquivos
   - Clique direito em um → **Select for Compare**
   - Clique direito no outro → **Compare with Selected**

##### Online:
- **Diffchecker:** https://www.diffchecker.com/
  - Cole o conteúdo dos dois arquivos
  - Clique em **Find Difference**

---

## 📋 CHECKLIST DE VERIFICAÇÃO

Use este checklist para garantir que tudo está igual:

### Estrutura de Tabelas
- [ ] Mesmo número de tabelas (10 tabelas públicas)
- [ ] Tabela: `administradores` existe em ambos
- [ ] Tabela: `colaboradores` existe em ambos
- [ ] Tabela: `contracheques` existe em ambos
- [ ] Tabela: `dados_mensais` existe em ambos
- [ ] Tabela: `faixa_etaria` existe em ambos
- [ ] Tabela: `recibos_documentos` existe em ambos
- [ ] Tabela: `resumo_anual` existe em ambos
- [ ] Tabela: `statistics` existe em ambos
- [ ] Tabela: `tempo_atendimento` existe em ambos
- [ ] Tabela: `unidades` existe em ambos

### Colunas (verificar para cada tabela)
- [ ] `administradores`: mesmas colunas (id, username, password_hash, nome, ativo)
- [ ] `colaboradores`: mesmas colunas (id, cpf, nome, email, etc)
- [ ] `contracheques`: mesmas colunas (id, colaborador_id, mes_referencia, etc)
- [ ] `recibos_documentos`: mesmas colunas (id, colaborador_id, tipo, etc)
- [ ] Outras tabelas: mesmas colunas

### Chaves e Restrições
- [ ] Mesmas chaves primárias
- [ ] Mesmas chaves estrangeiras
- [ ] Mesmas restrições (constraints)

### Row Level Security (RLS)
- [ ] RLS habilitado nas mesmas tabelas
- [ ] Mesmas políticas RLS em cada tabela
- [ ] Políticas com mesmas condições (USING e WITH CHECK)

### Storage
- [ ] Bucket `contracheques` existe em ambos
- [ ] Mesmas políticas de storage
- [ ] Storage público/privado configurado igual

---

## ⚠️ PROBLEMAS COMUNS E SOLUÇÕES

### ❌ Problema 1: "Tabela X não existe no DEV"

**Solução:**
1. Execute: `database/MIGRAÇÃO-DESENVOLVIMENTO.sql` no banco DEV
2. Isso criará todas as tabelas

---

### ❌ Problema 2: "Coluna X está faltando no DEV"

**Solução:**
1. No banco de PRODUÇÃO, execute:
```sql
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'NOME_DA_TABELA'
ORDER BY ordinal_position;
```
2. Copie o resultado
3. No banco DEV, crie a coluna faltante:
```sql
ALTER TABLE nome_tabela 
ADD COLUMN nome_coluna tipo_dados;
```

---

### ❌ Problema 3: "Política RLS diferente ou faltando"

**Solução:**
1. Execute: `database/APLICAR-POLITICAS-DEV.sql` no banco DEV
2. Isso sincronizará as políticas

---

### ❌ Problema 4: "Bucket de storage não existe"

**Solução:**
1. No Supabase Dashboard do DEV
2. Vá em: **Storage**
3. Clique em: **New bucket**
4. Nome: `contracheques`
5. Configurar como: **Private** ou **Public** (igual à produção)

---

## 🎯 RESULTADO ESPERADO

Após a comparação, você deve encontrar:

### ✅ ESTRUTURA IDÊNTICA:
```
┌─────────────────────────────────────────────────────────────┐
│  ✅ BANCOS COM ESTRUTURA IDÊNTICA                           │
├─────────────────────────────────────────────────────────────┤
│  Tabelas:             10 / 10  ✅                           │
│  Colunas:             Idênticas ✅                          │
│  Chaves PK/FK:        Idênticas ✅                          │
│  Políticas RLS:       Idênticas ✅                          │
│  Storage (buckets):   Idênticos ✅                          │
│  Storage (policies):  Idênticas ✅                          │
└─────────────────────────────────────────────────────────────┘
```

### ⚠️ DADOS DIFERENTES (OK!):
```
┌─────────────────────────────────────────────────────────────┐
│  ⚠️  DADOS DIFERENTES (ISSO É ESPERADO E OK!)               │
├─────────────────────────────────────────────────────────────┤
│  PRODUÇÃO:                                                  │
│  - colaboradores: 150 registros (dados reais)               │
│  - contracheques: 1200 PDFs                                 │
│                                                              │
│  DESENVOLVIMENTO:                                           │
│  - colaboradores: 7 registros (dados de teste)              │
│  - contracheques: 50 PDFs (testes)                          │
└─────────────────────────────────────────────────────────────┘
```

---

## 📝 DOCUMENTAÇÃO RELACIONADA

- 📄 `database/COMPARAR-BANCOS.sql` - Script de comparação
- 📄 `database/MIGRAÇÃO-DESENVOLVIMENTO.sql` - Criar estrutura no DEV
- 📄 `database/APLICAR-POLITICAS-DEV.sql` - Sincronizar políticas RLS
- 📄 `ARQUITETURA-BRANCHES-BANCOS.md` - Arquitetura completa

---

## 🎉 CONCLUSÃO

Depois de seguir este guia, você terá **certeza absoluta** de que:

✅ A estrutura dos bancos está idêntica
✅ Pode desenvolver no DEV sem medo
✅ Quando fizer deploy, a estrutura será compatível
✅ Não haverá surpresas em produção

**Lembre-se:** A diferença nos **dados** é proposital e correta! 🚀
