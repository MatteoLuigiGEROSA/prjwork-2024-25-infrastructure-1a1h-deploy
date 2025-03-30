#!/bin/bash

# -----------------------------------------------------------------------------
# FASE POST-INSTALLAZIONE BACKEND UBUNTU SERVER
# -----------------------------------------------------------------------------
#   Vers.:  SAB-29/03/2025
#   Auth.:  MatteoG (con supporto di ChatGPT)
#   Descr.: Esegue aggiornamenti mirati dopo il primo reboot
# -----------------------------------------------------------------------------

echo "Avvio aggiornamento dinamico di pacchetti in phasing (post-reboot)..."

# Aggiorna la cache dei pacchetti
sudo apt update

# Trova tutti i pacchetti aggiornabili e li forza con --only-upgrade
sudo apt list --upgradable 2>/dev/null | awk -F/ '/\/noble/ {print $1}' | xargs sudo apt install --only-upgrade -y

echo "Aggiornamento completato. Nessun reboot richiesto."
