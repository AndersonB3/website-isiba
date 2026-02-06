# 🚀 Scripts SQL para Configuração do Supabase
## ISIBA - Sistema de Gestão de Contracheques

Execute estes scripts no **SQL Editor** do Supabase na ordem apresentada.

Acesse: https://supabase.com/dashboard/project/kklhcmrnraroletwbbid/sql/new

---

## 📋 1. CRIAR TABELA DE COLABORADORES

```sql
-- Tabela de colaboradores
CREATE TABLE colaboradores (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nome_completo TEXT NOT NULL,
    cpf TEXT UNIQUE NOT NULL,
    cpf_hash TEXT NOT NULL,
    senha_hash TEXT NOT NULL,
    email TEXT,
    ativo BOOLEAN DEFAULT true,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para busca rápida
CREATE INDEX idx_colaboradores_cpf ON colaboradores(cpf);
CREATE INDEX idx_colaboradores_ativo ON colaboradores(ativo);
CREATE INDEX idx_colaboradores_nome ON colaboradores(nome_completo);

-- Comentários nas colunas
COMMENT ON TABLE colaboradores IS 'Tabela de colaboradores da ISIBA';
COMMENT ON COLUMN colaboradores.cpf IS 'CPF sem formatação (apenas números)';
COMMENT ON COLUMN colaboradores.cpf_hash IS 'Hash SHA-256 do CPF para autenticação';
COMMENT ON COLUMN colaboradores.senha_hash IS 'Hash SHA-256 da senha';
```

---

## 📄 2. CRIAR TABELA DE CONTRACHEQUES

```sql
-- Tabela de contracheques
CREATE TABLE contracheques (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    colaborador_id UUID REFERENCES colaboradores(id) ON DELETE CASCADE,
    mes_referencia TEXT NOT NULL,
    ano INTEGER NOT NULL,
    arquivo_url TEXT NOT NULL,
    nome_arquivo TEXT NOT NULL,
    tamanho_arquivo BIGINT NOT NULL,
    enviado_por TEXT DEFAULT 'admin.rh',
    enviado_em TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para melhor performance
CREATE INDEX idx_contracheques_colaborador ON contracheques(colaborador_id);
CREATE INDEX idx_contracheques_periodo ON contracheques(ano DESC, mes_referencia);
CREATE INDEX idx_contracheques_data ON contracheques(enviado_em DESC);

-- Constraint única: um colaborador não pode ter dois contracheques no mesmo mês/ano
CREATE UNIQUE INDEX idx_contracheques_unico ON contracheques(colaborador_id, mes_referencia, ano);

-- Comentários
COMMENT ON TABLE contracheques IS 'Tabela de contracheques enviados aos colaboradores';
COMMENT ON COLUMN contracheques.arquivo_url IS 'Caminho do arquivo no Storage do Supabase';
COMMENT ON COLUMN contracheques.tamanho_arquivo IS 'Tamanho do arquivo em bytes';
```

---

## ⏰ 3. TRIGGER PARA ATUALIZAÇÃO AUTOMÁTICA

```sql
-- Função para atualizar data de modificação
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.atualizado_em = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger na tabela colaboradores
CREATE TRIGGER update_colaboradores_updated_at 
    BEFORE UPDATE ON colaboradores 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();
```

---

## 🔒 4. HABILITAR ROW LEVEL SECURITY (RLS)

```sql
-- Habilitar RLS nas tabelas
ALTER TABLE colaboradores ENABLE ROW LEVEL SECURITY;
ALTER TABLE contracheques ENABLE ROW LEVEL SECURITY;

-- Política: Permitir acesso total (como estamos usando anon key, não há restrição)
-- Mais tarde você pode refinar essas políticas
CREATE POLICY "Permitir todas operações em colaboradores" ON colaboradores
    FOR ALL 
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Permitir todas operações em contracheques" ON contracheques
    FOR ALL 
    USING (true)
    WITH CHECK (true);
```

---

## 📦 5. CRIAR BUCKET DE STORAGE

```sql
-- Criar bucket para contracheques
INSERT INTO storage.buckets (id, name, public) 
VALUES ('contracheques', 'contracheques', false);

-- Política: Permitir upload
CREATE POLICY "Permitir upload de contracheques" 
    ON storage.objects
    FOR INSERT 
    TO public
    WITH CHECK (bucket_id = 'contracheques');

-- Política: Permitir leitura
CREATE POLICY "Permitir leitura de contracheques" 
    ON storage.objects
    FOR SELECT 
    TO public
    USING (bucket_id = 'contracheques');

-- Política: Permitir atualização
CREATE POLICY "Permitir atualização de contracheques" 
    ON storage.objects
    FOR UPDATE 
    TO public
    USING (bucket_id = 'contracheques');

-- Política: Permitir exclusão
CREATE POLICY "Permitir exclusão de contracheques" 
    ON storage.objects
    FOR DELETE 
    TO public
    USING (bucket_id = 'contracheques');
```

---

## 🧪 6. INSERIR DADOS DE TESTE (OPCIONAL)

```sql
-- Inserir um colaborador de teste
-- CPF: 111.222.333-44
-- Senha: teste123
-- CPF Hash e Senha Hash gerados com SHA-256

INSERT INTO colaboradores (
    nome_completo, 
    cpf, 
    cpf_hash, 
    senha_hash, 
    email, 
    ativo
) VALUES (
    'João Silva Santos',
    '11122233344',
    'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', -- hash de "11122233344"
    'ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae', -- hash de "teste123"
    'joao.silva@email.com',
    true
);
```

---

## ✅ 7. VERIFICAR INSTALAÇÃO

```sql
-- Verificar tabelas criadas
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('colaboradores', 'contracheques');

-- Verificar total de colaboradores
SELECT COUNT(*) as total_colaboradores FROM colaboradores;

-- Verificar total de contracheques
SELECT COUNT(*) as total_contracheques FROM contracheques;

-- Verificar bucket de storage
SELECT * FROM storage.buckets WHERE name = 'contracheques';
```

---

## 📝 ORDEM DE EXECUÇÃO

1. Execute os scripts na ordem: 1 → 2 → 3 → 4 → 5
2. O script 6 é opcional (dados de teste)
3. Execute o script 7 para validar

---

## ⚠️ IMPORTANTE

- **Backup**: Sempre faça backup antes de modificar o banco
- **RLS**: As políticas atuais permitem acesso total. Refine conforme necessário
- **Storage**: O bucket é privado, URLs precisam ser assinadas
- **Hashes**: As senhas são hasheadas com SHA-256 no frontend antes de salvar

---

## 🔐 CREDENCIAIS DO PROJETO

- **URL**: https://kklhcmrnraroletwbbid.supabase.co
- **Anon Key**: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtrbGhjbXJucmFyb2xldHdiYmlkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjkxMjM2NDEsImV4cCI6MjA4NDY5OTY0MX0.dk1aXu6WiNN_Yn-PU-ST2nHOTca0PjDDZgYKauiUP0Y

---

## 📞 SUPORTE

Se encontrar erros durante a execução:
1. Verifique se executou os scripts na ordem
2. Verifique se não há tabelas com o mesmo nome
3. Consulte os logs do Supabase para detalhes do erro
