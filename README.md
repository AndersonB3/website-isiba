# 🏥 ISIBA Social - Website Institucional

![ISIBA Social](https://img.shields.io/badge/ISIBA-Social-0891b2?style=for-the-badge)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)

## 📋 Sobre o Projeto

Website institucional moderno e profissional para o **ISIBA**, instituição de saúde sem fins lucrativos especializada na gestão de Unidades de Pronto Atendimento (UPAs) e hospitais públicos através de licitações.

### 🎯 Objetivos

- Transmitir credibilidade institucional
- Demonstrar transparência na gestão pública
- Comunicar humanização no cuidado em saúde
- Apresentar eficiência e organização
- Oferecer navegação simples e intuitiva

## ✨ Características

### 🎨 Design
- ✅ Layout moderno e elegante
- ✅ Paleta de cores institucional (azul e verde)
- ✅ Tipografia profissional (Inter + Poppins)
- ✅ Animações suaves e transições fluidas
- ✅ Ícones Font Awesome 6

### 📱 Responsividade
- ✅ Desktop (1200px+)
- ✅ Tablet (768px - 1024px)
- ✅ Mobile (320px - 767px)
- ✅ Design adaptativo com breakpoints otimizados

### ♿ Acessibilidade
- ✅ HTML5 semântico
- ✅ Bom contraste de cores
- ✅ Texto legível
- ✅ Navegação por teclado
- ✅ ARIA labels

### ⚡ Performance
- ✅ CSS otimizado (Flexbox + Grid)
- ✅ JavaScript vanilla leve
- ✅ Lazy loading de imagens
- ✅ Carregamento assíncrono de recursos

## 📁 Estrutura de Arquivos

```
WEBSITE ISIBA/
├── index.html              # Página principal
├── README.md              # Documentação
│
├── assets/
│   ├── css/
│   │   └── style.css      # Estilos principais
│   │
│   ├── js/
│   │   └── main.js        # Scripts principais
│   │
│   ├── img/
│   │   ├── logo.png       # Logo colorida
│   │   ├── logo-white.png # Logo branca (rodapé)
│   │   ├── hero-bg.jpg    # Imagem hero section
│   │   └── favicon.png    # Ícone do site
│   │
│   └── relatorio/
│       └── relatorio-anual-2025.pdf # Relatório anual
```

## 🚀 Instalação e Uso

### Opção 1: Abrir Localmente
```bash
# Clone ou baixe o projeto
cd WEBSITE\ ISIBA

# Abra o index.html no navegador
# Recomendado: Use Live Server (VS Code) ou qualquer servidor local
```

### Opção 2: Live Server (VS Code)
```bash
# Instale a extensão Live Server no VS Code
# Clique com botão direito em index.html
# Selecione "Open with Live Server"
```

### Opção 3: Python Server
```bash
# Na pasta do projeto
python -m http.server 8000
# Acesse: http://localhost:8000
```

## 🎨 Personalização

### Cores
Edite as variáveis CSS em `assets/css/style.css`:

```css
:root {
  --primary-color: hsl(200, 85%, 45%);      /* Azul principal */
  --secondary-color: hsl(150, 60%, 45%);    /* Verde secundário */
  --title-color: hsl(210, 40%, 15%);        /* Títulos */
  --text-color: hsl(210, 15%, 35%);         /* Texto */
}
```

### Tipografia
```css
:root {
  --body-font: 'Inter', sans-serif;
  --heading-font: 'Poppins', sans-serif;
}
```

### Vídeo Institucional
Edite a URL do vídeo em `assets/js/main.js`:

```javascript
const videoUrl = 'https://www.youtube.com/embed/SEU_VIDEO_ID?autoplay=1';
```

## 📝 Seções do Website

1. **Header Fixo**
   - Logo institucional
   - Menu de navegação
   - Botão Webmail destacado

2. **Hero Section**
   - Imagem/vídeo de fundo
   - Título principal
   - Call-to-actions

3. **Apresentação Institucional**
   - 4 valores principais em cards
   - Ícones animados
   - Layout responsivo

4. **Relatório Anual**
   - Estatísticas animadas
   - Números de impacto
   - Link para PDF completo

5. **Footer**
   - Endereços (Salvador e São Paulo)
   - Contatos
   - Redes sociais

## 🔧 Tecnologias Utilizadas

- **HTML5** - Estrutura semântica
- **CSS3** - Estilização moderna
- **JavaScript (Vanilla)** - Interatividade
- **Font Awesome 6** - Ícones
- **Google Fonts** - Tipografia
- **AOS Library** - Animações on scroll

## 📦 Dependências Externas (CDN)

```html
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<!-- AOS Animations -->
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
```

## 🖼️ Imagens Necessárias

Para o funcionamento completo, adicione as seguintes imagens em `assets/img/`:

1. **logo.png** (400x100px recomendado)
   - Logo colorida para o header

2. **logo-white.png** (400x100px recomendado)
   - Logo branca para o footer

3. **hero-bg.jpg** (1920x1080px recomendado)
   - Imagem de fundo da seção hero
   - Sugestão: profissionais de saúde, hospital, atendimento

4. **favicon.png** (32x32px ou 64x64px)
   - Ícone do site

## 🎯 Funcionalidades JavaScript

- ✅ Menu mobile responsivo
- ✅ Header com scroll dinâmico
- ✅ Modal de vídeo
- ✅ Contador animado de estatísticas
- ✅ Smooth scroll
- ✅ Botão "Voltar ao topo"
- ✅ Efeito parallax no hero
- ✅ Animações AOS

## 📱 Compatibilidade

- ✅ Chrome (últimas 2 versões)
- ✅ Firefox (últimas 2 versões)
- ✅ Safari (últimas 2 versões)
- ✅ Edge (últimas 2 versões)
- ✅ Opera (últimas 2 versões)

## 🔍 SEO

Otimizado para buscadores:
- Meta tags completas
- HTML semântico
- URLs amigáveis
- Alt text em imagens
- Estrutura hierárquica de headings

## 📞 Contatos ISIBA Social

### Salvador – BA
Edifício Guimarães Trade  
Av. Tancredo Neves, nº 1189  
Sala 503 a 505 – Caminho das Árvores  
CEP: 41.870-021

### São Paulo – SP
Edifício Palácio das Américas  
Av. Brigadeiro Faria Lima, nº 1811  
Sala 918  
CEP: 01452-001

**Central de Atendimento:** (71) 2137.7396  
**E-mail:** contato@isiba.org.br

## 📄 Licença

Este projeto foi desenvolvido para uso exclusivo do ISIBA Social.

## 👨‍💻 Suporte

Para dúvidas ou suporte técnico, entre em contato através dos canais oficiais do ISIBA Social.

---

<div align="center">
  <p>Desenvolvido com ❤️ para transformar vidas através da gestão humanizada em saúde</p>
  <p><strong>🏥 ISIBA Social - Gestão Humanizada</strong></p>
</div>
