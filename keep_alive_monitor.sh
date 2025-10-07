#!/bin/bash

# Script para manter instância Render ativa
# Execute este script em outro lugar para fazer ping na sua instância

INSTANCE_URL="https://kick-stream-live.onrender.com"

echo "=== Monitor de Keep-Alive para Render ==="
echo "URL: $INSTANCE_URL"
echo "Iniciando monitoramento..."

while true; do
    echo "$(date): Fazendo ping na instância..."
    
    # Fazer requisições para diferentes endpoints
    curl -s "$INSTANCE_URL/health" > /dev/null 2>&1
    curl -s "$INSTANCE_URL/keepalive" > /dev/null 2>&1
    curl -s "$INSTANCE_URL/" > /dev/null 2>&1
    
    echo "$(date): Ping realizado com sucesso"
    sleep 300  # Ping a cada 5 minutos
done
