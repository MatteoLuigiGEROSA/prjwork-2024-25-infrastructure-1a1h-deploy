# Documentazione NGINX Reverse Proxy (Container Docker)

Questa guida descrive la configurazione di **NGINX in container Docker** per fungere da reverse proxy HTTPS al backend Flask servito da Gunicorn.

---

## ⚖️ Obiettivo

Esporre in HTTPS (porta 443) l'applicazione `CommonRestApi` (in ascolto sulla porta 8000 del container) tramite **NGINX in container**, sfruttando un certificato SSL self-signed.

---

## 📁 Struttura delle directory

    backend/CommonRestApi/
    ├── nginx/
    │   ├── nginx.conf              → Configurazione principale NGINX
    │   └── conf.d/
    │       └── commonrestapi.conf   → Virtual host HTTPS (porta 443)
    └── certs/selfsigned/
        ├── fullchain.pem            → Certificato SSL self-signed
        └── privkey.pem              → Chiave privata SSL

---

## 🔧 Generazione file (script `a03b-nginx-reverse-proxy.sh`)

Lo script crea:

- `nginx/nginx.conf`
- `nginx/conf.d/commonrestapi.conf`
- certificati self-signed in `certs/selfsigned/`

I certificati sono validi 1 anno e utilizzano chiave RSA 2048 bit.

---

## ⚖️ Virtual host (HTTPS)

**Percorso file:** `nginx/conf.d/commonrestapi.conf`

```nginx
server {
    listen 443 ssl;
    server_name localhost;

    ssl_certificate     /etc/nginx/certs/fullchain.pem;
    ssl_certificate_key /etc/nginx/certs/privkey.pem;

    location / {
        proxy_pass         http://commonrestapi:8000;
        proxy_http_version 1.1;
        proxy_set_header   Host $host;
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
    }
}
```

---

## 🚀 Esecuzione con Docker Compose

Il servizio NGINX viene avviato accanto al backend tramite `docker-compose.yml`:

```yaml
services:
  nginx-reverse-proxy:
    image: nginx:alpine
    container_name: nginx-reverse-proxy
    ports:
      - "443:443"
    volumes:
      - ./nginx:/etc/nginx:ro
      - ./certs/selfsigned:/etc/nginx/certs:ro
    depends_on:
      - commonrestapi
    restart: unless-stopped
```

---

## 📊 Test e verifica

```bash
curl -k https://localhost/
```

Il flag `-k` permette di accettare certificati self-signed. Output atteso:

```
CFP Terragni di Meda, Project-work MRA (1A) e PAL (1H) A.S. 2024-25 - Flask web-server per le REST-API
```

---

## 🔐 Produzione (opzionale)

Per ambiente di produzione, si raccomanda:

- Uso di **Let's Encrypt** (Certbot + rinnovo automatico)
- Configurazione **DNS personalizzato** (es. `api.mra-pal.it`)
- Hardening NGINX (headers di sicurezza, redirect da HTTP)

---

## 🔍 Log

I log NGINX sono disponibili tramite:

```bash
docker logs -f nginx-reverse-proxy
```

---

📍 **Autore:** MatteoG con supporto ChatGPT 4.0
📅 **Ultimo aggiornamento:** 31/03/2025

