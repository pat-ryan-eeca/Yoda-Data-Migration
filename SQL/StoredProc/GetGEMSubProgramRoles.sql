USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgramRoles]    Script Date: 29/09/2025 3:11:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 10/9/2025
-- Description:	 Rteurns Roles for an Activity (i.e a Subprogram)
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[GetGEMSubProgramRoles]
		--
	@ProgramId INT,
	@SubProgramId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT @ProgramId, @SubProgramId, sr.role_code, st.name,st.Stakeholder_ID
				
				
		FROM Program p
		join subprogram s on s.Program_ID = p.Program_ID

		join SEC_StakeholderRoles sr on
			sr.universal_resource_id=s.Uro_ID 
		join Stakeholder st on st.Stakeholder_ID=sr.stakeholder_id 
	
		where 
			p.Program_ID = @ProgramId
			and s.Subprogram_ID = @SubProgramId

END
