*This project has been created as part of the 42 curriculum by samlard*

# Inception

Inception is a 42 school system administration project that involves setting up a small infrastructure composed of different services inside a virtual machine, using Docker and Docker Compose.

The infrastructure consists of:
- **NGINX** — a web server acting as the sole entry point (TLS only, port 443)
- **WordPress** — a PHP-FPM-based CMS connected to the database
- **MariaDB** — a relational database for WordPress

Each service runs in its own dedicated Docker container built from a custom `Dockerfile` (based on the penultimate stable version of Alpine or Debian). Containers communicate over a Docker network, and data is persisted using named volumes.

## Requirements

- Docker
- Docker Compose v2

## How to run

```bash
make
```

This will build all images and start the containers in detached mode. The site will be available at `https://localhost`.

### Other useful commands

| Command        | Description                                      |
|----------------|--------------------------------------------------|
| `make up`      | Build images and start containers                |
| `make down`    | Stop and remove containers                       |
| `make start`   | Start existing containers                        |
| `make stop`    | Stop running containers                          |
| `make restart` | Restart all containers                           |
| `make logs`    | Follow container logs                            |
| `make ps`      | List container statuses                          |
| `make clean`   | Remove containers, volumes, and orphan services  |
| `make fclean`  | Full cleanup including images and data volumes   |
| `make re`      | Full rebuild from scratch                        |

## Further information

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [WordPress documentation](https://developer.wordpress.org/)
- [MariaDB documentation](https://mariadb.com/kb/en/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [42 School](https://42.fr/)
