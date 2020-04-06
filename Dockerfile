FROM alpine:latest
LABEL maintainer="alex@openzula.org"

EXPOSE 20 21 10090-10100

RUN apk update
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing s3fs-fuse
RUN apk add --no-cache vsftpd

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY provision.sh /usr/local/bin

RUN mkdir /media/ftp

RUN chmod +x /usr/local/bin/provision.sh
CMD /usr/local/bin/provision.sh
