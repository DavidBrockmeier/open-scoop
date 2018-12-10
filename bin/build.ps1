# This file is used by a bot to 
# automatically update Open-Scoop application.
# Please do not edit this file.

# Variables
$USER = $env:USERNAME
$SCOOP = scoop which scoop
if ( !$env:SCOOP_HOME ) { 
  $env:SCOOP_HOME = resolve-path (split-path (split-path (scoop which scoop))) 
}
$checkver = "C:\\Users\\$USER\\scoop\\apps\\scoop\\current\\bin\\checkver.ps1"
$dir = "C:\\Users\\$USER\\scoop\\proj\\open-scoop" 

#Start
Set-Location $HOME
Set-Location scoop/proj/open-scoop/bin

git pull

$files = Get-ChildItem ../.\*.json
$i = 1;
Get-ChildItem ../.\*.json | Foreach-Object {
  $basename = $_.BaseName
  Write-Progress -Activity "Updating application manifests" -status "Scanning $basename.json" -percentComplete ($i / $files.count * 100)
  $out = ../../../apps/scoop/current/bin/checkver.ps1 -dir $dir -App $basename -u | Out-String
  git commit -q -a -m "Auto-updated $basename" > log.txt
  $i++
}

Write-Output "Finished updating app manifests"
Set-Location ..