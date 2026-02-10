# 🔐 PAINEL ADMINISTRATIVO RH - ISIBA
## Servidor Separado (Porta 3001)

---

## 📁 ESTRUTURA DO PROJETO

```
WEBSITE ISIBA/
├── index.html (Site público - porta 80/8080)
├── trabalhe-conosco.html
├── colaborador.html
├── assets/
│   ├── css/
│   ├── js/
│   └── img/
│
└── painel-rh/ (Painel Admin - porta 3001) ⭐
    ├── server.js (Servidor Node.js)
    ├── package.json
    ├── admin-rh.html
    ├── assets/
    │   ├── css/
    │   │   └── admin-rh.css
    │   ├── js/
    │   │   ├── supabase-config.js
    │   │   ├── supabase-admin.js
    │   │   └── admin-rh.js
    │   └── img/
    └── README.md (este arquivo)
```

---

## 🚀 INSTALAÇÃO

### **1. Instalar Node.js**

Se ainda não tem, baixe em: https://nodejs.org/

**Verificar instalação:**
```bash
node --version
npm --version
```

---

### **2. Instalar Dependências**

Abra o PowerShell nesta pasta (`painel-rh`) e execute:

```powershell
npm install
```

**Isso instalará:**
- `express` - Servidor web
- `cors` - Permitir requisições do Supabase

---

## ▶️ INICIAR O SERVIDOR

### **Modo Normal:**

```powershell
npm start
```

### **Modo Desenvolvimento:**

```powershell
npm run dev
```

**Você verá:**
```
═══════════════════════════════════════════
🚀 PAINEL ADMINISTRATIVO RH - ISIBA
═══════════════════════════════════════════
✅ Servidor rodando na porta: 3001
🌐 Acesse: http://localhost:3001
📊 Health Check: http://localhost:3001/health
═══════════════════════════════════════════
⚙️  Credenciais padrão:
   Usuário: admin
   Senha: admin
═══════════════════════════════════════════
```

---

## 🌐 ACESSAR O PAINEL

Após iniciar o servidor, abra no navegador:

**URL Local:**
```
http://localhost:3001
```

**URL na Rede Local:**
```
http://[SEU_IP]:3001
```

Para descobrir seu IP:
```powershell
ipconfig
```
Procure por "IPv4 Address"

---

## 🔐 LOGIN

- **Usuário**: `admin`
- **Senha**: `admin`

*(Autenticação via Supabase)*

---

## ⚙️ CONFIGURAÇÃO

### **Mudar a Porta:**

Edite o arquivo `server.js`:

```javascript
const PORT = 3001; // Altere para a porta desejada
```

### **CORS (permitir domínios):**

Se precisar restringir acesso, edite `server.js`:

```javascript
app.use(cors({
    origin: ['http://localhost:3001', 'https://seudominio.com']
}));
```

---

## 🔒 SEGURANÇA

### **Por que porta separada?**

1. ✅ **Isolamento**: O painel não fica exposto no site público
2. ✅ **Segurança**: Acesso restrito a porta específica
3. ✅ **Firewall**: Pode bloquear porta 3001 externamente
4. ✅ **Performance**: Servidor dedicado para admin

### **Boas práticas:**

- ⚠️ **NÃO exponha a porta 3001 publicamente**
- ✅ Use VPN para acesso remoto
- ✅ Configure firewall para bloquear acesso externo
- ✅ Use HTTPS em produção
- ✅ Altere as credenciais padrão

---

## 🌍 PRODUÇÃO

### **1. Deploy Local (Intranet)**

O painel pode rodar apenas na rede interna da empresa:

```powershell
# Iniciar servidor
npm start

# Acessar de outro computador na mesma rede
http://192.168.1.X:3001
```

### **2. Deploy na Nuvem (VPS/Cloud)**

**Opções:**
- DigitalOcean
- AWS EC2
- Google Cloud
- Azure
- Heroku

**Passos:**

1. Fazer upload dos arquivos da pasta `painel-rh`
2. Instalar Node.js no servidor
3. Executar `npm install`
4. Configurar firewall (liberar apenas porta 3001 para IPs específicos)
5. Usar PM2 para manter o servidor rodando:

```bash
npm install -g pm2
pm2 start server.js --name "painel-rh"
pm2 save
pm2 startup
```

### **3. HTTPS/SSL**

Para produção, use certificado SSL:

```javascript
// server.js
const https = require('https');
const fs = require('fs');

const options = {
    key: fs.readFileSync('chave-privada.pem'),
    cert: fs.readFileSync('certificado.pem')
};

https.createServer(options, app).listen(3001);
```

---

## 🧪 TESTAR

### **Health Check:**

```
http://localhost:3001/health
```

**Resposta esperada:**
```json
{
  "status": "OK",
  "service": "Painel RH - ISIBA",
  "port": 3001,
  "timestamp": "2026-01-28T..."
}
```

---

## 🐛 TROUBLESHOOTING

### **Erro: "Porta 3001 já está em uso"**

**Solução 1 - Matar processo:**
```powershell
# Descobrir PID
netstat -ano | findstr :3001

# Matar processo
taskkill /PID [NUMERO_PID] /F
```

**Solução 2 - Mudar porta:**
Edite `server.js` e altere o `PORT`

### **Erro: "Cannot find module 'express'"**

```powershell
npm install
```

### **Erro: "EACCES: permission denied"**

Execute PowerShell como Administrador

---

## 📊 MONITORAMENTO

### **Ver logs em tempo real:**

```powershell
npm start
```

### **Com PM2:**

```bash
pm2 logs painel-rh
pm2 monit
```

---

## 🔄 ATUALIZAÇÃO

Para atualizar o painel:

1. Fazer backup dos arquivos
2. Substituir arquivos atualizados
3. Reiniciar servidor:

```powershell
# Parar (Ctrl+C)
# Iniciar novamente
npm start
```

Com PM2:
```bash
pm2 restart painel-rh
```

---

## 📞 SUPORTE

**Dúvidas?**
- Verifique os logs no console
- Abra DevTools (F12) no navegador
- Consulte documentação do Node.js

---

## ✅ CHECKLIST DE INSTALAÇÃO

- [ ] Node.js instalado
- [ ] Dependências instaladas (`npm install`)
- [ ] Scripts SQL executados no Supabase
- [ ] Tabela `administradores` criada
- [ ] Servidor iniciado (`npm start`)
- [ ] Painel acessível em `http://localhost:3001`
- [ ] Login funcionando com `admin/admin`
- [ ] Cadastro de funcionário testado
- [ ] Upload de contracheque testado

---

## 🎯 PRÓXIMOS PASSOS

1. ✅ Testar todas as funcionalidades
2. ✅ Alterar credenciais padrão
3. ✅ Configurar firewall (bloquear acesso externo à porta 3001)
4. ✅ Configurar backup automático do banco
5. ✅ Integrar portal do colaborador (porta 8080)

---

**Servidor configurado e pronto para uso!** 🚀
