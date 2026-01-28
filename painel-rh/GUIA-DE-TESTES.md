# 🧪 Guia Completo de Testes do Painel RH

## ✅ PRÉ-REQUISITOS

Antes de começar os testes, certifique-se de que:

1. **Servidor está rodando**
   ```powershell
   cd painel-rh
   npm start
   ```
   Ou clique no arquivo `INICIAR-PAINEL.bat`
   
2. **Banco de dados configurado no Supabase**
   - Acesse: https://supabase.com/dashboard/project/kklhcmrnraroletwbbid
   - Vá em **SQL Editor**
   - Execute os scripts na ordem:

### 📝 Scripts SQL a Executar:

#### **Script 1: Tabelas Principais** (SCRIPTS-SQL-SUPABASE.md)
```sql
-- Copie e execute todo o conteúdo do arquivo SCRIPTS-SQL-SUPABASE.md
```

#### **Script 2: Tabela de Administradores** (SQL-ADMIN-TABLE.sql)
```sql
-- Copie e execute todo o conteúdo do arquivo SQL-ADMIN-TABLE.sql
```

3. **Verificar se as tabelas foram criadas**
   - No Supabase, vá em **Table Editor**
   - Você deve ver 3 tabelas:
     - ✅ `administradores`
     - ✅ `colaboradores`
     - ✅ `contracheques`

4. **Verificar Storage Bucket**
   - Vá em **Storage**
   - Deve existir um bucket chamado `contracheques` (privado)

---

## 🧪 ROTEIRO DE TESTES

### **TESTE 1: Login no Painel** ✅

1. Acesse: http://localhost:3001
2. Digite as credenciais:
   - **Usuário:** `admin`
   - **Senha:** `admin`
3. Clique em "Entrar no Painel"

**✅ Resultado esperado:**
- Login bem-sucedido
- Dashboard aparece com 4 cards de estatísticas
- Menu lateral ativo
- Console mostra: "✅ Administrador autenticado: Administrador RH"

---

### **TESTE 2: Cadastrar Funcionário** 📝

1. No menu lateral, clique em **"Cadastrar Funcionário"**
2. Preencha o formulário:
   - **Nome Completo:** João Silva Santos
   - **CPF:** 123.456.789-00
   - **E-mail:** joao.silva@exemplo.com (opcional)
   - **Senha:** 123456
   - **Status:** Ativo

3. Clique em **"Cadastrar Funcionário"**

**✅ Resultado esperado:**
- Mensagem verde: "✅ Funcionário cadastrado com sucesso!"
- Console mostra: "✅ Colaborador cadastrado"
- Formulário é limpo automaticamente

**🧪 Teste adicional:**
- Tente cadastrar o mesmo CPF novamente
- Deve mostrar erro: "❌ CPF já cadastrado no sistema"

---

### **TESTE 3: Listar Funcionários** 👥

1. No menu lateral, clique em **"Listar Funcionários"**
2. Verifique a tabela de funcionários

**✅ Resultado esperado:**
- Tabela mostra o funcionário cadastrado:
  - Nome: João Silva Santos
  - CPF: 123.456.789-00
  - E-mail: joao.silva@exemplo.com
  - Status: Badge verde "Ativo"
  - Ações: Botões de Editar/Deletar

**🧪 Teste de busca:**
- Digite "João" na caixa de busca
- Tabela deve filtrar e mostrar apenas resultados correspondentes
- Digite "123" - deve filtrar por CPF

---

### **TESTE 4: Enviar Contracheque** 📤

1. No menu lateral, clique em **"Enviar Contracheque"**

2. Preencha o formulário:
   - **Selecionar Funcionário:** João Silva Santos
   - **Mês de Referência:** Janeiro
   - **Ano:** 2026

3. **Upload do PDF:**
   - Clique na área de upload OU
   - Arraste um arquivo PDF para a área
   - **Importante:** Use um PDF real (máx. 10MB)
   - Você pode criar um PDF de teste no Word ou usar qualquer PDF

4. Clique em **"Enviar Contracheque"**

**✅ Resultado esperado:**
- Barra de progresso aparece
- Mensagem verde: "✅ Contracheque enviado com sucesso!"
- Console mostra: "✅ Contracheque enviado"
- Formulário é limpo

**🔍 Verificar no Supabase:**
1. Vá em **Storage** → bucket `contracheques`
2. Deve ter uma pasta com o CPF: `12345678900`
3. Dentro, o arquivo: `2026-01.pdf`

---

### **TESTE 5: Histórico de Envios** 📋

1. No menu lateral, clique em **"Histórico de Envios"**

**✅ Resultado esperado:**
- Tabela mostra o contracheque enviado:
  - **Funcionário:** João Silva Santos
  - **Mês/Ano:** Janeiro/2026
  - **Data de Envio:** Data e hora atual
  - **Tamanho:** Tamanho do arquivo (ex: 125.5 KB)
  - **Status:** Badge verde "Enviado"

**🧪 Teste de filtro:**
- Selecione "Janeiro" no filtro de mês
- Tabela deve mostrar apenas envios de Janeiro
- Selecione "Todos os meses" - volta a mostrar tudo

---

### **TESTE 6: Visão Geral (Estatísticas)** 📊

1. No menu lateral, clique em **"Visão Geral"**

**✅ Resultado esperado:**
- **Card 1 - Funcionários Ativos:** 1
- **Card 2 - Contracheques Enviados:** 1
- **Card 3 - Envios Este Mês:** 1 (se for Janeiro)
- **Card 4 - Último Envio:** Data/hora do último envio

