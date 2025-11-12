USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgramContractVariations]    Script Date: 11/12/2025 1:58:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 30/10/2025
-- Description:	Returns contarct variations for a subprogram
-- =============================================
ALTER   PROCEDURE [dbo].[GetGEMSubProgramContractVariations]
@ProgramId INT,
@SubProgramId INT,
@External_Reference VARCHAR(200)='',
@SkipFiles BIT = 1  -- if 1 (true) files are not exported

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


with parent_child as (

select  
	gwi.Workflow_Instance_ID as Workflow_Instance_ID,
	gwi.Parent_Workflow_Instance_ID as Parent_Workflow_Instance_ID,cgd.Grant_ID  as Grant_id,
	p.project_id as project_id, 
	c.Contract_ID as Contract_ID,
	c.Stakeholder_ID as Stakeholder_ID,
	p.Program_ID as Program_ID,
	p.Subprogram_ID as Subprogram_ID
	
		
	FROM Project p 
		INNER JOIN  dbo.GrantWorkflowInstance gwi on gwi.Grant_ID=p.Project_ID and p.Subprogram_ID =@SubProgramId
		INNER join Contract c on c.Project_ID = p.Project_ID and p.Subprogram_ID =@SubProgramId

	    LEFT JOIN dbo.CurrentGrantData cgd on
			cgd.Workflow_Instance_ID = gwi.Workflow_Instance_ID                 
			and cgd.Field_Definition_ID=1700

		LEFT OUTER JOIN (select top 1 * from  GrantWorkflowInstance ) gwip  ON gwi.workflow_instance_id = gwip.Parent_Workflow_Instance_ID AND gwip.Grant_Step_ID = 526
				
			--LEFT JOIN [dbo].[File] f on
			--  f.File_ID = cgd6.File_ID
		
	  where  p.Program_ID = @ProgramId
			and p.Subprogram_ID =@SubProgramId
			and p.External_Reference like '%'+@External_Reference +'%'
		
	)

	select 
		
		LTRIM(RTRIM (pc1.project_id)) as project_id, 
		LTRIM(RTRIM (pc1.Contract_ID)) as Contract_ID,  
		LTRIM(RTRIM (pc1.Stakeholder_ID)) as  Stakeholder_ID, 
		LTRIM(RTRIM (pc1.Workflow_Instance_ID)) as  Workflow_Instance_ID,
		LTRIM(RTRIM(CAST((cgd.Value) AS VARCHAR(MAX)))) as Title,  
		LTRIM(RTRIM(CAST((cgd2.Value) AS VARCHAR(MAX)))) as Type,  
		LTRIM(RTRIM(CAST((cgd3.Value)AS VARCHAR(MAX)))) as MilestoneIniatedOn, 
		LTRIM(RTRIM(CAST((cgd4.Value) AS VARCHAR(MAX)))) as ContractorSignatoryName, 
		LTRIM(RTRIM(CAST((cgd5.Value) AS VARCHAR(MAX)))) as status, 
		--LTRIM(RTRIM(CAST((cgd7.Value) AS VARCHAR(MAX)))) as RequestedOn, 
		--LTRIM(RTRIM(CAST((cgd8.Value) AS VARCHAR(MAX)))) as ExecutionDate, 
		dbo.CleanString(CAST((cgd9.Value) AS VARCHAR(MAX))) as Request_Summary,
		--LTRIM(RTRIM(CAST((cgd10.Value) AS VARCHAR(MAX)))) as RIARecomendation,
		--LTRIM(RTRIM(CAST((cgd11.Value) AS VARCHAR(MAX)))) as RIASummary, 
		--LTRIM(RTRIM(CAST((cgd12.Value) AS VARCHAR(MAX)))) as RIAUser,
		--dbo.CleanString(CAST((cgd13.Value) AS VARCHAR(MAX))) as RO_Outcome,
		--dbo.CleanString(CAST((cgd14.Value) AS VARCHAR(MAX))) as RODecisionBy,
		dbo.CleanString(CAST((cgd15.Value) AS VARCHAR(MAX))) as InternalReviewComment,
		dbo.CleanString(CAST((cgd16.Value) AS VARCHAR(MAX))) as InternalReviewRecommendation,
		--dbo.CleanString(CAST((cgd17.Value) AS VARCHAR(MAX))) as InteralReviewEnteredBy,
		dbo.CleanString(CAST((cgd18.Value) AS VARCHAR(MAX))) as Contract_Description,
		dbo.CleanString(CAST((cgd19.Value) AS VARCHAR(MAX))) as Completion_Date,
		dbo.CleanString(CAST((cgd20.Value) AS VARCHAR(MAX))) as Commencement_Date,	
		dbo.CleanString(CAST((cgd21.Value) AS VARCHAR(MAX))) as ContractorSignatoryPosition,	
		dbo.CleanString(CAST((cgd22.Value) AS VARCHAR(MAX))) as ContractCap,
		dbo.CleanString(CAST((cgd23.Value) AS VARCHAR(MAX))) as AuthorityToSign,
		dbo.CleanString(CAST((gd.Value) AS VARCHAR(MAX))) as Project_Code,
		LTRIM(RTRIM(f.File_ID)) as file_id, 
		LTRIM(RTRIM(f.File_Name)) as File_Name
	
	
	from parent_child pc1  inner join parent_child pc2 
	on pc2.Parent_Workflow_Instance_ID = pc1.Workflow_Instance_ID

		LEFT JOIN dbo.CurrentGrantData cgd on
			cgd.Workflow_Instance_ID = pc1.Workflow_Instance_ID                 
			and cgd.Field_Definition_ID=1478
		
		LEFT JOIN  dbo.CurrentGrantData cgd2 on
			cgd2.Grant_ID=cgd.Grant_ID              
			and cgd2.Field_Definition_ID=1463
			and cgd2.Workflow_Instance_ID= pc1.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd3 on
			cgd3.Grant_ID=cgd.Grant_ID              
			and cgd3.Field_Definition_ID=1465 --Initiated On
			and cgd3.Workflow_Instance_ID= pc1.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd4 on
			cgd4.Grant_ID=cgd.Grant_ID              
			and cgd4.Field_Definition_ID=1455
		    and cgd4.Workflow_Instance_ID= pc1.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd5 on
			cgd5.Grant_ID=cgd.Grant_ID              
			and cgd5.Field_Definition_ID=1298
		    and cgd5.Workflow_Instance_ID= pc1.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd6 on
			cgd6.Grant_ID=cgd.Grant_ID              
			and cgd6.Field_Definition_ID=1683
			and cgd6.Workflow_Instance_ID= pc1.Workflow_Instance_ID  
		
		LEFT JOIN  dbo.CurrentGrantData cgd9 on
			cgd9.Grant_ID=cgd.Grant_ID              
			and cgd9.Field_Definition_ID=1467
		    and cgd9.Workflow_Instance_ID= pc1.Workflow_Instance_ID  
	   
		LEFT JOIN  dbo.CurrentGrantData cgd15 on
			cgd15.Grant_ID=pc1.Grant_ID              
			and cgd15.Field_Definition_ID=1469 --*ContractRMComments
		    and cgd15.Workflow_Instance_ID= pc1.Workflow_Instance_ID  
			
		LEFT JOIN  dbo.CurrentGrantData cgd16 on
			cgd16.Grant_ID=cgd.Grant_ID              
			and cgd16.Field_Definition_ID=1470
		    and cgd16.Workflow_Instance_ID= pc1.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd18 on
			cgd18.Grant_ID=cgd.Grant_ID              
			and cgd18.Field_Definition_ID=1728
		    and cgd18.Workflow_Instance_ID= pc1.Workflow_Instance_ID 
			
		LEFT JOIN  dbo.CurrentGrantData cgd19 on
			cgd19.Grant_ID=cgd.Grant_ID              
			and cgd19.Field_Definition_ID=1370
		    and cgd19.Workflow_Instance_ID= pc1.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd20 on
			cgd20.Grant_ID=cgd.Grant_ID              
			and cgd20.Field_Definition_ID=1369 --Commencement Date 
		    and cgd20.Workflow_Instance_ID= pc1.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd21 on
			cgd21.Grant_ID=cgd.Grant_ID              
			and cgd21.Field_Definition_ID=1456 --Commencement Date 
		    and cgd21.Workflow_Instance_ID= pc1.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd22 on
			cgd22.Grant_ID=cgd.Grant_ID              
			and cgd22.Field_Definition_ID=1729 --Contract Cap 
		    and cgd22.Workflow_Instance_ID= pc1.Workflow_Instance_ID 

		LEFT JOIN  dbo.CurrentGrantData cgd23 on
			cgd23.Grant_ID=cgd.Grant_ID              
			and cgd23.Field_Definition_ID=1727 --Authority to Sign  
		    and cgd23.Workflow_Instance_ID= pc1.Workflow_Instance_ID

		LEFT OUTER JOIN (select top 1 * from  GrantWorkflowInstance ) gwip  ON pc1.workflow_instance_id = gwip.Parent_Workflow_Instance_ID AND gwip.Grant_Step_ID = 526

		LEFT OUTER JOIN GrantData gd ON gwip.Workflow_Instance_ID = gd.Workflow_Instance_ID AND gd.Field_Definition_ID = 1700  

		LEFT JOIN [dbo].[File] f on
				 f.File_ID = cgd6.File_ID

		where  
			pc1.Program_ID = @ProgramId
			and pc1.Subprogram_ID =@SubProgramId
			--and pc2.External_Reference like '%'+@External_Reference +'%'
			and cgd.Value is not null
		
END
