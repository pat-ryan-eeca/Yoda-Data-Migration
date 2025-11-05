
# Prerequsisites

## Create the stored procedures
1. Log on to the GEM database with permission to create stored proceduers
2.  create the EXPORT directory  with a script like
`DECLARE @RootPath VARCHAR(255) = 'c:\temp\EXPORT2\';
SET @cmd= 'mkdir "' + @RootPath + '"';
PRINT 'Creating output folder ' + @RootPath; 
EXEC xp_cmdshell @cmd;
`
2. Run the script `UpdateYodaStoredProcedures.sql' in the .SQL\StoreedProc folder to create the stored procedure s

## Data Migration 
### Pre-processing
1. Find  the master migration script in the .\SQL\Export folder  (e.g for LEHVF this is ExportAllLEHVF.sql)
2. Run the script on the database - it will cretae output csv files in a timestamped folder under the export directory 
1. create a workspace folder on a windows machine for the migration files, and copy the exported csv files from the database to it
2. Copy the scripts from the PowerShell folder to the Workspace folder 
3. Run the power shell script 'concatBankAccount.ps1'
4. (LEHVF only)  Download the LEHVF Supplier List to the Workspace folder and run the script 'enrichLEHVSupplierList.ps1'
5. Run the script 'match.ps1' (to do needs params for differnt entity types)

### Migration
Load the pre-processed CSVs to Enquire using the Enquire Daat Migration Tool



# To do
- enhance dedupe script to use a sql command to get the external ids of the objects already loaded and use these to dedupe against
- refactor dedupe to function and repeat for all csvs

- create a log file 
GetGEMSubProgramContractVariations is slow and has duplicates

