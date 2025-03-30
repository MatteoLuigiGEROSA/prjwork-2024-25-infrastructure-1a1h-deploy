# -----------------------------------------------------------------------------
# DOCKERIZZAZIONE BACKEND: CommonRestApi (Flask + Gunicorn + Docker + Volumi)
# -----------------------------------------------------------------------------
#   Vers.:  DOM-30/03/2025
#   Auth.:  MatteoG (con supporto di ChatGPT)
#   Descr.: Crea Dockerfile, configura logging + volume persistente, avvia container
# -----------------------------------------------------------------------------

#!/bin/bash

# DEFINIZIONE: directory dell'applicazione backend
APP_DIR="$HOME/backend/CommonRestApi"
cd "$APP_DIR" || { echo "Errore: directory $APP_DIR non trovata"; exit 1; }

echo "Creo Dockerfile per il backend Flask..."

cat <<EOF > Dockerfile
# Base image ufficiale Python
FROM python:3.12-slim

# Imposta directory di lavoro nel container
WORKDIR /app

# Copia file di requirements e installa dipendenze
COPY requirements.txt .

# Installa dipendenze (senza cache, più sicuro)
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copia tutto il contenuto dell'app nella directory di lavoro
COPY . .

# Comando default: avvia Gunicorn (WSGI server) sulla porta 8000
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "--access-logfile", "/logs/access.log", "--error-logfile", "/logs/gunicorn-error.log", "app_controller:app"]

EOF

echo "Dockerfile creato con successo."

echo "Creo file docker-compose.yml con supporto a logging + volume persistente..."

cat <<EOF > docker-compose.yml
version: '3.8'

services:
  backend:
    build: .
    container_name: commonrestapi
    ports:
      - "8000:8000"  # Esponi la porta del container sulla stessa porta del sistema host
    volumes:
      - ./logs:/logs             # La directory host "logs" viene mappata su "/logs" del container (volume persistente)
      - ./creds:/creds:ro        # La directory host "creds" viene mappata su "/creds" del container (volume persistente, read-only)
    environment:
      - PYTHONUNBUFFERED=1
    restart: unless-stopped
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "5"
EOF

echo "Creo directory locale per i log se non esiste..."
mkdir -p logs

echo "Creo directory locale per le credenziali se non esiste..."
mkdir -p creds
sudo chown "$USER:$USER" creds

echo "Avvio build e container Docker in background..."

docker compose up -d --build

echo "Container avviato con nome: commonrestapi"
echo "Per vedere i log: docker logs -f commonrestapi"
