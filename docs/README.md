
# Progetto Deploy Infrastruttura MRA-PAL – Classe 1A1H (2024/25)

Questo repository contiene tutto il materiale necessario per **installare, configurare e documentare** l'infrastruttura completa del Project-work **MRA-PAL** (*Misuratore Riflessi Atleti* e *Passaggio A Livello*), ideata per l'A.S. 2024-25 a scopo didattico presso il Centro Formazione Professionale **CFP G.Terragni di Meda**, specializzaz. *Oreratore Informatico*.

## 🎯 Scopo del repository

Offrire agli studenti di prima superiore un progetto reale e guidato per imparare:

- Le basi dello sviluppo e deploy di **applicazioni web Flask**
- Le basi dell'Architettura **multiple-layers**, con suddivisione dei sistemi a livelli multipli separati per:
  1. i moduli *frontend/web*,
  2. i moduli *backend/REST-API*,
  3. i moduli *eis/database* (External Information Systems, compresi Database e Web-Service di Terze Parti)
- La configurazione di un'infrastruttura **server-side professionale**
- L'utilizzo di tecnologie moderne come **Docker**, **Gunicorn**, **Nginx**, **JWT**, **Postman**, e altro
- I concetti fondamentali della **programmazione di backend**, **sistemistica Linux**, **sicurezza** e **monitoraggio**

Il progetto è strutturato per essere **riproducibile da zero**, con istruzioni passo-passo, script di installazione automatizzati e una documentazione (auspicabilmente) curata in stile didattico.

**Ovviamente, obiettivo a massima priorità è quello di rendere ogni singola/singolo Studente in grado di poter agevolmente contribuire di persona a tutto quanto qui presente.**

---

## 🧱 Componenti principali dell’infrastruttura

| Componente       | Funzione                                                                 |
|------------------|--------------------------------------------------------------------------|
| **Flask**        | Framework Python per costruire le web application (API e frontend)       |
| **Gunicorn**     | Server WSGI per esporre le app Flask in produzione                      |
| **Nginx**        | Reverse proxy HTTP/HTTPS, bilanciamento e gestione dei certificati       |
| **Docker**       | Contenitori per isolare ogni componente in ambienti separati             |
| **Docker Compose** | Orchestrazione dei container e dei servizi                            |
| **JWT**          | Sistema di autenticazione sicuro basato su token                        |
| **Postman**      | Strumento per testare manualmente le API REST                           |
| **Script Bash**  | Automazione dell’installazione e del deploy dell’intera infrastruttura  |
| **Certbot/SSL**  | Protezione HTTPS tramite certificati auto-firmati o Let's Encrypt       |
| **Monitoring**   | Verifica dello stato e raccolta log di backend, frontend e reverse proxy|

---

## 🗂️ Organizzazione del repository

Il repository è suddiviso logicamente in cartelle:

- `docker/` – Configurazioni Docker (BE, FE-MRA, FE-PAL)
- `bash/` – Script bash per installazione e provisioning automatico
- `certs/` – Certificati SSL (self-signed o Let’s Encrypt)
- `monitoring/` – Script di health check e visualizzazione dei log
- `test-harness/` – Collezioni Postman e futuri script di test automatici
- `docs/` – Documentazione tecnica, guide didattiche e approfondimenti
- `.gitignore` – File per escludere cartelle locali o file temporanei

---

## 👩‍🏫 Finalità didattiche

Questo progetto è pensato per essere uno **strumento didattico concreto**, per mostrare agli studenti:

- Come si costruisce e si distribuisce una web app nel mondo reale
- Come si configura un’infrastruttura server moderna, accessibile via browser
- Come funziona un flusso API sicuro con autenticazione JWT
- Come si interagisce con un server Linux in cloud

Tutti i file sono commentati e le guide sono pensate per essere lette, comprese e modificate dagli studenti.

---

## 🔗 Repository GitHub

📌 https://github.com/MatteoLuigiGEROSA/prjwork-2024-25-infrastructure-1a1h-deploy

---

> Progetto a cura degli Alunni delle Classi Prima-A e Prima-H A.S. 2024-25 e dei proff. Matteo Luigi Gerosa, Matteo Serratoni e Marco Bovinelli, pensato per supportare il percorso di apprendimento tecnico degli Studenti. 🚀
