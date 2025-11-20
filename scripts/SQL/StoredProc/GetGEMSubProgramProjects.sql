USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgramProjects]    Script Date: 11/20/2025 1:48:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER   PROCEDURE [dbo].[GetGEMSubProgramProjects]
	-- Add the parameters for the stored procedure here
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
select @ProgramId as Program, @SubProgramId as SubProgram,  p.Project_ID as Project_ID, c.Stakeholder_id as Applicant,  p.Project_Title as Contract_Title, p.External_Reference, 
		p.Project_Status_ID as Project_Status_ID, p.Project_Actual_Start_Date , p.Project_Actual_Finish_Date,pd.value as EECA_CONTACT, t.Name as Round, dbo.CleanString(CAST((gd.Value) AS VARCHAR(MAX))) as Project_Code
		from Contract c join Project p  on c.Project_ID=p.Project_ID
		inner join STKH_Stakeholders s on c.Stakeholder_ID = s.stakeholder_id
		inner join STKH_Legal l on l.stakeholder_id=s.stakeholder_id
		inner join SEC_StakeholderRoles sr on s.stakeholder_id = sr.stakeholder_id and sr.universal_resource_id=p.Uro_ID
		inner join PRJ_ProjectData pd on pd.universal_resource_id=p.Uro_ID
		inner join TimePeriod t on t.Time_Period_ID = p.Time_Period_ID
		INNER JOIN  dbo.GrantWorkflowInstance gwi on gwi.Grant_ID=p.Project_ID and p.Subprogram_ID =@SubProgramId
		
		--project code is defined in a child workflow of the contract variation workflow
		INNER join GrantWorkflowInstance gwic on gwic.Parent_Workflow_Instance_ID = gwi.Workflow_Instance_ID
		LEFT JOIN dbo.GrantData gd on
			gd.Workflow_Instance_ID = gwic.Workflow_Instance_ID                 
			and gd.Field_Definition_ID=1700
			and gd.Grant_ID = gwic.Grant_ID

		where p.Subprogram_ID =@SubProgramId 
		and p.Program_ID = @ProgramId 
		--and p.Project_Actual_Finish_Date >  cast(sysdatetime() as date)
		and  p.Project_Actual_Start_Date is not null
		and pd.field_code='PROJ_EECA_CONTACT'
		and p.External_Reference like '%'+@External_Reference +'%'
		and CAST(gd.Value AS VARCHAR(MAX)) like  '%'+@Project_Code +'%'
 
 )

 -- dedupe
	select distinct 
		Program,
		SubProgram,
		Project_ID,
		Applicant,
		Contract_Title,
		External_Reference,
		Project_Status_ID,
		t1.Project_Actual_Start_Date , 
		t1.Project_Actual_Finish_Date,
		EECA_CONTACT,
		Round,
		Project_Code



		from t1

 
END
