  $PreviousRunsPath = ".\PreviousRuns\GEMStakeholderAcccounts.csv"
	$csvDataOld = Import-Csv -Path  $PreviousRunsPath 
    $csvDataNew = Import-Csv -Path ".\GEMStakeholderAcccounts.csv"

    foreach ($newRow in $csvDataNew) {
        # Access column values using dot notation
        Write-Host "Stakeholder_ID: $($row.Stakeholder_ID)"
        
        # Perform other operations with $row.ColumnName
		 $foundRow = $csvDataOld | Where-Object { $_.Stakeholder_ID -eq $($newRow.Stakeholder_ID) }
		 if ($null -ne $foundRow) {
			Write-Host "found duplicate $($foundRow.Stakeholder_ID) previous update :  $($foundRow.last_updated_on)" ;
		  	$oldDate = [datetime]::parseexact($foundRow.last_updated_on , 'yyyy-MM-dd HH:mm:ss.fff',$null);
		    $newDate = [datetime]::parseexact($newRow.last_updated_on, 'yyyy-MM-dd HH:mm:ss.fff',$null);
		  
			if  ( $newDate -gt $oldDate ) {
				 Write-Host "new data is more recent";
			}
		
			
			
		 }
    }