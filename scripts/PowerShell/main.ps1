
<# orchestrates teh yoda migration pre-processing scripts which modify teh output from the sql scripst prioer to loadinmg into the 
Enquire Data Migration tool#>


#constatnt
$isLEHVF = $false

$outfile = . .\scripts\PowerShell\concatBankAccount.ps1  -InputDir ".\Input\" -FileName "GEMStakeholderAcccounts.csv"
$outfile = . .\\scripts\PowerShell\deDupeWithERW.ps1  -InputDir ".\Output\" -FileName $outfile

#$outfile =  ./deDupeWithERW.ps1
Write-Host "processed file is $outfile" 

if (isLEHVF) {
     . .\enrichLEHVSupplierList.ps1
}

