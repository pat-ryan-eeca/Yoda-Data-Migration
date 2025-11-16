<# 
checks for duplicates in GEM export files looking up the object id in the ERW
If a duplicate is found we mark at as a duplicate in the output file

The updated file is saved to OutPath

Todo
----
If a duplicate is found check if the new record is more recent, if so  mark it as an update.
Otherwise mark at as a duplciatecd 

#>

param(
    [string]$InputDir = ".\Input\",
    [string]$FileName = "GEMStakeholderAcccounts.csv",
    [string]$GemIDField = "Stakeholder_ID",
    [string]$ERWTable = "DIM_CLA_CLIENT_ACCOUNT",
    #need to replace this with the actual name of the External_id field
    [string]$ERWKeyField = "RECORD_ID"
)

#Constants
#paths relative to project root

$outputDir = ".\Output\"

$LogPath = ".\logs\yoda.log"

$pyScript = Resolve-Path -Path (Join-Path $PSScriptRoot '..\Python\call_record_exists.py')
# Create logs directory if it doesn't exist
New-Item -ItemType Directory -Force -Path (Split-Path $LogPath) | Out-Null
# Create output directory if it doesn't exist
New-Item -ItemType Directory -Force -Path (Split-Path $OutPath) | Out-Null

# Helper function to write to console and log file
function Write-Log {
    param([string]$Message, [System.ConsoleColor]$Color = "White")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logLine = "[$timestamp] $Message"
    Write-Host $logLine -ForegroundColor $Color
    Add-Content -Path $LogPath -Value $logLine -Encoding utf8
}



function deDupe {
    
    param (
        [string]$InputDir,
        [string]$FileName,
        [string]$GemIDField,
        [string]$ERWTable,
        [string]$ERWKeyField	
    )


        $csvDataNew = Import-Csv -Path  $InputDir$FileName
        Write-Log "Opened CSV file: $FileName with $($csvDataNew.Count) rows" "Green"

        # Collect all unique IDs to check
        $allIDs = @($csvDataNew | ForEach-Object { $_.$GemIDField } | Where-Object { $_ } | Select-Object -Unique)
        Write-Log "Collected $($allIDs.Count) unique IDs to check in batch" "Cyan"

        # Call Python once with all IDs in batch
        $idListString = $allIDs -join ','
        $output = & python $pyScript $ERWTable $ERWKeyField $idListString 2>&1

        if ($LASTEXITCODE -eq 0) {
            $txt = $output.Trim()
            try {
                # Parse JSON array response
                $existingIds = $txt | ConvertFrom-Json
                Write-Log "Found $($existingIds.Count) existing IDs in ERW table" "Green"

                # Convert to hash for O(1) lookup
                $existingIdHash = @{}
                foreach ($id in $existingIds) {
                    $existingIdHash[$id] = $true
                }

                # Update rows based on batch results
                $duplicateCount = 0
                $notFoundCount = 0

                foreach ($newRow in $csvDataNew) {
                    $GemIDValue = $newRow.$GemIDField
                    if ([string]::IsNullOrWhiteSpace($GemIDValue)) {
                        continue
                    }

                    if ($existingIdHash.ContainsKey($GemIDValue)) {
                        Write-Log "$GemIDValue : Found in ERW - marking as duplicate" "Yellow"
                        $newRow.Program_ID = "duplicate"
                        $duplicateCount++
                    } else {
                        Write-Log "$GemIDValue : Not found in ERW" "Green"
                        $notFoundCount++
                    }
                }

                Write-Log "Summary: $duplicateCount duplicates found, $notFoundCount new records" "Cyan"

            } catch {
                Write-Log "ERROR parsing JSON response: $_" "Red"
                return
            }
        } else {
            Write-Log "ERROR: Python returned exit code $LASTEXITCODE - $output" "Red"
            return
        }

        # Save output to processed folder
        $outFilePrefix = "_dedupe_"
        $outFile = $outputDir+$outFilePrefix+$FileName
        $csvDataNew | Export-Csv $outFile -NoTypeInformation -Force
        Write-Log "Processed file saved to: $outFile" "Green"
}

Write-Log "=== deDupeWithERW started ===" "Cyan"
deDupe -InputDir $InputDir -FileName $FileName -GemIDField $GemIDField -ERWTable $ERWTable -ERWKeyField $ERWKeyField
Write-Log "=== deDupeWithERW completed ===" "Cyan"