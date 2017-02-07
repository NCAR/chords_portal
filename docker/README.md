# CHORDS Docker Assets

## Usage

Service-specific resource files go into `docker/<service>`. *E.g.* **nginx** conf for for `web` service:

`docker/web/nginx_default.conf`

## Docker

Link appropriate `Dockerfile` to `Dockerfile` in root directory, and then build from root, *e.g.*

```sh
ln -s docker/app/rpi-Dockerfile Dockerfile
docker build .
```

## Docker Compose

Link appropriate `docker-compose*.yml` file to `docker-compose.yml` root directory, and then use from root, *e.g.*

```sh
ln -s docker/docker-compose-dev.yml docker-compose.yml
docker-compose up -d
docker-compose stop
```
