USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[ExportImageToFile2]    Script Date: 10/30/2025 4:41:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 31/10/2025
-- Description:	export image data to files
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[ExportImageToFile]
	
	@FileId  INT,
	@TableName NVARCHAR (200),
	@Filename NVARCHAR (2000)
		
AS
BEGIN
-- select imagedata into temprary table

	DECLARE @cmd  NVARCHAR (2000)
	SET @cmd = cast(@FileId as NVARCHAR(200))
	SET @cmd = 'BCP "SELECT f.file_data  from '+ @TableName + ' f where f.file_id='+ cast(@FileId as NVARCHAR(200)) +' "' +  ' queryout "'+  @Filename + '" -T -N -S EECAGEMUDB1'
	
	PRINT @cmd
	--SET @cmd = 'BCP "SELECT  f.file_data from GEM_UAT.dbo.COMM_Files f where f.file_id = 427" queryout "C:\temp\33333.txt" -T -N -S EECAGEMUDB1'
	SET @cmd = 'BCP "SELECT  f.file_data from GEM_UAT.dbo.COMM_Files f where f.file_id='+ cast(@FileId as NVARCHAR(200)) +' "' + ' queryout "' +  @Filename + '" -T -N -S EECAGEMUDB1'
	PRINT @cmd

   EXEC xp_cmdshell  @cmd


END
