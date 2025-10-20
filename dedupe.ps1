<# cgecks for duplciates in GEMStakeholderAcccounts vby comariant with the GEMStakeholderAcccounts in PreviousRunsPath
If a duplicate is found we check if hte wne dfiel dlast_updated date is more recent, in which case we keep it 
Otherwsie we remove tehg duplcite from the new fiel
The updated fiel is saved to OutPath
#>


    $PreviousRunsPath = ".\PreviousRuns\GEMStakeholderAcccounts.csv"
	$csvDataOld = Import-Csv -Path  $PreviousRunsPath 
    $csvDataNew = Import-Csv -Path ".\GEMStakeholderAcccounts.csv"
	$OutPath = ".\Processed\GEMStakeholderAcccounts.csv"

    foreach ($newRow in $csvDataNew) {
        # Access column values using dot notation
        Write-Host "Stakeholder_ID: $($row.Stakeholder_ID)"
        
        # Perform other operations with $row.ColumnName
		 $foundRow = $csvDataOld |Where-Object { $_.Stakeholder_ID -eq $($newRow.Stakeholder_ID) }
				
		 if ($null -ne $foundRow) {
			Write-Host "found duplicate $($foundRow.Stakeholder_ID) previous update :  $($foundRow.last_updated_on)" ;
		  	$oldDate = [datetime]::parseexact($foundRow.last_updated_on , 'yyyy-MM-dd HH:mm:ss.fff',$null);
		    $newDate = [datetime]::parseexact($newRow.last_updated_on, 'yyyy-MM-dd HH:mm:ss.fff',$null);
		  
			if  ( $newDate -gt $oldDate ) {
				 Write-Host "new data is more recent";
			}
			else {
				 Write-Host "new data is not more recent - deleting as duplicate";
				#mark duplicate for deletion
				$newRow.Program_ID = "delete";
			}
		
			
			
		 }
    }
	
	#save the processed output
	$csvDataNew | Where-Object  { $_.Program_ID -notlike  "*delete*" } | Export-Csv $OutPath -NoTypeInformation -Force