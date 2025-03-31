# INSTALLAZIONE STEP-BY-STEP – INFRASTRUTTURA MRA-PAL

Questa guida descrive passo-passo la procedura per preparare un server Ubuntu 24.04 LTS
per ospitare il backend `CommonRestApi` tramite Docker, con NGINX come reverse proxy.

---

## ⚙️ FASE 0 – Clonazione repository di infrastruttura + installazione Git

📄 Script: `bash/a00-clone-infrastructure-deploy.sh`

1. Installa `git` se non presente
2. Clona il repository GitHub di infrastruttura nella directory `~/infrastructure-1a1h-deploy`

---

## 🧱 FASE 1 – Setup sistema base Ubuntu

📄 Script: `bash/a01-setup-ubuntu-system.sh`

Installa i pacchetti fondamentali per infrastruttura:

- `curl`, `git`, `ufw`, `htop`, `unzip`
- Docker Engine + Docker Compose
- Configura timezone Europa/Roma

---

## 🔄 FASE 2 – Post-reboot: aggiornamenti e pacchetti in phasing

📄 Script: `bash/a02-after-setup-ubuntu-system.sh`

- Verifica aggiornamenti rilasciati in “phasing”
- Esegue upgrade manuale per `openssh-*` e altri pacchetti differiti

---

## 🧰 FASE 3 – Inizializzazione backend (ambiente sviluppo)

📄 Script: `bash/a03-init-backend.sh`

1. Clona il repository `CommonRestApi` da GitHub
2. Crea virtualenv in `backend/CommonRestApi/venv`
3. Installa le dipendenze da `requirements.txt`
4. Crea directory `creds/` e assegna ownership a utente corrente
5. Crea directory `logs/` per log persistenti
6. Verifica presenza file `requirements.txt` generato da `pipreqs` (o equivalente)

---

## 🛡️ FASE 4 – Setup NGINX come reverse proxy (HTTPS in container)

📄 Script: `bash/a04-nginx-setup.sh`

1. Crea struttura `nginx/` con:
   - Config principale (`nginx.conf`)
   - Virtual host (`conf.d/commonrestapi.conf`)
2. Genera certificato self-signed in `certs/selfsigned/`
3. I file generati verranno montati nel container NGINX
4. Non avvia container, prepara solo i file

📎 Per dettagli → vedi `docs/nginx.md`

---

## 🐳 FASE 5 – Dockerizzazione backend + NGINX (multi-container)

📄 Script: `bash/a05-dockerize-backend.sh`

1. Genera `Dockerfile` per il backend con Flask + Gunicorn
2. Crea `docker-compose.yml` con:
   - Servizio `commonrestapi` (porta `8000`, volumi `logs/`, `creds/`)
   - Servizio `nginx-reverse-proxy` (porta `443`, volumi `nginx/`, `certs/selfsigned/`)
   - Rete condivisa tra container (`app-network`)
3. Builda ed esegue entrambi i container
4. Verifica funzionamento con:
   ```bash
   curl -k https://localhost/
   ```

---

## 📂 Struttura volumi

| Volume Host                 | Montato in Container       | Descrizione                            |
|----------------------------|----------------------------|----------------------------------------|
| `./logs/`                  | `/logs`                    | Log di Gunicorn: accessi + errori      |
| `./creds/`                 | `/creds` (read-only)       | File JSON delle credenziali Firebase   |
| `./nginx/`                 | `/etc/nginx`               | Configurazione NGINX custom            |
| `./certs/selfsigned/`      | `/etc/nginx/certs`         | Certificati self-signed per HTTPS      |

---

## 🪵 Logging Gunicorn e NGINX

- `logs/access.log`: log HTTP access
- `logs/gunicorn-error.log`: errori Gunicorn / runtime Python
- `/var/log/nginx/access.log`: log accessi NGINX (dentro container)
- `/var/log/nginx/error.log`: errori reverse proxy NGINX (dentro container)

📎 Per dettagli → vedi `docs/logging.md`

---

📌 Prossime fasi (in arrivo):

- `FASE 6` → Installazione WebSSH come container con reverse proxy
- `FASE 7` → Se possibile, certificati HTTPS reali con Let’s Encrypt + certbot Docker
- `FASE 8` → Monitoraggio + health-check + script diagnostici
- `FASE 9` → Deploy frontend Flask (MRA e PAL)
- `FASE 10` → Backup automatico credenziali + logs