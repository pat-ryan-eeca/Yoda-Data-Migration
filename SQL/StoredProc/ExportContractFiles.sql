USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[ExportClaimFiles]    Script Date: 10/31/2025 2:16:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 18/8/2025
-- Description:	Export all claim files for the given program, subprogram to a directory
-- =============================================
CREATE OR ALTER   PROCEDURE [dbo].[ExportClaimFiles]
	@ProgramId INT,
	@SubProgramId INT,
	@Rootdir  NVARCHAR (2000),
	@External_Reference VARCHAR(200)=''

AS

DECLARE @FullPath NVARCHAR (2000);
DECLARE @Filename NVARCHAR (2000);
DECLARE @Obj INT
DECLARE @ReturnCode INT
DECLARE @FileID INT

DECLARE cursor_contract  CURSOR FOR

	SELECT f.file_id, f.filename
		from Project p
		INNER JOIN contract c on c.Project_ID = p.Project_ID
		INNER JOIN PRJ_Milestones m on p.Project_ID=m.project_id
		INNER JOIN PRJ_MilestoneClaims mc on mc.milestone_id = m.milestone_id
		INNER JOIN PRJ_ClaimDocuments cd on cd.claim_id = mc.claim_id 
		INNER JOIN  COMM_Documents d on d.document_id = cd.document_id
		join COMM_Files f on f.file_id = d.file_id

	where p.Subprogram_ID =@SubProgramId 
	and p.Program_ID = @ProgramId 
	and  p.External_Reference like '%'+@External_Reference +'%'
	

OPEN cursor_contract;

FETCH NEXT FROM cursor_contract INTO @FileID, @Filename
WHILE @@FETCH_STATUS = 0

BEGIN
	SET @FullPath = @RootDir+@Filename
	PRINT  'Extracting file ' +  @Filename 
	exec ExportImageToFile @FileID,'COMM_Files', @FullPath
	FETCH NEXT FROM cursor_contract INTO @FileID, @Filename
END;
-- Close the cursor to release resources
CLOSE cursor_contract;

-- Deallocate the cursor to remove it from memory
DEALLOCATE cursor_contract;