---

### **TESTE 7: Cadastrar Mais Funcionários** 👥

Cadastre mais 2-3 funcionários para testar melhor:

**Funcionário 2:**
- Nome: Maria Oliveira Costa
- CPF: 987.654.321-00
- E-mail: maria.oliveira@exemplo.com
- Senha: 123456

**Funcionário 3:**
- Nome: Carlos Roberto Lima
- CPF: 111.222.333-44
- Senha: 123456
- E-mail: (deixe vazio para testar campo opcional)

---

### **TESTE 8: Enviar Múltiplos Contracheques** 📤

1. Envie contracheques para os outros funcionários
2. Teste diferentes meses (Janeiro, Fevereiro, etc.)
3. Teste diferentes anos (2025, 2026)

**🔍 Verificar:**
- Histórico atualiza corretamente
- Estatísticas atualizam
- Storage organiza por CPF

---

### **TESTE 9: Logout e Login Novamente** 🚪

1. Clique no botão **"Sair"** no rodapé do menu lateral
2. Deve voltar para a tela de login
3. Faça login novamente
4. Dashboard deve carregar com os dados atualizados

---

### **TESTE 10: Verificar Console do Navegador** 🔍

Durante todos os testes, mantenha o Console aberto (F12):

**✅ Mensagens esperadas:**
- ✅ Supabase configurado com sucesso!
- ✅ Funções do Supabase Admin carregadas!
- ✅ Admin RH (com Supabase) carregado!
- ✅ Administrador autenticado: Administrador RH
- ✅ Colaborador cadastrado
- ✅ X colaboradores encontrados
- ✅ Contracheque enviado
- ✅ Estatísticas atualizadas

**❌ NÃO deve aparecer:**
- Erros em vermelho
- Warnings sobre variáveis não definidas
- Erros de CORS
- Erros 404

---

## 🐛 PROBLEMAS COMUNS E SOLUÇÕES

### **Problema 1: "Erro ao autenticar"**
**Causa:** Tabela `administradores` não existe ou usuário não foi criado
**Solução:** Execute o script `SQL-ADMIN-TABLE.sql` no Supabase

### **Problema 2: "Erro ao cadastrar colaborador"**
**Causa:** Tabela `colaboradores` não existe
**Solução:** Execute o script `SCRIPTS-SQL-SUPABASE.md` completo

### **Problema 3: "Erro ao enviar contracheque"**
**Causa:** Bucket `contracheques` não existe ou não tem permissões
**Solução:** 
1. Vá em Storage no Supabase
2. Crie o bucket `contracheques` (privado)
3. Configure as políticas de acesso (veja SCRIPTS-SQL-SUPABASE.md)

### **Problema 4: Upload trava em "Enviando..."**
**Causa:** Arquivo muito grande ou problema de rede
**Solução:** 
- Use PDF menor que 10MB
- Verifique conexão com internet
- Verifique console para erros

### **Problema 5: Estatísticas não atualizam**
**Causa:** Função `obterEstatisticas()` com erro
**Solução:** Verifique console e recarregue a página (F5)

---

## 📊 VERIFICAÇÃO FINAL NO SUPABASE

Após todos os testes, verifique no Supabase:

### **1. Table Editor → administradores**
- ✅ 1 registro: admin
- ✅ Campo `ultimo_acesso` atualizado

### **2. Table Editor → colaboradores**
- ✅ 3 registros (João, Maria, Carlos)
- ✅ Campos `cpf_hash` e `senha_hash` preenchidos
- ✅ Campo `ativo` = true

### **3. Table Editor → contracheques**
- ✅ 3+ registros de contracheques
- ✅ Campos `colaborador_id` ligados aos funcionários
- ✅ Campo `arquivo_url` com caminho correto

### **4. Storage → contracheques**
- ✅ 3 pastas (CPFs dos funcionários)
- ✅ Dentro de cada, arquivos PDF nomeados: `YYYY-MM.pdf`

---

## 🎯 PRÓXIMOS PASSOS

Após os testes do painel RH, vamos implementar:

1. **Portal do Colaborador** (`colaborador.html`)
   - Integração com Supabase
   - Login com CPF e senha
   - Dashboard do funcionário
   - Visualização e download de contracheques

2. **Funcionalidades Extras**
   - Editar funcionário
   - Desativar funcionário
   - Deletar contracheque
   - Filtros avançados
   - Exportar relatórios

---

## 💡 DICAS

- **Use CPFs fictícios** para testes (não use CPFs reais)
- **Mantenha o Console aberto** durante os testes (F12)
- **Teste em modo anônimo** do navegador para limpar cache
- **Faça backup** do banco antes de testes destrutivos
- **Documente** qualquer comportamento inesperado

---

## ✅ CHECKLIST DE CONCLUSÃO

- [ ] Login funcionando
- [ ] Cadastro de funcionário funcionando
- [ ] Listagem de funcionários funcionando
- [ ] Busca de funcionários funcionando
- [ ] Upload de contracheque funcionando
- [ ] Histórico funcionando
- [ ] Filtros funcionando
- [ ] Estatísticas atualizando
- [ ] Logout funcionando
- [ ] Dados persistindo no Supabase
- [ ] Storage organizando arquivos corretamente
- [ ] Console sem erros

---

**🎉 Se todos os testes passarem, o Painel RH está 100% funcional!**

