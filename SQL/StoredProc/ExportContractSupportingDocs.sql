USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[ExportContractSupportingDocs]    Script Date: 10/31/2025 2:22:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 30/10/2025
-- Description:	Export all contract supporting docs  for the given program, subprogram to a directory
-- =============================================
CREATE OR ALTER   PROCEDURE [dbo].[ExportContractSupportingDocs]
	@ProgramId INT,
	@SubProgramId INT,
	@Rootdir  NVARCHAR (2000),
	@External_Reference VARCHAR(200)=''
AS
DECLARE @ImageData VARBINARY (max);
DECLARE @Path2OutFile NVARCHAR (2000);
DECLARE @Filename NVARCHAR (2000);
DECLARE @Obj INT
DECLARE @ReturnCode INT
DECLARE  @grant_step_field_id INT =4235
DECLARE @FileID INT
DECLARE @FullPath NVARCHAR (2000)

DECLARE cursor_contract  CURSOR FOR

		SELECT
		 f.File_ID, f.File_Name
		

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
							and  p.External_Reference like '%'+@External_Reference +'%'
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
	  
	

OPEN cursor_contract;

FETCH NEXT FROM cursor_contract INTO @FileID, @Filename
WHILE @@FETCH_STATUS = 0

BEGIN
	SET @FullPath = @RootDir+@Filename
	PRINT  'extracting ' +  @Filename 
	exec ExportImageToFile @FileID,'File', @FullPath
	FETCH NEXT FROM cursor_contract INTO @FileID, @Filename
END;
-- Close the cursor to release resources
CLOSE cursor_contract;

-- Deallocate the cursor to remove it from memory
DEALLOCATE cursor_contract;
