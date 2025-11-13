DECLARE @ProgramId INT= 9;
DECLARE @SubProgramId INT =34;
DECLARE @External_Reference VARCHAR(200)='';
DECLARE @grantStepId INT= 526; 
			
	with Variation_Milestone as (			
		SELECT
		 
			gd.grant_id,
             gs.Spawned_Workflow_ID
			 , gwi.Parent_Workflow_Instance_ID as contract_id
            , gwi.Workflow_Instance_ID as milestone_id
            , swdc.Field_Definition_ID
            , COALESCE(gd.Value, CONVERT(NVARCHAR(4000), gd.Value_Long_Text)) AS Value
			,p.Project_Actual_Finish_Date as finish_date
		
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
			
			LEFT JOIN dbo.project p on  gwi.Grant_ID =p.Project_ID



            WHERE 
		    -- gwi.Grant_ID = @grantId AND 
			 gwi.Grant_ID in (select p.project_id from Project p 
			 --where p.Program_ID=@programId and p.Subprogram_ID=@subprogramId and  p.External_Reference like '%'+@External_Reference +'%' 
			  )
			  and
			gs.Grant_Step_ID = @grantStepId
		
           
			)

			select active.project_code, active.milestone_code_description, active.count_project_milestones, inactive.count_project_milestones 
			from
			
			(
			select  Right(mc.milestone_code,4) as project_code ,mc.milestone_code_description as milestone_code_description, count (mc.milestone_code) as count_project_milestones
			
			from Variation_Milestone vm 
			INNER JOIN Variation_Milestone vm2 on
			vm.milestone_id = vm2.milestone_id   and vm.Field_Definition_ID=1397 and vm2.Field_Definition_ID=1397

			
			INNER JOIN Variation_Milestone vm3 on
			vm2.milestone_id = vm3.milestone_id and vm3.Field_Definition_ID=1398


			INNER JOIN  rvMilestoneCodes  mc on 
				mc.grant_id = vm.grant_id
				
				and CAST(vm2.value AS VARCHAR(MAX)) = mc.milestone_ref 

		    where  (vm.finish_date is null) or (vm.finish_date  >  cast(sysdatetime() as date))
			

			group by Right(mc.milestone_code,4), mc.milestone_code_description
			) as active
			

			inner  join 
			(
			select  Right(mc.milestone_code,4) as project_code, count (mc.milestone_code) as count_project_milestones
			
			from Variation_Milestone vm 
			INNER JOIN Variation_Milestone vm2 on
			vm.milestone_id = vm2.milestone_id   and vm.Field_Definition_ID=1397 and vm2.Field_Definition_ID=1397

			
			INNER JOIN Variation_Milestone vm3 on
			vm2.milestone_id = vm3.milestone_id and vm3.Field_Definition_ID=1398


			INNER JOIN  rvMilestoneCodes  mc on 
				mc.grant_id = vm.grant_id
				
				and CAST(vm2.value AS VARCHAR(MAX)) = mc.milestone_ref 

		    where  (vm.finish_date  <  cast(sysdatetime() as date))
			

			group by Right(mc.milestone_code,4), mc.milestone_code_description
			) as inactive
			ON inactive.project_code=active.project_code