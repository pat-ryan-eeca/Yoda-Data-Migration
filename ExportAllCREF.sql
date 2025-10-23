
DECLARE @ProgramId INT= 9;
DECLARE @SubProgramId INT =34;
DECLARE @External_Ref VARCHAR(200)='CREF';
DECLARE @RootPath VARCHAR(255) = 'c:\temp\GEMEXPORT2\CREF\'

EXEC  ExportAll @ProgramID, @SubProgramId, @External_Ref, @RootPath