$BasePath = $env:USERPROFILE+'\Pictures'

function Remove-Duplicates {
    param (
        [Parameter(Mandatory)]
        [string] $BaseFolder
    )
    $SubFolder = Get-ChildItem -Directory -Path $BaseFolder

    foreach ($Folder in $SubFolder) {
        Remove-Duplicates($BaseFolder+"\"+$Folder.Name)
    }
    
    Write-Output $BaseFolder
    
    $HashArry = @()

    $Files = Get-ChildItem -File -Path $BaseFolder | Sort-Object -Descending Name

    foreach ($File in $Files) {
        $Hash = ($File | Get-FileHash).Hash

        if($null -eq $HashArry) {
            $HashArry += $Hash
        } elseif (-Not ($HashArry -contains $Hash)) {
            $HashArry += $Hash
        } else {
            $File | Remove-Item
        }
    }

    $HashArry.clear()

}

Remove-Duplicates($BasePath)
