USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[ExportAll]    Script Date: 11/17/2025 10:46:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 30/10/2025
-- Description:	Runs all the Yoda export scripts with the given parameters
-- =============================================
CREATE OR ALTER    PROCEDURE [dbo].[ExportAll] 
	@ProgramId INT,
	@SubProgramId INT,
	@External_Reference VARCHAR(200)='',
	@RootPath VARCHAR(255) = 'c:\temp\GEMEXPORT2\',
	@SkipFiles BIT = 1  -- if 1 (true) files are not exported

AS
BEGIN

DECLARE  @FilePath VARCHAR(255);
DECLARE  @MaxFieldLength INT = 1024;
DECLARE @sql NVARCHAR(MAX);
DECLARE @header NVARCHAR(MAX);
DECLARE @cmd VARCHAR(4000);

SET @RootPath = @RootPath + FORMAT(GETDATE(), 'yyyy-MM-dd_HH_mm')+'\' 
SET @cmd= 'mkdir "' + @RootPath + '"';
PRINT 'Creating output folder ' + @RootPath; 
EXEC xp_cmdshell @cmd;


--LEHV
--GetGEMSubProgram
SET @header = 'PRINT(''Program_ID, Subprogram_ID, Program_Short_Name, Brief_Outline, Subprogram_Name,  Subprogram_Budget_Code, Subprogram_Start_Date, Subprogram_End_Date, Subprogram_Brief_Outline, Workflow_Code, InitiativeAdmistratorId, InitiativeAdmistratorName'');' 
SET @sql = 'EXEC GetGEMSubProgram ' +  CONVERT(VARCHAR(10), @ProgramId) +',' +   CONVERT(VARCHAR(10), @SubProgramId) +'"';
SET @cmd = 'sqlcmd -S EECAGEMUDB1 -d GEM_UAT -Q "'+ @header + @sql + ' -o ' + @RootPath + '\GEMSubProgram.csv -s "," -h -1 -y ' + CONVERT(VARCHAR(10), @MaxFieldLength);
EXEC xp_cmdshell  @cmd


--GetGEMStakeholderAcccounts
SET @header =  'PRINT(''Program_ID,Subprogram_ID,Contract_ID, Project_ID, Stakeholder_ID, name, alt_name, phone_work, universal_resource_id, email_work, staff, gst_rate_code, gst_number, contact_name, crm_reference, entity_reg, registered_gst,Account_Name,Account_Number, account_suffix, bank_number,  branch_number, last_updated_on'') ;' 
SET @sql = 'EXEC GetGEMStakeholderAcccounts ' +  CONVERT(VARCHAR(10), @ProgramId) +',' +   CONVERT(VARCHAR(10), @SubProgramId) +'"';
SET @cmd = 'sqlcmd -S EECAGEMUDB1 -d GEM_UAT -Q "' + @header + @sql + ' -o ' + @RootPath + '\GEMStakeholderAcccounts.csv -s "," -h -1 -y ' + CONVERT(VARCHAR(10), @MaxFieldLength);
select @cmd
EXEC xp_cmdshell  @cmd

--GetGEMSubProgramProjects
SET @header =  'PRINT(''Program_ID,Subprogram_ID,Project_ID, Applicant, Contract_Title, Reference, Status, Start_Date, End_Date, EECA_Contact, Round, project_Last_Updated_On, contract_Last_Updated_On'');' 
SET @sql = 'EXEC GetGEMSubProgramProjects ' +  CONVERT(VARCHAR(10), @ProgramId) +',' +   CONVERT(VARCHAR(10), @SubProgramId)  +'"';
SET @cmd = 'sqlcmd -S EECAGEMUDB1 -d GEM_UAT -Q "'  + @header + @sql + ' -o ' + @RootPath + '\GEMSubProgramProjects.csv -s "," -h -1 -y ' + CONVERT(VARCHAR(10), @MaxFieldLength);
select @cmd
EXEC xp_cmdshell  @cmd

--GetGEMProgramRoles
SET @header =  'PRINT(''Program_ID, Role_Code, Stakeholder_Name, Stakeholder_ID'');' 
SET @sql = 'EXEC GetGEMProgramRoles ' +  CONVERT(VARCHAR(10), @ProgramId) +'"';
SET @cmd = 'sqlcmd -S EECAGEMUDB1 -d GEM_UAT -Q "'  + @header + @sql + ' -o ' + @RootPath + '\GetGEMProgramRoles.csv -s "," -h -1 -y ' + CONVERT(VARCHAR(10), @MaxFieldLength);
select @cmd
EXEC xp_cmdshell  @cmd


