FROM alpine:3.18
LABEL maintainer="alex@openzula.org"

EXPOSE 20 21 10090-10100

RUN apk update
RUN apk add --no-cache s3fs-fuse vsftpd mailcap

RUN mkdir /var/log/vsftpd
RUN mkdir /media/ftp

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY provision.sh /usr/local/bin

RUN chmod +x /usr/local/bin/provision.sh
CMD /usr/local/bin/provision.sh
