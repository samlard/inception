*This project has been created as part of the 42 curriculum by ssoumill*

# Inception

## Overview

Inception is a system administration project from the 42 curriculum. It involves setting up a small infrastructure composed of different services running in Docker containers using Docker Compose.

## Architecture

The project sets up the following services:

- **NGINX** – A web server acting as the entry point, with TLSv1.2/TLSv1.3 only.
- **WordPress** – A PHP-FPM-based WordPress installation (without NGINX).
- **MariaDB** – A database server for WordPress.

Each service runs in its own dedicated Docker container, and the containers communicate through a Docker network.

## Prerequisites

- Docker
- Docker Compose
- Make

## How to Run

Clone the repository and run:

```bash
make
```

To stop and remove the containers:

```bash
make down
```

To clean up all volumes and images:

```bash
make fclean
```

## Project Structure

```
.
├── Makefile
├── secrets/          # Secret files (credentials)
└── srcs/
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/  # MariaDB container configuration
        ├── nginx/    # NGINX container configuration
        └── wordpress/ # WordPress container configuration
```

## More Information

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [WordPress documentation](https://wordpress.org/documentation/)
- [MariaDB documentation](https://mariadb.com/kb/en/documentation/)
