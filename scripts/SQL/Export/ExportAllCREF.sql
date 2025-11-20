DECLARE @ProgramId INT= 9;
DECLARE @SubProgramId INT =34;
DECLARE @Project_Code VARCHAR(200)='4013.6100.M065';
DECLARE @External_Ref VARCHAR(200)='CREF';
DECLARE @RootPath VARCHAR(255) = 'c:\temp\GEMEXPORT2\CREF\'

EXEC  ExportAll @ProgramID, @SubProgramId, @External_Ref,@Project_Code, @RootPath