USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgramContracts]    Script Date: 28/08/2025 3:36:50 PM ******/
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
	@SubProgramId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select p.Project_ID as Contract_ID, c.Stakeholder_id as applicant,  p.Project_Title as Contract_Title, p.External_Reference, p.Project_Status_ID, p.Project_Actual_Start_Date, p.Project_Actual_Finish_Date
		from Contract c join Project p  on c.Project_ID=p.Project_ID
		join STKH_Stakeholders s on c.Stakeholder_ID = s.stakeholder_id
		join STKH_Legal l on l.stakeholder_id=s.stakeholder_id
		where p.Subprogram_ID =@SubProgramId 
		and p.Program_ID = @ProgramId 
		and p.Project_Actual_Finish_Date >  cast(sysdatetime() as date)
 
END
