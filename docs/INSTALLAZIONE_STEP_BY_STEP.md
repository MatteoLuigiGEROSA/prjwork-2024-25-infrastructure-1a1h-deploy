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

---

## 🛡️ FASE 4 – Setup NGINX come reverse proxy (HTTPS in container)

📄 Script: `bash/a03b-nginx-setup.sh`

1. Crea struttura `nginx/` con:
   - Config principale (`nginx.conf`)
   - Virtual host (`conf.d/commonrestapi.conf`)
2. Genera certificato self-signed in `certs/selfsigned/`
3. I file generati verranno montati nel container NGINX

---

## 🐳 FASE 5 – Dockerizzazione backend + NGINX (multi-container)

📄 Script: `bash/a03c-dockerize-backend.sh`

1. Genera `Dockerfile` per il backend con Flask + Gunicorn
2. Crea `docker-compose.yml` con:
   - Servizio `commonrestapi` (porta `8000`, volumi `logs/`, `creds/`)
   - Servizio `nginx-proxy` (porta `443`, volumi `nginx/`, `certs/selfsigned/`)
   - Rete condivisa tra container
3. Builda ed esegue entrambi i container

---

## 📂 Struttura volumi

| Volume Host                 | Montato in Container | Descrizione                            |
|----------------------------|----------------------|----------------------------------------|
| `./logs/`                  | `/logs`              | Log di Gunicorn: accessi + errori      |
| `./creds/`                 | `/creds` (read-only) | File JSON delle credenziali Firebase   |
| `./nginx/`                 | `/etc/nginx`         | Configurazione NGINX custom            |
| `./certs/selfsigned/`      | `/etc/nginx/certs`   | Certificati self-signed per HTTPS      |

---

## 🪵 Logging Gunicorn e NGINX

- `logs/access.log`: log HTTP access
- `logs/gunicorn-error.log`: errori Gunicorn / runtime Python
- `/var/log/nginx/access.log`: log accessi NGINX (dentro container)
- `/var/log/nginx/error.log`: errori reverse proxy NGINX (dentro container)

📎 Per dettagli → vedi `docs/logging.md`

---

📌 Prossime fasi (in arrivo):
- `FASE 6` → Installazione WebSSH con reverse proxy
- `FASE 7` → HTTPS con Let’s Encrypt
- `FASE 8` → Monitoraggio + health-check
- `FASE 9` → Deploy frontend Flask (MRA e PAL)
