-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 29/09/2025
-- Description:	Get the roles associated with all rounds of a sub program
-- =============================================
CREATE PROCEDURE [GetGEMSubProgramRoundRoles]
	@ProgramId INT,
	@SubProgramId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select tp.Uro_ID, tp.Time_Period_ID roundId , sr.role_code, s.name

from TimePeriod tp
 INNER JOIN
                  -- Select distinct, because there is no unique constraint on this table.
                  ( SELECT DISTINCT Time_Period_ID FROM TimePeriodSubprogram WHERE @SubProgramId = 34 ) tss ON tss.Time_Period_ID = tp.Time_Period_ID


 INNER JOIN SEC_StakeholderRoles sr

  on sr.universal_resource_id = tp.Uro_ID

 INNER JOIN STKH_Stakeholders s
        ON   s.stakeholder_id = sr.stakeholder_id
              
 WHERE
                  tp.Program_ID = @ProgramId
END

