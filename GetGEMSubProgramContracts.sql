USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgramContracts]    Script Date: 29/09/2025 2:48:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetGEMSubProgramContracts]
	-- Add the parameters for the stored procedure here
	@ProgramId INT,
	@SubProgramId INT,
	@External_Reference VARCHAR(200)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select p.Project_ID as Contract_ID, c.Stakeholder_id as applicant,  p.Project_Title as Contract_Title, p.External_Reference, 
		p.Project_Status_ID, p.Project_Actual_Start_Date, p.Project_Actual_Finish_Date,pd.value as EECA_CONTACT
		from Contract c join Project p  on c.Project_ID=p.Project_ID
		join STKH_Stakeholders s on c.Stakeholder_ID = s.stakeholder_id
		join STKH_Legal l on l.stakeholder_id=s.stakeholder_id
		join SEC_StakeholderRoles sr on s.stakeholder_id = sr.stakeholder_id and sr.universal_resource_id=p.Uro_ID
		join PRJ_ProjectData pd on pd.universal_resource_id=p.Uro_ID


		where p.Subprogram_ID =@SubProgramId 
		and p.Program_ID = @ProgramId 
		--and p.Project_Actual_Finish_Date >  cast(sysdatetime() as date)
		and  p.Project_Actual_Start_Date is not null
		and pd.field_code='PROJ_EECA_CONTACT'
		and p.External_Reference like '%'+@External_Reference +'%'
 
END
