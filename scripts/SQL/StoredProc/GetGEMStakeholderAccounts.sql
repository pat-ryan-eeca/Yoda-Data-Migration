USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMStakeholderAcccounts]    Script Date: 11/20/2025 2:07:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 20/11/2025
-- Description:	Returns stakeholder details
-- =============================================
ALTER   PROCEDURE [dbo].[GetGEMStakeholderAccounts]
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
select p.Program_ID,  p.Subprogram_ID, c.Contract_ID, c.Project_ID,c.Stakeholder_ID, s.name, s.alternate_name, s.phone_work, s.universal_resource_id, s.email_work, s.staff, s.gst_rate_code, s.gst_number, s.contact_name,s.crm_reference, s.entity_reg, l.registered_gst,
 ba.Account_Name, ba.Account_Number, ba.account_suffix,ba.bank_number, ba.branch_number

from Contract c join Project p  on c.Project_ID=p.Project_ID
join STKH_Stakeholders s on c.Stakeholder_ID = s.stakeholder_id
join STKH_Legal l on l.stakeholder_id=s.stakeholder_id
join StakeholderAccount sa on sa.Stakeholder_ID = s.stakeholder_id
join BankAccountDetail ba on ba.Bank_Account_Detail_ID = sa.Bank_Account_Detail_ID

INNER JOIN  dbo.GrantWorkflowInstance gwi on gwi.Grant_ID=p.Project_ID and p.Subprogram_ID =@SubProgramId
		
		--project code is defined in a child workflow of the contract variation workflow
		INNER join GrantWorkflowInstance gwic on gwic.Parent_Workflow_Instance_ID = gwi.Workflow_Instance_ID
		LEFT JOIN dbo.GrantData gd on
			gd.Workflow_Instance_ID = gwic.Workflow_Instance_ID                 
			and gd.Field_Definition_ID=1700
			and gd.Grant_ID = gwic.Grant_ID

where p.Subprogram_ID =@SubProgramId 
and p.Program_ID = @ProgramId 
and  p.External_Reference like '%'+@External_Reference +'%'
and CAST(gd.Value AS VARCHAR(MAX)) like  '%'+@Project_Code +'%'
--and p.Project_Actual_Finish_Date >  cast(sysdatetime() as date)
)


 -- dedupe
	select distinct 
		Program_ID,
		Subprogram_ID,
		Contract_ID,
		Project_ID,
		Stakeholder_ID,
		name,
		alternate_name,
		phone_work,
		universal_resource_id,
		email_work,
		staff,
		gst_rate_code,
		gst_number,
		contact_name,
		crm_reference,
		entity_reg,
		registered_gst,
		Account_Name,
		Account_Number,
		account_suffix,
		bank_number,
		branch_number
	from t1


 
END
