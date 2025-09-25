USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgramMilestonesClaimsPayments]    Script Date: 25/09/2025 1:18:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetGEMSubProgramMilestonesClaimsPayments]
	-- Add the parameters for the stored procedure here
	@ProgramId INT,
	@SubProgramId INT,
	@External_Reference VARCHAR(200)=''

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

     select p.Program_ID,p.Subprogram_ID, p.Project_ID as Contract_ID, m.milestone_id, m.reference,  dbo.CleanString(m.title), dbo.CleanString(m.description),  m.due_date, m.submitted_as_complete_datetime, m.type, m.amount_type, mc.claim_id, mc.milestone_id, mc.submitted_datetime, 
 mc.checked_status, mc.approval_status, f.filename, f.file_id, d.document_title,  pr.Payment_Run_ID, pt.Payment_ID, pt.Amount_Inc/1.15 as amount_ex,  pt.Payment_Date


from Contract c 
		join Project p  on c.Project_ID=p.Project_ID
		full outer join PRJ_Milestones m on m.project_id = p.Project_ID

full outer join PRJ_MilestoneClaims mc on mc.milestone_id=m.milestone_id
full outer join  PRJ_MilestoneClaimLines cl on cl.claim_id =mc.claim_id
full outer join Payment pt on pt.Payment_ID = cl.payment_id
full outer join PaymentRun pr on pt.Payment_Run_ID = pr.Payment_Run_ID

full outer  join PRJ_ClaimDocuments cd on cd.claim_id = mc.claim_id 
full outer join COMM_Documents d on d.document_id = cd.document_id
full outer join COMM_Files f on f.file_id = d.file_id /* outlook msg file with claim for file as attachment */
where 
			p.Subprogram_ID = @SubProgramId
			and p.Program_ID = @ProgramId
			and  p.External_Reference like '%'+@External_Reference +'%'

END
