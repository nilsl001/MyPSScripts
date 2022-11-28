$BasePath = $env:USERPROFILE+'\Pictures'
$SearchString = '*'
$NewFolderFormat = "yyyy-MM-dd"

$Photos = Get-ChildItem -File -Path $BasePath $SearchString 

foreach ($Pic in $Photos) {
    if ($Pic.CreationTime -lt $Pic.LastWriteTime) {
        $FolderName = $Pic.CreationTime.ToString($NewFolderFormat)
    } else {
        $FolderName = $Pic.LastWriteTime.ToString($NewFolderFormat)
    }
    
    $FolderPath = $BasePath+"\"+$FolderName

    if (-Not (Test-Path -Path $FolderPath)) {
        New-Item -ItemType Directory $FolderPath
    }

    $BaseFile = $BasePath+"\"+$Pic.Name
    $FolderFile = $FolderPath+"\"+$Pic.Name
    $FolderPSFileDate = Get-Date -Format ("yyyyMMdd-HHmmss")
    $FolderPSFile = $FolderPath+"\PSJob_"+$FolderPSFileDate+"_"+$Pic.Name
    if (Test-Path $FolderFile) {
        if ((Get-FileHash $BaseFile).Hash -eq (Get-FileHash $FolderFile).Hash) {
            Remove-Item $BaseFile
        } else {
            Move-Item $BaseFile $FolderPSFile
        }
    } else {
        Move-Item $BaseFile $FolderFile
    }
}