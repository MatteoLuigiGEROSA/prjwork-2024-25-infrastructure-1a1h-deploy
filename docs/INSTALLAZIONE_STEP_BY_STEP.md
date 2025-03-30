# INSTALLAZIONE STEP-BY-STEP – INFRASTRUTTURA MRA-PAL

Questa guida descrive passo-passo la procedura per preparare un server Ubuntu 24.04 LTS
per ospitare il backend `CommonRestApi` su Docker + Gunicorn + Flask.

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

## 🧰 FASE 3 – Inizializzazione backend (sviluppo)

📄 Script: `bash/a03-init-backend.sh`

1. Clona il repository `CommonRestApi` da GitHub
2. Crea virtualenv in `backend/CommonRestApi/venv`
3. Installa le dipendenze da `requirements.txt`
   (uso in ambiente di sviluppo non containerizzato)

---

## 🐳 FASE 3B – Dockerizzazione backend Flask + Gunicorn

📄 Script: `bash/a03b-dockerize-backend.sh`

1. Genera `Dockerfile` con:
   - Python 3.12 slim
   - Installazione da `requirements.txt`
   - Avvio Gunicorn
2. Genera `docker-compose.yml` con:
   - Porta `8000:8000`
   - Volume `/logs` persistente
   - Volume `/creds` in sola lettura
3. Builda e avvia il container Docker `commonrestapi`

---

## 📂 Struttura volumi

| Volume Host                 | Montato in Container | Descrizione                            |
|----------------------------|----------------------|----------------------------------------|
| `./logs/`                  | `/logs`              | Contiene i file `access.log` e `gunicorn-error.log` |
| `./creds/`                 | `/creds` (read-only) | File JSON delle credenziali Firebase   |

---

## 🪵 Logging Gunicorn

Durante la creazione del container backend, Gunicorn è configurato per scrivere i log in due file distinti:

- `logs/access.log`: log standard HTTP (accessi)
- `logs/gunicorn-error.log`: errori runtime, crash di worker, eccezioni Python

I file sono persistenti nel volume `./logs` mappato dal file `docker-compose.yml`.
Puoi consultarli direttamente nella directory `backend/CommonRestApi/logs/`.

📎 Per dettagli completi → vedi `docs/logging.md`

---

📌 Prossime fasi (in arrivo):
- `FASE 10` → Installazione WebSSH con reverse proxy su porta 8443
- `FASE 20` → Configurazione Nginx + HTTPS con reverse proxy verso Gunicorn
- `FASE 30` → Monitoraggio + health-check script + log viewer centralizzato

