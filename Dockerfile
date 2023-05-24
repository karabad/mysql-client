ARG ARCH=
# Use an latest alpine linux
FROM ${ARCH}alpine:latest

# Install mysql client
RUN apk add --no-cache mysql-client

ENTRYPOINT ["/usr/bin/mysql"]
