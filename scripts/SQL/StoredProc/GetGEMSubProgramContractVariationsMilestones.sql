USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgramContractVariationsMilestones]    Script Date: 23/10/2025 2:31:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:	Pat Ryan
-- Create date: 8/9/2025
-- Description:	returns milestones associated with a contract variation
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[GetGEMSubProgramContractVariationsMilestones]
@ProgramId INT,
@SubProgramId INT,
@External_Reference VARCHAR(200)=''

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    DECLARE @grantStepId INT= 526; 				
				
				
	with Variation_Milestone as (			
		SELECT
		 
			gd.grant_id,
             gs.Spawned_Workflow_ID
			 , gwi.Parent_Workflow_Instance_ID as contract_id
            , gwi.Workflow_Instance_ID as milestone_id
            , swdc.Field_Definition_ID
            , COALESCE(gd.Value, CONVERT(NVARCHAR(4000), gd.Value_Long_Text)) AS Value
            FROM dbo.GrantWorkflowInstance gwi
            JOIN dbo.GrantStep gs
                ON gs.Grant_Step_ID = gwi.Grant_Step_ID
                    -- AND gwi.Parent_Workflow_Instance_ID = @parentWfInstId
            JOIN dbo.SpawnedWorkflowDefinitionColumn swdc
                ON swdc.Spawned_Workflow_Definition_ID = gs.Spawned_Workflow_ID
            LEFT JOIN dbo.GrantData gd
                ON gd.Grant_ID = gwi.Grant_ID
                    AND gd.Field_Definition_ID = swdc.Field_Definition_ID
                    AND gd.Workflow_Instance_ID = gwi.Workflow_Instance_ID
                    AND gd.Array_Index_Field IS NULL
			


            WHERE 
		    -- gwi.Grant_ID = @grantId AND 
			 gwi.Grant_ID in (select p.project_id from Project p where p.Program_ID=@programId and p.Subprogram_ID=@subprogramId and  p.External_Reference like '%'+@External_Reference +'%') and
			gs.Grant_Step_ID = @grantStepId
		
           
			)
			
			select  vm.grant_id as project_id, vm.contract_id, vm.milestone_id,  vm2.value as milestoneRef,mc.milestone_code, mc.milestone_code_description,  RIGHT(mc.milestone_code,4) as project_code, vm3.value as MilestoneTitle, vm4.value as MilestoneFinancial, vm5.value as MilestoneRecurrence,  vm6.value as MilestoneType, vm7.value as  MilestoneStatus,  vm8.value as MilestoneAmount,  vm9.value as  MilestoneRecurrenceStartDate
			
			from Variation_Milestone vm 
			INNER JOIN Variation_Milestone vm2 on
			vm.milestone_id = vm2.milestone_id   and vm.Field_Definition_ID=1397 and vm2.Field_Definition_ID=1397

			
			INNER JOIN Variation_Milestone vm3 on
			vm2.milestone_id = vm3.milestone_id and vm3.Field_Definition_ID=1398

			INNER JOIN Variation_Milestone vm4 on
			vm3.milestone_id = vm4.milestone_id and vm4.Field_Definition_ID=1399

			INNER JOIN Variation_Milestone vm5 on
			vm4.milestone_id = vm5.milestone_id and vm5.Field_Definition_ID=1400

			INNER JOIN Variation_Milestone vm6 on
			vm5.milestone_id = vm6.milestone_id and vm6.Field_Definition_ID=1401

			INNER JOIN Variation_Milestone vm7 on
			vm6.milestone_id = vm7.milestone_id and vm7.Field_Definition_ID=1411

			INNER JOIN Variation_Milestone vm8 on
			vm7.milestone_id = vm8.milestone_id and vm8.Field_Definition_ID=1415

			INNER JOIN Variation_Milestone vm9 on
			vm8.milestone_id = vm9.milestone_id and vm9.Field_Definition_ID=1430

			INNER JOIN  rvMilestoneCodes  mc on 
				mc.grant_id = vm.grant_id
				
				and CAST(vm2.value AS VARCHAR(MAX)) = mc.milestone_ref 
END
