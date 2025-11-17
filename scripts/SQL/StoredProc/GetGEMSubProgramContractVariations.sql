USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgramContractVariations]    Script Date: 11/17/2025 4:25:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 30/10/2025
-- Description:	Returns contarct variations for a subprogram
-- =============================================
ALTER     PROCEDURE [dbo].[GetGEMSubProgramContractVariations]
@ProgramId INT,
@SubProgramId INT,
@External_Reference VARCHAR(200)='',
@SkipFiles BIT = 1  -- if 1 (true) files are not exported

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



select  
	p.Project_ID,gwi.Workflow_Instance_ID, gwi.Parent_Workflow_Instance_ID, gwic.Workflow_Instance_ID as child,
	
	LTRIM(RTRIM (p.project_id)) as project_id, 
		LTRIM(RTRIM (c.Contract_ID)) as Contract_ID,  
		LTRIM(RTRIM (c.Stakeholder_ID)) as  Stakeholder_ID, 
		LTRIM(RTRIM (gwi.Workflow_Instance_ID)) as  Workflow_Instance_ID,
		LTRIM(RTRIM(CAST((cgd.Value) AS VARCHAR(MAX)))) as Title,
		LTRIM(RTRIM(CAST((cgd2.Value) AS VARCHAR(MAX)))) as Type, 
		LTRIM(RTRIM(CAST((cgd3.Value)AS VARCHAR(MAX)))) as MilestoneIniatedOn, 
		LTRIM(RTRIM(CAST((cgd4.Value) AS VARCHAR(MAX)))) as ContractorSignatoryName, 
		LTRIM(RTRIM(CAST((cgd5.Value) AS VARCHAR(MAX)))) as status, 
		dbo.CleanString(CAST((cgd9.Value) AS VARCHAR(MAX))) as Request_Summary,
		dbo.CleanString(CAST((cgd15.Value) AS VARCHAR(MAX))) as InternalReviewComment,
		dbo.CleanString(CAST((cgd16.Value) AS VARCHAR(MAX))) as InternalReviewRecommendation,
		dbo.CleanString(CAST((cgd18.Value) AS VARCHAR(MAX))) as Contract_Description,
		dbo.CleanString(CAST((cgd19.Value) AS VARCHAR(MAX))) as Completion_Date,
		dbo.CleanString(CAST((cgd20.Value) AS VARCHAR(MAX))) as Commencement_Date,	
		dbo.CleanString(CAST((cgd21.Value) AS VARCHAR(MAX))) as ContractorSignatoryPosition,	
		dbo.CleanString(CAST((cgd22.Value) AS VARCHAR(MAX))) as ContractCap,
		dbo.CleanString(CAST((cgd23.Value) AS VARCHAR(MAX))) as AuthorityToSign,
		dbo.CleanString(CAST((gd.Value) AS VARCHAR(MAX))) as Project_Code,
		LTRIM(RTRIM(f.File_ID)) as file_id, 
		LTRIM(RTRIM(f.File_Name)) as File_Name

		
	FROM Project p 
		INNER join Contract c on c.Project_ID = p.Project_ID and p.Subprogram_ID =@SubProgramId

		INNER JOIN  dbo.GrantWorkflowInstance gwi on gwi.Grant_ID=p.Project_ID and p.Subprogram_ID =@SubProgramId
		
		--project code is defined in a child workflow of the contract variation workflow
		INNER join GrantWorkflowInstance gwic on gwic.Parent_Workflow_Instance_ID = gwi.Workflow_Instance_ID
		
		INNER JOIN  (
			select GrantData.Value,GrantData.Workflow_Instance_ID, GrantData.Field_Definition_ID, ROW_NUMBER()
			OVER (PARTITION BY Workflow_Instance_ID  ORDER BY (SELECT NULL)) AS RowNum
			from GrantData
			) gd
		on 	gd.Workflow_Instance_ID = gwic.Workflow_Instance_ID    
		and gd.Field_Definition_ID=1700 --project code  
		and RowNum = 1 -- for some reason there are two child workflows with Field_Definition_ID=1700, we dedupe with RowNum()
	  
		LEFT JOIN dbo.CurrentGrantData cgd on
			cgd.Workflow_Instance_ID = gwi.Workflow_Instance_ID                 
			and cgd.Field_Definition_ID=1478

		LEFT JOIN  dbo.CurrentGrantData cgd2 on
			cgd2.Grant_ID=cgd.Grant_ID              
			and cgd2.Field_Definition_ID=1463
			and cgd2.Workflow_Instance_ID= gwi.Workflow_Instance_ID

		LEFT JOIN  dbo.CurrentGrantData cgd3 on
			cgd3.Grant_ID=cgd.Grant_ID              
			and cgd3.Field_Definition_ID=1465 --Initiated On
			and cgd3.Workflow_Instance_ID= gwi.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd4 on
			cgd4.Grant_ID=cgd.Grant_ID              
			and cgd4.Field_Definition_ID=1455
		    and cgd4.Workflow_Instance_ID= gwi.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd5 on
			cgd5.Grant_ID=cgd.Grant_ID              
			and cgd5.Field_Definition_ID=1298
		    and cgd5.Workflow_Instance_ID= gwi.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd6 on
			cgd6.Grant_ID=cgd.Grant_ID              
			and cgd6.Field_Definition_ID=1683
			and cgd6.Workflow_Instance_ID= gwi.Workflow_Instance_ID  

	   LEFT JOIN  dbo.CurrentGrantData cgd9 on
			cgd9.Grant_ID=cgd.Grant_ID              
			and cgd9.Field_Definition_ID=1467
		    and cgd9.Workflow_Instance_ID= gwi.Workflow_Instance_ID

	   LEFT JOIN  dbo.CurrentGrantData cgd15 on
			cgd15.Grant_ID=cgd.Grant_ID              
			and cgd15.Field_Definition_ID=1469 --*ContractRMComments
		    and cgd15.Workflow_Instance_ID= gwi.Workflow_Instance_ID  
			
		LEFT JOIN  dbo.CurrentGrantData cgd16 on
			cgd16.Grant_ID=cgd.Grant_ID              
			and cgd16.Field_Definition_ID=1470
		    and cgd16.Workflow_Instance_ID= gwi.Workflow_Instance_ID

		LEFT JOIN  dbo.CurrentGrantData cgd18 on
			cgd18.Grant_ID=cgd.Grant_ID              
			and cgd18.Field_Definition_ID=1728
		    and cgd18.Workflow_Instance_ID= gwi.Workflow_Instance_ID 
			
		LEFT JOIN  dbo.CurrentGrantData cgd19 on
			cgd19.Grant_ID=cgd.Grant_ID              
			and cgd19.Field_Definition_ID=1370
		    and cgd19.Workflow_Instance_ID= gwi.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd20 on
			cgd20.Grant_ID=cgd.Grant_ID              
			and cgd20.Field_Definition_ID=1369 --Commencement Date 
		    and cgd20.Workflow_Instance_ID= gwi.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd21 on
			cgd21.Grant_ID=cgd.Grant_ID              
			and cgd21.Field_Definition_ID=1456 --Commencement Date 
		    and cgd21.Workflow_Instance_ID= gwi.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd22 on
			cgd22.Grant_ID=cgd.Grant_ID              
			and cgd22.Field_Definition_ID=1729 --Contract Cap 
		    and cgd22.Workflow_Instance_ID= gwi.Workflow_Instance_ID 

		LEFT JOIN  dbo.CurrentGrantData cgd23 on
			cgd23.Grant_ID=cgd.Grant_ID              
			and cgd23.Field_Definition_ID=1727 --Authority to Sign  
		    and cgd23.Workflow_Instance_ID= gwi.Workflow_Instance_ID
		
		LEFT JOIN [dbo].[File] f on
				 f.File_ID = cgd6.File_ID

	  where  p.Program_ID = @ProgramId
			and p.Subprogram_ID =@SubProgramId
			and p.External_Reference like '%'+@External_Reference +'%'
		
END