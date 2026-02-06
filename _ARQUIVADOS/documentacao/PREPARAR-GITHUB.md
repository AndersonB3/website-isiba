# 🚀 PREPARAR PARA GITHUB - GUIA RÁPIDO

## ⚡ Comandos Rápidos (PowerShell)

Execute estes comandos na pasta do projeto:

```powershell
# 1. Remover arquivos de configuração do Git (se já foram commitados)
git rm --cached painel-rh\assets\js\supabase-config.js
git rm --cached assets\js\supabase-config.js

# 2. Verificar se .gitignore está funcionando
git status

# 3. Commit das mudanças
git add .
git commit -m "chore: protect sensitive data and prepare for GitHub"

# 4. Push para o repositório
git push origin develop
```

---

## 📋 CHECKLIST PRÉ-GITHUB

### ✅ **1. Limpar Banco de Dados**

Execute no Supabase SQL Editor:

```sql
-- Limpar dados de produção
DELETE FROM contracheques;
DELETE FROM colaboradores;

-- Atualizar admin para credenciais de exemplo
UPDATE administradores 
SET senha_hash = '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9'
WHERE usuario = 'admin';
-- Senha será: admin123

-- Criar colaborador de exemplo
INSERT INTO colaboradores (
    nome_completo, cpf, cpf_hash, senha_hash, email, ativo
) VALUES (
    'João Silva (Exemplo)',
    '12345678900',
    '0a0b3d3b75cf7b5b87e9e4b02adcce43df0a0a8e14c1c7b05fe3e7f3a8b5c8c7',
    'ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae',
    'exemplo@empresa.com',
    true
);
-- CPF: 123.456.789-00 / Senha: teste123
```

### ✅ **2. Limpar Storage (PDFs)**

No Supabase Storage:
1. Acesse o bucket `contracheques`
2. Delete todos os PDFs de teste/produção

### ✅ **3. Verificar Arquivos de Configuração**

```powershell
# Verificar se arquivos .example existem
Get-ChildItem -Recurse -Filter "*.example.js"

# Verificar se supabase-config.js está no .gitignore
Get-Content .gitignore | Select-String "supabase-config"
```

### ✅ **4. Limpar Arquivos Temporários**

```powershell
# Remover logs
Remove-Item -Recurse -Force *.log

# Remover PDFs de teste
Remove-Item -Recurse -Force *teste*.pdf
```

### ✅ **5. Atualizar README.md**

Adicione instruções de setup:

```markdown
## 🔧 Configuração Inicial

### 1. Clonar o repositório
```bash
git clone https://github.com/SEU-USUARIO/website-isiba.git
cd website-isiba
```

### 2. Configurar Supabase
1. Crie uma conta no [Supabase](https://supabase.com)
2. Crie um novo projeto
3. Execute os scripts em `SCRIPTS-SQL-SUPABASE.md`
4. Copie os arquivos de configuração:
```bash
cp assets/js/supabase-config.example.js assets/js/supabase-config.js
cp painel-rh/assets/js/supabase-config.example.js painel-rh/assets/js/supabase-config.js
```
5. Edite os arquivos e adicione suas credenciais do Supabase

### 3. Instalar dependências do Painel RH
```bash
cd painel-rh
npm install
npm start
```

### 4. Acessar o sistema
- **Site Principal**: http://localhost/
- **Painel RH**: http://localhost:3001/admin-rh.html
- **Portal Colaborador**: http://localhost/colaborador.html

### 5. Credenciais de Exemplo
**Painel RH:**
- Usuário: `admin`
- Senha: `admin123`

**Portal Colaborador:**
- CPF: `123.456.789-00`
- Senha: `teste123`

⚠️ **Altere essas credenciais em produção!**
```

---

## 🔐 Criar .env.example (Opcional)

Se usar variáveis de ambiente:

```bash
# .env.example
SUPABASE_URL=https://seu-projeto.supabase.co
SUPABASE_ANON_KEY=sua-chave-anonima-aqui
NODE_ENV=development
PORT=3001
```

---

## 📦 Estrutura Final para GitHub

