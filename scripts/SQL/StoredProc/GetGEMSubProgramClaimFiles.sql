USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgramClaimFiles]    Script Date: 25/09/2025 1:19:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 8/9/20205
-- Description: return claim fiels for a subprogram
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[GetGEMSubProgramClaimFiles]
	@ProgramId INT,
	@SubProgramId INT,
	@External_Reference VARCHAR(200)=''

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

       SELECT
                     cd.title as title         
                   ,fw_iclaimsuppdoc_f.filename AS _filename
                   ,fw_iclaimsuppdoc_f.size AS fw_filesize
                  
                  FROM
                     PRJ_ClaimSupportingDocuments      cd
                  
               LEFT OUTER JOIN
                      COMM_Documents fw_iclaimsuppdoc_d
                      ON   fw_iclaimsuppdoc_d.document_id = cd.document_id

               LEFT OUTER JOIN 
                      COMM_Files fw_iclaimsuppdoc_f
                      ON   fw_iclaimsuppdoc_f.file_id = fw_iclaimsuppdoc_d.file_id
               
                  WHERE
                     cd.claim_id  in ( SELECT mc.claim_id 
						from Project p
						INNER JOIN contract c on c.Project_ID = p.Project_ID
						INNER JOIN PRJ_Milestones m on p.Project_ID=m.project_id
						INNER JOIN PRJ_MilestoneClaims mc on mc.milestone_id = m.milestone_id
						where p.Subprogram_ID =@SubProgramId 	
							and p.Program_ID = @ProgramId 
							and  p.External_Reference like '%'+@External_Reference +'%'
						)
END
