# DEV_DOC.md — Developer Documentation

## Overview

Inception is a 42 curriculum project that builds a minimal web infrastructure entirely with Docker containers. Each service (NGINX, WordPress, MariaDB) is defined in its own `Dockerfile` and wired together with Docker Compose.

---

## Prerequisites

| Tool | Minimum version | Purpose |
|------|----------------|---------|
| Docker | 20.10+ | Build and run containers |
| Docker Compose (v2) | 2.x | Orchestrate the multi-container stack |
| Make | any | Convenience wrapper around Compose commands |

> The project has been developed on **Debian Bullseye**. All images are based on `debian:bullseye`.

---

## Setting Up the Environment from Scratch

### 1. Clone the repository
```bash
git clone <repo-url> inception
cd inception
```

### 2. Create the environment file

Create `srcs/.env` with the following variables (adjust values as needed):

```dotenv
# Domain
DOMAIN_NAME=ssoumill.42.fr

# MariaDB
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=<db_password>

# WordPress admin account
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=<admin_password>
WP_ADMIN_EMAIL=admin@ssoumill.42.fr

# WordPress regular user
WP_USER=user
WP_USER_PASSWORD=<user_password>
WP_USER_EMAIL=user@ssoumill.42.fr
```

### 3. Create the secrets files

The `secrets/` directory contains plain-text secret files read at runtime:

```bash
echo "<db_password>"       > secrets/db_password.txt
echo "<db_root_password>"  > secrets/db_root_password.txt
# credentials.txt can hold a human-readable summary of all credentials
```

### 4. Add a local DNS entry (development only)

```bash
echo "127.0.0.1   ssoumill.42.fr" | sudo tee -a /etc/hosts
```

---

## Building and Launching the Project

### Build images and start all containers
```bash
make          # equivalent to: make up
```

### Rebuild after code changes
```bash
make re       # full clean + rebuild (⚠️ destroys all data)
# or, to rebuild without data loss:
docker compose -f srcs/docker-compose.yml --env-file srcs/.env up -d --build <service>
```

---

## Useful Makefile Commands

| Command | Description |
|---------|-------------|
| `make up` | Build images (if needed) and start all containers in detached mode |
| `make down` | Stop and remove containers (volumes and data are kept) |
| `make start` | Start previously stopped containers |
| `make stop` | Stop containers without removing them |
| `make restart` | Restart all containers |
| `make build` | Build (or rebuild) images without starting |
| `make logs` | Tail logs from all containers (`Ctrl+C` to exit) |
| `make ps` | Show container status |
| `make clean` | `down` + remove orphan containers and anonymous volumes |
| `make fclean` | Full purge: containers, volumes, images, and data directories |
| `make re` | `fclean` then `up` — full rebuild from scratch |

---

## Repository Structure

```
.
├── Makefile                       # All management commands
├── secrets/
│   ├── credentials.txt            # Human-readable credential summary
│   ├── db_password.txt            # MariaDB application user password
│   └── db_root_password.txt       # MariaDB root password
└── srcs/
    ├── .env                       # Environment variables (not committed)
    ├── docker-compose.yml         # Service orchestration
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile         # Based on debian:bullseye + mariadb-server
        │   └── conf/
        │       └── init.sh        # DB initialisation script (runs as CMD)
        ├── nginx/
        │   ├── Dockerfile         # Based on debian:bullseye + nginx + openssl
        │   └── conf/
        │       └── nginx.conf     # HTTPS-only reverse proxy to WordPress:9000
        └── wordpress/
            ├── Dockerfile         # Based on debian:bullseye + php-fpm + wp-cli
            └── tools/
                └── setup.sh       # WordPress download, config and install (runs as CMD)
```

---

## Docker Compose Services

### `mariadb`
- Builds from `./requirements/mariadb`.
- Runs `init.sh` which initialises the data directory on first start and launches `mysqld`.
- Exposes port **3306** internally (not published to the host).
- Data persists in the `mariadb_data` volume.

### `wordpress`
- Builds from `./requirements/wordpress`.
- Waits for MariaDB to be ready, then downloads WordPress core, creates `wp-config.php`, and installs the site using **WP-CLI** (only on first boot).
- Serves PHP files over **FastCGI on port 9000** (internal only).
- Data persists in the `wordpress_data` volume (shared with NGINX).

### `nginx`
- Builds from `./requirements/nginx`.
- Generates a self-signed TLS certificate at build time.
- Accepts **HTTPS only on port 443** (published to the host).
- Forwards PHP requests to `wordpress:9000` via FastCGI.

### Network
All containers communicate through the `inception` Docker bridge network. Only NGINX is reachable from the outside world (port 443).

---

## Data Persistence

| Data | Volume name | Host path |
|------|-------------|-----------|
| WordPress files | `wordpress_data` | `/home/ssoumill/data/wordpress` |
| MariaDB database | `mariadb_data` | `/home/ssoumill/data/mariadb` |


### Backup
To back up the database:
```bash
docker exec mariadb mysqldump -u root <database> > backup.sql
```

To back up WordPress files:
```bash
tar -czf wordpress_backup.tar.gz /home/ssoumill/data/wordpress
```

---

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| `make up` fails creating data dirs | Missing `sudo` or wrong path | Check Makefile path matches your username |
| Browser shows "connection refused" on port 443 | NGINX not running | `make logs` → check nginx container |
| WordPress shows database error | MariaDB not ready or wrong credentials | Check `.env` values match `secrets/` files |
| `wp core install` loop | WordPress already installed but `wp-config.php` missing | `make clean && make up` |
| Self-signed cert warning | Expected behaviour | Accept the exception in your browser |
