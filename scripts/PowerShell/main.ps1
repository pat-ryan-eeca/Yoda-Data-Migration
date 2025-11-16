
<# orchestrates the yoda migration pre-processing scripts which modify the output from the sql scripts prior to loading into the 
Enquire Data Migration tool
A pipes and filters pattern is used - each step acts on the output from the previous step and creates a new outpout file with a prefix
 indicating the action taken.  This is placed in the output folder ands and is used as input to the next step

#>

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

Write-Log "============== Yoda data nmigration pre-rpcoessing started =====================" "Cyan"
## process stakeholders
Write-Log "processing stakeholders" "Cyan"
$outfile = . .\scripts\PowerShell\concatBankAccount.ps1  -InputDir ".\Input\" -FileName "GEMStakeholderAcccounts.csv"
$outfile = . .\\scripts\PowerShell\deDupeWithERW.ps1  -InputDir ".\Output\" -FileName $outfile

## process projects
Write-Log "processing contracts" "Cyan"
$outfile = . .\\scripts\PowerShell\deDupeWithERW.ps1  -InputDir ".\Input\" -FileName "GEMSubProgramProjects.csv" -GemIDField "Project_ID" -ERWTable "DIM_PRO_PROJECT" -ERWKeyField "OBJECT_ID"

#$outfile =  ./deDupeWithERW.ps1
Write-Host "processed file is $outfile" 

if ($isLEHVF) {
     . .\enrichLEHVSupplierList.ps1
}



Write-Log "============== Yoda data nmigration pre-rpcoessing finished =====================" "Cyan"
Write-Log  "see $LogPath for details"
