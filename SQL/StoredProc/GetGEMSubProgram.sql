USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgram]    Script Date: 29/09/2025 2:09:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetGEMSubProgram]
	--
	@ProgramId INT,
	@SubProgramId INT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

      SELECT p.Program_ID, s.Subprogram_ID,  dbo.CleanString(p.Short_Name) as program_shortname, dbo.CleanString(p.Brief_Outline) as program_Brief_Outline,  dbo.CleanString(s.Name) as Subprogram_Name,  s.Budget_Code as Subprogram_Budget_Code, s.Start_Date as Subprogram_Start_Date, 	  
				 s.End_Date as Subprogram_End_Date,  dbo.CleanString(s.Brief_Outline) as Subprogram_Brief_Outline, s.Workflow_Code,
				  st.Stakeholder_ID as InitiativeAdmistratorId, st.name as InitiativeAdmistratorName
		FROM Program p
		join subprogram s on s.Program_ID = p.Program_ID
		join SEC_StakeholderRoles sr on
			sr.universal_resource_id=p.Uro_ID and sr.role_code = 'PROGADM'
		join Stakeholder st on st.Stakeholder_ID=sr.stakeholder_id

	
		where 
			p.Program_ID = @ProgramId 
			and s.Subprogram_ID =@SubProgramId 


END
