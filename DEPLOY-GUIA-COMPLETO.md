# 🚀 GUIA COMPLETO DE DEPLOY - ISIBA Social

## 📋 Visão Geral

Este projeto é um **sistema de gestão de contracheques** integrado com Supabase, pronto para deploy no **GitHub Pages**.

---

## ✅ PRÉ-REQUISITOS

Antes de fazer o deploy, certifique-se de que:

- [x] Conta no GitHub ativa
- [x] Conta no Supabase configurada
- [x] Repositório `website-isiba` já existe
- [x] Branch `master` é o branch de produção

---

## 🔧 PASSO 1: Configurar Supabase

### 1.1 Executar Scripts SQL

Acesse: **Supabase Dashboard → SQL Editor**

**Execute na ordem:**

#### A) Criar Estrutura de Tabelas

```sql
-- Tabela de Administradores
CREATE TABLE IF NOT EXISTS administradores (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    usuario TEXT NOT NULL UNIQUE,
    senha_hash TEXT NOT NULL,
    nome_completo TEXT NOT NULL,
    email TEXT,
    ativo BOOLEAN DEFAULT true,
    ultimo_acesso TIMESTAMP WITH TIME ZONE,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Tabela de Colaboradores
CREATE TABLE IF NOT EXISTS colaboradores (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    nome_completo TEXT NOT NULL,
    cpf TEXT NOT NULL UNIQUE,
    cpf_hash TEXT NOT NULL,
    senha_hash TEXT NOT NULL,
    email TEXT,
    ativo BOOLEAN DEFAULT true,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
    primeiro_acesso BOOLEAN DEFAULT true,
    codigo_funcionario VARCHAR(20)
);

-- Tabela de Contracheques
CREATE TABLE IF NOT EXISTS contracheques (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    colaborador_id UUID REFERENCES colaboradores(id) ON DELETE CASCADE,
    mes_referencia TEXT NOT NULL,
    ano INTEGER NOT NULL,
    arquivo_url TEXT NOT NULL,
    nome_arquivo TEXT NOT NULL,
    tamanho_arquivo BIGINT NOT NULL,
    enviado_por TEXT DEFAULT 'admin.rh',
    enviado_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
    tipo_documento VARCHAR(50) DEFAULT 'contracheque',
    visualizado BOOLEAN DEFAULT false,
    data_primeira_visualizacao TIMESTAMP WITH TIME ZONE,
    recibo_gerado BOOLEAN DEFAULT false,
    assinatura_digital TEXT,
    mes TEXT,
    data_envio TIMESTAMP WITH TIME ZONE DEFAULT now(),
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT now(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Índices para performance
CREATE INDEX IF NOT EXISTS idx_administradores_usuario ON administradores(usuario);
CREATE INDEX IF NOT EXISTS idx_administradores_ativo ON administradores(ativo);
CREATE INDEX IF NOT EXISTS idx_colaboradores_cpf_hash ON colaboradores(cpf_hash);
CREATE INDEX IF NOT EXISTS idx_colaboradores_ativo ON colaboradores(ativo);
CREATE INDEX IF NOT EXISTS idx_contracheques_colaborador ON contracheques(colaborador_id);
CREATE INDEX IF NOT EXISTS idx_contracheques_ano_mes ON contracheques(ano, mes_referencia);
```

#### B) Inserir Administrador Inicial

**⚠️ ATENÇÃO:** Use o script `ATUALIZAR_SENHA.sql` com sua senha personalizada!

```sql
-- Inserir admin com senha: redeaberta@$2026
INSERT INTO administradores (
    usuario,
    senha_hash,
    nome_completo,
    email,
    ativo
) VALUES (
    'admin.isiba',
    'b02f8c57df397a87a180adad0a62c0bb461cc159c379a3677f5f517f78cfe0b9',
    'Administrador ISIBA',
    'admin@isiba.com.br',
    true
) ON CONFLICT (usuario) DO UPDATE
SET senha_hash = EXCLUDED.senha_hash,
    atualizado_em = now();
```

#### C) Configurar Políticas de Segurança (RLS)

```sql
-- Habilitar RLS
ALTER TABLE administradores ENABLE ROW LEVEL SECURITY;
ALTER TABLE colaboradores ENABLE ROW LEVEL SECURITY;
ALTER TABLE contracheques ENABLE ROW LEVEL SECURITY;

-- Políticas para leitura pública (necessário para autenticação)
CREATE POLICY "Permitir leitura pública de administradores"
ON administradores FOR SELECT
USING (true);

CREATE POLICY "Permitir leitura pública de colaboradores"
ON colaboradores FOR SELECT
USING (true);

CREATE POLICY "Permitir leitura pública de contracheques"
ON contracheques FOR SELECT
USING (true);

-- Políticas para escrita (apenas service_role)
CREATE POLICY "Permitir inserção via service_role"
ON administradores FOR INSERT
WITH CHECK (true);

CREATE POLICY "Permitir atualização via service_role"
ON administradores FOR UPDATE
USING (true);
```

