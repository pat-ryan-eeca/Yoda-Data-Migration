
DECLARE @ProgramId INT= 10;
DECLARE @SubProgramId INT =42;
DECLARE @External_Ref VARCHAR(200)='';

EXEC  ExportAll @ProgramID, @SubProgramId, @External_Ref