#!/bin/bash

# -----------------------------------------------------------------------------
# CONFIGURAZIONE NGINX IN CONTAINER (Docker Reverse Proxy con HTTPS)
# -----------------------------------------------------------------------------
#   Vers.:  LUN-31/03/2025
#   Auth.:  MatteoG (con supporto di ChatGPT)
#   Descr.: Prepara configurazione per NGINX in container (no installazione host)
# -----------------------------------------------------------------------------

# DEFINIZIONE: directory dell'applicazione backend
APP_DIR="$HOME/backend/CommonRestApi"
cd "$APP_DIR" || { echo "Errore: directory $APP_DIR non trovata"; exit 1; }

# 1. Prepara struttura NGINX per reverse proxy in Docker
NGINX_DIR="$APP_DIR/nginx"
CONF_DIR="$NGINX_DIR/conf.d"
CERT_DIR="$APP_DIR/certs/selfsigned"

mkdir -p "$CONF_DIR"
mkdir -p "$CERT_DIR"

# 2. Configurazione principale NGINX
cat <<EOF > "$NGINX_DIR/nginx.conf"
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    keepalive_timeout  65;

    include /etc/nginx/conf.d/*.conf;
}
EOF

# 3. Configurazione virtual host HTTPS
cat <<EOF > "$CONF_DIR/commonrestapi.conf"
server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate     /etc/ssl/certs/fullchain.pem;
    ssl_certificate_key /etc/ssl/certs/privkey.pem;

    location / {
        proxy_pass         http://commonrestapi:8000;
        proxy_http_version 1.1;
        proxy_set_header   Host \$host;
        proxy_set_header   X-Real-IP \$remote_addr;
        proxy_set_header   X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto \$scheme;
    }
}
EOF

# 4. Genera certificato self-signed per test
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$CERT_DIR/privkey.pem" \
  -out "$CERT_DIR/fullchain.pem" \
  -subj "/C=IT/ST=Lombardia/L=Meda/O=CFP-Terragni/CN=localhost"

# 5. Notifica utente
echo "Configurazione NGINX per container completata. I file sono in:"
echo "  - $NGINX_DIR/nginx.conf"
echo "  - $CONF_DIR/commonrestapi.conf"
echo "  - Certificati SSL in $CERT_DIR"
echo "Procedi ora con l'aggiornamento del docker-compose.yml per includere il servizio nginx."