```
WEBSITE ISIBA/
├── assets/
│   └── js/
│       ├── supabase-config.example.js  ✅ (commit)
│       └── supabase-config.js          ❌ (ignorado)
├── painel-rh/
│   ├── assets/
│   │   └── js/
│   │       ├── supabase-config.example.js  ✅ (commit)
│   │       └── supabase-config.js          ❌ (ignorado)
│   ├── node_modules/                       ❌ (ignorado)
│   └── package.json                        ✅ (commit)
├── .gitignore                              ✅ (commit)
├── README.md                               ✅ (commit)
├── SCRIPTS-SQL-SUPABASE.md                 ✅ (commit)
├── LIMPAR-BANCO-DADOS.md                   ✅ (commit)
└── PREPARAR-GITHUB.md                      ✅ (commit - este arquivo)
```

---

## ✅ Verificação Final

Execute antes do push:

```powershell
# 1. Verificar o que será commitado
git status

# 2. Verificar que supabase-config.js NÃO aparece
git ls-files | Select-String "supabase-config.js"
# Resultado esperado: apenas .example.js

# 3. Ver diferenças
git diff --cached

# 4. Testar se .gitignore funciona
echo "teste" > assets\js\supabase-config.js
git status
# supabase-config.js NÃO deve aparecer

# 5. Limpar arquivo de teste
Remove-Item assets\js\supabase-config.js
```

---

## 🚨 IMPORTANTE: Antes do Push

### ❌ **NUNCA COMMITE:**
- `supabase-config.js` (credenciais reais)
- `node_modules/`
- `.env` com dados reais
- PDFs de colaboradores reais
- Logs com informações sensíveis

### ✅ **SEMPRE COMMITE:**
- `*.example.js` (templates sem credenciais)
- `.gitignore` (proteção)
- `README.md` (documentação)
- Scripts SQL de estrutura
- Código-fonte

---

## 📝 Mensagens de Commit Sugeridas

```bash
# Primeira vez
git commit -m "feat: initial commit - ISIBA website with RH panel"

# Removendo dados sensíveis
git commit -m "chore: remove sensitive data and protect credentials"

# Adicionando exemplos
git commit -m "docs: add configuration examples and setup guide"

# Atualizando documentação
git commit -m "docs: update README with installation instructions"
```

---

## 🎯 Comando COMPLETO de Preparação

Execute tudo de uma vez:

```powershell
# Script completo de preparação
Write-Host "🚀 Preparando projeto para GitHub..." -ForegroundColor Cyan

# 1. Verificar Git
if (-not (Test-Path .git)) {
    Write-Host "❌ Não é um repositório Git!" -ForegroundColor Red
    exit
}

# 2. Remover do Git (se já commitado)
git rm --cached painel-rh/assets/js/supabase-config.js 2>$null
git rm --cached assets/js/supabase-config.js 2>$null

# 3. Limpar temporários
Write-Host "🧹 Limpando arquivos temporários..." -ForegroundColor Yellow
Remove-Item -Recurse -Force *.log -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force *teste*.pdf -ErrorAction SilentlyContinue

# 4. Verificar .gitignore
if (-not (Get-Content .gitignore | Select-String "supabase-config.js")) {
    Write-Host "⚠️  Adicione supabase-config.js ao .gitignore!" -ForegroundColor Red
}

# 5. Status
Write-Host "`n📋 Status do Git:" -ForegroundColor Cyan
git status

Write-Host "`n✅ Verificação completa!" -ForegroundColor Green
Write-Host "Execute: git add . && git commit -m 'chore: prepare for GitHub'" -ForegroundColor Cyan
```

---

## 📞 Após o Push

### Para outros desenvolvedores usarem:

1. Clone o repositório
2. Copie os arquivos `.example.js` para `.js`
3. Configure com suas credenciais do Supabase
4. Execute os scripts SQL
5. Instale as dependências: `npm install`
6. Inicie o servidor: `npm start`

---

**✅ Pronto para GitHub!** 🎉

Todos os dados sensíveis protegidos e documentação completa!
