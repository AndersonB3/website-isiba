# 🧹 ANÁLISE DE LIMPEZA - WEBSITE ISIBA
**Data:** 9 de Fevereiro de 2026

---

## 📊 ARQUIVOS IDENTIFICADOS PARA ARQUIVAMENTO

### ✅ CATEGORIA 1: BACKUPS SQL ANTIGOS (RAIZ)
**Ação:** Mover para `backups/producao/`

```
✓ backup-PROD-2026-02-06_16-30-17.sql  (3 dias atrás)
✓ backup-PROD-2026-02-06_16-30-39.sql  (3 dias atrás)
✓ estrutura-PROD.sql                    (backup de estrutura)
```

**Motivo:** Backups devem ficar na pasta `backups/` (já protegida no .gitignore)

---

### ✅ CATEGORIA 2: SCRIPTS SQL DE DEBUG/DESENVOLVIMENTO
**Ação:** Mover para `_ARQUIVADOS/sql-debug/`

```
✓ ADD_ASSINATURA_DIGITAL.sql
✓ ADICIONAR_CAMPO_CODIGO.sql
✓ ADICIONAR_COLUNA_ASSINATURA.sql
✓ ADICIONAR_PRIMEIRO_ACESSO.sql
✓ ATUALIZAR_DOCUMENTOS_BLOQUEIO.sql
✓ BLOQUEAR_RAPIDO.sql
✓ BLOQUEAR_TODOS_DOCUMENTOS.sql
✓ CORRIGIR_POLITICAS_RLS.sql
✓ DEBUG-ASSINATURA-VIEW.sql
✓ DEBUG_USUARIO_TESTE.sql
✓ DIAGNOSTICO_BLOQUEIO.sql
✓ EXECUTAR-TUDO-UMA-VEZ.sql
✓ FIX-VIEW-ASSINATURA.sql
✓ FORCAR_PRIMEIRO_ACESSO_TRUE.sql
✓ LIMPAR_RAPIDO_SIMPLES.sql
✓ LIMPAR_RECIBOS_E_BLOQUEAR.sql
✓ LIMPAR_TESTES_ANTES_SEGURANCA.sql
✓ SISTEMA_RECIBOS.sql
✓ SISTEMA_RECIBOS_LIMPO.sql
✓ SISTEMA_RECIBOS_PASSO_A_PASSO.sql
✓ URGENTE_SEGURANCA_RLS_STORAGE.sql
✓ VERIFICACAO_URGENTE.sql
✓ VERIFICAR_PERMISSOES_STORAGE.sql
✓ VERIFICAR_POLITICA_DETALHES.sql
✓ VERIFICAR_VIEW_ASSINATURA.sql
```

**Total:** 25 arquivos SQL de debug  
**Motivo:** Scripts usados durante desenvolvimento, não necessários no dia-a-dia

---

### ✅ CATEGORIA 3: DOCUMENTAÇÃO TEMPORÁRIA/DUPLICADA
**Ação:** Mover para `_ARQUIVADOS/documentacao/`

```
✓ ANALISE-LIMPEZA-ARQUIVOS.md (análise antiga)
✓ ANALISE-POLITICAS-RLS.md (análise específica)
✓ COPIAR-DADOS-PRODUCAO.md (substituído por GUIA-COPIAR-DADOS-PROD-DEV.md)
✓ CORRECAO-LOADER.md (correção já aplicada)
✓ CORRECAO-SCRIPTS.md (correção já aplicada)
✓ FIX-LOGIN-RLS.md (fix já aplicado)
✓ INICIAR-AMBIENTE-LOCAL.md (substituído por QUICK-START-DEV.md)
✓ INSTALAR-SUPABASE-CLI-MANUAL.md (manual longo, mantém versão curta)
✓ MERGE-MASTER-DEVELOP.md (merge já feito)
✓ RESUMO-ARQUIVOS-CRIADOS.md (resumo temporário)
✓ RESUMO-CONFIGURACAO.md (substituído por outros guias)
✓ SETUP-RAPIDO-LOCAL.md (duplicado)
✓ TESTE-PRIMEIRO-ACESSO.md (teste já concluído)
✓ VERIFICACAO-BANCO-DEVELOP.md (verificação já feita)
```

**Total:** 14 arquivos MD temporários  
**Motivo:** Documentação de processos já concluídos ou substituída por guias melhores

---

### ✅ CATEGORIA 4: SCRIPTS POWERSHELL OBSOLETOS/DUPLICADOS
**Ação:** Mover para `_ARQUIVADOS/scripts-obsoletos/`

