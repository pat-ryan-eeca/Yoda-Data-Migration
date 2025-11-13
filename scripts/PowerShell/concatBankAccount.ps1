<# add a column to GEMStakeholderAcccounts.csv containing the concatenated bank account details save in the ./Processed folder
#>

param(
    [string]$InputDir = ".\Input\",
	[string]$FileName = "GEMStakeholderAcccounts.csv"
)

$LogPath = ".\logs\yoda.log"
function Write-Log {
    param([string]$Message, [System.ConsoleColor]$Color = "White")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logLine = "[$timestamp] $Message"
    Write-Host $logLine -ForegroundColor $Color
    Add-Content -Path $LogPath -Value $logLine -Encoding utf8
}


$bankAccountColumnName = "bank_account_number"


$outFilePrefix = "_concatBankAccount_"
$outputDir = ".\Output\"

$csvData = Import-Csv -Path $InputDir$FileName
$outFile = $outFilePrefix+$FileName

Write-Log "concatenating bank account fields for  $InputDir$FileName "
#add bank account column
Write-Log "adding $bankAccountColumnName column ";
$csvData| Select-Object *,@{Name= $bankAccountColumnName;Expression='?'} |  Export-Csv $outputDir$outFile -NoTypeInformation


$csvData = Import-Csv -Path $outputDir$OutFile

 foreach ($row in $csvData) {
	 
	 $row.$bankAccountColumnName = $row.'bank_number'.Trim() +'-'  + $row.'branch_number'.Trim() + '-' + $row.'Account_Number'.Trim()+ '-' + $row.'account_suffix'.Trim()
	 
 }

 
 Write-Log "saving changes to  $outputDir$outFile";
	$csvData | Export-Csv $outFile -NoTypeInformation -Force
return $outFile
	
	
	