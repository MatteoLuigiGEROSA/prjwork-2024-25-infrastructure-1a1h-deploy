# -----------------------------------------------------------------------------
# BOOTSTRAP INFRASTRUTTURA - Clona repository di deploy
# -----------------------------------------------------------------------------
#   Vers.:  DOM-30/03/2025
#   Auth.:  MatteoG (con supporto di ChatGPT)
#   Descr.: Installa git (se mancante) e clona il repository da GitHub
# -----------------------------------------------------------------------------

#!/bin/bash

REPO_URL="https://github.com/MatteoLuigiGEROSA/prjwork-2024-25-infrastructure-1a1h-deploy.git"
REPO_ROOT_DIR="infrastructure-1a1h-deploy"
DEST_DIR="$HOME/$REPO_ROOT_DIR"

echo "Verifico presenza del tool Git..."
if ! command -v git &> /dev/null; then
    echo "Tool Git non trovato, procedo con l'installazione..."
    sudo apt update && sudo apt install -y git
else
    echo "Tool Git già installato."
fi

echo "Controllo se la cartella $DEST_DIR esiste già..."
if [ -d "$DEST_DIR" ]; then
    echo "Directory già esistente. Vuoi aggiornare il repository? [s/N]"
    read -r conferma
    if [[ "$conferma" =~ ^[sS]$ ]]; then
        cd "$DEST_DIR" || { echo "Errore: impossibile accedere a $DEST_DIR"; exit 1; }
        git pull
    else
        echo "Clonazione saltata. Il repository esiste già in: $DEST_DIR"
        exit 0
    fi
else
    echo "Procedo con la clonazione del repository nella home dell'utente come: $DEST_DIR"
    cd "$HOME"
    git clone "$REPO_URL" "$REPO_ROOT_DIR"
fi

echo "Repository clonato correttamente in: $DEST_DIR"
