# ===== Deployment Script for poker-course-advanced =====
# Builds MkDocs site, backs up current site on server, uploads new version.

$serverUser = "root" # Server SSH username
$serverHost = "206.168.213.20" # Server IP or hostname
$serverPort = "22"                     # SSH port
$remoteDir = "/var/www/poker-course-advanced"   # Remote directory for MkDocs build
$backupDir = "/var/www/poker-course-advanced-backups" # Remote backups folder
$dateStamp = Get-Date -Format "yyyyMMdd_HHmmss"

Write-Host "=== Starting Deployment for poker-course-advanced ==="

# Step 1: Build MkDocs site
Write-Host "Building MkDocs site..."
mkdocs build
if ($LASTEXITCODE -ne 0) {
    Write-Error "MkDocs build failed. Aborting deployment."
    exit 1
}

# Step 2: Ensure backup directory exists on server
Write-Host "Ensuring backup directory exists..."
ssh -p ${serverPort} ${serverUser}@${serverHost} "mkdir -p ${backupDir}"

# Step 3: Backup current site
Write-Host "Backing up existing site..."
ssh -p ${serverPort} ${serverUser}@${serverHost} "if [ -d ${remoteDir} ]; then cp -r ${remoteDir} ${backupDir}/backup_${dateStamp}; fi"

# Step 4: Clean old files
Write-Host "Cleaning old site files..."
ssh -p ${serverPort} ${serverUser}@${serverHost} "rm -rf ${remoteDir}/*"

# Step 5: Upload new site
Write-Host "Uploading new site..."
scp -P ${serverPort} -r site/* "${serverUser}@${serverHost}:${remoteDir}"

# Step 6: Verify
Write-Host "Verifying new site..."
ssh -p ${serverPort} ${serverUser}@${serverHost} "ls -l ${remoteDir} | head"

Write-Host "=== Deployment completed successfully! ==="
Write-Host "Rollback: rm -rf ${remoteDir}/* && cp -r ${backupDir}/backup_${dateStamp}/* ${remoteDir}/"
