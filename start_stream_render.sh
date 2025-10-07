#!/bin/bash

echo "=== Servidor de Mídia Kick - Stream Contínuo 100% ==="
echo "Iniciando em: $(date)"

# Configurações - usando variáveis de ambiente do Render
RTMP_URL="${RTMP_URL:-rtmps://fa723fc1b171.global-contribute.live-video.net}"
STREAM_KEY="${STREAM_KEY:-sk_us-west-2_EjKsW9ogmEwb_1HyG6woK3Z95jdOJfLAYjPxSCvn8p7}"
IMAGE_PATH="/app/live_image.png"
FPS="${FPS:-30}"
BITRATE="${BITRATE:-4000k}"
RETRY_DELAY=5
MAX_RETRIES=1000

# URL completa - CORRIGIDA com /app/ antes da chave
FULL_RTMP_URL="${RTMP_URL}/app/${STREAM_KEY}"

echo "Configurações:"
echo "- URL: $RTMP_URL"
echo "- Stream Key: $STREAM_KEY"
echo "- FPS: $FPS"
echo "- Bitrate: $BITRATE"
echo "- Imagem: $IMAGE_PATH"
echo "- Retry Delay: ${RETRY_DELAY}s"

# Verificar se a imagem existe
if [ ! -f "$IMAGE_PATH" ]; then
    echo "ERRO: Imagem não encontrada em $IMAGE_PATH"
    ls -la /app/
    exit 1
fi

echo "Imagem encontrada: $(ls -la $IMAGE_PATH)"

# Verificar FFmpeg
echo "Verificando FFmpeg..."
ffmpeg -version | head -3

echo "Iniciando stream..."
echo "URL completa: $FULL_RTMP_URL"

# Função para manter a máquina ativa
keep_alive() {
    while true; do
        echo "$(date): Heartbeat - Sistema ativo"
        sleep 15
    done
}

# Iniciar heartbeat em background
keep_alive &
HEARTBEAT_PID=$!

# Contador de tentativas
ATTEMPT=1

# Loop infinito para manter o container ativo
while [ $ATTEMPT -le $MAX_RETRIES ]; do
    echo "=== Tentativa $ATTEMPT/$MAX_RETRIES em: $(date) ==="
    
    # Comando FFmpeg para stream contínuo (sem timeout)
    ffmpeg \
        -re \
        -loop 1 \
        -i "$IMAGE_PATH" \
        -c:v libx264 \
        -tune stillimage \
        -preset ultrafast \
        -pix_fmt yuv420p \
        -r $FPS \
        -g 60 \
        -b:v $BITRATE \
        -maxrate $BITRATE \
        -bufsize 8000k \
        -f flv \
        "$FULL_RTMP_URL" \
        -y \
        -loglevel warning \
        -fflags +genpts \
        -avoid_negative_ts make_zero
    
    EXIT_CODE=$?
    
    if [ $EXIT_CODE -eq 0 ]; then
        echo "Stream terminou normalmente"
    else
        echo "Stream falhou com código: $EXIT_CODE - reconectando..."
    fi
    
    echo "Aguardando ${RETRY_DELAY} segundos antes da próxima tentativa..."
    sleep $RETRY_DELAY
    
    ATTEMPT=$((ATTEMPT + 1))
done

echo "Máximo de tentativas atingido. Reiniciando processo..."
kill $HEARTBEAT_PID 2>/dev/null
exit 1
