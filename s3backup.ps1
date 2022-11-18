#your s3 bucket name
$bucketName = "mybucket"
#makes time date variables
$bDate = Get-Date -Format "yyyy-MM-dd"
$bTime = Get-Date -Format "HH-mm"
#makes sure the backups file exists
if (!(Test-Path -Path "$HOME\backups")) {
    New-Item -ItemType Directory -Path "$HOME\backups"
}
#iterates through the directories in backupdirs.txt
Get-Content .\backupdirs.txt | ForEach-Object {
    #gets the name of the directory
    $dir = $_
    $dirName = Split-Path $dir -Leaf
    #zips the directory
    Compress-Archive -Path $dir -DestinationPath "$HOME\backups\$bDate-$bTime-$dirName.zip"
    #fills variables with the file name and path
    $file = "$HOME\backups\$bDate-$bTime-$dirName.zip"
    #uploads the file to s3
    Write-S3Object -BucketName $bucketName -File $file -Key "backups\$bDate-$bTime-$dirName.zip"
    #cleans up the file
    Remove-Item $file
}