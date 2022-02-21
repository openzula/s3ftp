# s3ftp (Openzula)
The aim of this Docker image is to provide easy access to an AWS S3 bucket over FTP, for those times when you can't use
a more secure method such as SFTP. This project does not support multiple users, and does not support multiple buckets.

At this time it does not support SSL/TLS, though could easily be adapted for this.

Unlike other AWS S3 FTP Docker images out there, this image is tiny (based on Alpine) and it uses an Alpine package to
install s3fs instead of compiling it from source. FTP is provided by [vsftpd](https://security.appspot.com/vsftpd.html).

## Prerequisites
Ensure that you have the following:

* AWS S3 bucket
  * Name
  * Region (e.g. 'eu-west-2')
* AWS IAM user or role with a policy for the desired permissions

For example the following IAM policy would provide full write access to the bucket:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetBucketLocation",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::s3fs-example"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListAllMyBuckets"
      ],
      "Resource": [
        "arn:aws:s3:::*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:DeleteObject",
        "s3:GetBucketAcl",
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::s3fs-example/*"
      ]
    }
  ]
}
```

## Deployment
All configuration of this Docker image is done at run time instead of build time. This may seem a little strange however
it allows you to use the same (already built) Docker image and configure it per environment by simply passing in
different environmental variables, e.g.

```shell script
docker run -it --rm -d --privileged \
    -p 20:20 -p 21:21 -p 10090-10100:10090-10100 \
    -e FTP_USER='longcat' \
    -e FTP_S3_BUCKET='s3fs-example' \
    -e FTP_S3_IAM_ROLE='s3fs-role-ec2' \
    --name mys3ftp \
    openzula/s3ftp
```

If you do not specify a `FTP_PWD` environmental variable as per the example above, then one will be generated for you at
run time. To find this password simply run the following command:

```shell script
# Replace 'mys3ftp' with the name you gave the Docker container (--name)
docker logs mys3ftp | grep Generated
```

## Configuration
The following environmental variables can be used at run time to configure the image:

| Name | Description | Required | Default |
| ---- | ----------- | -------- | ------- |
| `FTP_USER` | The name of the FTP user to login as | Yes | - |
| `FTP_PWD` | The password of the FTP user | No | Auto-generated |
| `FTP_S3_IAM_ROLE` | The AWS IAM Role to use instead of access tokens | If access keys not used | - |
| `FTP_S3_ACCESS_KEY` | The AWS Access Key for the IAM user | If role not used | - |
| `FTP_S3_SECRET` | The AWS Secret Key for the IAM user | If role not used | - |
| `FTP_S3_BUCKET` | The name of the AWS S3 bucket to mount. s3fs prefixes are supported | Yes | - |
| `FTP_S3_REGION` | The AWS region of the S3 bucket | No | `eu-west-2` |

## License
This project is licensed under the BSD 3-clause license - see [LICENSE.md](LICENSE.md) file for details.
