#!/bin/bash
#your s3 bucket name
bucketName="mybucket"
#time date variables
bDate=$(date +%Y%m%d)
bTime=$(date +%H%M)
#makes sure the backups directory exists
if [ ! -d "~/backups" ]; then
    mkdir ~/backups
fi
#iterates through the directories in the backupdirs.txt file
for dir in `cat ./backupdirs.txt`
do
    #fills variable with the directory name
    dirName=$(echo $dir |rev|cut -d/ -f1|rev)
    #creates a tar.gz file of the directory
    tar zcvf ~/backups/$bDate-$bTime-$dirName-backup.tar.gz $dir
    #uploads the tar.gz file to s3
    aws s3 cp ~/backups/$bDate-$bTime-$dirName-backup.tar.gz s3://$bucketName/backups/
    #cleans up the tar.gz file
    rm ~/backups/$bDate-$bTime-$dirName-backup.tar.gz
done