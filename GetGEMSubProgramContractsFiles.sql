USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgramContractsFiles]    Script Date: 8/09/2025 5:10:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 8/9/2025
-- Description:	Get Files associated with a contract
-- =============================================
ALTER PROCEDURE [dbo].[GetGEMSubProgramContractsFiles] 
	@ProgramId INT,
	@SubProgramId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT   p.Program_ID,  p.Subprogram_ID, p.Project_ID, c.Contract_ID, f.filename, d.document_title

        from Contract c join Project p
		on  c.Project_ID=p.Project_ID
		INNER JOIN  COMM_DocumentsUniversalResources u
		on p.Uro_ID= u.universal_resource_id
		INNER JOIN  [GEM_UAT].[dbo].[COMM_Documents] d
		on u.document_id=d.document_id
		INNER JOIN  COMM_Files f
		on d.file_id = f.file_id
        where  p.Program_ID = @ProgramId
			and p.Subprogram_ID = @SubProgramId
			

END
