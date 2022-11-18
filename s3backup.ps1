$bucketName = "mybucket"
$bDate = Get-Date -Format "yyyy-MM-dd"
$bTime = Get-Date -Format "HH-mm"
if (!(Test-Path -Path "$HOME\backups")) {
    New-Item -ItemType Directory -Path "$HOME\backups"
}
Get-Content .\backupdirs.txt | ForEach-Object {
    $dir = $_
    $dirName = Split-Path $dir -Leaf
    Compress-Archive -Path $dir -DestinationPath "$HOME\backups\$bDate-$bTime-$dirName.zip"
    $file = "$HOME\backups\$bDate-$bTime-$dirName.zip"
    Write-S3Object -BucketName $bucketName -File $file -Key "backups\$bDate-$bTime-$dirName.zip"
    Remove-Item $file
}