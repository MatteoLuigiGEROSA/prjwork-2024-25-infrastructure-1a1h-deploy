# INSTALLAZIONE STEP-BY-STEP – INFRASTRUTTURA MRA-PAL

Questa guida descrive l'intera procedura per configurare da zero un server Ubuntu 24.04 LTS per ospitare il backend del progetto MRA-PAL.

---

## 🧩 Fase 0 – Clonazione del repository di installazione

Lo script `a00-clone-infrastructure-deploy.sh` è pensato per essere il **primo file da copiare su una macchina Ubuntu** appena creata.
Installa Git (se assente) e clona il repository di deploy.

### ✅ Come eseguire:

```bash
chmod +x a00-clone-infrastructure-deploy.sh
./a00-clone-infrastructure-deploy.sh
```

📦 Clonerà il repository da GitHub nel path `~/infrastructure-1a1h-deploy`
📁 La directory risultante sarà forzatamente: `~/infrastructure-1a1h-deploy`

---

## 🛠️ Fase 1 – Setup iniziale con `a01-setup-ubuntu-system.sh`

Questo script esegue il setup completo del sistema operativo Ubuntu 24.04 LTS per il backend del progetto.
Include l’installazione di tutti i pacchetti fondamentali, Docker, Docker Compose, timezone e directory per WebSSH.

### ✅ Cosa installa:

- Strumenti di base: `git`, `curl`, `wget`, `python3`, `pip`, `venv`, ecc.
- Docker CE e plugin ufficiale Docker Compose
- Configura il fuso orario in automatico su `Europe/Rome`
- Crea la cartella base per WebSSH in `/opt/webssh`

### 🚀 Come eseguirlo:

```bash
cd ~/infrastructure-1a1h-deploy/bash
chmod +x a01-setup-ubuntu-system.sh
./a01-setup-ubuntu-system.sh
```

📌 Al termine viene consigliato un **reboot della macchina** o almeno un logout/login per attivare Docker senza `sudo`.

---

## 🧩 Fase 2 – Script post-reboot: `a02-after-setup-ubuntu-system.sh`

Dopo il reboot è consigliato eseguire questo script per aggiornare pacchetti che potrebbero essere soggetti a phasing.

### ✅ Come eseguire:

```bash
cd ~/infrastructure-1a1h-deploy/bash
chmod +x a02-after-setup-ubuntu-system.sh
./a02-after-setup-ubuntu-system.sh
```

### 📦 Cosa fa:

- Aggiorna la cache pacchetti (`apt update`)
- Identifica automaticamente i pacchetti aggiornabili (anche se in phasing)
- Li installa forzando l'upgrade in modo sicuro (`--only-upgrade`)
- Nessun reboot richiesto dopo l’esecuzione

---

## ⚙️ Fase 3 – Inizializzazione del Backend (CommonRestApi)

Questo script clona il repository del backend, crea un ambiente virtuale Python e installa le dipendenze di sviluppo per testare la CommonRestApi **fuori da Docker**.

### ✅ Come eseguire:

```bash
cd ~/infrastructure-1a1h-deploy/bash
chmod +x a03-init-backend.sh
./a03-init-backend.sh
```

### 📂 Cosa fa:

- Clona da GitHub: `https://github.com/MatteoLuigiGEROSA/prjwork-2024-25-1a1h-common-rest-api`
- Crea virtualenv nella directory `venv/`
- Installa pacchetti da `requirements.txt`
- Pronto per l'uso in modalità sviluppo/test

➡️ Il backend non è ancora containerizzato: questo passo serve per verifiche locali.
Prossimo step: `a03b-dockerize-backend.sh` per esecuzione in produzione.

