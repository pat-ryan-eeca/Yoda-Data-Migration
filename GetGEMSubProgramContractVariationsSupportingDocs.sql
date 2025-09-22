USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgramContractVariationsSupportingDocs]    Script Date: 22/09/2025 3:22:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 17-09-2025
-- Description:	Return the supporting docs for a contratc variation
-- =============================================
ALTER PROCEDURE [dbo].[GetGEMSubProgramContractVariationsSupportingDocs]
@ProgramId INT,
@SubProgramId INT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE @grant_step_field_id INT =4235


 SELECT
		  @ProgramId
		 ,@SubProgramId 
         , gd.Grant_ID AS projectid
		 , Workflow_Instance_ID as contract_variationid
         ,f.File_Name                              AS    FileName
         ,f.File_Size                              AS    FileSize
         ,f.Retrieval_Guid                         AS    FileRetrievalGuid
		

      FROM

         dbo.GrantStepField   gsftable
      INNER JOIN
         dbo.GrantStepField   gsfcol
            ON    gsfcol.Grant_Step_ID    =  gsftable.Grant_Step_ID
            AND   gsfcol.LGT_Membership   =  gsftable.LGT_Code
	  JOIN (
               SELECT
                          cgd.Field_Definition_ID
                        , cgd.Array_Index_Field
                        , cgd.Workflow_Instance_ID 
                        , cgd.Value
						, cgd.Grant_ID
                        , cgd.File_ID
                        , cgd.Value_Long_Text
                        , f.File_Name
                        , COALESCE(DATALENGTH(f.File_Data), 0) AS File_Size
                        , f.Content_Type
                        , f.File_Data
						
                     FROM dbo.CurrentGrantData cgd
                        
                        LEFT JOIN dbo.[File] f
                           ON f.File_ID = cgd.File_ID
                     WHERE cgd.Grant_ID in (
					 select p.Project_ID from                    
							project p 
						where p.Subprogram_ID = @SubProgramId	
							and p.Program_ID = @ProgramId 
						)					 
                  
                       
                       
            ) gd
            ON gd.Field_Definition_ID = gsfcol.Field_Definition_ID

			 LEFT OUTER JOIN
         dbo.FieldDefinition  fd
            ON    fd.Field_Definition_ID  =  gsfcol.Field_Definition_ID
      LEFT OUTER JOIN
         dbo.[File] f
            ON    f.[File_ID]             =  gd.[File_ID]
      WHERE
         gsftable.Grant_Step_Field_ID = @grant_step_field_id
		
      
	  ORDER BY
         gd.Array_Index_Field
	  

END
