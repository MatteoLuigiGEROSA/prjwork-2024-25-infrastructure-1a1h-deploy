#!/bin/bash

# -----------------------------------------------------------------------------
# DOCKERIZZAZIONE BACKEND + NGINX REVERSE PROXY (HTTPS)
# -----------------------------------------------------------------------------
#   Vers.:  LUN-31/03/2025
#   Auth.:  MatteoG (con supporto di ChatGPT)
#   Descr.: Crea Dockerfile e docker-compose.yml per multi-container (Flask+Nginx)
# -----------------------------------------------------------------------------

if [ ! -f "./nginx/conf.d/commonrestapi.conf" ]; then
    echo "ERRORE: NGINX non configurato. Esegui prima lo script preparatorio per la configurazione di NGINX."
    exit 1
fi

APP_DIR="$HOME/backend/CommonRestApi"
cd "$APP_DIR" || { echo "Errore: directory $APP_DIR non trovata"; exit 1; }

# Assicura che le directory volumi siano create e accessibili
mkdir -p creds logs nginx/conf.d certs/selfsigned
sudo chown -R "$USER:$USER" creds logs

# --------------------------------------------------
# CREAZIONE DOCKERFILE BACKEND
# --------------------------------------------------
echo "Creo Dockerfile per il backend Flask..."
cat <<EOF > Dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "--access-logfile", "/logs/access.log", "--error-logfile", "/logs/gunicorn-error.log", "app_controller:app"]
EOF

echo "Dockerfile creato con successo."

# --------------------------------------------------
# CREAZIONE docker-compose.yml MULTI-SERVIZIO
# --------------------------------------------------
echo "Creo docker-compose.yml (Flask + Nginx con HTTPS)..."
cat <<EOF > docker-compose.yml
version: '3.8'

services:
  commonrestapi:
    build: .
    container_name: commonrestapi
    ports:
      - "8000:8000"         # Esponi la porta del container sulla stessa porta del sistema host
    volumes:
      - ./logs:/logs        # La directory host "logs" viene mappata su "/logs" del container (volume persistente)
      - ./creds:/creds:ro   # La directory host "creds" viene mappata su "/creds" del container (volume persistente, read-only)
    environment:
      - PYTHONUNBUFFERED=1
    restart: unless-stopped
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "5"
    networks:
      - app-network

  nginx:
    image: nginx:latest
    container_name: nginx-reverse-proxy
    ports:
      - "443:443"
    volumes:
      - ./nginx:/etc/nginx:ro
      - ./certs/selfsigned:/etc/nginx/certs:ro
    depends_on:
      - commonrestapi
    restart: unless-stopped
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
EOF

echo "docker-compose.yml creato con successo."

echo "Avvio build multi-container..."
docker compose up -d --build

echo "Container avviati: commonrestapi + nginx-reverse-proxy"
echo "Per i log Nginx: docker logs -f nginx-reverse-proxy"
echo "Per i log backend: docker logs -f commonrestapi"
