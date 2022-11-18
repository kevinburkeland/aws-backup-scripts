#!/bin/bash
bucketName="mybucket"
bDate=$(date +%Y%m%d)
bTime=$(date +%H%M)
if [ ! -d "~/backups" ]; then
    mkdir ~/backups
fi
for dir in `cat /opt/backupdirs.txt`
do
    dirName=$(echo $dir |rev|cut -d/ -f1|rev)
    tar zcvf ~/backups/$bDate-$bTime-$dirName-backup.tar.gz $dir
    aws s3 cp ~/backups/$bDate-$bTime-$dirName-backup.tar.gz s3://$bucketName/backups/
    rm ~/backups/$bDate-$bTime-$dirName-backup.tar.gz
done