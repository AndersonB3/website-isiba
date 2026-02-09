# 🔐 TESTE DE PRIMEIRO ACESSO - GUIA COMPLETO

## 📋 O QUE FOI IMPLEMENTADO

### ✅ Arquivos Criados/Atualizados:

1. **primeiro-acesso.html** (NOVO)
   - Página de troca de senha obrigatória
   - Design moderno e responsivo
   - Indicador de força da senha em tempo real
   - Validação de requisitos (maiúscula, minúscula, número, 8+ caracteres)
   - Integrado com Supabase

2. **assets/js/primeiro-acesso.js** (ATUALIZADO)
   - Lógica de verificação da senha temporária
   - Atualização da senha no banco de dados
   - Validação de requisitos de segurança
   - Redirecionamento automático após troca

3. **assets/js/colaborador.js** (JÁ EXISTIA)
   - Verificação do flag `primeiro_acesso` no login
   - Redirecionamento automático para `primeiro-acesso.html`

---

## 🚀 COMO TESTAR (Passo a Passo)

### 1️⃣ CRIAR NOVO USUÁRIO NO PAINEL RH

1. Acesse: `https://andersonb3.github.io/website-isiba/painel-rh/admin-rh.html`
2. Faça login com credenciais de admin
3. Na aba **"Gerenciar Colaboradores"**:
   - Clique em **"➕ Adicionar Novo Colaborador"**
   - Preencha os dados:
     - **Nome**: João Teste
     - **CPF**: 111.222.333-44
     - **Código do Funcionário**: 12345
     - **Senha Temporária**: Teste123
   - ✅ **IMPORTANTE**: Marque a opção **"Primeiro Acesso"**
   - Clique em **"Salvar"**

### 2️⃣ FAZER LOGIN COM O NOVO USUÁRIO

1. Abra uma **aba anônima** ou limpe os cookies
2. Acesse: `https://andersonb3.github.io/website-isiba/colaborador.html`
3. Digite:
   - **CPF**: 111.222.333-44
   - **Senha**: Teste123
4. Clique em **"Entrar"**

### 3️⃣ O QUE DEVE ACONTECER

✅ **Comportamento Esperado:**

1. Após login bem-sucedido, você verá a mensagem:
   ```
   ✅ Login realizado! Você precisa trocar sua senha...
   ```

2. Será **automaticamente redirecionado** para:
   ```
   https://andersonb3.github.io/website-isiba/primeiro-acesso.html
   ```

3. Na página de troca de senha:
   - Digite a **senha temporária** (Teste123)
   - Crie uma **nova senha** (ex: NovoTeste123)
   - **Requisitos obrigatórios**:
     - ✅ Mínimo 8 caracteres
     - ✅ 1 letra maiúscula
     - ✅ 1 letra minúscula
     - ✅ 1 número
   - Confirme a nova senha
   - Clique em **"Alterar Senha e Continuar"**

4. Após confirmar:
   ```
   ✅ Senha atualizada com sucesso! Redirecionando...
   ```

5. Será redirecionado para:
   ```
   https://andersonb3.github.io/website-isiba/portal-colaborador.html
   ```

---

## 🔍 VERIFICAÇÕES NO BANCO DE DADOS

### Antes da Troca de Senha:
```sql
SELECT id, nome, cpf, primeiro_acesso, senha_hash 
FROM colaboradores 
WHERE cpf = '11122233344';
```

**Resultado esperado:**
- `primeiro_acesso`: `true`
- `senha_hash`: Hash da senha "Teste123"

### Depois da Troca de Senha:
```sql
SELECT id, nome, cpf, primeiro_acesso, senha_hash 
FROM colaboradores 
WHERE cpf = '11122233344';
```

**Resultado esperado:**
- `primeiro_acesso`: `false` ✅ (atualizado!)
- `senha_hash`: Hash da nova senha "NovoTeste123"

---

## 🛠️ CONSOLE DE DEBUG

Abra o **Console do Navegador** (F12) para ver os logs:

### Login no colaborador.html:
```
🔍 [COLABORADOR.JS] Dados completos retornados: {...}
🔍 [COLABORADOR.JS] primeiro_acesso: true
✅ [COLABORADOR.JS] Detectado primeiro acesso! Redirecionando...
```

### Na página primeiro-acesso.html:
```
👤 Colaborador: {id: "...", nome: "João Teste", ...}
🔍 [DEBUG] Buscando senha atual do banco para colaborador: ...
🔍 [DEBUG] Hash no banco: ...
🔍 [DEBUG] Hash da senha digitada: ...
🔍 [DEBUG] Hashes coincidem? true
✅ [DEBUG] Senha temporária correta! Atualizando...
✅ Senha atualizada com sucesso!
```

