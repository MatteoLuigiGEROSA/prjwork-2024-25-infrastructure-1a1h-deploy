# -----------------------------------------------------------------------------
# INIZIALIZZAZIONE BACKEND: CommonRestApi (Flask + virtualenv)
# -----------------------------------------------------------------------------
#   Vers.:  DOM-30/03/2025
#   Auth.:  MatteoG (con supporto di ChatGPT)
#   Descr.: Clona il repository CommonRestApi e prepara ambiente virtuale
# -----------------------------------------------------------------------------

#!/bin/bash

echo "Clonazione repository backend CommonRestApi da GitHub..."

# Imposta la directory di destinazione
APP_DIR="$HOME/backend/CommonRestApi"

# Clona il repository se non esiste già
if [ ! -d "$APP_DIR" ]; then
    mkdir -p "$HOME/backend"
    cd "$HOME/backend"
    git clone https://github.com/MatteoLuigiGEROSA/prjwork-2024-25-1a1h-common-rest-api.git CommonRestApi
else
    echo "Repository già presente in $APP_DIR, salto clonazione."
fi

cd "$APP_DIR"

# Crea virtualenv se non esiste
if [ ! -d "venv" ]; then
    echo "Creo virtualenv Python..."
    python3 -m venv venv
fi

# Attiva virtualenv e installa dipendenze
source venv/bin/activate
echo "Installazione dipendenze da requirements.txt..."
pip install --upgrade pip
pip install -r requirements.txt
deactivate

echo "Backend pronto (non containerizzato)."

