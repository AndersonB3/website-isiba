# 🔐 AUTENTICAÇÃO PROFISSIONAL - ADMINISTRADORES
## Sistema RH - ISIBA Social

---

## ✅ O QUE FOI IMPLEMENTADO

Agora o sistema possui **autenticação profissional via banco de dados**:

- ✅ Tabela `administradores` no Supabase
- ✅ Senhas criptografadas com SHA-256
- ✅ Validação no banco de dados
- ✅ Registro de último acesso
- ✅ Controle de usuários ativos/inativos
- ✅ Sistema multi-usuário (suporta vários admins)

---

## 📋 PASSO A PASSO - CONFIGURAÇÃO

### **1️⃣ Executar Script SQL**

Acesse: https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/sql/new

Cole e execute o conteúdo do arquivo: **`SQL-ADMIN-TABLE.sql`**

Ou copie este código:

```sql
-- Criar tabela de administradores
CREATE TABLE IF NOT EXISTS administradores (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    usuario TEXT UNIQUE NOT NULL,
    senha_hash TEXT NOT NULL,
    nome_completo TEXT NOT NULL,
    email TEXT,
    ativo BOOLEAN DEFAULT true,
    ultimo_acesso TIMESTAMP WITH TIME ZONE,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_admin_usuario ON administradores(usuario);
CREATE INDEX idx_admin_ativo ON administradores(ativo);

-- Trigger para atualização
CREATE TRIGGER update_administradores_updated_at 
    BEFORE UPDATE ON administradores 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Habilitar RLS
ALTER TABLE administradores ENABLE ROW LEVEL SECURITY;

-- Política de acesso
CREATE POLICY "Permitir todas operações em administradores" ON administradores
    FOR ALL 
    USING (true)
    WITH CHECK (true);

-- Inserir administrador padrão
INSERT INTO administradores (usuario, senha_hash, nome_completo, email, ativo)
VALUES (
    'admin',
    '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918',
    'Administrador RH',
    'rh.isiba@gmail.com',
    true
)
ON CONFLICT (usuario) DO NOTHING;
```

---

### **2️⃣ Verificar Criação**

No SQL Editor, execute:

```sql
SELECT * FROM administradores;
```

**✅ Deve retornar:**
```
usuario: admin
nome_completo: Administrador RH
ativo: true
```

---

### **3️⃣ Testar Login**

1. Abra `admin-rh.html` no navegador
2. Faça login com:
   - **Usuário**: `admin`
   - **Senha**: `admin`
3. ✅ Deve autenticar via banco de dados!

---

## 🔑 CREDENCIAIS PADRÃO

- **Usuário**: `admin`
- **Senha**: `admin`
- **Nome**: Administrador RH
- **E-mail**: rh.isiba@gmail.com

---

## 🎯 COMO FUNCIONA

### **Fluxo de Autenticação:**

```
1. Usuário digita login e senha
         ↓
2. Sistema gera hash SHA-256 da senha
         ↓
3. Busca no banco: usuario + senha_hash
         ↓
4. Se encontrar: Login aprovado
         ↓
5. Atualiza último_acesso
         ↓
6. Salva sessão e redireciona
```

### **Segurança:**

- ✅ Senhas NUNCA são salvas em texto puro
- ✅ Apenas hash SHA-256 é armazenado
- ✅ Comparação no banco de dados
- ✅ Controle de usuários ativos
- ✅ Sessão via sessionStorage

---

## 👥 ADICIONAR NOVOS ADMINISTRADORES

### **Via SQL Editor:**

```sql
-- Calcule o hash SHA-256 da senha primeiro
-- Use: https://emn178.github.io/online-tools/sha256.html
-- Exemplo: senha "minhaSenha123" = hash "abc123..."

INSERT INTO administradores (usuario, senha_hash, nome_completo, email)
VALUES (
    'maria.silva',
    'COLE_O_HASH_AQUI',
    'Maria Silva',
    'maria@isiba.com'
);
```

### **Via JavaScript (futuro):**

