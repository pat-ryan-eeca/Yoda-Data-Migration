
Prerequsisites
1. create ProcessedDirectory and PreviousRuns directoy in working directory


Steps to perfrom to migrate a fund from GEM to Enquire
1. Log on tot he GEM databases serve rand run the master database script : one of
ExportAllCREF.sql
ExportAllLEHVF.sql

2. This will generetae oputput folders on teh srever, copy these to your woreking directory

3. Get the latest List for LEHVF and copy them to a subdirectroy called ./Lisst in the workign folders
4. From a command shell in the working directory, run the powershell script
dedupe.ps1


To do
- align csv files with Tactiv entities
- refactor dedupe to function and repeat for all csvs
- create ProcessedDirectory and PreviousRuns directoy in working directory
- copy/merge new files to PreviousRuns once complete
- create a log file 