[![MIT license][license-image]][license-url]
[![Docker][docker-image]][docker-url]

[license-image]: https://img.shields.io/badge/license-MIT-blue.svg
[license-url]: https://github.com/salvoxia/minio-backup-s3/blob/master/LICENSE

[docker-image]: https://img.shields.io/docker/pulls/salvoxia/minio-backup-s3.svg
[docker-url]: https://hub.docker.com/r/salvoxia/minio-backup-s3/

# MinIO Backup S3
`minio-backup-s3` is a service giving you ability to mirror entities from `SOURCE OBJECT STORAGE` to `DESTINATION OBJECT STORAGE`.

## Docker

For a single run:
```sh
docker run -e MC_SOURCE_EP_ACCESS_KEY=<Access Key> -e MC_SOURCE_EP_SECRET_KEY=<Secret Key> -e MC_SOURCE_EP_HOST=https://<YOUR-S3-ENDPOINT> -e MC_DEST_EP_ACCESS_KEY=<Access Key> -e MC_DEST_EP_SECRET_KEY=<Secret Key> -e MC_DEST_EP_HOST=https://<YOUR-S3-ENDPOINT> salvoxia/minio-backup-s3:<IMAGE_VERSION>
```

For mirroring to happen on a schedule:
```sh
docker run -e MC_SOURCE_EP_ACCESS_KEY=<Access Key> -e MC_SOURCE_EP_SECRET_KEY=<Secret Key> -e MC_SOURCE_EP_HOST=https://<YOUR-S3-ENDPOINT> -e MC_DEST_EP_ACCESS_KEY=<Access Key> -e MC_DEST_EP_SECRET_KEY=<Secret Key> -e MC_DEST_EP_HOST=https://<YOUR-S3-ENDPOINT> -e CRON_EXPRESSION="0 * * * *" salvoxia/minio-backup-s3:<IMAGE_VERSION>
```

## Kubernetes Cronjob Manifest
The following manifest can be used to create a Kubernetes Cronjob performing mirroring on a schedule.  
Apply with `kubectl apply -f <FILE_NAME>.yaml`.
```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: minio-backup
  namespace: minio
spec:
  schedule: "* * * * *"
  jobTemplate:
    spec:      
      template:
        spec:
          containers:
            - name: minio-backup-s3
              image: git.local.salvoxia.de/blindfish/minio-backup-s3:latest
              env:
                - name: MC_SOURCE_EP_ACCESS_KEY
                  value: xxxxxxxxxxxxxxxxxx
                - name: MC_SOURCE_EP_SECRET_KEY
                  value: yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
                - name: MC_SOURCE_EP_HOST
                  value: https://minio-source
                - name: MC_DEST_EP_ACCESS_KEY
                  value: xxxxxxxxxxxxxxxxxx
                - name: MC_DEST_EP_SECRET_KEY
                  value: yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
                - name: MC_DEST_EP_HOST
                  value: https://minio-dest
          restartPolicy: Never
```

## Environment Variables

|Variable | Mandatory? | Description |
|--- |--- |--- |
|**MC_SOURCE_EP_ACCESS_KEY**| **yes** | Access Key for source MinIO instance
|**MC_SOURCE_EP_SECRET_KEY**| **yes** |  Secret Key for source MinIO instance
|**MC_SOURCE_EP_HOST** | **yes** |  MinIO source endpoint url
|**MC_DEST_EP_ACCESS_KEY**| **yes** |  Access Key for destination MinIO instance
|**MC_DEST_EP_SECRET_KEY**| **yes** |  Secret Key for destination MinIO instance
|**MC_DEST_EP_HOST** | **yes** |  MinIO destination endpoint url
|MC_INSECURE | no |  Set to 1 to disable TLS/SSL certificate verification by MinIO client (calls `mc --insecure`)
|MC_MIRROR_OVERWRITE | no |  Set to 1 to overwrite existing items in the destination (calls `mc mirror --overwrite`)
|CRON_EXPRESSION | no | A crontab-style expression (e.g. "0 * * * *") to perform mirroring on a schedule (e.g. every hour). If not provided, the container finished after a single run.