---

## ❌ POSSÍVEIS ERROS E SOLUÇÕES

### ❌ "Sessão expirada. Faça login novamente."
**Causa:** Dados do colaborador não estão no sessionStorage  
**Solução:** Certifique-se de fazer login pelo `colaborador.html` primeiro

### ❌ "Senha temporária incorreta!"
**Causa:** A senha digitada não confere com o hash no banco  
**Solução:** Verifique a senha temporária cadastrada no banco de dados

### ❌ "A nova senha deve ter no mínimo 8 caracteres!"
**Causa:** Senha não atende aos requisitos de segurança  
**Solução:** Crie uma senha com pelo menos 8 caracteres, 1 maiúscula, 1 minúscula e 1 número

### ❌ Página não redireciona automaticamente
**Causa:** Arquivo `primeiro-acesso.html` não existe ou não está acessível  
**Solução:** Verifique se o arquivo foi enviado para o GitHub Pages

---

## 📊 FLUXO COMPLETO DO SISTEMA

```
┌─────────────────────────────────────┐
│  1. Admin Cria Colaborador          │
│     (primeiro_acesso = true)        │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│  2. Colaborador Faz Login           │
│     (colaborador.html)              │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│  3. Sistema Verifica Flag           │
│     if (primeiro_acesso === true)   │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│  4. Redireciona para                │
│     primeiro-acesso.html            │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│  5. Colaborador Troca Senha         │
│     - Valida senha temporária       │
│     - Cria nova senha forte         │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│  6. Sistema Atualiza Banco          │
│     - senha_hash = nova_senha       │
│     - primeiro_acesso = false       │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│  7. Redireciona para Portal         │
│     (portal-colaborador.html)       │
└─────────────────────────────────────┘
```

---

## 🔐 SEGURANÇA IMPLEMENTADA

✅ **Hash SHA-256** para todas as senhas  
✅ **Validação de requisitos** (8+ chars, maiúscula, minúscula, número)  
✅ **Senha temporária verificada** diretamente no banco  
✅ **Sessão temporária** via sessionStorage  
✅ **Flag automática** de primeiro acesso  
✅ **Redirecionamento automático** obrigatório  
✅ **Impossível pular** a troca de senha  

---

## 📝 PRÓXIMOS PASSOS

1. ✅ **Testar no GitHub Pages**
2. ✅ **Verificar logs do console**
3. ✅ **Confirmar atualização no banco**
4. ✅ **Testar segundo login** (não deve pedir troca novamente)
5. 🚀 **Fazer commit e push** para produção

---

## 🎯 COMANDOS GIT PARA SUBIR AS ALTERAÇÕES

```bash
# 1. Adicionar arquivos
cd "c:\Users\Usuario\Desktop\WEBSITE ISIBA"
git add primeiro-acesso.html
git add assets/js/primeiro-acesso.js

# 2. Commit
git commit -m "feat: Implementar página de primeiro acesso obrigatório

- Adicionar primeiro-acesso.html com design moderno
- Atualizar primeiro-acesso.js com validações completas
- Integração com Supabase
- Indicador de força da senha
- Validação de requisitos de segurança
- Redirecionamento automático
- Atualização de flag primeiro_acesso no banco"

# 3. Push para GitHub
git push origin master
```

---

## ✅ CHECKLIST DE VERIFICAÇÃO

- [ ] Arquivo `primeiro-acesso.html` criado
- [ ] Arquivo `primeiro-acesso.js` atualizado
- [ ] Supabase configurado corretamente
- [ ] Função `hashString` disponível
- [ ] Redirecionamento no `colaborador.js` funcionando
- [ ] Teste criando novo usuário no painel RH
- [ ] Teste fazendo login com primeiro acesso
- [ ] Verificar redirecionamento automático
- [ ] Confirmar troca de senha
- [ ] Verificar atualização do flag no banco
- [ ] Teste segundo login (não deve pedir troca)
- [ ] Commit e push para GitHub

---

## 📞 SUPORTE

Se encontrar problemas:
1. Verifique o **Console do Navegador** (F12)
2. Verifique os **logs** no sessionStorage
3. Confirme a **configuração do Supabase**
4. Verifique se o arquivo está no **GitHub Pages**

---

**Data da Implementação:** 05/02/2026  
**Status:** ✅ Pronto para Teste  
**Próximo Passo:** Fazer commit e push para GitHub Pages
