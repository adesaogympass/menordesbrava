#!/usr/bin/env python3
"""
Servidor HTTP simples para health checks do Render
Mantém a máquina ativa respondendo a requisições de health check
"""

import http.server
import socketserver
import threading
import time
import os
import socket
from datetime import datetime

class HealthHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            response = f"OK - {datetime.now().isoformat()}"
            self.wfile.write(response.encode())
        elif self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            html = """
            <!DOCTYPE html>
            <html>
            <head>
                <title>Kick Stream Live</title>
                <meta charset="utf-8">
                <meta http-equiv="refresh" content="30">
            </head>
            <body>
                <h1>🎥 Kick Stream Live</h1>
                <p>Stream ativo desde: {}</p>
                <p>Status: ✅ Online</p>
                <p>Health Check: <a href="/health">/health</a></p>
                <p>Keep Alive: <a href="/keepalive">/keepalive</a></p>
                <script>
                    // Auto-refresh para manter ativo
                    setInterval(function() {{
                        fetch('/keepalive');
                    }}, 30000);
                </script>
            </body>
            </html>
            """.format(datetime.now().isoformat())
            self.wfile.write(html.encode())
        elif self.path == '/keepalive':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            response = f"KEEPALIVE - {datetime.now().isoformat()}"
            self.wfile.write(response.encode())
        else:
            self.send_response(404)
            self.end_headers()
    
    def log_message(self, format, *args):
        # Suprimir logs de acesso para reduzir ruído
        pass

def start_health_server():
    """Inicia o servidor de health check na porta do Render"""
    PORT = int(os.environ.get('PORT', 8080))
    
    # Configurar para manter conexões vivas
    class KeepAliveTCPServer(socketserver.TCPServer):
        allow_reuse_address = True
        def server_bind(self):
            self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            super().server_bind()
    
    with KeepAliveTCPServer(("", PORT), HealthHandler) as httpd:
        print(f"Health server iniciado na porta {PORT}")
        print("Servidor configurado para manter instância ativa")
        httpd.serve_forever()

def main():
    """Função principal - inicia o servidor de health check"""
    try:
        start_health_server()
    except Exception as e:
        print(f"Erro no servidor de health: {e}")
        # Se falhar, não impede o stream de continuar
        pass

if __name__ == "__main__":
    main()
