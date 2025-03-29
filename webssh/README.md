
# WebSSH – Accesso Shell via Browser (porta 8443)

Questa directory contiene tutti i file necessari a installare, configurare e documentare l'accesso SSH via browser attraverso **WebSSH** per i server Linux (BE e FE) del progetto MRA-PAL.

## 📌 Funzione
WebSSH permette di accedere alla shell dei server direttamente via browser (HTTPS), utile per:
- Debug
- Accesso remoto semplificato
- Dimostrazioni didattiche

## 🧱 Componenti installati

- **Python + venv**
- **webssh** (installato in virtualenv dedicato)
- **Nginx** come reverse proxy HTTPS sulla porta **8443**
- **Certificati SSL** (auto-firmati, collocati in `/opt/webssh`)

## 📂 Struttura

- `nginx/webssh.conf` – Configurazione Nginx per il reverse proxy
- `scripts/install-webssh.sh` – Script automatico per installare WebSSH
- `scripts/create-cert-selfsigned.sh` – Script per creare certificati SSL auto-firmati
- `docs/webssh-timeout.md` – Guida per aumentare i timeout di sessione

## 🔒 Sicurezza

- L'accesso è disponibile solo via **HTTPS**
- L'accesso può essere limitato con firewall o IP whitelist
- La connessione interna a `ssh` richiede utente autorizzato e configurato sul server
