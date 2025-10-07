#!/bin/bash

echo "=== Iniciando Serviços do Stream Kick no Render ==="
echo "Data/Hora: $(date)"

# Função para capturar sinais e fazer cleanup
cleanup() {
    echo "Recebido sinal de parada. Fazendo cleanup..."
    kill $STREAM_PID $HEALTH_PID 2>/dev/null
    wait
    exit 0
}

# Configurar trap para sinais
trap cleanup SIGTERM SIGINT

# Iniciar servidor de health check em background
echo "Iniciando servidor de health check..."
python3 /app/health_server_render.py &
HEALTH_PID=$!

# Aguardar um pouco para o servidor de health inicializar
sleep 5

# Verificar se o health server está funcionando
echo "Verificando health server..."
curl -s http://localhost:${PORT:-8080}/health || echo "Health server não respondeu"

# Iniciar o stream
echo "Iniciando stream..."
/app/start_stream_render.sh &
STREAM_PID=$!

echo "Serviços iniciados:"
echo "- Health Server PID: $HEALTH_PID"
echo "- Stream PID: $STREAM_PID"

# Aguardar que ambos os processos terminem
wait $STREAM_PID $HEALTH_PID
