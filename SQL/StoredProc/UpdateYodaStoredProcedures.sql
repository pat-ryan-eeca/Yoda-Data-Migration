-- =============================================
-- Author:		Pat Ryan
-- Create date: 30/10/2025
-- Description:	Create or update the stored procedures used for Yoda
-- =============================================
USE [GEM_UAT]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

DECLARE @cmd VARCHAR(4000);
DECLARE @RootPath VARCHAR(255) = 'c:\temp\yoda\StoredProc\';


SET @cmd= 'mkdir "' + @RootPath + '"';
PRINT 'Creating output folder ' + @RootPath; 
EXEC xp_cmdshell @cmd;


-- create or update stored procs
SET @cmd = 'sqlcmd -i' + @RootPath + 'svf_cleanstring.sql'
EXEC xp_cmdshell  @cmd

SET @cmd = 'sqlcmd -i' + @RootPath + 'ExportAll.sql'
EXEC xp_cmdshell  @cmd

SET @cmd = 'sqlcmd -i' + @RootPath + 'GetGEMSubProgram.sql'
EXEC xp_cmdshell  @cmd

SET @cmd = 'sqlcmd -i' + @RootPath + 'GetGEMStakeholderAcccounts.sql'
EXEC xp_cmdshell  @cmd

SET @cmd = 'sqlcmd -i' + @RootPath + 'GetGEMSubProgramContracts.sql'
EXEC xp_cmdshell  @cmd

SET @cmd = 'sqlcmd -i' + @RootPath + 'GetGEMProgramRoles.sql'
EXEC xp_cmdshell  @cmd

SET @cmd = 'sqlcmd -i' + @RootPath + 'GetGEMSubProgramRoles.sql'
EXEC xp_cmdshell  @cmd


SET @cmd = 'sqlcmd -i' + @RootPath + 'GetGEMSubProgramProjectRoles.sql'
EXEC xp_cmdshell  @cmd

SET @cmd = 'sqlcmd -i' + @RootPath + 'GetGEMSubProgramContractsFiles.sql'
EXEC xp_cmdshell  @cmd

SET @cmd = 'sqlcmd -i' + @RootPath + 'GetGEMSubProgramContractVariations.sql'
EXEC xp_cmdshell  @cmd

SET @cmd = 'sqlcmd -i' + @RootPath + 'GetGEMSubProgramContractVariationsSupportingDocs.sql'
EXEC xp_cmdshell  @cmd

SET @cmd = 'sqlcmd -i' + @RootPath + 'GEMSubProgramMilestones.sql'
EXEC xp_cmdshell  @cmd

SET @cmd = 'sqlcmd -i' + @RootPath + 'GetGEMSubProgramContractVariationsMilestones.sql'
EXEC xp_cmdshell  @cmd

SET @cmd = 'sqlcmd -i' + @RootPath + 'GetGEMSubProgramMilestonesClaimsPayments.sql'
EXEC xp_cmdshell  @cmd

SET @cmd = 'sqlcmd -i' + @RootPath + 'GetGEMSubProgramClaimFiles.sql'
EXEC xp_cmdshell  @cmd

SET @cmd = 'sqlcmd -i' + @RootPath + 'ExportClaimFiles.sql'
EXEC xp_cmdshell  @cmd

SET @cmd = 'sqlcmd -i' + @RootPath + 'ExportContractFiles.sql'
EXEC xp_cmdshell  @cmd

SET @cmd = 'sqlcmd -i' + @RootPath + 'ExportContractSupportingDocs.sql'
EXEC xp_cmdshell  @cmd

SET @cmd = 'sqlcmd -i' + @RootPath + 'ExportAll.sql'
EXEC xp_cmdshell  @cmd


