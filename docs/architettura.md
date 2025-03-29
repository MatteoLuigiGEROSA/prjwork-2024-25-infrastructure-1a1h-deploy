
# Struttura del Repository `infrastructure-1a1h-deploy`

Questo repository contiene tutta l'infrastruttura necessaria per il deploy completo del sistema MRA-PAL su architettura Docker, suddivisa tra backend (BE) e due frontend distinti (FE-MRA e FE-PAL). Ogni componente include configurazioni, script di provisioning, certificati, documentazione e strumenti di test e monitoring.

## Alberatura del progetto

```
infrastructure-1a1h-deploy/
│
├── docker/                           # Configurazioni Docker per BE, FE-MRA, FE-PAL
│   ├── be/                           # Backend CommonRestApi
│   │   ├── Dockerfile                # Dockerfile per il backend
│   │   ├── gunicorn.conf.py          # Configurazione Gunicorn
│   │   ├── nginx/
│   │   │   └── default.conf          # Configurazione Nginx
│   │   └── docker-compose.yml        # Orchestrazione Docker backend
│   │
│   ├── fe-mra/                       # Frontend MRA
│   │   ├── Dockerfile
│   │   ├── gunicorn.conf.py
│   │   ├── nginx/
│   │   │   └── default.conf
│   │   └── docker-compose.yml
│   │
│   └── fe-pal/                       # Frontend PAL
│       ├── Dockerfile
│       ├── gunicorn.conf.py
│       ├── nginx/
│       │   └── default.conf
│       └── docker-compose.yml
│
├── bash/                             # Script Bash di provisioning
│   ├── setup-system-ubuntu.sh        # Installa pacchetti base e Docker
│   ├── init-backend.sh               # Setup del backend completo
│   ├── init-frontend-mra.sh          # Setup del frontend MRA
│   ├── init-frontend-pal.sh          # Setup del frontend PAL
│   └── common-env.sh                 # Variabili d'ambiente comuni
│
├── test-harness/                                   # Testing manuale (Postman) e futuro automatico
│   ├── postman/                                    # Directory per le collezioni Postman
│   │   ├── CommonRestApi.postman_collection.json   # Collection di richieste HTTP verso la CommonRestApi
│   │   └── CommonRestApi.postman_environment.json  # Ambiente Postman (base URL, token JWT, ecc.)
│   ├── README.md                                   # Guida all'uso di Postman
│   └── script/                                     # Script di test automatizzati futuri
│
├── monitoring/                       # Health check e centralizzazione log
│   ├── README.md                     # Documentazione monitoring
│   ├── healthcheck.sh                # Verifica stato dei container
│   └── logtail.sh                    # Visualizza log aggregati
│
├── certs/                            # Certificati SSL
│   ├── README.md                     # Guida alla gestione SSL
│   ├── selfsigned/                   # Certificati auto-firmati
│   └── letsencrypt/                  # Certificati gestiti da Certbot
│
├── docs/                             # Documentazione tecnica e didattica
│   ├── README.md                     # Introduzione generale
│   ├── INSTALLAZIONE_STEP_BY_STEP.md # Guida dettagliata all'installazione
│   ├── architettura.md               # Architettura del sistema
│   ├── flask-jwt.md                  # JWT e sicurezza API
│   ├── docker-structure.md           # Struttura Docker e container
│   ├── nginx-config.md               # Reverse proxy e sicurezza
│   └── gunicorn.md                   # Configurazione Gunicorn
│
└── .gitignore                        # File per ignorare contenuti locali in fase di upload vs git-repository
```

## Scopo del progetto

Questa infrastruttura è pensata per un utilizzo **didattico** da parte di studenti di un istituto tecnico informatico, con obiettivi sia per sviluppatori (dev) che per sistemisti (ops).

Il progetto supporta:
- Deploy scalabile via Docker Compose
- Testing manuale tramite Postman
- Automatizzazione completa via Bash
- Documentazione per l'apprendimento e la manutenzione
