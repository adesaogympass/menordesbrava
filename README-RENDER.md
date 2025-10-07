# Kick Stream Live - Render Deployment

Este projeto configura um stream contínuo para Kick.com usando Render.com como plataforma de hospedagem.

## 🚀 Como fazer o deploy no Render

### Opção 1: Deploy Automático (Recomendado)

1. **Fork este repositório** no GitHub
2. **Conecte ao Render**:
   - Acesse [render.com](https://render.com)
   - Faça login com sua conta GitHub
   - Clique em "New +" → "Web Service"
3. **Configure o serviço**:
   - **Build Command**: (deixe vazio)
   - **Start Command**: (deixe vazio)
   - **Dockerfile Path**: `./Dockerfile.render`
   - **Plan**: Starter (gratuito)
   - **Region**: Oregon (mais próximo do Brasil)

### Opção 2: Deploy Manual

1. **Clone o repositório**:
   ```bash
   git clone <seu-repositorio>
   cd kick-stream-live
   ```

2. **Configure as variáveis de ambiente**:
   - `RTMP_URL`: `rtmps://fa723fc1b171.global-contribute.live-video.net`
   - `STREAM_KEY`: `sk_us-west-2_EjKsW9ogmEwb_1HyG6woK3Z95jdOJfLAYjPxSCvn8p7`
   - `FPS`: `30`
   - `BITRATE`: `4000k`

3. **Faça o deploy**:
   - Render detectará automaticamente o `render.yaml`
   - O deploy será feito automaticamente

## ⚙️ Configurações

### Variáveis de Ambiente

| Variável | Valor Padrão | Descrição |
|----------|--------------|-----------|
| `RTMP_URL` | `rtmps://fa723fc1b171.global-contribute.live-video.net` | URL de ingestão da Kick |
| `STREAM_KEY` | `sk_us-west-2_EjKsW9ogmEwb_1HyG6woK3Z95jdOJfLAYjPxSCvn8p7` | Chave do stream |
| `FPS` | `30` | Frames por segundo |
| `BITRATE` | `4000k` | Taxa de bits do vídeo |

### Características do Render

- ✅ **Sem limite de tempo**: Diferente do Fly.io trial
- ✅ **Health checks**: Mantém o serviço ativo
- ✅ **Auto-restart**: Reinicia automaticamente se falhar
- ✅ **Logs em tempo real**: Acompanhe o status
- ✅ **Deploy automático**: Atualizações via Git

## 🔧 Funcionamento

1. **Stream contínuo**: FFmpeg envia imagem estática
2. **Reinício automático**: A cada 3 minutos para estabilidade
3. **Health check**: Servidor HTTP responde em `/health`
4. **Heartbeat**: Logs regulares de atividade
5. **Reconexão**: Tenta reconectar em 5 segundos se falhar

## 📊 Monitoramento

- **Logs**: Acesse o dashboard do Render
- **Health**: `https://seu-app.onrender.com/health`
- **Status**: `https://seu-app.onrender.com/`

## 🆚 Render vs Fly.io

| Característica | Render | Fly.io |
|----------------|--------|--------|
| Trial | ✅ Sem limite | ❌ 5 minutos |
| Deploy | ✅ Automático | ⚠️ Manual |
| Configuração | ✅ Simples | ⚠️ Complexa |
| Preço | ✅ Gratuito | ⚠️ Pago após trial |
| Estabilidade | ✅ Excelente | ✅ Excelente |

## 🎯 Vantagens do Render

1. **Sem limite de trial**: Funciona 24/7 gratuitamente
2. **Deploy automático**: Conecta direto ao GitHub
3. **Configuração simples**: Menos arquivos de configuração
4. **Health checks nativos**: Mantém o serviço ativo
5. **Logs integrados**: Dashboard completo

## 🚨 Troubleshooting

### Stream não conecta
- Verifique as credenciais RTMP_URL e STREAM_KEY
- Confirme se a chave está ativa na Kick

### Serviço para
- Render reinicia automaticamente
- Verifique os logs para erros

### Performance
- Plano Starter é suficiente
- Upgrade para plano pago se necessário

## 📝 Arquivos Importantes

- `render.yaml`: Configuração do Render
- `Dockerfile.render`: Container otimizado
- `start_stream_render.sh`: Script de stream
- `health_server_render.py`: Servidor de health
- `start_services_render.sh`: Inicializador

---

**Resultado**: Stream contínuo 24/7 na Kick.com sem limitações de trial! 🎉