```
✓ ATUALIZAR-HOSTINGER.ps1 (deploy específico)
✓ instalar-cli-auto.ps1 (CLI já instalado)
✓ INSTALAR-SUPABASE-CLI-V2.ps1 (versão antiga)
✓ INSTALAR-SUPABASE-CLI.ps1 (duplicado)
✓ LIMPAR_PROJETO.ps1 (limpeza antiga)
✓ PREPARAR-DEPLOY-HOSTINGER.ps1 (deploy específico)
✓ SUPABASE-CLI-POWERSHELL.ps1 (substituído por .bat)
✓ _ARQUIVAR_ARQUIVOS.ps1 (script usado, pode arquivar)
```

**Total:** 8 scripts PS1  
**Motivo:** Scripts usados uma vez ou substituídos por versões .bat

---

### ✅ CATEGORIA 5: SCRIPTS BAT REDUNDANTES
**Ação:** Consolidar e arquivar duplicados

```
✓ BACKUP-BANCOS.bat (substituído por BACKUP-AUTOMATICO.bat)
✓ COMPARAR-BANCOS.bat (substituído por COMPARAR-ESTRUTURAS-AUTO.bat)
✓ GERENCIAR-SUPABASE.bat (substituído por MENU-SUPABASE.bat)
✓ INICIAR-PAINEL-RH.bat (específico, mover para painel-rh/)
✓ INICIAR-SERVIDOR.bat (duplicado)
✓ INICIAR-TUDO.bat (genérico demais)
✓ INSTALAR-SUPABASE-AUTOMATICO.bat (CLI já instalado)
✓ INSTALAR-SUPABASE-CLI.bat (duplicado)
✓ LOGIN-SUPABASE.bat (login já feito)
✓ VER-ARQUITETURA.bat (visualização, pode arquivar)
✓ VERIFICAR-BANCO-DEVELOP.bat (verificação já feita)
```

**Total:** 11 scripts BAT redundantes  
**Motivo:** Funcionalidade duplicada ou já executada

---

### ✅ CATEGORIA 6: HTML DE TESTE/DESENVOLVIMENTO
**Ação:** Já arquivado (verificar se sobrou algum)

```
✓ admin-limpar-banco.html (ferramenta de debug)
✓ primeiro-acesso-new.html (versão de teste, mantém primeiro-acesso.html)
```

**Total:** 2 arquivos HTML  
**Motivo:** Arquivos de teste, versão nova já está ativa

---

### ⚠️ CATEGORIA 7: GUIAS PRINCIPAIS (MANTER NA RAIZ)
**Ação:** MANTER - São documentação ativa

```
✅ ARQUITETURA-BRANCHES-BANCOS.md → ESSENCIAL (arquitetura do projeto)
✅ AUTOMACAO-COMPLETA-RESUMO.md → ESSENCIAL (automação)
✅ AUTOMACAO-SUPABASE-RESUMO.md → CONSOLIDAR com acima?
✅ CONFIGURAR-AMBIENTES.md → ESSENCIAL (configuração)
✅ GIT-WORKFLOW.md → ESSENCIAL (workflow Git)
✅ GUIA-AMBIENTES.md → ESSENCIAL (ambientes)
✅ GUIA-API-SUPABASE.md → ÚTIL (referência API)
✅ GUIA-BACKUP-DASHBOARD.md → ESSENCIAL (backup ativo)
✅ GUIA-CLONAR-BANCO-COMPLETO.md → ÚTIL (procedimento)
✅ GUIA-COMPARAR-BANCOS.md → ÚTIL (procedimento)
✅ GUIA-COPIAR-DADOS-PROD-DEV.md → ESSENCIAL (uso frequente)
✅ GUIA-COPIAR-POLITICAS-RLS.md → ÚTIL (procedimento)
✅ GUIA-RAPIDO-CLONAR.md → ÚTIL (quick reference)
✅ GUIA-SUPABASE-CLI.md → ESSENCIAL (referência CLI)
✅ GUIA-TESTES-COMPLETO.md → ÚTIL (testes)
✅ PROBLEMA-FIREWALL-5432.md → ESSENCIAL (troubleshooting)
✅ QUICK-START-DEV.md → ESSENCIAL (início rápido)
✅ STATUS-FINAL-AUTOMACAO.md → ESSENCIAL (status atual)
✅ SUPABASE-CLI-STATUS.md → ÚTIL (status CLI)
✅ README.md → ESSENCIAL (principal)
```

**Ação:** Manter todos (são documentação ativa e útil)

---

