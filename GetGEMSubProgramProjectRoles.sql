USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgramProjectRoles]    Script Date: 25/09/2025 1:12:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 10/9/2025
-- Description:	 Rteurns Roles for an Initiative (i.e a program)
-- =============================================
ALTER PROCEDURE [dbo].[GetGEMSubProgramProjectRoles]
		--
	@ProgramId INT,
	@Subprogram_ID INT,
	@External_Reference VARCHAR(200)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  select p.Program_ID, p.Subprogram_ID, p.Project_ID, sr.role_code, st.name,st.Stakeholder_ID
	from Contract c join Project p  on c.Project_ID=p.Project_ID

	join SEC_StakeholderRoles sr on
			sr.universal_resource_id=p.Uro_ID 
	join Stakeholder st on st.Stakeholder_ID=sr.stakeholder_id 

where 
			p.Program_ID = 10
			and p.Subprogram_ID = 42
			and sr.role_code ='RM'
			and p.External_Reference like '%'+@External_Reference +'%'

		

END
