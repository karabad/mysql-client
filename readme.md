# Summary

Docker image with mysql client.

Based on [alpine](https://github.com/alpinelinux/docker-alpine) [MIT license](https://github.com/alpinelinux/alpine-wiki/blob/master/LICENSE) and [mariadb-client](https://pkgs.alpinelinux.org/package/edge/main/x86/mysql-client) [GPLv2 license](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)

# Runing

Backup mysql database:
```
docker run -it --rm --entrypoint mysqldump karabad/mysql-client:latest --host=192.168.0.42 --port=3306 --username=dbuser --password=secret database > database.sql
```

Restore database
```
docker run -it --rm --entrypoint mysql karabad/mysql-client:latest --host=192.168.0.42 --port=3306 --username=dbuser --password=secret database < database.sql
```

Shell commands:
```
docker run -it --rm --entrypoint sh karabad/mysql-client:latest -c "ls -l"
```

Backup mysql database via SSH tunnel:
```
SSH_PUBLIC_KEY=$(cat ~/.ssh/id_rsa.pub) && SSH_PRIVATE_KEY=$(cat ~/.ssh/id_rsa) && SSH_USER=user && SSH_SERVER=192.168.0.42 && DB_HOST=localhost && DB_PORT=3306 && DB_USER=dbusr && DB_PASS=secret && DB_NAME=exampledb && TUNNEL_PORT=8806 \
  docker run \
    -e "SSH_PUBLIC_KEY=$SSH_PUBLIC_KEY" \
    -e "SSH_PRIVATE_KEY=$SSH_PRIVATE_KEY" \
    -e "SSH_USER=$SSH_USER" \
    -e "SSH_SERVER=$SSH_SERVER" \
    -e "TUNNEL_PORT=$TUNNEL_PORT" \
    -e "DB_HOST=$DB_HOST" \
    -e "DB_PORT=$DB_PORT" \
    -e "DB_USER=$DB_USER" \
    -e "DB_PASS=$DB_PASS" \
    -e "DB_NAME=$DB_NAME" \
    -it --rm --entrypoint mysqldump_via_tunnel karabad/mysql-client:latest > database.sql
```

Restore mysql database via SSH tunnel:
```
SSH_PUBLIC_KEY=$(cat ~/.ssh/id_rsa.pub) && SSH_PRIVATE_KEY=$(cat ~/.ssh/id_rsa) && SSH_USER=user && SSH_SERVER=192.168.0.42 && DB_HOST=localhost && DB_PORT=3306 && DB_USER=dbusr && DB_PASS=secret && DB_NAME=exampledb && TUNNEL_PORT=8806 \
  docker run \
    -e "SSH_PUBLIC_KEY=$SSH_PUBLIC_KEY" \
    -e "SSH_PRIVATE_KEY=$SSH_PRIVATE_KEY" \
    -e "SSH_USER=$SSH_USER" \
    -e "SSH_SERVER=$SSH_SERVER" \
    -e "TUNNEL_PORT=$TUNNEL_PORT" \
    -e "DB_HOST=$DB_HOST" \
    -e "DB_PORT=$DB_PORT" \
    -e "DB_USER=$DB_USER" \
    -e "DB_PASS=$DB_PASS" \
    -e "DB_NAME=$DB_NAME" \
    -it --rm --entrypoint mysql_via_tunnel karabad/mysql-client:latest < database.sql
```

Copy database from one server to another via tunnels
```
SRC_SSH_PUBLIC_KEY=$(cat ~/.ssh/id_rsa.pub) && SRC_SSH_PRIVATE_KEY=$(cat ~/.ssh/id_rsa) && SRC_SSH_USER=srcuser && SRC_SSH_SERVER=192.168.1.42 && SRC_DB_HOST=192.168.11.42 && SRC_DB_PORT=3306 && SRC_DB_USER=dbuser1 && SRC_DB_PASS=secret && SRC_DB_NAME=exampledb && SRC_TUNNEL_PORT=8806 && \
SRC_PRE_SQL="DROP TABLE temp;" && SRC_POST_SQL="DROP DATABASE exampledb;" \
DST_SSH_PUBLIC_KEY=$(cat ~/.ssh/id_rsa.pub) && DST_SSH_PRIVATE_KEY=$(cat ~/.ssh/id_rsa) && DST_SSH_USER=dstuser && DST_SSH_SERVER=192.168.2.42 && DST_DB_HOST=192.168.22.42 && DST_DB_PORT=3306 && DST_DB_USER=dbuser2 && DST_DB_PASS=secret && DST_DB_NAME=exampledb && DST_TUNNEL_PORT=8807 && \
DST_PRE_SQL="CREATE DATABASE exampledb;CREATE USER 'sammy'@'localhost' IDENTIFIED BY 'password';" && DST_POST_SQL="GRANT ALL PRIVILEGES ON exampledb.* TO 'sammy'@'localhost';"
  docker run \
    -e "SRC_SSH_PUBLIC_KEY=$SRC_SSH_PUBLIC_KEY" \
    -e "SRC_SSH_PRIVATE_KEY=$SRC_SSH_PRIVATE_KEY" \
    -e "SRC_SSH_USER=$SRC_SSH_USER" \
    -e "SRC_SSH_SERVER=$SRC_SSH_SERVER" \
    -e "SRC_TUNNEL_PORT=$SRC_TUNNEL_PORT" \
    -e "SRC_DB_HOST=$SRC_DB_HOST" \
    -e "SRC_DB_PORT=$SRC_DB_PORT" \
    -e "SRC_DB_USER=$SRC_DB_USER" \
    -e "SRC_DB_PASS=$SRC_DB_PASS" \
    -e "SRC_DB_NAME=$SRC_DB_NAME" \
    -e "SRC_PRE_SQL=$SRC_PRE_SQL" \
    -e "SRC_POST_SQL=$SRC_POST_SQL" \
    -e "DST_SSH_PUBLIC_KEY=$DST_SSH_PUBLIC_KEY" \
    -e "DST_SSH_PRIVATE_KEY=$DST_SSH_PRIVATE_KEY" \
    -e "DST_SSH_USER=$DST_SSH_USER" \
    -e "DST_SSH_SERVER=$DST_SSH_SERVER" \
    -e "DST_TUNNEL_PORT=$DST_TUNNEL_PORT" \
    -e "DST_DB_HOST=$DST_DB_HOST" \
    -e "DST_DB_PORT=$DST_DB_PORT" \
    -e "DST_DB_USER=$DST_DB_USER" \
    -e "DST_DB_PASS=$DST_DB_PASS" \
    -e "DST_DB_NAME=$DST_DB_NAME" \
    -e "DST_PRE_SQL=$DST_PRE_SQL" \
    -e "DST_POST_SQL=$DST_POST_SQL" \
    -it --rm --entrypoint dbcopy karabad/mysql-client:latest
```



# Building with Docker

## Single arhitecture
Build a new docker image

```
docker build -t karabad/mysql-client:latest-amd64 --build-arg ARCH=amd64/ .
```

Running with:
```
docker run -t -i --rm karabad/mysql-client:latest-amd64
```

Uploading

## Multi architecture

Build:
```
docker buildx build --platform linux/arm64/v8,linux/amd64,linux/amd64/v2,linux/ppc64le,linux/s390x,linux/386,linux/arm/v7,linux/arm/v6 --tag karabad/mysql-client:latest --load .
```

Run:
```
docker run -t -i --rm karabad/mysql-client:latest-amd64
```

Push to docker hub:
```
docker login
docker buildx build --platform linux/arm64/v8,linux/amd64,linux/amd64/v2,linux/ppc64le,linux/s390x,linux/386,linux/arm/v7,linux/arm/v6 --tag karabad/mysql-client:latest --load .
```
