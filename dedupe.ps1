<# checks for duplicates in GEM export files  by comparing with the file in PreviousRunsPath
If a duplicate is found we check if the new data is more recent, in which case we keep it 
Otherwise we remove the duplicate from the new file
The updated file is saved to OutPath
#>

#constants
$PreviousRunsPath = ".\PreviousRuns\"
$OutPath = ".\Processed\"

function deDupe {
	
	param (
		[string]$FileName,
		[string]$KeyField
		
		)


	$csvDataOld = Import-Csv -Path "$PreviousRunsPath$FileName"
    $csvDataNew = Import-Csv -Path  ".\$FileName";
	

    foreach ($newRow in $csvDataNew) {
        # Access column values using dot notation
      
        Write-Host "Key field is $KeyField"
        # Perform other operations with $row.ColumnName
		# $foundRow = $csvDataOld |Where-Object { $_.$KeyField -eq $($newRow.$KeyField) }
		$x = $newRow.$KeyField
		$foundRow = $csvDataOld |Where-Object { $_.$KeyField -eq $x }
		# $foundRow = $csvDataOld |Where-Object { $_.($($KeyField)) -eq $($newRow.Stakeholder_ID) }
		
		 
		 if ($null -ne $foundRow) {
			$dup = $foundRow.$KeyField
			Write-Host "found duplicate  $dup"
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
	$csvDataNew | Where-Object  { $_.Program_ID -notlike  "*delete*" } | Export-Csv "$OutPath$FileName" -NoTypeInformation -Force
	
}


deDupe -FileName "GEMStakeholderAcccounts.csv" -KeyField Stakeholder_ID ;