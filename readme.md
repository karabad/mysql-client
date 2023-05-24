# Summary

Docker image with mysql client.

Based on [alpine](https://github.com/alpinelinux/docker-alpine) [MIT license](https://github.com/alpinelinux/alpine-wiki/blob/master/LICENSE) and [mariadb-client](https://pkgs.alpinelinux.org/package/edge/main/x86/mysql-client) [GPLv2 license](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)

# Runing

Mysql dump:
```
docker run -it --rm --entrypoint mysqldump karabad/mysql-client:latest
```

Shell:
```
docker run -it --rm --entrypoint sh karabad/mysql-client:latest
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
