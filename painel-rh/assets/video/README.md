# 📹 Pasta de Vídeos

## Como adicionar seu vídeo institucional:

### Passo 1: Adicione o arquivo de vídeo
Coloque seu arquivo de vídeo nesta pasta com o nome:
- **institucional.mp4** (formato recomendado - melhor compatibilidade)
- **institucional.webm** (opcional - formato alternativo)

### Passo 2: Formatos suportados
O player HTML5 suporta os seguintes formatos:
- `.mp4` (H.264/AAC) - **RECOMENDADO** ✅
- `.webm` (VP8/VP9/Vorbis)
- `.ogg` (Theora/Vorbis)

### Passo 3: Recomendações técnicas
Para melhor performance:
- **Resolução**: 1920x1080 (Full HD) ou 1280x720 (HD)
- **Taxa de bits**: 5-10 Mbps para Full HD
- **Codec de vídeo**: H.264
- **Codec de áudio**: AAC
- **Tamanho máximo**: ~50 MB (para web)

### Como converter vídeos:
Use ferramentas gratuitas como:
- **HandBrake** (https://handbrake.fr/)
- **FFmpeg** (linha de comando)
- **CloudConvert** (online - https://cloudconvert.com/)

### Exemplo de conversão com FFmpeg:
```bash
ffmpeg -i seu-video-original.mov -c:v libx264 -preset slow -crf 22 -c:a aac -b:a 128k institucional.mp4
```

### Estrutura esperada:
```
assets/
  └── video/
      ├── institucional.mp4  (principal)
      ├── institucional.webm (opcional)
      └── README.md
```

---

## 🎬 Funcionamento:

Quando o usuário clicar no botão **"Play Video"**:
1. Modal abre automaticamente
2. Vídeo começa a tocar (autoplay)
3. Controles nativos do navegador disponíveis
4. Ao fechar, o vídeo pausa e volta ao início

### Recursos implementados:
✅ Autoplay ao abrir modal
✅ Pausa ao fechar
✅ Controles de reprodução
✅ Tela cheia disponível
✅ Responsivo
✅ Fecha com ESC ou clicando fora
✅ Download desabilitado

---

**Dica:** Se o arquivo for muito grande, considere hospedar no YouTube ou Vimeo e usar o sistema de iframe.
