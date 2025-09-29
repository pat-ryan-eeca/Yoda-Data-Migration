USE [GEM_UAT]
GO
/****** Object:  StoredProcedure [dbo].[GetGEMSubProgramRounds]    Script Date: 29/09/2025 3:01:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pat Ryan
-- Create date: 29/9/2025
-- Description:	Gets the rounds associated with a subprogram
-- =============================================
ALTER PROCEDURE [dbo].[GetGEMSubProgramRounds]
@ProgramId INT,
@SubProgramId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;       
            SELECT
                  @ProgramId
				, @SubProgramId 
				, t.Time_Period_ID as RoundId
				, dbo.CleanString(t.Name)
				, t.Start_Date         
				, t.End_Date                  
				, t.Budget_Amount                 
				, dbo.CleanString(t.Brief_Outline)
				, t.grant_manager_stakeholder_id              
				, tpx.direct_selection                  
                  
               FROM
                  TimePeriod t
               LEFT OUTER JOIN
                  [vw_EECA_TP_TimePeriods] tpx ON tpx.time_period_id = t.time_period_id
            
               LEFT OUTER JOIN
                  STKH_Stakeholders       stkh   ON    stkh.stakeholder_id   =  t.grant_manager_stakeholder_id
               INNER JOIN
                  -- Select distinct, because there is no unique constraint on this table.
                  ( SELECT DISTINCT Time_Period_ID FROM TimePeriodSubprogram WHERE @SubProgramId = 34 ) tss ON tss.Time_Period_ID = t.Time_Period_ID
               WHERE
                  t.Program_ID = @ProgramId
            
END

