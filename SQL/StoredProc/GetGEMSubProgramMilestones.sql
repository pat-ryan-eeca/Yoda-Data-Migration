USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgramMilestones]    Script Date: 29/09/2025 4:10:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 30/10/2025
-- Description:	Return the a subprogram's milestones
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[GetGEMSubProgramMilestones] 
	@ProgramId INT,
	@SubProgramId INT,
	@External_Reference VARCHAR(200)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	  select  p.Program_ID,p.Subprogram_ID, p.Project_ID as Contract_ID, m.milestone_id,  mf.name as type , m.title, m.due_date,m.reference, m.submitted_as_complete_datetime, dbo.CleanString(m.description), m.amount_type,m.amount

		from Contract c 
		join Project p  on c.Project_ID=p.Project_ID
		join PRJ_Milestones m on m.project_id = p.Project_ID
		join PRJ_MilestoneForms mf on mf.form_id = m.form_id

		where 
			p.Subprogram_ID = @SubProgramId
			and p.Program_ID = @ProgramId
			--and p.Project_Actual_Finish_Date >  cast(sysdatetime() as date)
			and p.External_Reference like '%'+@External_Reference +'%'

END
