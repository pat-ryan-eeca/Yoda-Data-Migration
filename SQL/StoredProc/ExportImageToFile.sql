USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[ExportClaimFiles]    Script Date: 10/30/2025 1:28:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 18/8/2025
-- Description:	Export all claim files for the given program, subprogram to a directory
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].ExportImageToFile
	@ImageData VARBINARY (max),
	@Rootdir  NVARCHAR (2000),
	@Filename NVARCHAR (2000)
AS
 BEGIN TRY
	DECLARE @Obj INT;
	DECLARE @ReturnCode INT;
	DECLARE @Path2OutFile NVARCHAR (2000);

     EXEC @ReturnCode = sp_OACreate 'ADODB.Stream' ,@Obj OUTPUT;
	 select  @ReturnCode
     EXEC  @ReturnCode =sp_OASetProperty @Obj ,'Type',1;
	 select  @ReturnCode
     EXEC @ReturnCode = sp_OAMethod @Obj,'Open';
	 select @ReturnCode
     EXEC  @ReturnCode =sp_OAMethod @Obj,'Write', NULL, @ImageData;
	 select  @ReturnCode
	 SET @Path2OutFile= @Rootdir+@Filename
	 EXEC @ReturnCode =sp_OAMethod @Obj,'SaveToFile', NULL, @Path2OutFile, 2;
	 select @ReturnCode
     EXEC  @ReturnCode= sp_OAMethod @Obj,'Close';
	 select  @ReturnCode
     EXEC @ReturnCode= sp_OADestroy @Obj;
	 select @ReturnCode
     
    END TRY
    
 BEGIN CATCH
  EXEC sp_OADestroy @Obj;
  select 8
 END CATCH

