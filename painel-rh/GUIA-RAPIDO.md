# 🚀 GUIA RÁPIDO - PAINEL RH

## ⚡ INSTALAÇÃO EM 3 PASSOS

### **1️⃣ Instalar Node.js**

Baixe e instale: https://nodejs.org/ (versão LTS recomendada)

---

### **2️⃣ Instalar Dependências**

Abra o PowerShell **nesta pasta** (`painel-rh`) e execute:

```powershell
npm install
```

---

### **3️⃣ Iniciar Servidor**

**Opção A - Arquivo .bat (Fácil):**

Dê duplo clique em: `INICIAR-PAINEL.bat`

**Opção B - PowerShell:**

```powershell
npm start
```

---

## 🌐 ACESSAR

Abra o navegador em:

```
http://localhost:3001
```

**Login:**
- Usuário: `admin`
- Senha: `admin`

---

## 🛑 PARAR SERVIDOR

Pressione **Ctrl + C** no terminal/PowerShell

---

## 📋 PORTAS

- **Site público**: Porta 80 ou 8080
- **Painel RH**: Porta 3001 (isolado) ⭐
- **Portal Colaborador**: Porta 8080 (futuro)

---

## ✅ VERIFICAR FUNCIONAMENTO

Acesse: http://localhost:3001/health

Deve retornar:
```json
{
  "status": "OK",
  "service": "Painel RH - ISIBA Social",
  "port": 3001
}
```

---

## 🆘 PROBLEMAS?

### **"Node.js não encontrado"**
→ Instale: https://nodejs.org/

### **"Porta 3001 em uso"**
→ Mate o processo:
```powershell
netstat -ano | findstr :3001
taskkill /PID [NUMERO] /F
```

### **"Cannot find module"**
→ Execute:
```powershell
npm install
```

---

## 📖 MAIS INFORMAÇÕES

Consulte o arquivo `README.md` para documentação completa.

---

**Pronto! Servidor configurado!** 🎉
