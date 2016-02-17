# Uses AlphaFS to search for files.
#
# Example: .\search_files.ps1 -Filter "*.encrypted" -Recurse
#
# Optional arguments:
# -Recurse - Boolean determining whether to recursively search or not
# -OutputFile - Output search results into CSV format file
# -MoveTo - Move found file to this folder
# 
# by Stefan Midjich <swehack@gmail.com> - 2016

param(
  [string]$SearchPath = (Get-Location).Path,
  [string]$OutputFile = $false,
  [switch]$Recurse = $false,
  [string]$Filter = "*",
  [string]$MoveTo = $false
)

# Include AlphaFS version of Get-ChildItem without 260-char path limit.
Import-Module -name "C:\scripts\AlphaFS.2.0.1\lib\net451\AlphaFS.dll"
. .\Get-AlphaFSChildItem.ps1

$report = @()

foreach ($File in (Get-AlphaFSChildItem -Recurse:$Recurse -Path:$SearchPath -SearchPattern:$Filter)) {
  $row = "" | select Owner, FullName, FileSize, Created, LastAccessed, LastModified
  $row.Owner = (get-acl $File.FullName).Owner
  $row.FullName = $File.FullName
  $row.FileSize = $File.FileSize
  $row.Created = $File.Created
  $row.LastAccessed = $File.LastAccessed
  $row.LastModified = $File.LastModified

  $report += $row

  if ($MoveTo -ne $false) {
    Write-Progress -Activity "search_shares.ps1" -Status "Moving $($File.FullName) to $($MoveTo)"
    Write-Debug "Moving $($File.FullName) to $($MoveTo)"
    Move-Item $File.FullName $MoveTo
  }

  # The -Append argument only works on Win2k12 and higher.
  if ($OutputFile -ne $false) {
    $row | export-csv -Path $OutputFile -Append
  } else {
    write-host $row
  }
}
