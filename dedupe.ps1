
    $csvData = Import-Csv -Path ".\GEMStakeholderAcccounts_lehvf.csv"
	$csvData2 = Import-Csv -Path ".\GEMStakeholderAcccounts_cref.csv"

    foreach ($row in $csvData) {
        # Access column values using dot notation
        Write-Host "Stakeholder_ID: $($row.Stakeholder_ID)"
        
        # Perform other operations with $row.ColumnName
		 $foundRow = $csvData2 | Where-Object { $_.Stakeholder_ID -eq $($row.Stakeholder_ID) }
		 if ($null -ne $foundRow) {
			Write-Host "found duplciate $($foundRow.Stakeholder_ID)" 
		 }
    }