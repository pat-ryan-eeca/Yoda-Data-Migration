<#add a column called RoundId to GEMSubProgramContracts.csv if not already presesent and populate with 100
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
	
	
	$updatedCsvData = $csvDataNew | ForEach-Object {
    $currentRow = $_
    
    # Create an ordered hashtable to define the new column order
    $properties = [ordered]@{}
    $properties.Add($roundColumnName, $RoundId) # Add the new column first

    # Add all existing properties from the current row
    foreach ($property in $currentRow.PSObject.Properties) {
        $properties.Add($property.Name, $property.Value)
    }
    
    # Create a new custom object with the defined order
    [PSCustomObject]$properties
}
	
	
	#save the processed output
	$updatedCsvData | Where-Object  { $_.Program_ID -notlike  "*delete*" } | Export-Csv "$workDir$OutPath$FileName" -NoTypeInformation -Force
	
}


addRoundID -FileName "GEMSubProgramContracts.csv" -KeyField Stakeholder_ID ;