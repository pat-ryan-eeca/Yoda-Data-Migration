<# lookup  external ids from input file in ERW and return the Eqnuire Id
#>

#constants

$InFile = "..\Workspace\Processed\GEMStakeholderAcccounts.csv"
$OutFile = "..\Workspace\Processed\GEMStakeholderAcccounts_enriched.csv"
$KeyField = "Stakeholder_ID"
$EnquireIdColumn = "Object_ID"
$matchQuery = "SELECT ca." + $EnquireIdColumn +" FROM `DIM_CLA_CLIENT_ACCOUNT ca where ca.external_id=` "



$csvData = Import-Csv -Path $InFile
#add object_id column
Write-Host "adding $roundColumnName column ";
$csvData| Select-Object *,@{Name= $EnquireIdColumn;Expression='?'} |  Export-Csv $OutFile -NoTypeInformation


$csvData = Import-Csv -Path $OutFile
 foreach ($row in $csvData) {
	 
	 $query = $matchQuery + $row.$keyField;
	 Write-Host $query
	 # run sql, extratc resposne, append to EnquireIdColumn
	 
 }
 #save enriched file with Enquire ID added 
Export-Csv $OutFile -NoTypeInformation