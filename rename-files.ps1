# Set the directory path
$directory = "C:\Users\AlexanderSchönfeld\OneDrive - Das Lizenz Atelier GmbH & Co. KG\_Customer\AI Pioneers\public\img"

# Get a list of files in the directory
$files = Get-ChildItem $directory

# Get the total count of files
$fileCount = $files.Count

# Determine the number of digits needed for filenames
if ($fileCount -lt 10) {
    $digits = 1
} elseif ($fileCount -lt 100) {
    $digits = 2
} else {
    $digits = 3
}

# Create an array to store the new filenames
$newFileNames = @()

# Construct new filenames and store them in the array
for ($i = 0; $i -lt $fileCount; $i++) {
    $newFileName = ($i + 1).ToString("D$digits") + ".jpg"
    $newFileNames += $newFileName
}

# Print all new filenames to the console
Write-Host "New filenames:"
$newFileNames

# Prompt for user confirmation
$choice = Read-Host "Do you want to proceed with renaming? (Y/N)"

# Check user's choice
if ($choice -eq "Y" -or $choice -eq "y") {
    # Rename all files
    for ($i = 0; $i -lt $fileCount; $i++) {
        Rename-Item -Path $files[$i].FullName -NewName $newFileNames[$i]
        Write-Host "Renamed: $($files[$i].Name) -> $($newFileNames[$i])"
    }
    
    Write-Host "All files renamed successfully."
} else {
    Write-Host "Renaming aborted."
}