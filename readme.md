
# Prerequsisites
The python scripts get their database cerdentials from environment variables. Set it up with soemthing like

setx MYSQL_HOST "reporting.uat-enquire.cloud"
setx MYSQL_PORT "6033"
setx MYSQL_USER "eeca_rpt_user"
setx MYSQL_PASSWORD "get from Password1"
setx MYSQL_DATABASE "enquire_reporting_eeca"

## Create the stored procedures
1. Log on to the GEM database with permission to create stored procedures
2.  create the EXPORT directory  with a script like
`DECLARE @RootPath VARCHAR(255) = 'c:\temp\EXPORT2\';
SET @cmd= 'mkdir "' + @RootPath + '"';
PRINT 'Creating output folder ' + @RootPath; 
EXEC xp_cmdshell @cmd;
`
2. Run the script `UpdateYodaStoredProcedures.sql' in the .scripts\SQL\StoredProc folder to create the stored procedure 

## Data Migration 
### Pre-processing
1. checkout this project into your working directory
1. Find  the master migration script in the .\scripts\SQL\Export folder  (e.g for LEHVF this is ExportAllLEHVF.sql)
2. Run the script on the database server - it will create output csv files in a timestamped folder under the export directory 
1. Copy the exported csv files from the database to the Input folder of this project (makes sure it is clean to start with)
4. (LEHVF only)  Download the LEHVF Supplier List to the .\Input\Lists  folder 
3. Run the power shell script 'main.ps1' from the project root directory i.e

    `.\scripts\PowerShell\main.ps1`   
         or for LEHVF  
    `.\scripts\PowerShell\main.ps1 -isLEHVF $True`

### Migration
Load the pre-processed CSVs to Enquire using the Enquire Data Migration Tool

#To Do
Consider Import-Csv -Path "C:\path\to\your\input.csv" | Sort-Object -Unique | Export-Csv -Path "C:\path\to\your\output.csv" -NoTypeInformation

Sort-Object -Unique should remove rows whcuh are identical in all of their values

