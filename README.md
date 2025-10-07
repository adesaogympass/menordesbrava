# Servidor de Mídia para Kick - Fly.io

Este projeto cria um servidor de mídia leve usando Fly.io que transmite uma imagem estática para a Kick em loop contínuo, substituindo o OBS.

## Características

- ✅ Container Linux leve com Alpine
- ✅ FFmpeg integrado
- ✅ Stream contínuo a 30 FPS
- ✅ Bitrate de 4000 kbps (4 Mbps)
- ✅ Configuração automática no Fly.io
- ✅ Health checks para monitoramento

## Arquivos do Projeto

- `Dockerfile` - Configuração do container
- `start_stream.sh` - Script de inicialização do stream
- `fly.toml` - Configuração do Fly.io
- `config.env.example` - Exemplo de configuração
- `health_check.sh` - Script de health check
- `live_image.png` - Imagem baixada automaticamente da URL

## Configuração

### 1. Imagem configurada

A imagem está configurada para ser baixada automaticamente da URL: `https://i.ytimg.com/vi/IFF4ZS2TKh8/maxresdefault.jpg`

Se você quiser usar uma imagem diferente, edite a variável `IMAGE_URL` no arquivo `start_stream.sh`.

### 2. Credenciais já configuradas

As credenciais já estão configuradas nos arquivos:
- **RTMP URL:** `rtmps://fa723fc1b171.global-contribute.live-video.net`
- **Stream Key:** `sk_us-west-2_JrOv7bsRKfT6_uZeIFjhDxq3YCo6FuTPvTwhfYj8Gfz`

## Deploy no Fly.io

### 1. Instale o Fly CLI

```bash
# Windows (PowerShell)
iwr https://fly.io/install.ps1 -useb | iex

# macOS/Linux
curl -L https://fly.io/install.sh | sh
```

### 2. Faça login no Fly.io

```bash
fly auth login
```

### 3. Deploy da aplicação

```bash
fly deploy
```

### 4. Verificar status

```bash
fly status
fly logs
```

**Pronto!** O sistema irá:
1. Baixar automaticamente a imagem da URL fornecida
2. Configurar o stream com suas credenciais
3. Transmitir a imagem em loop contínuo para a Kick

## Comandos Úteis

```bash
# Ver logs em tempo real
fly logs -f

# Reiniciar a aplicação
fly restart

# Parar a aplicação
fly stop

# Iniciar a aplicação
fly start

# Ver informações da aplicação
fly info
```

## Configurações do Stream

- **FPS**: 30 quadros por segundo
- **Bitrate**: 4000 kbps (4 Mbps)
- **Codec**: H.264 (libx264)
- **Formato**: FLV para RTMP
- **Loop**: Infinito da imagem estática

## Troubleshooting

### Stream não inicia
1. Verifique se as credenciais estão corretas
2. Confirme se a imagem `live_image.png` existe
3. Verifique os logs: `fly logs`

### Container para de funcionar
1. O Fly.io mantém o container ativo com `min_machines_running = 1`
2. Health checks verificam se o FFmpeg está rodando
3. Se houver problemas, o container reinicia automaticamente

### Problemas de conectividade
1. Verifique se a URL RTMP está correta
2. Confirme se a chave do stream é válida
3. Teste a conectividade: `fly ssh console`

## Estrutura do Projeto

```
.
├── Dockerfile              # Configuração do container
├── start_stream.sh         # Script principal do stream
├── fly.toml               # Configuração do Fly.io
├── config.env.example     # Exemplo de configuração
├── health_check.sh        # Health check
├── live_image.png         # Sua imagem (adicionar)
└── README.md              # Este arquivo
```

## Custos

O Fly.io oferece um plano gratuito com:
- 3 VMs compartilhadas
- 3GB de armazenamento
- 160GB de transferência por mês

Para uso contínuo 24/7, considere o plano pago.

## Suporte

Para problemas específicos:
1. Verifique os logs: `fly logs`
2. Consulte a documentação do Fly.io
3. Verifique as configurações da Kick
