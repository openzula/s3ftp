#!/usr/bin/env sh

## The reason for "/./" within the home directory is so that vsftpd
## will chroot the user to the parent directory ("/media/ftp"), but
## upon login will change directory to "/media/ftp/$user"
FTP_USER_HOME="/media/ftp/./$FTP_USER"
FTP_DATA_DIR="$FTP_USER_HOME"

adduser -h "$FTP_USER_HOME" -s /bin/false -D "$FTP_USER"
chown -R "$FTP_USER":"$FTP_USER" "$FTP_USER_HOME"
echo "$FTP_USER" > /etc/vsftpd/userlist

if [ -z "$FTP_PWD" ]; then
  FTP_PWD=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c12; echo)
  echo "Generated FTP user password: $FTP_PWD"
fi

echo "${FTP_USER}:${FTP_PWD}" | /usr/sbin/chpasswd 2> /dev/null

## Configure AWS S3 Bucket mount
echo "${FTP_S3_ACCESS_KEY}:${FTP_S3_SECRET}" > /etc/passwd-s3fs
chmod 0400 /etc/passwd-s3fs

s3fs "$FTP_S3_BUCKET" "$FTP_DATA_DIR" \
    -o allow_other,umask=077,uid="$(id -u "$FTP_USER")",gid="$(id -g "$FTP_USER")" \
    -o passwd_file=/etc/passwd-s3fs \
    -o url="https://s3-${FTP_S3_REGION:-eu-west-2}.amazonaws.com"

/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
