title "Configuration settings"
Write-Host "Please wait..."
# GitHub repo info
$owner = "luisdiko14-lab"
$repo  = "Repo-1"
$tag   = "Test"

# Construct download URL for the ZIP of the tag
$url = "https://github.com/$owner/$repo/archive/refs/tags/$tag.zip"

# Local paths
$zipFile = "$PSScriptRoot\$repo-$tag.zip"
$extractFolder = "$PSScriptRoot\$repo-$tag"

Write-Output "Downloading from: $url"

# Download the ZIP
Invoke-WebRequest -Uri $url -OutFile $zipFile

Write-Output "Download complete. Saved to $zipFile"

# Create extraction folder if it doesn't exist
if (-not (Test-Path -Path $extractFolder)) {
    New-Item -ItemType Directory -Path $extractFolder | Out-Null
}

# Extract ZIP contents
Expand-Archive -Path $zipFile -DestinationPath $extractFolder -Force

Write-Output "Extraction complete! Extracted to $extractFolder"

# Optional: delete the ZIP file after extraction
# Remove-Item -Path $zipFile

Write-Output "Done."