### ⚠️ CATEGORIA 8: SCRIPTS BAT ATIVOS (MANTER NA RAIZ)
**Ação:** MANTER - São ferramentas ativas

```
✅ BACKUP-AUTOMATICO.bat → ESSENCIAL (backup CLI)
✅ BACKUP-VIA-DASHBOARD.bat → ESSENCIAL (backup Dashboard)
✅ COMPARAR-ESTRUTURAS-AUTO.bat → ÚTIL (comparação)
✅ COPIAR-PROD-PARA-DEV.bat → ESSENCIAL (cópia de dados)
✅ MENU-SUPABASE.bat → ESSENCIAL (menu principal)
✅ SINCRONIZAR-ESTRUTURA.bat → ÚTIL (sincronização)
```

**Ação:** Manter todos (são ferramentas ativas)

---

## 📊 RESUMO DA LIMPEZA

| Categoria | Arquivos | Ação |
|-----------|----------|------|
| Backups SQL (raiz) | 3 | Mover → `backups/producao/` |
| Scripts SQL debug | 25 | Mover → `_ARQUIVADOS/sql-debug/` |
| Docs temporárias | 14 | Mover → `_ARQUIVADOS/documentacao/` |
| Scripts PS1 | 8 | Mover → `_ARQUIVADOS/scripts-obsoletos/` |
| Scripts BAT | 11 | Mover → `_ARQUIVADOS/scripts-obsoletos/` |
| HTML teste | 2 | Mover → `_ARQUIVADOS/html-teste/` |
| **TOTAL** | **63** | **Arquivar** |

---

## ✅ ARQUIVOS QUE FICARÃO NA RAIZ (ORGANIZADOS)

### 📄 HTML Principais (5 arquivos):
- `index.html` - Landing page
- `admin-rh.html` - Painel RH
- `colaborador.html` - Dashboard colaborador
- `portal-colaborador.html` - Portal de acesso
- `primeiro-acesso.html` - Primeiro acesso
- `relatorio.html` - Relatórios
- `trabalhe-conosco.html` - Carreiras
- `meus-contracheques.html` - Redirect

### 📜 Scripts Ativos (7 arquivos):
- `BACKUP-AUTOMATICO.bat`
- `BACKUP-VIA-DASHBOARD.bat`
- `COPIAR-PROD-PARA-DEV.bat`
- `MENU-SUPABASE.bat`
- `SINCRONIZAR-ESTRUTURA.bat`
- `COMPARAR-ESTRUTURAS-AUTO.bat`
- `BACKUP-API-REST.ps1`

### 📚 Guias Essenciais (18 arquivos):
- `README.md`
- `ARQUITETURA-BRANCHES-BANCOS.md`
- `AUTOMACAO-COMPLETA-RESUMO.md`
- `CONFIGURAR-AMBIENTES.md`
- `GIT-WORKFLOW.md`
- `GUIA-AMBIENTES.md`
- `GUIA-API-SUPABASE.md`
- `GUIA-BACKUP-DASHBOARD.md`
- `GUIA-CLONAR-BANCO-COMPLETO.md`
- `GUIA-COMPARAR-BANCOS.md`
- `GUIA-COPIAR-DADOS-PROD-DEV.md`
- `GUIA-COPIAR-POLITICAS-RLS.md`
- `GUIA-RAPIDO-CLONAR.md`
- `GUIA-SUPABASE-CLI.md`
- `GUIA-TESTES-COMPLETO.md`
- `PROBLEMA-FIREWALL-5432.md`
- `QUICK-START-DEV.md`
- `STATUS-FINAL-AUTOMACAO.md`
- `SUPABASE-CLI-STATUS.md`

### 📁 Pastas:
- `assets/` - CSS, JS, imagens, vídeos
- `database/` - Schemas SQL
- `docs/` - Documentação adicional
- `painel-rh/` - Painel RH local
- `backups/` - Backups (gitignored)
- `_ARQUIVADOS/` - Arquivos antigos
- `.github/` - GitHub workflows
- `.vscode/` - Configurações VS Code
- `supabase/` - Configurações Supabase

---

## 🎯 RESULTADO ESPERADO

**Antes:** 150+ arquivos na raiz  
**Depois:** ~40 arquivos essenciais na raiz  
**Melhoria:** -73% de arquivos na raiz (muito mais organizado!)

---

## 🚀 PRÓXIMO PASSO

Execute o script de limpeza:
```batch
.\EXECUTAR-LIMPEZA-ORGANIZADA.bat
```

Ou revise manualmente a lista acima antes de executar.
