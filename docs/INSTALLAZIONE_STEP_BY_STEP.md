# INSTALLAZIONE STEP-BY-STEP – INFRASTRUTTURA MRA-PAL


---

## 🐳 Fase 3B – Dockerizzazione del Backend (`a03b-dockerize-backend.sh`)

Questa fase costruisce il container Docker per la web-app `CommonRestApi`, completa di:
- Server WSGI **Gunicorn**
- Dockerfile personalizzato
- Volume persistente per i log
- docker-compose per semplificare il deploy

### ✅ Come eseguire:

```bash
cd ~/infrastructure-1a1h-deploy/bash
chmod +x a03b-dockerize-backend.sh
./a03b-dockerize-backend.sh
```

### 🔧 Dipendenze (nel file `requirements.txt` della web-app):

```txt
Flask>=2.3.0
gunicorn>=21.2.0
```

📌 Anche se usi `flask run` in sviluppo, la presenza di `gunicorn` **non interferisce**:
può convivere nel virtualenv e viene usato solo in produzione (es. con Docker).

---

### 📁 File generati:

- `Dockerfile`: definisce l'immagine Python + app
- `docker-compose.yml`: gestisce build, porte, volumi e logging
- `logs/`: directory persistente per i log del container

