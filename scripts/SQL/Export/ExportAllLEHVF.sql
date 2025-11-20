DECLARE @ProgramId INT= 10;
DECLARE @SubProgramId INT =42;
DECLARE @External_Ref VARCHAR(200)='';
DECLARE @Project_Code VARCHAR(200)='';
DECLARE @RootPath VARCHAR(255) = 'c:\temp\GEMEXPORT2\LEHVF\'

EXEC  ExportAll @ProgramID, @SubProgramId, @External_Ref,@Project_Code, @RootPath, 1