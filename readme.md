
#Prerequsisites

## Create the stored procedures
1. Log on to the GEM database with permission to create stored proceduers
2. Run the script `UpdateYodaStoredProcedures.sql' in the .SQL\StoreedProc folder to create the stored procedure 

## Data Migration 
### Pre-processing
1. Find  the master migration script in the .\SQL\Export folder  (e.g for LEHVF this is ExportAllLEHVF.sql)
2. Run the script on the database - it will cretae output csv files in a timestamped folder under the designated export folder 
1. create a workspace folder on a windows machine for the migration files, and copy the exported csv files from the database to it
2. Copy the scripts from the PowerShell folder to the Workspace folder 
3. Run the power shell script 'concatBankAccount.ps1'
4. (LEHVF only)  Download the LEHVF Supplier List to the Workspace folder and run enrichLEHVSupplierList.ps1
5. Run the script 'match.ps1' (to do needs params for differnt entity types)

### Migration
Load the pre-processed csvs to Enquire usign the DMT




#To do
- enhance dedupe script to use a sql command to get the external ids of the objects alreadfy loaded and use these top dedupe against
- refactor dedupe to function and repeat for all csvs

- create a log file 
GetGEMSubProgramContractVariations is slow


#How to install the stored procedures

1. create a working directroy that the database user has permission to access (note that although I was logged on to the database as a a windwos usewr, my windwos directory was not accessable from a SQL script run from ssms on the daatbase server. I had to cretae the folder using a tlsql script -  from the ssms console ,
`DECLARE @RootPath VARCHAR(255) = 'c:\temp\yoda\StoredProc\';
SET @cmd= 'mkdir "' + @RootPath + '"';
PRINT 'Creating output folder ' + @RootPath; 
EXEC xp_cmdshell @cmd;
`

2. checkout the code from git, and copy to the root folder, then run (from mssql) the script

'UpdateYodaStoredProcs.sql'


GetGEMSubProgramContractVariations is slow