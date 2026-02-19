# 🔐 GUIA DE SEGURANÇA - SUPABASE + VERCEL

## ✅ Resumo: Sua chave está SEGURA por design

A chave `SUPABASE_ANON_KEY` que aparece no código **é pública por design** — ela funciona como um "ID de aplicativo", não como uma senha. O Supabase foi construído para isso.

Veja o que o próprio Supabase diz:
> *"The anon key is safe to use in your browser and mobile apps. It's a public key."*

---

## 🔑 Os Dois Tipos de Chave

| Chave | Onde usar | Pode ficar no código? |
|-------|-----------|----------------------|
| `anon` / `public` | Frontend, browser | ✅ **SIM** |
| `service_role` | Apenas backend seguro | ❌ **NUNCA** |

### ⚠️ O que NUNCA fazer:
- Usar a `service_role key` no frontend
- Ela bypassa 100% do RLS e dá acesso total ao banco
- Nunca commitar a `service_role key` no GitHub

---

## 🛡️ A Proteção Real: Row Level Security (RLS)

O RLS é o que realmente protege seus dados. Com RLS ativo, mesmo que alguém tenha a `anon key`, **não consegue acessar dados que não são dele**.

### Situação atual do projeto:

| Tabela | RLS | Status |
|--------|-----|--------|
| `administradores` | ✅ Ativo | Protegida |
| `colaboradores` | ✅ Ativo | Protegida |
| `contracheques` | ✅ Ativo | Protegida |

---

## 📋 Checklist de Segurança

### No Supabase (executar `POLITICAS_RLS_SEGURANCA.sql`):
- [ ] RLS habilitado em todas as tabelas
- [ ] Políticas de leitura configuradas
- [ ] INSERT/DELETE bloqueados para `anon`
- [ ] Storage com políticas de acesso

### No Código:
- [ ] Apenas `anon key` no frontend ✅
- [ ] `service_role key` **nunca** no código ✅
- [ ] Senhas com hash SHA-256 ✅
- [ ] `.gitignore` bloqueando arquivos `.env` ✅

### Na Vercel:
- [ ] Variáveis de ambiente configuradas no painel
- [ ] Nenhuma `service_role key` exposta

---

## 🚨 Como Verificar se Está Protegido

1. Acesse o **Supabase Dashboard**
2. Vá em **Authentication → Policies**
3. Verifique se cada tabela tem o cadeado 🔒 ativo
4. Execute o SQL de verificação:

```sql
SELECT 
    tablename,
    rowsecurity as "RLS Ativo"
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('colaboradores', 'administradores', 'contracheques');
```

Resultado esperado: `rowsecurity = true` para todas as tabelas.

---

## 🔄 Como Funciona a Segurança do Sistema

```
Usuário (browser)
      │
      │  usa anon key (pública)
      ▼
  Supabase API
      │
      │  verifica RLS
      ▼
  ┌─────────────────────────────────┐
  │  Política RLS                   │
  │  "Este usuário pode ver         │
  │   apenas seus próprios dados?"  │
  └─────────────────────────────────┘
      │              │
      ▼              ▼
  ✅ SIM          ❌ NÃO
  Retorna         Retorna
  os dados        erro 403
```

---

## 🎯 Ação Necessária

**Execute o arquivo `database/POLITICAS_RLS_SEGURANCA.sql` no Supabase:**

1. Acesse: [https://supabase.com/dashboard](https://supabase.com/dashboard)
2. Selecione seu projeto: `kklhcmrnraroletwbbid`
3. Vá em **SQL Editor**
4. Cole e execute o conteúdo do arquivo `POLITICAS_RLS_SEGURANCA.sql`
5. Verifique se todas as tabelas mostram `✅ PROTEGIDO`

---

## 📞 Referências Oficiais

- [Supabase RLS Guide](https://supabase.com/docs/guides/database/row-level-security)
- [Supabase API Keys](https://supabase.com/docs/guides/api/api-keys)
- [Supabase Security Best Practices](https://supabase.com/docs/guides/database/hardening-data-api)
