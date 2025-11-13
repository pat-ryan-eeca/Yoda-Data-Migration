<# the  Current Supplier ID  in the sharepoint list for registered suppliers is used to match the stakleholder id from the 
	GEMSubProgramContracts file. The stakeholder id is then appended to the sharepoint_list csv 
#>
 
	$supPath = ".\Lists\LEHVF-Supplier_Details.csv"
	$supPathOut = ".\LEHVF-Supplier_Details_enriched.csv"
	
	$supData = Import-Csv -Path $supPath
	$stakeholderColumnName = "stakeholderid"
	

	
	$columnHeaders = $supData[0].PSObject.Properties.Name
	
	# add skaeholderid column if not already there
	if ($columnHeaders -contains $stakeholderColumnName) {
	Write-Host "column " + $stakeholderColumnName +  " found";
		
	} else {
		
	Write-Host "adding stakeholder column ";
		 $supData| Select-Object *,@{Name= $stakeholderColumnName;Expression={'unknown'}} |  Export-Csv $supPath -NoTypeInformation
	}
		
		
	$supData = Import-Csv -Path $supPath
	
     $contractData = Import-Csv -Path ".\GEMSubProgramContracts.csv"

    foreach ($row in $supData) {
        # Access column values using dot notation
		$supplierID = $row.'Current Supplier ID';
        Write-Host "Supplier_ID: " +  $supplierID;
		$searchString = '*'+  $supplierID + '*';
      
        # Perform other operations with $row.ColumnName
		 Write-Host " looking for  $($row.'Current Supplier ID')"
		 $foundRow = $contractData | Where-Object { $_.Reference -like $($searchString) }
		
		 if ($null -ne $foundRow) {
			
			Write-Host  "applicant stakeholder is $($foundRow.Applicant)" 
			 $row.stakeholderid = $foundRow.Applicant
			
			
		 } else {
			Write-Host  "not found"
		 }

    }
	Write-Host "saving changes to + $supPathOut";
	$supData | Export-Csv $supPathOut -NoTypeInformation -Force
	#$supData | Export-Csv '.\file7.csv' -NoTypeInformation -Force
	
