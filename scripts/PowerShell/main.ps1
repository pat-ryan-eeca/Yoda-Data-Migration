
<# orchestrates the yoda migration pre-processing scripts which modify the output from the sql scripts prior to loading into the 
Enquire Data Migration tool#>

param(
    [bool]$isLEHVF = $False
)

#constants
$isLEHVF = $false
$LogPath = ".\logs\yoda.log"

function Write-Log {
    param([string]$Message, [System.ConsoleColor]$Color = "White")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logLine = "[$timestamp] $Message"
    Write-Host $logLine -ForegroundColor $Color
    Add-Content -Path $LogPath -Value $logLine -Encoding utf8
}

## process stakeholders
Write-Log "processing stakeholders" "Cyan"
$outfile = . .\scripts\PowerShell\concatBankAccount.ps1  -InputDir ".\Input\" -FileName "GEMStakeholderAcccounts.csv"
$outfile = . .\\scripts\PowerShell\deDupeWithERW.ps1  -InputDir ".\Output\" -FileName $outfile

## process projects
Write-Log "processing contracts" "Cyan"
$outfile = . .\\scripts\PowerShell\deDupeWithERW.ps1  -InputDir ".\Input\" -FileName "GEMSubProgramContracts.csv" -GemIDField "Contract_ID" -ERWTable "DIM_PRO_PROJECT" -ERWKeyField "OBJECT_ID"

#$outfile =  ./deDupeWithERW.ps1
Write-Host "processed file is $outfile" 

if ($isLEHVF) {
     . .\enrichLEHVSupplierList.ps1
}

