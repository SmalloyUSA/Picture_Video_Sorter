#!/usr/bin/env pwsh

Add-Type -AssemblyName System.Windows.Forms

function Get-OlderDate($date1, $date2) {
    if ($date1 -lt $date2) {
        return $date1
    } else {
        return $date2
    }
}

# Create and configure the FolderBrowserDialog
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$folderBrowser.Description = "Select the directory that contains the images and files"
$folderBrowser.SelectedPath = [Environment]::GetFolderPath([Environment+SpecialFolder]::MyPictures)

# Show the FolderBrowserDialog
$dialogResult = $folderBrowser.ShowDialog()

if ($dialogResult -eq [System.Windows.Forms.DialogResult]::OK) {
    $selectedDirectory = $folderBrowser.SelectedPath
} else {
    Write-Host "No folder was selected."
    exit
}

# Create a "Pictures and Files Review" folder
$reviewDirectory = Join-Path $selectedDirectory "Pictures and Files Review"
if (-Not (Test-Path $reviewDirectory)) {
    New-Item -ItemType Directory -Path $reviewDirectory
}

# Process all files in the selected directory and its subdirectories
Get-ChildItem -Path $selectedDirectory -Recurse -File | ForEach-Object {
    $currentFile = $_
    $destination = Join-Path $selectedDirectory $currentFile.Name

    if (Test-Path $destination) {
        # If the file already exists in the target directory, move to "Pictures and Files Review"
        Move-Item $currentFile.FullName -Destination $reviewDirectory -Force
    } else {
        Move-Item $currentFile.FullName -Destination $selectedDirectory
    }
}

# Delete all empty subdirectories
Get-ChildItem -Path $selectedDirectory -Recurse -Directory | Where-Object { $_.GetFileSystemInfos().Count -eq 0 } | Remove-Item -Force

# Process the images in the selected directory for sorting into folders
Get-ChildItem -Path $selectedDirectory -File | Where-Object { $_.Extension -match "jpg|jpeg|png|gif|bmp|mp4|heic" } | ForEach-Object {
    try {
        $creationDate = $_.CreationTime
        $modifiedDate = $_.LastWriteTime
        $olderDate = Get-OlderDate $creationDate $modifiedDate

        $targetFolderName = '{0:yyyy-MM}' -f $olderDate
        $targetFolder = Join-Path $selectedDirectory $targetFolderName

        if (-Not (Test-Path $targetFolder)) {
            New-Item -ItemType Directory -Path $targetFolder
        }

        $baseName = '{0:yyyyMMdd}' -f $olderDate
        $extension = $_.Extension
        $newFileName = $baseName + $extension
        $newFilePath = Join-Path $targetFolder $newFileName

        $counter = 1
        while ((Test-Path $newFilePath) -or ($_.Name -like "*copy*")) {
            $newFileName = $baseName + "_$counter" + $extension
            $newFilePath = Join-Path $targetFolder $newFileName
            $counter++
        }

        Move-Item $_.FullName -Destination $newFilePath
    } catch {
        # If the file can't be sorted, move to "Pictures and Files Review"
        Move-Item $_.FullName -Destination $reviewDirectory -Force
    }
}

Write-Host "Operation completed."
