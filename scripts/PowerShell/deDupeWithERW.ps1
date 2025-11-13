<# 
checks for duplicates in GEM export files looking up the object id in the ERW
If a duplicate is found we mark at as a duplicate in the soucre file

The updated file is saved to OutPath
To capture logs run with cmd
powershell -File .\PowerShell\dedupe.ps1 > .\logs\dedupe.log 2>&1
or
.\PowerShell\dedupe.ps1 | Tee-Object -FilePath .\logs\dedupe.log -Append
to write to console as well as logs

e.g (with parameters)
 .\deDupeWithERW.ps1 -FileName "..\Workspace\GEMStakeholderAcccounts.csv" -GemIDField "Stakeholder_ID" -ERWTable "DIM_CLA_CLIENT_ACCOUNT" -ERWKeyField "RECORD_ID" | Tee-Object -FilePath .\logs\dedupe.log -Append
Todo
If a duplicate is found check if the new record is more recent, if so  mark it as an update.
Otherwise mark at as a duplciatecd 

#>

param(
    [string]$FileName = ".\Workspace\GEMStakeholderAcccounts.csv",
    [string]$GemIDField = "Stakeholder_ID",
    [string]$ERWTable = "DIM_CLA_CLIENT_ACCOUNT",
    [string]$ERWKeyField = "RECORD_ID"
)

#Constants
#paths relative to project root
$OutPath = "..\Processed\"
$LogPath = "..\logs\dedupe.log"

$pyScript = Resolve-Path -Path (Join-Path $PSScriptRoot '..\Python\call_record_exists.py')
# Create logs directory if it doesn't exist
New-Item -ItemType Directory -Force -Path (Split-Path $LogPath) | Out-Null

# Helper function to write to console and log file
function Write-Log {
    param([string]$Message, [System.ConsoleColor]$Color = "White")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logLine = "[$timestamp] $Message"
    Write-Host $logLine -ForegroundColor $Color
    Add-Content -Path $LogPath -Value $logLine -Encoding utf8
}

$py = '
import sys, json
try:
    from query_mysql import record_exists
except Exception as e:
    print(json.dumps({"error": "import error: " + str(e)}))
    sys.exit(1)
try:
    out = record_exists(sys.argv[1], sys.argv[2], sys.argv[3])
    print(json.dumps(out))
except Exception as e:
    print(json.dumps({"error": str(e)}))
    sys.exit(2)
'

function deDupe {
	
	param (
		[string]$FileName,
		[string]$GemIDField,
        [string]$ERWTable,
        [string]$ERWKeyField	
		)

        

        $csvDataNew = Import-Csv -Path  $FileName;

        foreach ($newRow in $csvDataNew) {
                # Access column values using dot notation
            
                Write-Log "deduplicating file $FileName" 
                # Perform other operations with $row.ColumnName
                # $foundRow = $csvDataOld |Where-Object { $_.$KeyField -eq $($newRow.$KeyField) }
                $GemIDValue = $newRow.$GemIDField

                

                 # Call python to query ERW and capture output
                #$output = & python -c $py $ERWTable $ERWKeyField $GemIDValue 2>&1
                $output = & python $pyScript $ERWTable $ERWKeyField $GemIDValue 2>&1

                  if ($LASTEXITCODE -eq 0) {
                    $txt = $output.Trim()
                    if ($txt -eq 'true') {
                        Write-Log "$GemIDValue : Found (exactly one)"
                         $newRow.Program_ID = "duplicate";
                    } elseif ($txt -eq 'false') {
                        Write-Log "$GemIDValue : Not found"
                    } else {
                        # unexpected non-json/boolean; try parse
                        try {
                            $obj = $txt | ConvertFrom-Json
                            if ($obj -is [System.Management.Automation.PSObject] -and $obj.error) {
                                Write-Log "$GemIDValue : Error - $($obj.error)"
                            } else {
                                Write-Log "$GemIDValue : Unknown response: $txt"
                            }
                        } catch {
                            Write-Log "$GemIDValue : Unexpected output: $txt"
                        }
                    }
                } else {
                    # Non-zero exit -> parse possible JSON error
                    try {
                        $errObj = ($output.Trim()) | ConvertFrom-Json
                        if ($errObj.error) {
                            Write-Log "$GemIDValue : Error - $($errObj.error)"
                        } else {
                            Write-Log "$GemIDValue : Python returned exit code $LASTEXITCODE - $output"
                        }
                    } catch {
                        Write-Log "$GemIDValue : Python returned exit code $LASTEXITCODE - $output"
                    }
                }

             
            }

        }


      deDupe -FileName $FileName -GemIDField $GemIDField -ERWTable $ERWTable -ERWKeyField $ERWKeyField