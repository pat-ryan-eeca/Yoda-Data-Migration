USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMProgramRoles]    Script Date: 10/09/2025 3:15:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 10/9/2025
-- Description:	 Rteurns Roles for an Initiative (i.e a program)
-- =============================================
ALTER PROCEDURE [dbo].[GetGEMProgramRoles]
		--
	@ProgramId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT sr.role_code, st.name,st.Stakeholder_ID
				
				
		FROM Program p
	
		join SEC_StakeholderRoles sr on
			sr.universal_resource_id=p.Uro_ID 
		join Stakeholder st on st.Stakeholder_ID=sr.stakeholder_id 
	
		where 
			p.Program_ID = @ProgramId
		

END
