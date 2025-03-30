# -----------------------------------------------------------------------------
# CONFIGURAZIONE NGINX + REVERSE PROXY HTTPS PER CommonRestApi
# -----------------------------------------------------------------------------
#   Vers.:  DOM-31/03/2025
#   Auth.:  MatteoG (con supporto di ChatGPT)
#   Descr.: Installa Nginx, crea certificati self-signed, configura reverse proxy
# -----------------------------------------------------------------------------

#!/bin/bash

DOMAIN_NAME="matger-ubt-svr01.westeurope.cloudapp.azure.com"
APP_PORT=8000
NGINX_CONF="/etc/nginx/sites-available/commonrestapi"
CERT_DIR="/etc/ssl/commonrestapi"

# Installazione NGINX se non presente
if ! command -v nginx &> /dev/null; then
  echo "Nginx non installato. Procedo con installazione..."
  sudo apt update && sudo apt install -y nginx
else
  echo "Nginx è già installato."
fi

# Creazione certificati SSL self-signed
echo "Creo certificati self-signed in $CERT_DIR..."
sudo mkdir -p "$CERT_DIR"
sudo openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout "$CERT_DIR/server.key" \
  -out "$CERT_DIR/server.crt" \
  -subj "/CN=$DOMAIN_NAME"

# Creazione file di configurazione Nginx
echo "Creo file virtual host per HTTPS reverse proxy..."
sudo tee "$NGINX_CONF" > /dev/null <<EOF
server {
    listen 443 ssl;
    server_name $DOMAIN_NAME;

    ssl_certificate     $CERT_DIR/server.crt;
    ssl_certificate_key $CERT_DIR/server.key;

    location / {
        proxy_pass         http://127.0.0.1:$APP_PORT;
        proxy_http_version 1.1;
        proxy_set_header   Host \$host;
        proxy_set_header   X-Real-IP \$remote_addr;
        proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto \$scheme;
    }
}
EOF

# Abilitazione configurazione Nginx
sudo ln -sf "$NGINX_CONF" /etc/nginx/sites-enabled/commonrestapi

# Verifica sintassi NGINX
sudo nginx -t && \
  echo "Reload Nginx con nuova configurazione..." && \
  sudo systemctl reload nginx

echo "Nginx configurato. HTTPS reverse proxy attivo su https://$DOMAIN_NAME"