--GetGEMSubProgramRoles
SET @header =  'PRINT(''Program_ID, Subprogram_ID, Role_Code, Stakeholder_Name, Stakeholder_ID'');' 
SET @sql = 'EXEC GetGEMSubProgramRoles ' +  CONVERT(VARCHAR(10), @ProgramId) +',' +   CONVERT(VARCHAR(10), @SubProgramId) +'"';
SET @cmd = 'sqlcmd -S EECAGEMUDB1 -d GEM_UAT -Q "'  + @header + @sql + ' -o ' + @RootPath + '\GetGEMSubProgramRoles.csv -s "," -h -1 -y ' + CONVERT(VARCHAR(10), @MaxFieldLength);
select @cmd
EXEC xp_cmdshell  @cmd

--GetGEMSubProgramProjectRoles
SET @header =  'PRINT(''Program_ID, Subprogram_ID, Project_ID, Role_Code, Stakeholder_Name, Stakeholder_ID'');' 
SET @sql = 'EXEC GetGEMSubProgramProjectRoles ' +  CONVERT(VARCHAR(10), @ProgramId) +',' +   CONVERT(VARCHAR(10), @SubProgramId) +'"';
SET @cmd = 'sqlcmd -S EECAGEMUDB1 -d GEM_UAT -Q "'  + @header + @sql + ' -o ' + @RootPath + '\GetGEMSubProgramProjectRoles.csv -s "," -h -1 -y ' + CONVERT(VARCHAR(10), @MaxFieldLength);
select @cmd
EXEC xp_cmdshell  @cmd

--GetGEMSubProgramFiles
SET @header =  'PRINT(''Program_ID, Subprogram_ID, Project_ID, Contract_ID, filename, document_title'');' 
SET @sql = 'EXEC GetGEMSubProgramContractsFiles ' +  CONVERT(VARCHAR(10), @ProgramId) +',' +   CONVERT(VARCHAR(10), @SubProgramId) +'"';
SET @cmd = 'sqlcmd -S EECAGEMUDB1 -d GEM_UAT -Q "'  + @header + @sql + ' -o ' + @RootPath + '\GetGEMSubProgramContractsFiles.csv -s "," -h -1 -y ' + CONVERT(VARCHAR(10), @MaxFieldLength);
select @cmd
EXEC xp_cmdshell  @cmd



--GetGEMSubProgramContractVariations		 
SET @header =  'PRINT(''project_id, Contract_ID, Applicant, Workflow_Instance_ID, Title,  Type, RequestedOn, ContractorSignatoryName,status, EnteredOnOn, ExecutionDate,Request_Summary, RIARecomendation, RIASummary, RIAReviewer, InternalReviewOutcome,RODecisonBy,InternalReviewComment,InternalReviewRecommendation, InteralReviewEnteredBy,ContractDescription, CompletionDate, CommencementDate, ContractorSignatoryPosition,ContractCap,AuthorityToSign,ProjectCode, File_ID, File_Name'');' 
SET @sql = 'EXEC GetGEMSubProgramContractVariations ' +  CONVERT(VARCHAR(10), @ProgramId) +',' +   CONVERT(VARCHAR(10), @SubProgramId) +'"';
SET @cmd = 'sqlcmd -S EECAGEMUDB1 -d GEM_UAT -Q "' + @header + @sql + ' -o ' + @RootPath + '\GEMSubProgramContractVariations.csv -s "," -h -1 -y ' + CONVERT(VARCHAR(10), @MaxFieldLength);
select @cmd
EXEC xp_cmdshell  @cmd

--GetGEMSubProgramContractVariationsSupportingDocs
SET @header =  'PRINT(''Program_ID,Subprogram_ID, Project_ID, contract_variationid, File_Name,FileSize, Retrieval_Guid'');' 
SET @sql = 'EXEC GetGEMSubProgramContractVariationsSupportingDocs ' +  CONVERT(VARCHAR(10), @ProgramId) +',' +   CONVERT(VARCHAR(10), @SubProgramId) +'"';
SET @cmd = 'sqlcmd -S EECAGEMUDB1 -d GEM_UAT -Q "' + @header + @sql + ' -o ' + @RootPath + '\GetGEMSubProgramContractVariationsSupportingDocs.csv -s "," -h -1 -y ' + CONVERT(VARCHAR(10), @MaxFieldLength);
select @cmd
EXEC xp_cmdshell  @cmd


