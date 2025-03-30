# -----------------------------------------------------------------------------
# BOOTSTRAP INFRASTRUTTURA - Clona repository di deploy
# -----------------------------------------------------------------------------
#   Vers.:  DOM-30/03/2025
#   Auth.:  MatteoG (con supporto di ChatGPT)
#   Descr.: Installa git (se mancante) e clona il repository da GitHub
# -----------------------------------------------------------------------------

#!/bin/bash

REPO_URL="https://github.com/MatteoLuigiGEROSA/prjwork-2024-25-infrastructure-1a1h-deploy.git"
DEST_DIR="$HOME/infrastructure-1a1h-deploy"

echo "Verifico presenza di Git..."
if ! command -v git &> /dev/null; then
    echo "📦 Git non trovato, procedo con l'installazione..."
    sudo apt update && sudo apt install -y git
else
    echo "Git già installato."
fi

echo "Controllo se la cartella $DEST_DIR esiste già..."
if [ -d "$DEST_DIR" ]; then
    echo "Directory già esistente. Vuoi aggiornare il repository? [s/N]"
    read -r conferma
    if [[ "$conferma" =~ ^[sS]$ ]]; then
        cd "$DEST_DIR" && git pull
    else
        echo "Clonazione saltata. Il repository esiste già in: $DEST_DIR"
        exit 0
    fi
else
    echo "Procedo a clonare il repository nella home dell'utente..."
    cd "$HOME"
    git clone "$REPO_URL"
fi

echo "Repository clonato correttamente in: $DEST_DIR"
