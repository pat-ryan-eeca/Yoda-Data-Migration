<# checks for duplicates in GEM export files  by comparing with the file in PreviousRunsPath
If a duplicate is found we check if the new data is more recent, in which case we keep it 
Otherwise we remove the duplicate from the new file
The updated file is saved to OutPath

Run this script from the directory above rootdir
The source files shoudl be in workDir
#>

#constants

$RoundId = 100
$roundColumnName = "enquireRoundID"
$workDir = ".\Workspace\" #name of child folder where soyrce fiels are
$outPath = "\Processed\" #relative to workDir

function addRoundID {
	
	param (
		[string]$FileName,
		[string]$KeyField
		
		)


    $csvDataNew = Import-Csv -Path  "$workDir$FileName";
	$columnHeaders = $csvDataNew[0].PSObject.Properties.Name

	# add round column if not already there
	if ($columnHeaders -contains $roundColumnName) {
	Write-Host "column $roundColumnName  found";
		
	} else {
		
	Write-Host "adding $roundColumnName column ";
		 $csvDataNew| Select-Object *,@{Name= $roundColumnName;Expression={$RoundId}} |  Export-Csv $workDir$FileName -NoTypeInformation
	}
	
	
	
	#save the processed output
	$csvDataNew | Where-Object  { $_.Program_ID -notlike  "*delete*" } | Export-Csv "$workDir$OutPath$FileName" -NoTypeInformation -Force
	
}


addRoundID -FileName "GEMSubProgramContracts.csv" -KeyField Stakeholder_ID ;