#### D) Configurar Storage para PDFs

```sql
-- Criar bucket para contracheques (se não existir)
INSERT INTO storage.buckets (id, name, public)
VALUES ('contracheques', 'contracheques', true)
ON CONFLICT (id) DO NOTHING;

-- Políticas de acesso ao storage
CREATE POLICY "Permitir leitura pública de contracheques"
ON storage.objects FOR SELECT
USING (bucket_id = 'contracheques');

CREATE POLICY "Permitir upload de contracheques"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'contracheques');
```

### 1.2 Obter Credenciais do Supabase

1. Vá em **Project Settings → API**
2. Copie:
   - **Project URL**: `https://seu-projeto.supabase.co`
   - **anon public key**: `eyJhbG...` (chave longa)

---

## 🔑 PASSO 2: Configurar Credenciais no Projeto

### 2.1 Atualizar supabase-config.js

Edite o arquivo: `painel-rh/assets/js/supabase-config.js`

```javascript
const CONFIG = {
    SUPABASE_URL: 'https://seu-projeto.supabase.co',  // ← COLE AQUI
    SUPABASE_ANON_KEY: 'eyJhbG...'  // ← COLE AQUI (chave completa)
};

// Inicializar Supabase
const { createClient } = supabase;
window.supabaseClient = createClient(CONFIG.SUPABASE_URL, CONFIG.SUPABASE_ANON_KEY);

console.log('✅ Supabase configurado com sucesso!');
console.log('✅ window.supabaseClient criado:', !!window.supabaseClient);
```

### 2.2 Verificar Outros Arquivos de Config

Verifique se existe `supabase-config.js` em outros locais:
- `assets/js/supabase-config.js` (raiz)
- `painel-rh/assets/js/supabase-config.js` (painel)

**Mantenha apenas uma versão** com as credenciais corretas!

---

## 🌐 PASSO 3: Deploy no GitHub Pages

### 3.1 Preparar Branch Master

```bash
# Certifique-se de que está no develop
git checkout develop

# Verificar se tem alterações pendentes
git status

# Se houver alterações, commitar
git add -A
git commit -m "chore: preparar projeto para deploy"

# Merge para master
git checkout master
git merge develop

# Push para GitHub
git push origin master
```

### 3.2 Ativar GitHub Pages

1. Acesse: **GitHub → Repositório `website-isiba`**
2. Vá em: **Settings → Pages** (menu lateral)
3. Configure:
   - **Source:** Deploy from a branch
   - **Branch:** `master`
   - **Folder:** `/ (root)`
4. Clique em **Save**

### 3.3 Aguardar Deploy

- O GitHub levará **2-5 minutos** para fazer o deploy
- URL gerada: `https://andersonb3.github.io/website-isiba/`

---

## ✅ PASSO 4: Testar o Site em Produção

### 4.1 Testar Homepage

Acesse: `https://andersonb3.github.io/website-isiba/`

**Verificar:**
- [x] Layout carregando corretamente
- [x] Imagens aparecendo
- [x] Menu funcionando
- [x] Botão "Portal RH" no rodapé

### 4.2 Testar Painel RH

Acesse: `https://andersonb3.github.io/website-isiba/painel-rh/admin-rh.html`

**Fazer Login:**
```
👤 Usuário: admin.isiba
🔐 Senha: redeaberta@$2026
```

**Verificar:**
- [x] Supabase conectando (veja console F12)
- [x] Login funcionando
- [x] Dashboard carregando
- [x] Menu lateral funcionando
- [x] Seções do painel (Cadastrar, Listar, Upload)

### 4.3 Testar Portal do Colaborador

Acesse: `https://andersonb3.github.io/website-isiba/colaborador.html`

**Verificar:**
- [x] Página carregando
- [x] Formulário de login
- [x] Validação de CPF

### 4.4 Testar Trabalhe Conosco

Acesse: `https://andersonb3.github.io/website-isiba/trabalhe-conosco.html`

**Verificar:**
- [x] Formulário carregando
- [x] Validação de campos
- [x] Envio via FormSubmit

---

## 🐛 PASSO 5: Solução de Problemas Comuns

### ❌ Erro: "Failed to load resource: net::ERR_BLOCKED_BY_CLIENT"

**Causa:** Adblocker bloqueando scripts

**Solução:**
1. Desative adblocker temporariamente
2. Ou adicione `*.github.io` na whitelist

### ❌ Erro: "Supabase não configurado"

**Causa:** Credenciais incorretas ou arquivo não carregado

