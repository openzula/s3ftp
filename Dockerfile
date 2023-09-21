FROM alpine:3.18
LABEL maintainer="alex@openzula.org"

EXPOSE 20 21 50000-50300

RUN apk update
RUN apk add --no-cache vsftpd mailcap
# To resolve https://github.com/s3fs-fuse/s3fs-fuse/issues/2098 we need
# s3fs-fuse >= 1.92, currently only available in edge
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community s3fs-fuse

RUN mkdir /var/log/vsftpd
RUN mkdir /media/ftp

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY provision.sh /usr/local/bin

RUN chmod +x /usr/local/bin/provision.sh
CMD /usr/local/bin/provision.sh
