USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgramContractsFiles]    Script Date: 11/20/2025 2:17:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 8/9/2025
-- Description:	Get Files associated with a contract
-- =============================================
CREATE OR ALTER   PROCEDURE [dbo].[GetGEMSubProgramContractsFiles] 
	@ProgramId INT,
	@SubProgramId INT,
	@External_Reference VARCHAR(200)='',
	@Project_Code VARCHAR(200)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 
with t1 as (
    SELECT   p.Program_ID,  p.Subprogram_ID, p.Project_ID, c.Contract_ID, f.filename, d.document_title

        from Contract c join Project p
		on  c.Project_ID=p.Project_ID
		INNER JOIN  COMM_DocumentsUniversalResources u
		on p.Uro_ID= u.universal_resource_id
		INNER JOIN  [GEM_UAT].[dbo].[COMM_Documents] d
		on u.document_id=d.document_id
		INNER JOIN  COMM_Files f
		on d.file_id = f.file_id

		INNER JOIN  dbo.GrantWorkflowInstance gwi on gwi.Grant_ID=p.Project_ID and p.Subprogram_ID =@SubProgramId
		--project code is defined in a child workflow of the contract variation workflow
		INNER join GrantWorkflowInstance gwic on gwic.Parent_Workflow_Instance_ID = gwi.Workflow_Instance_ID
		LEFT JOIN dbo.GrantData gd on
			gd.Workflow_Instance_ID = gwic.Workflow_Instance_ID                 
			and gd.Field_Definition_ID=1700
			and gd.Grant_ID = gwic.Grant_ID

        where  p.Program_ID = @ProgramId
			and p.Subprogram_ID = @SubProgramId
			and p.External_Reference like '%'+@External_Reference +'%'
			and CAST(gd.Value AS VARCHAR(MAX)) like  '%'+@Project_Code +'%'
 
			)

			 -- dedupe
	select distinct 
		Program_ID,
		Subprogram_ID,
		Project_ID,
		Contract_ID,
		filename,
		document_title

		from t1
END