-- GetGEMSubProgramMilestones
SET @header =  'PRINT('' Program_ID,Subprogram_ID,Contract_ID, Milestone_ID, Type,Title, Due_Date, Reference,Submitted_As_Complete_Datetime, Description, Amount_type, Amount'');' 
SET @sql = 'EXEC GetGEMSubProgramMilestones ' +  CONVERT(VARCHAR(10), @ProgramId) +',' +   CONVERT(VARCHAR(10), @SubProgramId) +'"';
SET @cmd = 'sqlcmd -S EECAGEMUDB1 -d GEM_UAT -Q "' + @header + @sql + ' -o ' + @RootPath + '\GEMSubProgramMilestones.csv -s "," -h -1 -y ' + CONVERT(VARCHAR(10), @MaxFieldLength);
select @cmd
EXEC xp_cmdshell  @cmd

--GetGEMSubProgramContractVariationsMilestones
						
SET @header =  'PRINT(''Project_id,Contract_ID, milestone_ID, milestone_ref, milestone_code, milestone_code_description, project_code, Milestone_Title,MilestoneFinancial, MilestoneRecurrence, MilestoneType,  MilestoneStatus, MilestoneAmount, MilestoneDueDate'') ;' 
SET @sql = 'EXEC GetGEMSubProgramContractVariationsMilestones ' +  CONVERT(VARCHAR(10), @ProgramId) +',' +   CONVERT(VARCHAR(10), @SubProgramId) +'"';
SET @cmd = 'sqlcmd -S EECAGEMUDB1 -d GEM_UAT -Q "' + @header + @sql + ' -o ' + @RootPath + '\GetGEMSubProgramContractVariationsMilestones.csv -s "," -h -1 -y ' + CONVERT(VARCHAR(10), @MaxFieldLength);
select @cmd
EXEC xp_cmdshell  @cmd


--GetGEMSubProgramMilestonesClaimsPayments

SET @header =  'PRINT(''Program_ID,Subprogram_ID,Contract_ID, milestone_ID, reference, Milestone_Title,Milestone_description, Milestone_due_date, Milestone_submitted_as_complete_date, Milestone_type, Milestone_amount_type, claim_id, Claim_milestone_id, Claim_submitted_datetime, Claim_checked_status, Claim_approval_status, filename, file_id, document_title, Payment_Run_ID,payment_id, amount_ex,Payment_Date'') ;' 
SET @sql = 'EXEC GetGEMSubProgramMilestonesClaimsPayments ' +  CONVERT(VARCHAR(10), @ProgramId) +',' +   CONVERT(VARCHAR(10), @SubProgramId) +'"';
SET @cmd = 'sqlcmd -S EECAGEMUDB1 -d GEM_UAT -Q "' + @header + @sql + ' -o ' + @RootPath + '\GEMSubProgramMilestonesClaimsPayments.csv -s "," -h -1 -y ' + CONVERT(VARCHAR(10), @MaxFieldLength);
select @cmd
EXEC xp_cmdshell  @cmd

-- GetGEMSubProgramClaimFiles

SET @header =  'PRINT(''title, filenamer,filesize '') ;' 
SET @sql = 'EXEC GetGEMSubProgramClaimFiles ' +  CONVERT(VARCHAR(10), @ProgramId) +',' +   CONVERT(VARCHAR(10), @SubProgramId) +'"';
SET @cmd = 'sqlcmd -S EECAGEMUDB1 -d GEM_UAT -Q "' + @header + @sql + ' -o ' + @RootPath + '\GetGEMSubProgramClaimFiles.csv -s "," -h -1 -y ' + CONVERT(VARCHAR(10), @MaxFieldLength);
select @cmd
EXEC xp_cmdshell  @cmd


if @SkipFiles=0
begin
	PRINT 'exporting files';
	--Claim Files
	SET @cmd= 'mkdir "' + @RootPath + 'ClaimFiles\'+ '"';
	EXEC xp_cmdshell @cmd;
	SET @FilePath = @RootPath + 'ClaimFiles\';
	--EXEC  ExportClaimFiles @ProgramID, @SubProgramId, @FilePath

	--contract Files
	SET @cmd= 'mkdir "' + @RootPath + 'ContractFiles\'+ '"';
	EXEC xp_cmdshell @cmd;
	SET @FilePath = @RootPath + 'ContractFiles\';
	-- EXEC  ExportContractFiles @ProgramID, @SubProgramId, @FilePath

	-- contract supporting docs
	SET @cmd= 'mkdir "' + @RootPath + 'ContractSupportingDocs\'+ '"';
	EXEC xp_cmdshell @cmd;
	SET @FilePath = @RootPath + 'ContractSupportingDocs\';
	EXEC  ExportContractSupportingDocs @ProgramID, @SubProgramId, @FilePath

end
else 
begin
	PRINT 'skipping file  export';
end

END
