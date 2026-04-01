# USER_DOC.md — User & Administrator Documentation

## Overview

The **Inception** stack provides a fully containerised web infrastructure composed of three services:

| Service | Role |
|---------|------|
| **NGINX** | HTTPS reverse proxy / web server (TLSv1.2 & TLSv1.3 only, port 443) |
| **WordPress** | PHP-FPM application server serving the WordPress website |
| **MariaDB** | Relational database storing all WordPress content |

All three services run in isolated Docker containers connected through a private Docker network called `inception`.

---

## Starting and Stopping the Project

All operations are performed from the **root of the repository** using `make`.

### Start (build images and launch containers)
```bash
make
# or equivalently:
make up
```
This creates the required data directories and starts all containers in the background.

### Stop (keep containers and data intact)
```bash
make stop
```

### Restart already-built containers
```bash
make start
```

### Restart all containers (stop then start)
```bash
make restart
```

### Stop and remove containers (data volumes are preserved)
```bash
make down
```

### Full clean (removes containers, volumes, images, and all data)
```bash
make fclean
```
> ⚠️ This permanently deletes all stored data including the database and uploaded files.

---

## Accessing the Website and Administration Panel

The NGINX container listens exclusively on **HTTPS port 443**.

| URL | Description |
|-----|-------------|
| `https://ssoumill.42.fr` | Public WordPress website |
| `https://ssoumill.42.fr/wp-admin` | WordPress administration panel |

> **Note:** The TLS certificate is self-signed. Your browser will show a security warning — this is expected. Accept the exception to proceed.

If you are accessing from a machine other than the host, make sure `ssoumill.42.fr` resolves to the correct IP address (add an entry to `/etc/hosts` if needed):
```
<host-ip>   ssoumill.42.fr
```

---

## Credentials

All credentials are stored in the `secrets/` directory at the root of the repository:

| File | Content |
|------|---------|
| `secrets/credentials.txt` | WordPress admin and regular user credentials |
| `secrets/db_password.txt` | MariaDB application user password |
| `secrets/db_root_password.txt` | MariaDB root password |

Additional configuration (domain name, usernames, emails) is read from `srcs/.env`.

### WordPress accounts

| Account | Username / Email | Where to find the password |
|---------|-----------------|---------------------------|
| Admin | Defined by `WP_ADMIN_USER` / `WP_ADMIN_EMAIL` in `srcs/.env` | `secrets/credentials.txt` |
| Regular user | Defined by `WP_USER` / `WP_USER_EMAIL` in `srcs/.env` | `secrets/credentials.txt` |

---

## Checking That the Services Are Running

### List running containers
```bash
make ps
```
All three containers (`nginx`, `wordpress`, `mariadb`) should appear with status **Up**.

### Follow live logs
```bash
make logs
```
Press `Ctrl+C` to stop tailing.

### Inspect a specific container
```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

### Quick health check
```bash
# Verify HTTPS is responding
curl -k https://ssoumill.42.fr

# Verify MariaDB is accepting connections
docker exec mariadb mysqladmin ping -u root
```
