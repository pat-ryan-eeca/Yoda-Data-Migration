USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgramContractVariations]    Script Date: 28/08/2025 2:16:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetGEMSubProgramContractVariations]
@ProgramId INT,
@SubProgramId INT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	/* missing the file reference for superseded variations  */
select  LTRIM(RTRIM (p.project_id)) as project_id, LTRIM(RTRIM (c.Contract_ID)) ,  LTRIM(RTRIM (gwi.Workflow_Instance_ID)), LTRIM(RTRIM(CAST((cgd.Value) AS VARCHAR(MAX)))) as Title,  
		LTRIM(RTRIM(CAST((cgd2.Value) AS VARCHAR(MAX)))) as Type,  LTRIM(RTRIM(CAST((cgd3.Value)AS VARCHAR(MAX)))) as MilestoneIniatedOn, 
		LTRIM(RTRIM(CAST((cgd4.Value) AS VARCHAR(MAX)))) as ContractorSignatoryName, LTRIM(RTRIM(CAST((cgd5.Value) AS VARCHAR(MAX)))) as status, LTRIM(RTRIM(CAST((cgd7.Value) AS VARCHAR(MAX)))) as RequestedOn, 
		LTRIM(RTRIM(CAST((cgd8.Value) AS VARCHAR(MAX)))) as ExecutionDate, dbo.CleanString(CAST((cgd9.Value) AS VARCHAR(MAX))) as Request_Summary,LTRIM(RTRIM(CAST((cgd10.Value) AS VARCHAR(MAX)))) as RIARecomendation,		
		LTRIM(RTRIM(CAST((cgd11.Value) AS VARCHAR(MAX)))) as RIASummary, LTRIM(RTRIM(CAST((cgd12.Value) AS VARCHAR(MAX)))) as RODecisionBy,
		dbo.CleanString(CAST((cgd13.Value) AS VARCHAR(MAX))) as RO_Outcome,dbo.CleanString(CAST((cgd14.Value) AS VARCHAR(MAX))) as RO_Outcome,
		dbo.CleanString(CAST((cgd15.Value) AS VARCHAR(MAX))) as InternalReviewComment,dbo.CleanString(CAST((cgd16.Value) AS VARCHAR(MAX))) as InternalReviewRecommendation,dbo.CleanString(CAST((cgd17.Value) AS VARCHAR(MAX))) as InteralReviewEnteredBy,
		
		LTRIM(RTRIM(f.File_ID)), LTRIM(RTRIM(f.File_Name))
		 
	FROM Project p 
		INNER JOIN  dbo.GrantWorkflowInstance gwi on gwi.Grant_ID=p.Project_ID
		INNER join Contract c on c.Project_ID = p.Project_ID

		INNER JOIN dbo.CurrentGrantData cgd on
			cgd.Workflow_Instance_ID = gwi.Workflow_Instance_ID                 
			and cgd.Field_Definition_ID=1478
		 LEFT JOIN  dbo.CurrentGrantData cgd2 on
			cgd2.Grant_ID=cgd.Grant_ID              
			and cgd2.Field_Definition_ID=1463
			and cgd2.Workflow_Instance_ID= gwi.Workflow_Instance_ID  
			
		 LEFT JOIN  dbo.CurrentGrantData cgd3 on
			cgd3.Grant_ID=cgd.Grant_ID              
			and cgd3.Field_Definition_ID=1465
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
		
		LEFT JOIN  dbo.CurrentGrantData cgd7 on
			cgd7.Grant_ID=cgd.Grant_ID              
			and cgd7.Field_Definition_ID=1296
		    and cgd7.Workflow_Instance_ID= gwi.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd8 on
			cgd8.Grant_ID=cgd.Grant_ID              
			and cgd8.Field_Definition_ID=1629
		    and cgd8.Workflow_Instance_ID= gwi.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd9 on
			cgd9.Grant_ID=cgd.Grant_ID              
			and cgd9.Field_Definition_ID=1467
		    and cgd9.Workflow_Instance_ID= gwi.Workflow_Instance_ID  

	    LEFT JOIN  dbo.CurrentGrantData cgd10 on
			cgd10.Grant_ID=cgd.Grant_ID              
			and cgd10.Field_Definition_ID=1474
		    and cgd10.Workflow_Instance_ID= gwi.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd11 on
			cgd11.Grant_ID=cgd.Grant_ID              
			and cgd11.Field_Definition_ID=1473
		    and cgd11.Workflow_Instance_ID= gwi.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd12 on
			cgd12.Grant_ID=cgd.Grant_ID              
			and cgd12.Field_Definition_ID=1476
		    and cgd12.Workflow_Instance_ID= gwi.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd13 on
			cgd13.Grant_ID=cgd.Grant_ID              
			and cgd13.Field_Definition_ID=1480
		    and cgd13.Workflow_Instance_ID= gwi.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd14 on
			cgd14.Grant_ID=cgd.Grant_ID              
			and cgd14.Field_Definition_ID=1481
		    and cgd14.Workflow_Instance_ID= gwi.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd15 on
			cgd15.Grant_ID=cgd.Grant_ID              
			and cgd15.Field_Definition_ID=1469
		    and cgd15.Workflow_Instance_ID= gwi.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd16 on
			cgd16.Grant_ID=cgd.Grant_ID              
			and cgd16.Field_Definition_ID=1470
		    and cgd16.Workflow_Instance_ID= gwi.Workflow_Instance_ID  

		LEFT JOIN  dbo.CurrentGrantData cgd17 on
			cgd17.Grant_ID=cgd.Grant_ID              
			and cgd17.Field_Definition_ID=1471
		    and cgd17.Workflow_Instance_ID= gwi.Workflow_Instance_ID  


		LEFT   JOIN [dbo].[File] f on
		f.File_ID = cgd6.File_ID



	  
	  where  p.Program_ID = @ProgramId
			and p.Subprogram_ID =@SubProgramId

	  

END