Pode-se criar uma interface no painel para cadastrar novos admins usando a função `cadastrarAdministrador()`.

---

## 📊 CONSULTAS ÚTEIS

### **Listar todos os administradores:**
```sql
SELECT usuario, nome_completo, email, ativo, ultimo_acesso 
FROM administradores 
ORDER BY nome_completo;
```

### **Ver último acesso:**
```sql
SELECT usuario, nome_completo, ultimo_acesso 
FROM administradores 
WHERE ativo = true
ORDER BY ultimo_acesso DESC;
```

### **Desativar administrador:**
```sql
UPDATE administradores 
SET ativo = false 
WHERE usuario = 'nome_usuario';
```

### **Reativar administrador:**
```sql
UPDATE administradores 
SET ativo = true 
WHERE usuario = 'nome_usuario';
```

### **Alterar senha:**
```sql
-- Calcule o hash SHA-256 da nova senha primeiro
UPDATE administradores 
SET senha_hash = 'NOVO_HASH_AQUI' 
WHERE usuario = 'admin';
```

---

## 🔄 DIFERENÇAS DO SISTEMA ANTIGO

### **ANTES (Hardcoded):**
```javascript
const ADMIN_USER = 'admin.rh';
const ADMIN_PASS = 'isiba2026';

if (usuario === ADMIN_USER && senha === ADMIN_PASS) {
    // Login
}
```

### **AGORA (Banco de Dados):**
```javascript
const result = await autenticarAdministrador(usuario, senha);

if (result.success) {
    // Login com dados do banco
    // Exibe nome completo do usuário
    // Registra último acesso
}
```

---

## ⚡ VANTAGENS

1. ✅ **Multi-usuário**: Vários admins podem ter acesso
2. ✅ **Segurança**: Senhas criptografadas no banco
3. ✅ **Auditoria**: Registro de último acesso
4. ✅ **Flexível**: Adicionar/remover usuários facilmente
5. ✅ **Profissional**: Sistema similar a plataformas corporativas
6. ✅ **Escalável**: Pronto para crescer

---

## 🚀 PRÓXIMOS PASSOS

Após testar o login:

1. ✅ Cadastrar funcionários
2. ✅ Fazer upload de contracheques
3. ✅ Integrar portal do colaborador
4. ⏳ (Futuro) Interface para gerenciar administradores

---

## 🐛 TROUBLESHOOTING

### **Erro: "Usuário ou senha incorretos"**
- Verifique se executou o script SQL
- Verifique se a tabela `administradores` foi criada
- Teste no SQL Editor: `SELECT * FROM administradores;`

### **Erro: "Supabase não foi inicializado"**
- Verifique conexão com internet
- Recarregue a página (F5)
- Abra o console (F12) e veja os erros

### **Erro: "função update_updated_at_column não existe"**
- Execute o script 3 do `SCRIPTS-SQL-SUPABASE.md` primeiro
- Essa função deve ser criada antes da tabela de admins

---

## 🔐 GERANDO HASH SHA-256

Para criar novos usuários, você precisa do hash da senha.

### **Opção 1: Online**
Use: https://emn178.github.io/online-tools/sha256.html

### **Opção 2: Console do Navegador (F12)**
```javascript
async function gerarHash(senha) {
    const encoder = new TextEncoder();
    const data = encoder.encode(senha);
    const hashBuffer = await crypto.subtle.digest('SHA-256', data);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
    console.log('Hash SHA-256:', hashHex);
    return hashHex;
}

// Uso:
gerarHash('minhaSenha123');
```

---

## ✅ CHECKLIST

- [ ] Executou `SQL-ADMIN-TABLE.sql` no Supabase
- [ ] Verificou criação da tabela `administradores`
- [ ] Testou login com `admin` / `admin`
- [ ] Login funcionou e exibiu "Administrador RH"
- [ ] Dashboard carregou com sucesso

**Se todos os itens estão ✅, o sistema está pronto!** 🎉

---

## 📞 SUPORTE

Dúvidas? Abra o console (F12) e me envie os erros que aparecem.