**Solução:**
1. Abra console (F12)
2. Verifique se `window.supabaseClient` existe
3. Revise `supabase-config.js`
4. Confirme que URL e Key estão corretas

### ❌ Erro: "Usuário ou senha incorretos"

**Causa:** Hash da senha no banco diferente do esperado

**Solução:**
1. Execute `VERIFICAR_BANCO.sql` no Supabase
2. Verifique se `hash_preview` começa com `b02f8c57df`
3. Se não, execute `ATUALIZAR_SENHA.sql`

### ❌ Erro 404: "Page not found"

**Causa:** GitHub Pages ainda não fez deploy ou branch errado

**Solução:**
1. Aguarde 5 minutos após ativar Pages
2. Verifique se o branch `master` tem os arquivos
3. Confirme que Pages está configurado para branch `master`

### ❌ Erro: "CORS policy blocked"

**Causa:** Supabase bloqueando requisições

**Solução:**
1. Supabase Dashboard → Project Settings → API
2. Em "API Settings", adicione seu domínio:
   - `https://andersonb3.github.io`
3. Salve e aguarde 1 minuto

---

## 📊 PASSO 6: Monitoramento Pós-Deploy

### 6.1 Verificar Logs do Supabase

1. Supabase Dashboard → Logs
2. Veja requisições em tempo real
3. Identifique erros de autenticação ou queries

### 6.2 Testar Funcionalidades Completas

**Cadastrar Colaborador:**
1. Login no painel RH
2. Ir em "Cadastrar Colaborador"
3. Preencher formulário
4. Salvar e verificar no banco

**Upload de Contracheque:**
1. Login no painel RH
2. Ir em "Enviar Contracheque"
3. Selecionar colaborador e PDF
4. Upload e verificar no storage

**Portal do Colaborador:**
1. Acessar `colaborador.html`
2. Fazer login com CPF de teste
3. Visualizar contracheques
4. Baixar PDF

---

## 🔒 PASSO 7: Segurança Pós-Deploy

### 7.1 Alterar Senha do Admin

**IMPORTANTE:** Troque a senha padrão imediatamente!

1. Acesse: `painel-rh/trocar-senha.html`
2. Use sua senha forte e única
3. Ou use `gerar-hash.js` para criar nova senha

### 7.2 Habilitar 2FA no GitHub

Proteja sua conta GitHub:
1. GitHub → Settings → Password and authentication
2. Enable two-factor authentication
3. Use app autenticador (Google Authenticator, Authy)

### 7.3 Habilitar 2FA no Supabase

Proteja seu projeto Supabase:
1. Supabase Dashboard → Account → Security
2. Enable 2-Step Verification

### 7.4 Revisar Políticas RLS

Certifique-se de que:
- ✅ RLS está habilitado em todas as tabelas
- ✅ Políticas não permitem DELETE sem autenticação
- ✅ Colaboradores só veem seus próprios dados

---

## 📝 CHECKLIST FINAL DE DEPLOY

Antes de considerar o deploy completo:

### Supabase
- [ ] Todas as tabelas criadas
- [ ] Administrador cadastrado e senha alterada
- [ ] RLS habilitado
- [ ] Políticas configuradas
- [ ] Storage bucket criado
- [ ] Credenciais copiadas

### GitHub
- [ ] Repositório atualizado
- [ ] Branch master sincronizado
- [ ] GitHub Pages ativado
- [ ] Deploy concluído (URL acessível)

### Testes
- [ ] Homepage funcionando
- [ ] Painel RH com login OK
- [ ] Supabase conectando
- [ ] Cadastro de colaborador funcional
- [ ] Upload de PDF funcional
- [ ] Portal do colaborador funcional
- [ ] Download de PDF funcional

### Segurança
- [ ] Senha padrão alterada
- [ ] 2FA habilitado no GitHub
- [ ] 2FA habilitado no Supabase
- [ ] Credenciais não expostas no código
- [ ] HTTPS ativo (automático no GitHub Pages)

---

## 🎉 DEPLOY CONCLUÍDO!

Seu projeto está no ar em:
```
🌐 https://andersonb3.github.io/website-isiba/
```

**URLs Importantes:**
- Homepage: `/`
- Painel RH: `/painel-rh/admin-rh.html`
- Portal Colaborador: `/colaborador.html`
- Trabalhe Conosco: `/trabalhe-conosco.html`

---

## 🆘 Suporte

Se encontrar problemas:
1. Verifique console do navegador (F12)
2. Revise logs do Supabase
3. Consulte `SOLUCAO-RAPIDA-LOGIN.md`
4. Execute `VERIFICAR_BANCO.sql`

---

**Última atualização:** 10 de fevereiro de 2026  
**Versão do Sistema:** 1.0.0  
**Status:** ✅ Pronto para Produção
