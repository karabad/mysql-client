ARG ARCH=
# Use an latest alpine linux
FROM ${ARCH}alpine:latest

# Install mysql client
RUN apk add --no-cache mysql-client
RUN apk add --no-cache mariadb-connector-c

# Install ssh client
RUN apk add --no-cache openssh
RUN mkdir -p ~/.ssh

COPY mysqldump_via_tunnel /usr/bin/mysqldump_via_tunnel
COPY make_tunnel /usr/bin/make_tunnel
COPY dbcopy /usr/bin/dbcopy
RUN chmod a+x /usr/bin/mysqldump_via_tunnel
RUN chmod a+x /usr/bin/make_tunnel
RUN chmod a+x /usr/bin/dbcopy

ENTRYPOINT ["/usr/bin/mysql"]
