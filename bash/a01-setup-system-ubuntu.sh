#!/bin/bash

# -----------------------------------------------------------------------------
# SETUP SISTEMA BASE UBUNTU SERVER 24.04 LTS
# -----------------------------------------------------------------------------
#   Vers.:  SAB-29/03/2025
#   Auth.:  MatteoG (con supporto di ChatGPT)
#   Descr.: Installa i pacchetti fondamentali per lo stack backend
# -----------------------------------------------------------------------------

echo "Avvio installazione dei pacchetti di base..."

# Aggiorna il sistema
sudo apt update && sudo apt upgrade -y

# Installa pacchetti fondamentali
sudo apt install -y \
    git \
    curl \
    wget \
    unzip \
    python3 \
    python3-pip \
    python3-venv \
    ca-certificates \
    gnupg \
    lsb-release

# Installazione Docker (via script ufficiale Docker)
echo "Installazione Docker..."

sudo apt remove docker docker-engine docker.io containerd runc -y
sudo apt install -y ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Abilita e avvia Docker
sudo systemctl enable docker
sudo systemctl start docker

# Aggiungi utente corrente al gruppo docker
sudo usermod -aG docker $USER

# Verifica installazione Docker
docker --version
docker compose version

# Prepara la cartella WebSSH
echo "📁 Preparo directory base per WebSSH in /opt/webssh"
sudo mkdir -p /opt/webssh
sudo chown -R $USER:$USER /opt/webssh

echo "Imposto il fuso orario su Europe/Rome..."
sudo timedatectl set-timezone Europe/Rome

# Verifica puntuale dell'attuale orario del sistema:
echo "Verifica puntuale di data/orario e fuso-orario di Sistema..."
sudo timedatectl

echo "Setup completato. È consigliato riavviare la macchina o fare logout/login per abilitare Docker senza necessità di impersonificazione sudo."
