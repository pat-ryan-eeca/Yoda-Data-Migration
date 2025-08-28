USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMStakeholderAcccounts]    Script Date: 28/08/2025 3:35:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetGEMStakeholderAcccounts]
	@ProgramId INT,
	@SubProgramId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   

select p.Program_ID,  p.Subprogram_ID, c.Contract_ID, c.Project_ID,c.Stakeholder_ID, s.name, s.alternate_name, s.phone_work, s.universal_resource_id, s.email_work, s.staff, s.gst_rate_code, s.gst_number, s.contact_name,s.crm_reference, s.entity_reg, l.registered_gst,
 ba.Account_Name, ba.Account_Number, ba.account_suffix,ba.bank_number, ba.branch_number

from Contract c join Project p  on c.Project_ID=p.Project_ID
join STKH_Stakeholders s on c.Stakeholder_ID = s.stakeholder_id
join STKH_Legal l on l.stakeholder_id=s.stakeholder_id
join StakeholderAccount sa on sa.Stakeholder_ID = s.stakeholder_id
join BankAccountDetail ba on ba.Bank_Account_Detail_ID = sa.Bank_Account_Detail_ID
where p.Subprogram_ID =@SubProgramId 
and p.Program_ID = @ProgramId 
and p.Project_Actual_Finish_Date >  cast(sysdatetime() as date)

 
END
