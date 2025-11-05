<# add a column to GEMStakeholderAcccounts.csv containing the concatenated bank account details save in the ./Processed folder
#>

$bankAccountColumnName = "bank_account_number"
$workDir = ".\Workspace\" #name of child folder where soyrce fiels are
$FileName = "GEMStakeholderAcccounts.csv"
$outPath = ".\Processed\" #relative to workDir

$csvData = Import-Csv -Path $workDir$FileName

#add bank account column
Write-Host "adding $roundColumnName column ";
$csvData| Select-Object *,@{Name= $bankAccountColumnName;Expression='?'} |  Export-Csv $workDir$OutPath$FileName -NoTypeInformation


$csvData = Import-Csv -Path $workDir$OutPath$FileName

 foreach ($row in $csvData) {
	 
	 $row.$bankAccountColumnName = $row.'bank_number'.Trim() +'-'  + $row.'branch_number'.Trim() + '-' + $row.'Account_Number'.Trim()+ '-' + $row.'account_suffix'.Trim()
	 
 }
 
 
 Write-Host "saving changes to + $outPath";
	$csvData | Export-Csv $workDir$OutPath$FileName -NoTypeInformation -Force
	
	
	