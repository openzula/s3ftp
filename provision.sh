#!/usr/bin/env sh

## The reason for "/./" within the home directory is so that vsftpd
## will chroot the user to the parent directory ("/media/ftp"), but
## upon login will change directory to "/media/ftp/$user"
FTP_USER_HOME="/media/ftp/./$FTP_USER"

adduser -h "$FTP_USER_HOME" -s /bin/false -D "$FTP_USER"
chown -R "$FTP_USER":"$FTP_USER" "$FTP_USER_HOME"

if [ -z "$FTP_PWD" ]; then
  FTP_PWD=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c12; echo)
  echo "Generated FTP user password: $FTP_PWD"
fi

echo "${FTP_USER}:${FTP_PWD}" | /usr/sbin/chpasswd 2> /dev/null

/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
