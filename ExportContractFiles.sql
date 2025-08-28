USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[ExportContractFiles]    Script Date: 28/08/2025 3:41:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ExportContractFiles]
	@ProgramId INT,
	@SubProgramId INT,
	@Rootdir  NVARCHAR (2000)
AS
DECLARE @ImageData VARBINARY (max);
DECLARE @Path2OutFile NVARCHAR (2000);
DECLARE @Filename NVARCHAR (2000);
DECLARE @Obj INT
DECLARE @ReturnCode INT

DECLARE cursor_contract  CURSOR FOR

		SELECT convert (IMAGE, f.file_data, 1), f.filename
         from Contract c join Project p
		on  c.Project_ID=p.Project_ID
		INNER JOIN  COMM_DocumentsUniversalResources u
		on p.Uro_ID= u.universal_resource_id
		INNER JOIN  [GEM_UAT].[dbo].[COMM_Documents] d
		on u.document_id=d.document_id
		INNER JOIN  COMM_Files f
		on d.file_id = f.file_id
        where  p.Program_ID = 10
			and p.Subprogram_ID = 42
		    -- and  c.Contract_ID=4457
	

OPEN cursor_contract;

FETCH NEXT FROM cursor_contract INTO @ImageData, @Filename
WHILE @@FETCH_STATUS = 0

BEGIN

	PRINT  'extracting ' +  @Filename 
	exec ExportImageToFile @RootDir, @Filename,  @ImageData
	FETCH NEXT FROM cursor_contract INTO @ImageData, @Filename
END;
-- Close the cursor to release resources
CLOSE cursor_contract;

-- Deallocate the cursor to remove it from memory
DEALLOCATE cursor_contract;
