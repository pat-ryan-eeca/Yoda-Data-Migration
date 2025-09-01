USE [GEM_UAT]
GO
/****** Object:  UserDefinedFunction [dbo].[CleanString]    Script Date: 1/09/2025 4:33:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
ALTER FUNCTION [dbo].[CleanString]
(
	@InString  nvarchar(MAX)
)
RETURNS nvarchar(MAX)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @OutString nvarchar(MAX)

	RETURN REPLACE(REPLACE(REPLACE(@InString,',', '~'), CHAR(10),' '), CHAR(13), ' ');



END
